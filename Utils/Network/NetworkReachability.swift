//
//  NetworkReachability.swift
//  DesignPatterns
//
//  Created by Augusto Avelino on 13/08/24.
//

import Foundation
import Network

public class NetworkReachability: NSObject {
    
    // MARK: Singleton
    
    public static let shared = NetworkReachability()
    
    // MARK: Props
    
    private let monitor = NWPathMonitor()
    @objc dynamic public var connection: Connection = .unavailable
    
    // MARK: - Status
    
    @objc public enum Connection: Int, CustomStringConvertible {
        case other, wifi, cellular, wiredEthernet, loopback, unavailable
        
        public var description: String {
            return switch self {
            case .other: "Other"
            case .wifi: "Wi-Fi"
            case .cellular: "Cellular"
            case .wiredEthernet: "Wired Ethernet"
            case .loopback: "Loopback"
            case .unavailable: "No Connection"
            }
        }
    }
    
    // MARK: - Life cycle
    
    fileprivate override init () {
        super.init()
        startMonitor()
    }
    
    private func startMonitor() {
        monitor.start(queue: .global(qos: .background))
        monitor.pathUpdateHandler = { [unowned self] path in
            guard let interface = path.availableInterfaces.first else {
                return self.connection = .unavailable
            }
            self.handleInterfaceType(interface.type)
        }
    }
    
    private func handleInterfaceType(_ type: NWInterface.InterfaceType) {
        connection = switch type {
        case .other: .other
        case .wifi: .wifi
        case .cellular: .cellular
        case .wiredEthernet: .wiredEthernet
        case .loopback: .loopback
        @unknown default: .unavailable
        }
    }
}
