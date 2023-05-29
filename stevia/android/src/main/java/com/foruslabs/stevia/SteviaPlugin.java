package com.foruslabs.stevia;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.foruslabs.stevia.haptic.*;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel;

/**
 * The Android implementation for Stevia's haptic feedback functions.
 */
public class SteviaPlugin implements FlutterPlugin, ActivityAware {

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
