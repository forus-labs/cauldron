package com.foruslabs.stevia.haptic;

import static android.view.HapticFeedbackConstants.*;
import static org.mockito.Mockito.*;

import android.app.*;
import android.view.*;

import org.junit.jupiter.api.*;
import org.junit.jupiter.params.*;
import org.junit.jupiter.params.provider.*;

import java.util.stream.*;

import io.flutter.plugin.common.*;
import io.flutter.plugin.common.MethodChannel.*;

class HapticMethodHandlerTest {

    HapticMethodHandler handler = spy(new HapticMethodHandler());
    Activity activity;
    View view = when(mock(View.class).performHapticFeedback(anyInt())).thenReturn(true).getMock();
    Result result = mock(Result.class);

    @BeforeEach
    void before() {
        View decor = when(mock(View.class).getRootView()).thenReturn(view).getMock();
        Window window = when(mock(Window.class).getDecorView()).thenReturn(decor).getMock();
        activity = when(mock(Activity.class).getWindow()).thenReturn(window).getMock();
        handler.activity = activity;
    }

    @Test
    void onMethodCall() {
        handler.onMethodCall(new MethodCall("hapticFeedback", "CLOCK_TICK"), result);
        verify(result).success(null);
        verifyNoMoreInteractions(result);
    }

    @Test
    void onMethodCall_unimplemented() {
        handler.onMethodCall(new MethodCall("something", "CLOCK_TICK"), result);
        verify(result).notImplemented();
        verifyNoMoreInteractions(result);
    }

    @Test
    void onMethodCall_invalid_argument() {
        handler.onMethodCall(new MethodCall("hapticFeedback", null), result);
        verify(result).error(HapticMethodHandler.ERROR_CODE, "No pattern specified.", null);
        verifyNoMoreInteractions(result);
    }


    @ParameterizedTest
    @MethodSource("hapticFeedback_arguments")
    void hapticFeedback(String name, boolean supports, int pattern) {
        doReturn(supports).when(handler).supports(anyInt());
        handler.hapticFeedback(name, result);

        verify(view, times(supports ? 1 : 0)).performHapticFeedback(pattern);
        verify(result).success(null);
        verifyNoMoreInteractions(result);
    }

    static Stream<Arguments> hapticFeedback_arguments() {
        return Stream.of(
            Arguments.of("CLOCK_TICK", true, CLOCK_TICK),
            Arguments.of("CONFIRM", true, CONFIRM),
            Arguments.of("CONFIRM", false, CONFIRM),
            Arguments.of("CLOCK_TICK", true, CLOCK_TICK),
            Arguments.of("GESTURE_START", true, GESTURE_START),
            Arguments.of("GESTURE_START", false, GESTURE_START),
            Arguments.of("GESTURE_END", true, GESTURE_END),
            Arguments.of("GESTURE_END", false, GESTURE_END),
            Arguments.of("KEYBOARD_PRESS", true, KEYBOARD_PRESS),
            Arguments.of("KEYBOARD_PRESS", false, KEYBOARD_PRESS),
            Arguments.of("KEYBOARD_RELEASE", true, KEYBOARD_RELEASE),
            Arguments.of("KEYBOARD_RELEASE", false, KEYBOARD_RELEASE),
            Arguments.of("KEYBOARD_TAP", true, KEYBOARD_TAP),
            Arguments.of("LONG_PRESS", true, LONG_PRESS),
            Arguments.of("REJECT", true, REJECT),
            Arguments.of("REJECT", false, REJECT),
            Arguments.of("TEXT_HANDLE_MOVE", true, TEXT_HANDLE_MOVE),
            Arguments.of("TEXT_HANDLE_MOVE", false, TEXT_HANDLE_MOVE),
            Arguments.of("VIRTUAL_KEY", true, VIRTUAL_KEY),
            Arguments.of("VIRTUAL_KEY_RELEASE", true, VIRTUAL_KEY_RELEASE),
            Arguments.of("VIRTUAL_KEY_RELEASE", false, VIRTUAL_KEY_RELEASE)
        );
    }


    @Test
    void hapticFeedback_unsupported_pattern() {
        handler.hapticFeedback("INVALID", result);
        verify(result).error(HapticMethodHandler.ERROR_CODE, "Unsupported pattern: INVALID", null);
        verifyNoMoreInteractions(result);
    }

    @Test
    void hapticFeedback_unsupported_sdk() {
        doReturn(false).when(handler).supports(anyInt());
        handler.hapticFeedback("CONFIRM", result);

        verifyNoInteractions(view);
        verify(result).success(null);
        verifyNoMoreInteractions(result);
    }

}
