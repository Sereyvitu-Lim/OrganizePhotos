//
//  CategoryFetch.swift
//  Organize Photo
//
//  Created by Sereyvitu Lim on 5/5/19.
//  Copyright © 2019 com.SereyvituLim. All rights reserved.
//

import Foundation
import CoreData

class CategoryEntity {
    
//    static func fetchCategories() -> [Category] {
//        var categories = [Category]()
//        let request = Category.createFetchRequest()
//        do {
//            categories = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
//        } catch {
//            fatalError("Failed to Fetch Category Data")
//        }
//        return categories
//    }
    
    static func fetchCategories() -> NSFetchedResultsController<Category> {
        let request = Category.createFetchRequest()
        let sort = NSSortDescriptor(key: "label", ascending: true)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 10
        
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchedResults = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResults.performFetch()
            return fetchedResults
        } catch {
            fatalError("Failed to Fetch Category Data")
        }
    }
    
    private static func createCategory() -> Category {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let category = Category(context: context)
        return category
    }
    
    static func createCategoryWithImageRelationship(desc: String, image: Image) {
        let category = CategoryEntity.fetchCategoryByLabel(label: desc)
        if category == nil {
            let cate = CategoryEntity.createCategory()
            configureCategoryEntity(category: cate, desc: desc, image: image)
        } else {
            if let category = category {
                let isContained = isContainedImage(category: category, image: image)
                if !isContained {
                    configureCategoryEntity(category: category, desc: desc, image: image)
                }
            }
        }
    }
    
    /**
     This function check to see if category already contains the image
     @Parameter:
     category: Category
     image: Image
     @Return Value: Bool
    */
    private static func isContainedImage(category: Category, image: Image) -> Bool {
        let images = category.images?.allObjects as! [Image]
        let isContained = images.filter({ $0.data == image.data })
        return isContained.count == 0 ? false : true
    }
    
    private static func configureCategoryEntity(category: Category, desc: String, image: Image) {
        category.label = desc
        category.addToImages(image)
        image.addToCategories(category)
    }
    
    private static func fetchCategoryByLabel(label: String) -> Category? {
        var category: Category? = nil
        let request = Category.createFetchRequest()
        request.predicate = NSPredicate(format: "label = %@", label)
        do {
            let temp = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
            category = temp.first
            return category
        } catch {
            fatalError("Cannot Fetch Category with \(label) Label")
        }
    }
    
}
