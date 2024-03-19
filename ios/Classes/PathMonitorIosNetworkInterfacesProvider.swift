import Foundation
import Network

public class PathMonitorIosNetworkInterfacesProvider: NSObject, IosNetworkInterfacesProvider {

  private let queue = DispatchQueue.global(qos: .background)

  private var pathMonitor: NWPathMonitor?

  public var currentNetworkInterfaceTypes: [NetworkInterfaceType] {
    let path = ensurePathMonitor().currentPath
    var types: [NetworkInterfaceType] = []

    if path.status == .satisfied {
      if path.usesInterfaceType(.wifi) {
        types.append(.wifi)
      }
      if path.usesInterfaceType(.cellular) {
        types.append(.cellular)
      }
      if path.usesInterfaceType(.wiredEthernet) {
        types.append(.wiredEthernet)
      }
      if path.usesInterfaceType(.other) {
        types.append(.other)
      }
    }

    return types.isEmpty ? [.none] : types
  }

  public var iosNetworkInterfacesUpdateHandler: IosNetworkInterfacesUpdateHandler?

  override init() {
    super.init()
    _ = ensurePathMonitor()
  }

  public func start() {
    _ = ensurePathMonitor()
  }

  public func stop() {
    pathMonitor?.cancel()
    pathMonitor = nil
  }

  @discardableResult
  private func ensurePathMonitor() -> NWPathMonitor {
    if (pathMonitor == nil) {
      let pathMonitor = NWPathMonitor()
      pathMonitor.start(queue: queue)
      pathMonitor.pathUpdateHandler = pathUpdateHandler
      self.pathMonitor = pathMonitor
    }
    return self.pathMonitor!
  }

  private func pathUpdateHandler(path: NWPath) {
    iosNetworkInterfacesUpdateHandler?(currentNetworkInterfaceTypes)
  }
}