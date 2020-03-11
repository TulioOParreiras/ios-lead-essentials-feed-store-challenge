//
//  CoreDataCache+CoreDataClass.swift
//  Tests
//
//  Created by Usemobile on 11/03/20.
//  Copyright © 2020 Essential Developer. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CoreDataCache)
public class CoreDataCache: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataCache> {
        return NSFetchRequest<CoreDataCache>(entityName: "CoreDataCache")
    }

    @NSManaged public var timestamp: Date
    @NSManaged public var feed: NSSet?
    
    private var feedAr: [CoreDataFeedImage] {
        let set = feed as? Set<CoreDataFeedImage> ?? []
        return set.sorted(by: { $0.createdAt < $1.createdAt })
    }
    
    public var localFeed: [LocalFeedImage] {
        return feedAr.map { $0.local } 
    }

    @objc(addFeedObject:)
    @NSManaged public func addToFeed(_ value: CoreDataFeedImage)

    @objc(removeFeedObject:)
    @NSManaged public func removeFromFeed(_ value: CoreDataFeedImage)

    @objc(addFeed:)
    @NSManaged public func addToFeed(_ values: NSSet)

    @objc(removeFeed:)
    @NSManaged public func removeFromFeed(_ values: NSSet)

}
