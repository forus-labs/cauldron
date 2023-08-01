package com.foruslabs.stevia.haptic;

import android.app.Activity;
import android.os.Build.*;
import android.view.HapticFeedbackConstants;

import androidx.annotation.*;

import com.foruslabs.stevia.*;

import io.flutter.embedding.engine.plugins.FlutterPlugin.*;
import io.flutter.plugin.common.*;
import io.flutter.plugin.common.MethodChannel.*;

/**
 * The method channel for haptic-related functionality.
  */
public class HapticMethodChannel implements Channel {

    private final HapticMethodHandler handler = new HapticMethodHandler();
    private @Nullable MethodChannel method;

    @Override
    public void attach(@NonNull FlutterPluginBinding binding) {
        method = new MethodChannel(binding.getBinaryMessenger(), "com.foruslabs.stevia.haptic");
        method.setMethodCallHandler(handler);
    }

    @Override
    public void detach(@NonNull FlutterPluginBinding binding) {
        if (method != null) {
            method.setMethodCallHandler(null);
        }
    }

    /**
     * Sets this channel's activity.
     *
     * @param activity the activity
     */
    public void activity(@Nullable Activity activity) {
        handler.activity = activity;
    }

}

class HapticMethodHandler implements MethodCallHandler {

    static final String ERROR_CODE = "invalid-haptic-pattern";
    static final int UNSUPPORTED_PATTERN = -100;

    /**
     * The current activity.
     */
    public @Nullable Activity activity;

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (!call.method.equals("hapticFeedback")) {
            result.notImplemented();
            return;
        }

        String name = call.arguments();
        if (name == null) {
            result.error(ERROR_CODE, "No pattern specified.", null);
            return;
        }

        hapticFeedback(name, result);
    }

    void hapticFeedback(@NonNull String name, @NonNull Result result) {
        var pattern = pattern(name);
        if (pattern == UNSUPPORTED_PATTERN) {
            result.error(ERROR_CODE, "Unsupported pattern: " + name, null);
            return;
        }

        var activity = this.activity;
        if (activity != null && pattern != -1) {
            activity.getWindow().getDecorView().getRootView().performHapticFeedback(pattern);
        }

        result.success(null);
    }
    
    int pattern(String name) {
        switch (name) {
            case "CLOCK_TICK": return  HapticFeedbackConstants.CLOCK_TICK;
            case "CONFIRM": return supports(VERSION_CODES.R) ? HapticFeedbackConstants.CONFIRM : -1;
            case "CONTEXT_CLICK": return HapticFeedbackConstants.CONTEXT_CLICK;
            case "GESTURE_START": return supports(VERSION_CODES.R) ? HapticFeedbackConstants.GESTURE_START : - 1;
            case "GESTURE_END": return supports(VERSION_CODES.R) ? HapticFeedbackConstants.GESTURE_END : - 1;
            case "KEYBOARD_PRESS": return supports(VERSION_CODES.O_MR1) ? HapticFeedbackConstants.KEYBOARD_PRESS : -1;
            case "KEYBOARD_RELEASE": return supports(VERSION_CODES.O_MR1) ? HapticFeedbackConstants.KEYBOARD_RELEASE : -1;
            case "KEYBOARD_TAP": return HapticFeedbackConstants.KEYBOARD_TAP;
            case "LONG_PRESS": return HapticFeedbackConstants.LONG_PRESS;
            case "REJECT": return supports(VERSION_CODES.R) ? HapticFeedbackConstants.REJECT : -1;
            case "TEXT_HANDLE_MOVE": return supports(VERSION_CODES.O_MR1) ? HapticFeedbackConstants.TEXT_HANDLE_MOVE : -1;
            case "VIRTUAL_KEY": return HapticFeedbackConstants.VIRTUAL_KEY;
            case "VIRTUAL_KEY_RELEASE": return supports(VERSION_CODES.O_MR1) ? HapticFeedbackConstants.VIRTUAL_KEY_RELEASE : -1;
            default: return UNSUPPORTED_PATTERN;
        }
    }

    boolean supports(int version) {
        return VERSION.SDK_INT >= version;
    }

}
