//
//  PacketManager.swift
//  SocketDemo
//
//  Created by dulingkang on 16/1/6.
//  Copyright © 2016年 dulingkang. All rights reserved.
//

import Foundation

class PacketManager: NSObject {
    
    static let sharedInstance = PacketManager()
    var bufferData = NSMutableData()
    override init() {}
    
    func handleBufferData(data: NSData) {
        if data.length != 0 {
            bufferData.appendData(data)
        }
        let headerData = bufferData.subdataWithRange(NSMakeRange(0, headerLength))
        if headerData.length == 0 {
            return
        }
        let payloadLength = parseHeader(headerData).payloadLength
        
        if bufferData.length == payloadLength + headerLength {
            self.processCompletePacket(bufferData)
            bufferData = NSMutableData()
        } else if bufferData.length > payloadLength + headerLength {
            let contentData = bufferData.subdataWithRange(NSMakeRange(headerLength, payloadLength))
            self.processCompletePacket(contentData)
            
            let leftData = bufferData.subdataWithRange(NSMakeRange(payloadLength + headerLength, bufferData.length - payloadLength - headerLength))
            bufferData = NSMutableData()
            bufferData.appendData(leftData)
            self.handleBufferData(NSData())
        }
    }
    
    func parseHeader(headerData: NSData) -> (spt: Int, payloadLength: Int) {
        let stream: NSInputStream = NSInputStream(data: headerData)
        stream.open()
        var buffer = [UInt8](count: 4, repeatedValue: 0)
        var index: Int = 0
        var spt: Int = 0
        var payloadLength: Int = 0
        while stream.hasBytesAvailable {
            stream.read(&buffer, maxLength: buffer.count)
            let sum: Int = Int(buffer[0]) + Int(buffer[1]) + Int(buffer[2]) + Int(buffer[3])
            if index == 0 {
                if sum != 276 {
                    return (0,0)
                }
            }
            
            if index == 1 {
                spt = sum
            }
            
            if index == 2 {
                payloadLength = sum
            }
            index++
            print("buffer:", buffer)
        }
        return (spt, payloadLength)
    }

    func parseJsonBody(bodyData: NSData) -> NSDictionary? {
        do {
            let parsedObject = try NSJSONSerialization.JSONObjectWithData(bodyData, options: NSJSONReadingOptions.AllowFragments)
            print("parsedObject:", parsedObject)
            return parsedObject as? NSDictionary
        } catch {
            print("parse error")
        }
        return nil
    }
    
    func processCompletePacket(data: NSData) {
        let headerData = data.subdataWithRange(NSMakeRange(0, headerLength))
        let spt = parseHeader(headerData).spt
        let payloadLength = parseHeader(headerData).payloadLength
        let leftData = data.subdataWithRange(NSMakeRange(headerLength, payloadLength))
        
        let type: PacketType = PacketType(rawValue: spt)!
        switch type {
        case .SPT_NONE:
            break
        case .SPT_STATUS:
            break
        case .SPT_CMD:
            break
        case .SPT_LOG:
            break
        case .SPT_FILE_START:
            let dict = self.parseJsonBody(leftData)
            
        case .SPT_FILE_SENDING:
            break
        }
    }
    
    
}