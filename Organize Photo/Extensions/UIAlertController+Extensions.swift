//
//  UIAlertController+Extensions.swift
//  Organize Photo
//
//  Created by Sereyvitu Lim on 5/6/19.
//  Copyright © 2019 com.SereyvituLim. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func createAlertController(title: String, message: String, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        _ = actions.map({ alert.addAction($0) })
        return alert
    }
    
}
