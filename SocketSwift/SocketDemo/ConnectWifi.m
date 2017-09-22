//
//  ConnectWifi.m
//  SocketDemo
//
//  Created by dulingkang on 15/12/22.
//  Copyright © 2015年 dulingkang. All rights reserved.
//

#import "ConnectWifi.h"
#import <SystemConfiguration/CaptiveNetwork.h>


@implementation ConnectWifi

+ (void)connectWithOneSsid:(NSString *)ssid {
    NSString *values[] = {ssid};
    CFArrayRef arrayRef = CFArrayCreate(kCFAllocatorDefault,(void *)values,
                                        (CFIndex)1, &kCFTypeArrayCallBacks);
    if( CNSetSupportedSSIDs(arrayRef)) {
//        NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
        if (CNMarkPortalOnline((__bridge CFStringRef)(ssid))) {
                    NSLog(@"success");

        }
    }
    
}

@end

