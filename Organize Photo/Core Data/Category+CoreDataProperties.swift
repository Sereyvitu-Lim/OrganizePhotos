//
//  Category+CoreDataProperties.swift
//  Organize Photo
//
//  Created by Sereyvitu Lim on 5/2/19.
//  Copyright © 2019 com.SereyvituLim. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }
    
    @NSManaged public var label: String?
    @NSManaged public var images: NSSet?

}

// MARK: Generated accessors for images
extension Category {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: Image)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: Image)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}
