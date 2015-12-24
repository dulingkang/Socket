//
//  ViewController.swift
//  SocketDemo
//
//  Created by dulingkang on 15/12/22.
//  Copyright © 2015年 dulingkang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ConnectManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let str = "http://192.168.100.199/xiaoka/configure.mobileconfig"
//        let url = NSURL(string: str)
//        UIApplication.sharedApplication().openURL(url!)
        
//        ConnectWifi.connectWithOneSsid("zkhy_black")
        
        let connectManager = ConnectManager.sharedInstance
        connectManager.delegate = self
        connectManager.socketHost = "www.baidu.com"
        connectManager.socketPort = 80
        connectManager.status = .SocketOfflineByUser
        connectManager.cutOffSocket()
        connectManager.status = .SocketOfflineByServer
        connectManager.socketConnectHost()
        
        let string = "GET / HTTP/1.1\n\n"
        let data = string.dataUsingEncoding(NSUTF8StringEncoding)
        connectManager.socket!.writeData(data, withTimeout: 3, tag: 1)
    }
    
    func socketDidReadData(data: NSData!) {
        print("did read data")
        let msg = NSString(data: data, encoding: NSUTF8StringEncoding)
        print("msg:", msg)
    }


}

