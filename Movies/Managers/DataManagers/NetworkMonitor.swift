
import Foundation
import Reachability

final class NetworkMonitor {
    static let shared: NetworkMonitor = .init()

    private init() {}

    private let reachability = try? Reachability()
    private(set) var isConnected: Bool = true

    func startMonitoring() {
        reachability?.whenReachable = { [ weak self ] reachability in
            if self?.reachability?.connection != .unavailable {
                print("🌐 Connection - ✅")
                self?.isConnected = true
            }
        }

        reachability?.whenUnreachable = { _ in
            print("🌐 Connection - ❌")
            self.isConnected = false
        }

        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    func stopMonitoring() {
        reachability?.stopNotifier()
    }
}
