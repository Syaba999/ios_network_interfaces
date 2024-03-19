import 'package:ios_network_interfaces/ios_network_interfaces_platform_interface.dart';

import 'src/enums.dart';

export 'src/enums.dart';

class IosNetworkInterfaces {
  factory IosNetworkInterfaces() {
    _singleton ??= IosNetworkInterfaces._();
    return _singleton!;
  }

  IosNetworkInterfaces._();

  static IosNetworkInterfaces? _singleton;

  Stream<List<NetworkInterfaceType>> get onNetworkInterfacesChanged {
    return IosNetworkInterfacesPlatform.instance.onNetworkInterfacesChanged;
  }

  Future<List<NetworkInterfaceType>> checkNetworkInterfaces() {
    return IosNetworkInterfacesPlatform.instance.checkNetworkInterfaces();
  }
}
