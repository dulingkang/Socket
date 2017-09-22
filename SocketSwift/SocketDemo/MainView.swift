//
//  MainView.swift
//  SocketDemo
//
//  Created by dulingkang on 16/1/7.
//  Copyright © 2016年 dulingkang. All rights reserved.
//

import UIKit

class MainView: UIView {

    var imageView: UIImageView!
    //MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    //MARK: - private method
    private func initViews() {
    }
}
