//
//  ImageEntity.swift
//  Organize Photo
//
//  Created by Sereyvitu Lim on 5/5/19.
//  Copyright © 2019 com.SereyvituLim. All rights reserved.
//

import Foundation

class ImageEntity {
    
    static func createImage(data: Data) -> Image {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let image = Image(context: context)
        image.data = data as NSData
        return image
    }
    
    static func fetchImages() -> [Image] {
        var images = [Image]()
        let request = Image.createFetchRequest()
        do {
            images = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
        } catch {
            fatalError("Failed to Fetch Image Data")
        }
        return images
    }
    
    private static func configureCategoryEntity(category: Category, desc: String, image: Image) {
        category.label = desc
        category.addToImages(image)
        image.addToCategories(category)
    }
    
}
