import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ios_network_interfaces/ios_network_interfaces_platform_interface.dart';

import 'src/enums.dart';
import 'src/utils.dart';

class MethodChannelIosNetworkInterfaces extends IosNetworkInterfacesPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('ios_network_interfaces');

  @visibleForTesting
  EventChannel eventChannel =
      const EventChannel('ios_network_interfaces_status');

  Stream<List<NetworkInterfaceType>>? _onNetworkInterfacesChanged;

  @override
  Stream<List<NetworkInterfaceType>> get onNetworkInterfacesChanged {
    _onNetworkInterfacesChanged ??= eventChannel
        .receiveBroadcastStream()
        .map((dynamic result) => List<String>.from(result))
        .map(parseNetworkInterfaceTypes);
    return _onNetworkInterfacesChanged!;
  }

  @override
  Future<List<NetworkInterfaceType>> checkNetworkInterfaces() {
    return methodChannel
        .invokeListMethod<String>('check')
        .then((value) => parseNetworkInterfaceTypes(value ?? []));
  }
}
