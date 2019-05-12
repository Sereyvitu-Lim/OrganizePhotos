//
//  CategoryImageCell.swift
//  Organize Photo
//
//  Created by Sereyvitu Lim on 5/2/19.
//  Copyright © 2019 com.SereyvituLim. All rights reserved.
//

import UIKit

class CategoryImageCell: CollectionCellBaseClass {
    
    private lazy var imageView: UIImageView =  {
        let image = UIImageView()
        image.contentMode = ContentMode.scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    var image: Image? {
        didSet {
            if let image = image {
                imageView.image = UIImage(data: image.data! as Data)
            }
        }
    }
    
    override func updateView() {
        setupConstraints()
    }
    
    private func setupConstraints() {
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": imageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": imageView]))
    }
    
}
