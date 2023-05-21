package com.foruslabs.stevia.haptic;

import android.app.Activity;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.view.HapticFeedbackConstants;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * The Android implementation for Stevia's haptic feedback functions.
 */
public class HapticPlugin implements FlutterPlugin, ActivityAware {

  private final HapticMethodHandler handler = new HapticMethodHandler();
  private @Nullable MethodChannel channel;


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    channel = new MethodChannel(binding.getBinaryMessenger(), "com.foruslabs.stevia.haptic");
    channel.setMethodCallHandler(handler);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    if (channel != null) {
      channel.setMethodCallHandler(null);
    }
  }


  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    handler.activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    handler.activity = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    handler.activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivity() {
    handler.activity = null;
  }

}
