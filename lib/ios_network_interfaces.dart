import 'dart:io';

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

  Stream<List<NetworkInterfaceType>>? get onNetworkInterfacesChanged {
    if (Platform.isIOS) {
      return IosNetworkInterfacesPlatform.instance.onNetworkInterfacesChanged;
    }
    return null;
  }

  Future<List<NetworkInterfaceType>> checkNetworkInterfaces() {
    if (Platform.isIOS) {
      return IosNetworkInterfacesPlatform.instance.checkNetworkInterfaces();
    }
    return Future(() => <NetworkInterfaceType>[]);
  }
}
