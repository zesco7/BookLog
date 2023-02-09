//
//  NetworkConnectionChecker.swift
//  BookLog
//
//  Created by Mac Pro 15 on 2023/02/09.
//

import UIKit
import Network

final class NetworkConnectionChecker {
    static let shared = NetworkConnectionChecker()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    public private(set) var isConnected:Bool = false
    public private(set) var connectionType:ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init(){
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring(){
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            print("path :\(path)")
            self?.isConnected = path.status == .satisfied
            self?.getConenctionType(path)
            if self?.isConnected == true{
                print("네트워크 연결 됨")
            }else{
                print("네트워크 연결 안 됨")
            }
        }
    }
    
    public func stopMonitoring(){
        monitor.cancel()
    }
    
    private func getConenctionType(_ path:NWPath) {
        if path.usesInterfaceType(.wifi){
            connectionType = .wifi
            print("wifi 연결")
        }else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
            print("cellular 연결")
        }else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
            print("wiredEthernet 연결")
        }else {
            connectionType = .unknown
            print("unknown ..")
        }
    }
}
