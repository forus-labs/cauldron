package com.foruslabs.stevia;

import android.app.Activity;
import android.os.Build;
import android.view.HapticFeedbackConstants;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import io.flutter.embedding.android.FlutterView;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** SteviaPlugin */
public class SteviaPlugin implements ActivityAware, FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Activity activity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "stevia");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      var argument = call.<String>arguments();
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
        switch (argument) {
          case "confirm" -> activity.getWindow().getDecorView().getRootView().performHapticFeedback(HapticFeedbackConstants.CONFIRM);
          case "failure" -> activity.getWindow().getDecorView().getRootView().performHapticFeedback(HapticFeedbackConstants.REJECT);
          case "heavy" -> activity.getWindow().getDecorView().getRootView().performHapticFeedback(HapticFeedbackConstants.CONTEXT_CLICK);
          case "medium" -> activity.getWindow().getDecorView().getRootView().performHapticFeedback(HapticFeedbackConstants.KEYBOARD_TAP);
          case "light" -> activity.getWindow().getDecorView().getRootView().performHapticFeedback(HapticFeedbackConstants.VIRTUAL_KEY);
        }

      }
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }


  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    activity = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivity() {
    activity = null;
  }

}
