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

enum PacketType: Int {
    case SPT_NONE = 0, SPT_STATUS, SPT_CMD, SPT_LOG, SPT_FILE_START, SPT_FILE_SENDING
}

protocol ConnectManagerDelegate {
    func socketDidReadData(data: NSData!)
}

let headerLength: Int = 12

class ConnectManager: NSObject, AsyncSocketDelegate {
    static let sharedInstance = ConnectManager()
    var socket: AsyncSocket?
    var socket1: AsyncSocket?
    var socketHost: String?
    var socketPort: UInt16?
    var connectTimer: NSTimer?
    var status: SocketStatus?
    var delegate: ConnectManagerDelegate?
    var fileLength: Int = 0
    
    override init() {
        super.init()
    }
    
    //MARK: - public method
    func socketConnectHost() {
        socket = AsyncSocket.init(delegate: self)
//        socket1 = AsyncSocket.init(delegate: self)
        do {
            try socket?.connectToHost(socketHost, onPort: socketPort!, withTimeout: 5)
//            try socket1?.connectToHost(socketHost, onPort: socketPort!, withTimeout: 5)
        } catch {
            print("connect to host: \(socketHost) error")
        }
    }
    
    func cutOffSocket() {
        self.status = .SocketOfflineByUser
        self.connectTimer?.invalidate()
        self.socket?.disconnect()
        self.socket1?.disconnect()
    }
    
    //MARK: - AsyncSocket delegate
    func onSocket(sock: AsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        print("socket connect success")
        
        //heart beat every 30 second
        connectTimer = NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: "longConnectToSocket", userInfo: nil, repeats: true)
        connectTimer?.fire()
    }
    
    func onSocketDidDisconnect(sock: AsyncSocket!) {
        print("connect is failure:", self.status)
        if self.status == .SocketOfflineByServer {
            self.socketConnectHost()
        }
    }
    
    func onSocket(sock: AsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        print("did read data:")
        print("dataLenght:", data.length)
        
        PacketManager.sharedInstance.handleBufferData(data)

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