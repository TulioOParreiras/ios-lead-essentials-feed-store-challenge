////
////  CoreDataFeedStore.swift
////  FeedStoreChallenge
////
////  Created by Usemobile on 11/03/20.
////  Copyright © 2020 Essential Developer. All rights reserved.
////
//
//import Foundation
//
//import CoreData
//
//public class CoreDataFeedStore: FeedStore {
//    
//    public init() { }
//    
//    private let identifier = "com.essentialdeveloper.FeedStoreChallenge"
//    private let model = "FeedCache"
//    
//    private lazy var persistentContainer: NSPersistentContainer = {
//        let feedStoreChallengeBundle = Bundle(identifier: identifier)
//        let modelURL = feedStoreChallengeBundle!.url(forResource: model, withExtension: "momd")!
//        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
//        let container = NSPersistentContainer(name: model, managedObjectModel: managedObjectModel!)
//        container.loadPersistentStores { (storeDescription, error) in
//            if let err = error {
//                fatalError("Loading of store failed: \(err)")
//            }
//        }
//        
//        return container
//    }()
//    
//    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
//    }
//    
//    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
//        
//        let context = persistentContainer.viewContext
//        let cache = NSEntityDescription.insertNewObject(forEntityName: "CoreDataCache", into: context) as! CoreDataCache
//        feed.forEach({
//            let coreDataFeedImage = NSEntityDescription.insertNewObject(forEntityName: "CoreDataFeedImage", into: context) as! CoreDataFeedImage
//            coreDataFeedImage.id = $0.id
//            coreDataFeedImage.imageDescription = $0.description
//            coreDataFeedImage.location = $0.location
//            coreDataFeedImage.url = $0.url
//            cache.addToFeed(coreDataFeedImage)
//        })
//        cache.timestamp = timestamp
//        
//        try! context.save()
//        completion(nil)
//    }
//    
//    public func retrieve(completion: @escaping RetrievalCompletion) {
//        completion(.empty)
//        let context = persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<CoreDataCache>(entityName: "CoreDataCache")
//        let fetchResponse = try! context.fetch(fetchRequest)
//        let cache = fetchResponse.last!
//        completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
//    }
//    
//}
