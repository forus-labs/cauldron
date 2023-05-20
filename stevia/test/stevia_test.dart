import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/stevia.dart';
import 'package:stevia/stevia_platform_interface.dart';
import 'package:stevia/stevia_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSteviaPlatform
    with MockPlatformInterfaceMixin
    implements SteviaPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SteviaPlatform initialPlatform = SteviaPlatform.instance;

  test('$MethodChannelStevia is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelStevia>());
  });

  test('getPlatformVersion', () async {
    Stevia steviaPlugin = Stevia();
    MockSteviaPlatform fakePlatform = MockSteviaPlatform();
    SteviaPlatform.instance = fakePlatform;

    expect(await steviaPlugin.getPlatformVersion(), '42');
  });
}
