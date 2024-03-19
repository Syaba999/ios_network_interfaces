import 'enums.dart';

List<NetworkInterfaceType> parseNetworkInterfaceTypes(List<String> states) {
  return states.map((state) {
    switch (state.trim()) {
      case 'wifi':
        return NetworkInterfaceType.wifi;
      case 'ethernet':
        return NetworkInterfaceType.wiredEthernet;
      case 'mobile':
        return NetworkInterfaceType.cellular;
      case 'other':
        return NetworkInterfaceType.other;
      default:
        return NetworkInterfaceType.none;
    }
  }).toList();
}
