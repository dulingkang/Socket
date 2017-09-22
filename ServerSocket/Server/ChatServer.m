//
//  ChatServer.m
//  Server
//
//  Created by Shawn on 2017/9/22.
//  Copyright © 2017年 Shawn. All rights reserved.
//

#import "ChatServer.h"
#import "GCDAsyncSocket.h"

@interface ChatServer()<GCDAsyncSocketDelegate>
@end

@implementation ChatServer {
    GCDAsyncSocket *_serverSocket;
    dispatch_queue_t _queue;
}

- (instancetype)init {
    if (self = [super init]) {
        _clientSockets = [NSMutableArray arrayWithCapacity:1];
        _queue = dispatch_get_global_queue(0, 0);
        _serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_queue];
    }
    return self;
}

- (void)startServer {
    NSError *error;
    [_serverSocket acceptOnPort:9898 error:&error];
    if (!error) {
        NSLog(@"server open success");
    } else {
        NSLog(@"server open error");
    }
}

#pragma mark - delegate
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    NSLog(@"server socket  %p, client socket %p", sock, newSocket);
    NSLog(@"%s",__func__);
    [self.clientSockets addObject:newSocket];
    
    //newSocket为客户端的Socket。这里读取数据
    [newSocket readDataWithTimeout:-1 tag:100];
}

-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"%s",__func__);
    [sock readDataWithTimeout:-1 tag:100];
}

#pragma mark 接收客户端传递过来的数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    //sock为客户端的socket
    NSLog(@"客户端的socket %p",sock);
    //接收到数据
    NSString *receiverStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"length:%ld",receiverStr.length);
    // 把回车和换行字符去掉，接收到的字符串有时候包括这2个，导致判断quit指令的时候判断不相等
    receiverStr = [receiverStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    receiverStr = [receiverStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    //判断是登录指令还是发送聊天数据的指令。这些指令都是自定义的
    //登录指令
    if([receiverStr hasPrefix:@"iam:"]){
        // 获取用户名
        NSString *user = [receiverStr componentsSeparatedByString:@":"][1];
        // 响应给客户端的数据
        NSString *respStr = [user stringByAppendingString:@"has joined"];
        [sock writeData:[respStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    }
    //聊天指令
    if ([receiverStr hasPrefix:@"msg:"]) {
        //截取聊天消息
        NSString *msg = [receiverStr componentsSeparatedByString:@":"][1];
        [sock writeData:[msg dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    }
    //quit指令
    if ([receiverStr isEqualToString:@"quit"]) {
        //断开连接
        [sock disconnect];
        //移除socket
        [self.clientSockets removeObject:sock];
    }
    NSLog(@"%s",__func__);
}
@end
