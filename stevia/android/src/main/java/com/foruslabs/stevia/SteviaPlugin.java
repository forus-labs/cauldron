package com.foruslabs.stevia;

import androidx.annotation.NonNull;

import com.foruslabs.stevia.haptic.*;
import com.foruslabs.stevia.time.*;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

/**
 * The Android implementation for Stevia's haptic feedback functions.
 */
public class SteviaPlugin implements FlutterPlugin, ActivityAware {
  private final HapticMethodChannel hapticChannel = new HapticMethodChannel();
  private final TimezoneChannel timezoneChannel = new TimezoneChannel();


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    hapticChannel.attach(binding);
    timezoneChannel.attach(binding);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    hapticChannel.detach(binding);
    timezoneChannel.detach(binding);
  }


  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    hapticChannel.activity(binding.getActivity());
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    hapticChannel.activity(null);
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    hapticChannel.activity(binding.getActivity());
  }

  @Override
  public void onDetachedFromActivity() {
    hapticChannel.activity(null);
  }

}
