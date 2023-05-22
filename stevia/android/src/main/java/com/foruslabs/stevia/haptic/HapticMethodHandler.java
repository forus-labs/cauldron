package com.foruslabs.stevia.haptic;

import android.app.Activity;
import android.os.Build.*;
import android.view.HapticFeedbackConstants;

import androidx.annotation.*;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.*;

/**
 * A {@code MethodCallHandler} for the {@code HapticPlugin}.
 */
public class HapticMethodHandler implements MethodCallHandler {

    private static final String ERROR_CODE = "invalid-haptic-pattern";
    private static final int UNSUPPORTED_PATTERN = -100;

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
            result.error(ERROR_CODE, "No pattern was specified.", null);
            return;
        }

        hapticFeedback(name, result);
    }

    void hapticFeedback(@NonNull String name, @NonNull Result result) {
        var pattern = switch (name) {
            case "CLOCK_TICK" -> HapticFeedbackConstants.CLOCK_TICK;
            case "CONFIRM" -> VERSION.SDK_INT >= VERSION_CODES.R ? HapticFeedbackConstants.CONFIRM : -1;
            case "CONTEXT_CLICK" -> HapticFeedbackConstants.CONTEXT_CLICK;
            case "GESTURE_START" -> VERSION.SDK_INT >= VERSION_CODES.R ? HapticFeedbackConstants.GESTURE_START : - 1;
            case "GESTURE_END" -> VERSION.SDK_INT >= VERSION_CODES.R ? HapticFeedbackConstants.GESTURE_END : - 1;
            case "KEYBOARD_PRESS" -> VERSION.SDK_INT >= VERSION_CODES.O_MR1 ? HapticFeedbackConstants.KEYBOARD_PRESS : -1;
            case "KEYBOARD_RELEASE" -> VERSION.SDK_INT >= VERSION_CODES.O_MR1 ? HapticFeedbackConstants.KEYBOARD_RELEASE : -1;
            case "KEYBOARD_TAP" -> HapticFeedbackConstants.KEYBOARD_TAP;
            case "LONG_PRESS" -> HapticFeedbackConstants.LONG_PRESS;
            case "REJECT" -> VERSION.SDK_INT >= VERSION_CODES.R ? HapticFeedbackConstants.REJECT : -1;
            case "TEXT_HANDLE_MOVE" -> VERSION.SDK_INT >= VERSION_CODES.O_MR1 ? HapticFeedbackConstants.TEXT_HANDLE_MOVE : -1;
            case "VIRTUAL_KEY" -> HapticFeedbackConstants.VIRTUAL_KEY;
            case "VIRTUAL_KEY_RELEASE" -> VERSION.SDK_INT >= VERSION_CODES.O_MR1 ? HapticFeedbackConstants.VIRTUAL_KEY_RELEASE : -1;
            default -> UNSUPPORTED_PATTERN;
        };

        if (pattern == UNSUPPORTED_PATTERN) {
            result.error(ERROR_CODE, "Unsupported pattern: " + name, null);
            return;
        }

        var activity = this.activity;
        if (activity != null && pattern != -1) {
            activity.getWindow().getDecorView().getRootView().performHapticFeedback(pattern);
        }

        result.success(false);
    }

}
