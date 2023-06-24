package com.foruslabs.stevia.time;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import org.junit.jupiter.api.*;

import java.time.*;

import io.flutter.plugin.common.*;
import io.flutter.plugin.common.EventChannel.*;
import io.flutter.plugin.common.MethodChannel.*;

class TimezoneMethodHandlerTest {

    TimezoneMethodHandler handler = new TimezoneMethodHandler();
    Result result = mock(Result.class);

    @Test
    void onMethodCall() {
        var timezone = ZoneId.systemDefault().getId();

        handler.onMethodCall(new MethodCall("currentTimezone", null), result);
        verify(result).success(timezone);
        verifyNoMoreInteractions(result);
    }

    @Test
    void onMethodCall_unimplemented() {
        handler.onMethodCall(new MethodCall("something", null), result);
        verify(result).notImplemented();
        verifyNoMoreInteractions(result);
    }

    @Test
    void onMethodCall_invalid_argument() {
        handler.onMethodCall(new MethodCall("currentTimezone", 1), result);
        verify(result).error("invalid-argument", "Argument should be null", null);
        verifyNoMoreInteractions(result);
    }

}

class TimezoneStreamHandlerTest {

    TimezoneStreamHandler handler = new TimezoneStreamHandler();
    EventSink sink = mock(EventSink.class);

    @Test
    void onListen() {
        assertNull(handler.sink);
        handler.onListen(null, sink);
        assertEquals(handler.sink, sink);
    }

    @Test
    void onReceive() {
        var timezone = ZoneId.systemDefault().getId();

        handler.onListen(null, sink);
        handler.onReceive(null, null);
        verify(sink).success(timezone);
    }

    @Test
    void onReceive_no_sink() {
        handler.onReceive(null, null);
        verifyNoInteractions(sink);
    }


    @Test
    void onCancel() {
        handler.sink = sink;
        handler.onCancel(null);
        assertEquals(handler.sink, sink);
    }

    @Test
    void onCancel_no_sink() {
        handler.onCancel(null);
        assertNull(handler.sink);
    }
}