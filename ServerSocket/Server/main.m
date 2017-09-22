//
//  main.m
//  Server
//
//  Created by Shawn on 2017/9/22.
//  Copyright © 2017年 Shawn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatServer.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        ChatServer *server = [ChatServer new];
        [server startServer];
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}
