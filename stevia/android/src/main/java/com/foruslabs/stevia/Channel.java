package com.foruslabs.stevia;

import androidx.annotation.*;

import io.flutter.embedding.engine.plugins.FlutterPlugin.*;

/**
 * Represents a channel.
 */
public interface Channel {

    /**
     * Attaches this {@code Channel} to a {@code FlutterEngine}.
     *
     * @param binding the engine's binding
     */
    void attach(@NonNull FlutterPluginBinding binding);

    /**
     * Detaches this {@code Channel} from a {@code FlutterEngine}.
     *
     * @param binding the engine's binding
     */
    void detach(@NonNull FlutterPluginBinding binding);

}
