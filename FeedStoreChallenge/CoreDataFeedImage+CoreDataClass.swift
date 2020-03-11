//
//  CoreDataFeedImage+CoreDataClass.swift
//  Tests
//
//  Created by Usemobile on 11/03/20.
//  Copyright © 2020 Essential Developer. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CoreDataFeedImage)
public class CoreDataFeedImage: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataFeedImage> {
        return NSFetchRequest<CoreDataFeedImage>(entityName: "CoreDataFeedImage")
    }

    @NSManaged public var id: UUID
    @NSManaged public var location: String?
    @NSManaged public var url: URL
    @NSManaged public var imageDescription: String?
    @NSManaged public var createdAt: Date
    
    var local: LocalFeedImage {
        return LocalFeedImage(id: id, description: imageDescription, location: location, url: url, createdAt: createdAt)
    }

}
