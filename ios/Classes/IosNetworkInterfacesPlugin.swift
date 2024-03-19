import Flutter
import UIKit

public class IosNetworkInterfacesPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private let iosNetworkInterfacesProvider: IosNetworkInterfacesProvider
  private var eventSink: FlutterEventSink?

  init(iosNetworkInterfacesProvider: IosNetworkInterfacesProvider) {
    self.iosNetworkInterfacesProvider = iosNetworkInterfacesProvider
    super.init()
    self.iosNetworkInterfacesProvider.iosNetworkInterfacesUpdateHandler = iosNetworkInterfacesUpdateHandler
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let binaryMessenger = registrar.messenger()
    let channel = FlutterMethodChannel(name: "ios_network_interfaces", binaryMessenger: binaryMessenger)
    let streamChannel = FlutterEventChannel(
          name: "ios_network_interfaces_status",
          binaryMessenger: binaryMessenger)

    let iosNetworkInterfacesProvider = PathMonitorIosNetworkInterfacesProvider()
    let instance = IosNetworkInterfacesPlugin(iosNetworkInterfacesProvider: iosNetworkInterfacesProvider)

    streamChannel.setStreamHandler(instance)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
    eventSink = nil
    iosNetworkInterfacesProvider.stop()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "check":
      result(statusFrom(networkInterfaceTypes: iosNetworkInterfacesProvider.currentNetworkInterfaceTypes))
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func statusFrom(networkInterfaceType: NetworkInterfaceType) -> String {
    switch networkInterfaceType {
    case .wifi:
      return "wifi"
    case .cellular:
      return "mobile"
    case .wiredEthernet:
      return "ethernet"
    case .other:
        return "other"
    case .none:
      return "none"
    }
  }

  private func statusFrom(networkInterfaceTypes: [NetworkInterfaceType]) -> [String] {
    return networkInterfaceTypes.map {
      self.statusFrom(networkInterfaceType: $0)
    }
  }

  public func onListen(
    withArguments _: Any?,
    eventSink events: @escaping FlutterEventSink
  ) -> FlutterError? {
    eventSink = events
    iosNetworkInterfacesProvider.start()
    // Update this to handle a list
    iosNetworkInterfacesUpdateHandler(networkInterfaceTypes: iosNetworkInterfacesProvider.currentNetworkInterfaceTypes)
    return nil
  }

  private func iosNetworkInterfacesUpdateHandler(networkInterfaceTypes: [NetworkInterfaceType]) {
    DispatchQueue.main.async {
      self.eventSink?(self.statusFrom(networkInterfaceTypes: networkInterfaceTypes))
    }
  }

  public func onCancel(withArguments _: Any?) -> FlutterError? {
    iosNetworkInterfacesProvider.stop()
    eventSink = nil
    return nil
  }
}
