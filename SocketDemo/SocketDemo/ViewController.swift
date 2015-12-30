//
//  ViewController.swift
//  SocketDemo
//
//  Created by dulingkang on 15/12/22.
//  Copyright © 2015年 dulingkang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ConnectManagerDelegate {

    var connectManager: ConnectManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let str = "http://192.168.100.199/xiaoka/configure.mobileconfig"
//        let url = NSURL(string: str)
//        UIApplication.sharedApplication().openURL(url!)
        
//        ConnectWifi.connectWithOneSsid("zkhy_black")
        
        connectManager = ConnectManager.sharedInstance
        connectManager.delegate = self
        connectManager.socketHost = "192.168.137.1"
        connectManager.socketPort = 53383
        connectManager.status = .SocketOfflineByUser
        connectManager.cutOffSocket()
        connectManager.status = .SocketOfflineByServer
        connectManager.socketConnectHost()
        
//        let string = "GET / HTTP/1.1\n\n"
//        let data = string.dataUsingEncoding(NSUTF8StringEncoding)
//        connectManager.socket!.writeData(data, withTimeout: 3, tag: 1)
    }
    
    
    func socketDidReadData(data: NSData!) {
        print("did read data")
        print("dataLenght:", data.length)

        let headerLength: Int = 16

        let headerData = data.subdataWithRange(NSMakeRange(0, 16))
        let stream: NSInputStream = NSInputStream(data: headerData)
        stream.open()
        var buffer = [UInt8](count: 4, repeatedValue: 0)
        
        while stream.hasBytesAvailable {
            stream.read(&buffer, maxLength: buffer.count)
            print("buffer:", buffer)
        }
        
        let leftLength: Int = data.length - headerLength

        let headerMsg = NSString(data: headerData, encoding: NSUTF8StringEncoding)
        let leftData = data.subdataWithRange(NSMakeRange(headerLength, leftLength))
        print("headerData:", headerData)
        print(headerMsg)

        do {
        let parsedObject = try NSJSONSerialization.JSONObjectWithData(leftData, options: NSJSONReadingOptions.AllowFragments)
            print("parsedObject:", parsedObject)

        } catch {}
        
    }


}

