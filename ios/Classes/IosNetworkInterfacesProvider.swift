import Foundation

public enum NetworkInterfaceType {
  case none
  case wiredEthernet
  case wifi
  case cellular
  case other
}

public protocol IosNetworkInterfacesProvider: NSObjectProtocol {
  typealias IosNetworkInterfacesUpdateHandler = ([NetworkInterfaceType]) -> Void

  var currentNetworkInterfaceTypes: [NetworkInterfaceType] { get }

  var iosNetworkInterfacesUpdateHandler: IosNetworkInterfacesUpdateHandler? { get set }

  func start()

  func stop()
}