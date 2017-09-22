//
//  ViewController.m
//  ClientSocket
//
//  Created by Shawn on 2017/9/22.
//  Copyright © 2017年 Shawn. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"

@interface ViewController ()<GCDAsyncSocketDelegate>

@end

@implementation ViewController {
    GCDAsyncSocket *_socket;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self connect2Server];
    [self login];
    [self sendMsg:nil];
}

- (void)connect2Server{
    //1.主机与端口号
    NSString *host = @"127.0.0.1";
    int port = 9898;
    
    //初始化socket，这里有两种方式。分别为是主/子线程中运行socket。根据项目不同而定
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];//这种是在主线程中运行
    //_socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)]; 这种是在子线程中运行
    
    //开始连接
    NSError *error = nil;
    [_socket connectToHost:host onPort:port error:&error];
    if(error) {
        NSLog(@"error:%@", error);
    }
    
}

-(void)login{
    //登录String
    NSString *loginStr = @"iam:I am login!";
    NSData *loginData = [loginStr dataUsingEncoding: NSUTF8StringEncoding];
    //发送登录指令。-1表示不超时。tag200表示这个指令的标识，很大用处
    [_socket writeData: loginData withTimeout:-1 tag:200];
}

//发送聊天数据
-(void)sendMsg:(NSString*)msg{
    NSString *sendMsg = @"msg:I send message to u!";
    NSData *sendData = [sendMsg dataUsingEncoding: NSUTF8StringEncoding];
    [_socket writeData:sendData withTimeout:-1 tag:201];
}

#pragma mark -socket的代理

#pragma mark 连接成功

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    //连接成功
    NSLog(@"%s",__func__);
}

#pragma mark 断开连接
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    if (err) {
        NSLog(@"连接失败");
    }else{
        NSLog(@"正常断开");
    }
}

#pragma mark 数据发送成功
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"%s",__func__);
    //发送完数据手动读取
    [sock readDataWithTimeout:-1 tag:tag];
}

#pragma mark 读取数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    //代理是在主/子线程调用
    NSLog(@"%@",[NSThread currentThread]);
    NSString *receiverStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (tag == 200) {
        //登录指令
    }else if(tag == 201){
        //聊天数据
    }
    NSLog(@"%s %@",__func__,receiverStr);
}
@end
