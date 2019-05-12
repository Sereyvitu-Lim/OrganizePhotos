//
//  TableCellBaseClass.swift
//  Organize Photo
//
//  Created by Sereyvitu Lim on 5/2/19.
//  Copyright © 2019 com.SereyvituLim. All rights reserved.
//

import UIKit

class TableCellBaseClass: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        updateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView() { }
    
}
