package com.foruslabs.stevia.time;

import android.content.*;

import androidx.annotation.*;

import com.foruslabs.stevia.*;

import java.time.*;

import io.flutter.embedding.engine.plugins.FlutterPlugin.*;
import io.flutter.plugin.common.*;
import io.flutter.plugin.common.EventChannel.*;
import io.flutter.plugin.common.MethodChannel.*;

/**
 * The channel for timezone-related functionality.
 */
public class TimezoneChannel implements Channel {

    private final TimezoneMethodHandler methodHandler = new TimezoneMethodHandler();
    private final TimezoneStreamHandler streamHandler = new TimezoneStreamHandler();
    private @Nullable MethodChannel method;
    private @Nullable EventChannel events;

    @Override
    public void attach(@NonNull FlutterPluginBinding binding) {
        var context = binding.getApplicationContext();
        context.registerReceiver(streamHandler, TimezoneStreamHandler.filter);

        method = new MethodChannel(binding.getBinaryMessenger(), "com.foruslabs.stevia.time.current");
        method.setMethodCallHandler(methodHandler);
        events = new EventChannel(binding.getBinaryMessenger(), "com.foruslabs.stevia.time.changes");
        events.setStreamHandler(streamHandler);
    }

    @Override
    public void detach(@NonNull FlutterPluginBinding binding) {
        var context = binding.getApplicationContext();
        context.unregisterReceiver(streamHandler);

        if (method != null) {
            method.setMethodCallHandler(null);
        }

        if (events != null) {
            events.setStreamHandler(null);
        }
    }

}

class TimezoneMethodHandler implements MethodCallHandler {
    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (!call.method.equals("currentTimezone")) {
            result.notImplemented();
            return;
        }

        result.success(ZoneId.systemDefault().getId());
    }
}

class TimezoneStreamHandler extends BroadcastReceiver implements StreamHandler {
    static final IntentFilter filter = new IntentFilter(Intent.ACTION_TIMEZONE_CHANGED);

    private @Nullable EventSink sink;

    @Override
    public void onListen(Object arguments, EventSink sink) {
        this.sink = sink;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        if (sink != null) {
            sink.success(ZoneId.systemDefault().getId());
        }
    }

    @Override
    public void onCancel(Object arguments) {
        if (sink != null) {
            sink.endOfStream();
        }
    }
}
