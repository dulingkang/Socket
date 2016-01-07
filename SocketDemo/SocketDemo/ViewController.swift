//
//  ViewController.swift
//  SocketDemo
//
//  Created by dulingkang on 15/12/22.
//  Copyright © 2015年 dulingkang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PacketManagerDelegate  {

    var connectManager: ConnectManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configConnectManager()
        PacketManager.sharedInstance.delegate = self
    }
    
    //MARK: - delegate
    func updateImage(image: UIImage) {
        
    }
    
    //MARK: - private method
    private func configConnectManager() {
        //        let str = "http://192.168.100.199/xiaoka/configure.mobileconfig"
        //        let url = NSURL(string: str)
        //        UIApplication.sharedApplication().openURL(url!)
        
        //        ConnectWifi.connectWithOneSsid("zkhy_black")
        
        connectManager = ConnectManager.sharedInstance
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
    
    
    
}

