//
//  SVProgressHUD+Extensions.swift
//  Organize Photo
//
//  Created by Sereyvitu Lim on 5/9/19.
//  Copyright © 2019 com.SereyvituLim. All rights reserved.
//

import SVProgressHUD

extension SVProgressHUD {
    
    static func setupProgressHUDStyle() {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setBackgroundColor(.orange)
        SVProgressHUD.setForegroundColor(.white)
        SVProgressHUD.setFont(UIFont.boldSystemFont(ofSize: 22))
    }
    
}
