//
//  ChatServer.h
//  Server
//
//  Created by Shawn on 2017/9/22.
//  Copyright © 2017年 Shawn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatServer : NSObject
@property (nonatomic, strong) NSMutableArray *clientSockets;

- (void)startServer;
@end
