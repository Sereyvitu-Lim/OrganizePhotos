//
//  CategoryCell.swift
//  Organize Photo
//
//  Created by Sereyvitu Lim on 5/2/19.
//  Copyright © 2019 com.SereyvituLim. All rights reserved.
//

import UIKit

class CategoryCell: TableCellBaseClass {
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var category: Category? {
        didSet {
            if let category = category {
                categoryLabel.text = category.label
            }
        }
    }
    
    override func updateView() {
        setupConstraints()
    }
    
    private func setupConstraints() {
        addSubview(categoryLabel)
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0]-12-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": categoryLabel]))
        addConstraint(NSLayoutConstraint.init(item: categoryLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
}
