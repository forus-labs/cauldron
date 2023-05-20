
import 'stevia_platform_interface.dart';

class Stevia {
  Future<String?> getPlatformVersion(String argument) {
    return SteviaPlatform.instance.getPlatformVersion(argument);
  }
}
