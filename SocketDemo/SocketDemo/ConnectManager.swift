//
//  ConnectManager.swift
//  SocketDemo
//
//  Created by dulingkang on 15/12/24.
//  Copyright © 2015年 dulingkang. All rights reserved.
//

import CocoaAsyncSocket

enum SocketStatus {
    case SocketOnline, SocketOfflineByServer, SocketOfflineByUser
}

protocol ConnectManagerDelegate {
    func socketDidReadData(data: NSData!)
}

class ConnectManager: NSObject, AsyncSocketDelegate {
    static let sharedInstance = ConnectManager()
    var socket: AsyncSocket?
    var socketHost: String?
    var socketPort: UInt16?
    var connectTimer: NSTimer?
    var status: SocketStatus?
    var delegate: ConnectManagerDelegate?
    
    override init() {
        super.init()
    }
    
    //MARK: - public method
    func socketConnectHost() {
        socket = AsyncSocket.init(delegate: self)
        do {
            try socket?.connectToHost(socketHost, onPort: socketPort!, withTimeout: 3)
        } catch {
            print("connect to host: \(socketHost) error")
        }
    }
    
    func cutOffSocket() {
        self.status = .SocketOfflineByUser
        self.connectTimer?.invalidate()
        self.socket?.disconnect()
    }
    
    //MARK: - AsyncSocket delegate
    func onSocket(sock: AsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        print("socket connect success")
        
        //heart beat every 30 second
        connectTimer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "longConnectToSocket", userInfo: nil, repeats: true)
        connectTimer?.fire()
    }
    
    func onSocketDidDisconnect(sock: AsyncSocket!) {
        print("connect is failure:", self.status)
        if self.status == .SocketOfflineByServer {
            self.socketConnectHost()
        }
    }
    
    func onSocket(sock: AsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        self.delegate?.socketDidReadData(data)
        self.socket!.readDataWithTimeout(3, tag: 1)
    }
    
    //MARK: - private method
    func longConnectToSocket() {
        let longStr = "longConnect"
        let data = longStr.dataUsingEncoding(NSUTF8StringEncoding)
        self.socket?.writeData(data, withTimeout: 1, tag: 1)
        self.socket!.readDataWithTimeout(3, tag: 1)
    }

}