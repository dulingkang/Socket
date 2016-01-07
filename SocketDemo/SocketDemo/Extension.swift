//
//  Extension.swift
//  SocketDemo
//
//  Created by dulingkang on 15/12/30.
//  Copyright © 2015年 dulingkang. All rights reserved.
//

import Foundation

extension String {
    func suffix() -> String {
        let splitArray = self.componentsSeparatedByString(".")
        return splitArray.last!
    }
}