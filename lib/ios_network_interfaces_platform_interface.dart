import 'package:ios_network_interfaces/ios_network_interfaces_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ios_network_interfaces.dart';

abstract class IosNetworkInterfacesPlatform extends PlatformInterface {
  /// Constructs a IosNetworkInterfacesPlatform.
  IosNetworkInterfacesPlatform() : super(token: _token);

  static final Object _token = Object();

  static IosNetworkInterfacesPlatform _instance =
      MethodChannelIosNetworkInterfaces();

  /// The default instance of [IosNetworkInterfacesPlatform] to use.
  ///
  /// Defaults to [MethodChannelIosNetworkInterfaces].
  static IosNetworkInterfacesPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IosNetworkInterfacesPlatform] when
  /// they register themselves.
  static set instance(IosNetworkInterfacesPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List<NetworkInterfaceType>> checkNetworkInterfaces() {
    throw UnimplementedError(
        'checkNetworkInterfaces() has not been implemented.');
  }

  Stream<List<NetworkInterfaceType>> get onNetworkInterfacesChanged {
    throw UnimplementedError(
        'get onNetworkInterfacesChanged has not been implemented.');
  }
}
