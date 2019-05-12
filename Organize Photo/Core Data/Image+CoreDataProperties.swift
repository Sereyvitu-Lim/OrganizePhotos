//
//  Image+CoreDataProperties.swift
//  Organize Photo
//
//  Created by Sereyvitu Lim on 5/2/19.
//  Copyright © 2019 com.SereyvituLim. All rights reserved.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var data: NSData?
    @NSManaged public var categories: NSSet?

}

// MARK: Generated accessors for categories
extension Image {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: Category)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: Category)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}
