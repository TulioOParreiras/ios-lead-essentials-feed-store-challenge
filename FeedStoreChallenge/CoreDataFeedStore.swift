//
//  CoreDataFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Usemobile on 11/03/20.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

import CoreData

public class CoreDataFeedStore: FeedStore {
    
    public init() { }
    
    private let identifier = "com.essentialdeveloper.FeedStoreChallenge"
    private let model = "FeedCache"
    
    private let queue = DispatchQueue(label: "\(CoreDataFeedStore.self)Queue", qos: .userInitiated, attributes: .concurrent)
    
    public lazy var persistentContainer: NSPersistentContainer = {
        let feedStoreChallengeBundle = Bundle(identifier: identifier)
        let modelURL = feedStoreChallengeBundle!.url(forResource: model, withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        let container = NSPersistentContainer(name: model, managedObjectModel: managedObjectModel!)
        container.loadPersistentStores { (storeDescription, error) in
            if let err = error {
                fatalError("Loading of store failed: \(err)")
            }
        }
        
        return container
    }()
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            let context = self.persistentContainer.viewContext
            let fetchCache = NSFetchRequest<CoreDataCache>(entityName: "CoreDataCache")
            let caches = try! context.fetch(fetchCache)
            caches.forEach({
                context.delete($0)
            })
            let fetchFeedImage = NSFetchRequest<CoreDataFeedImage>(entityName: "CoreDataFeedImage")
            let feedImages = try! context.fetch(fetchFeedImage)
            feedImages.forEach({
                context.delete($0)
            })
            try! context.save()
            completion(nil)
        }
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            let context = self.persistentContainer.viewContext
            let cache = NSEntityDescription.insertNewObject(forEntityName: "CoreDataCache", into: context) as! CoreDataCache
            feed.forEach({
                let coreDataFeedImage = NSEntityDescription.insertNewObject(forEntityName: "CoreDataFeedImage", into: context) as! CoreDataFeedImage
                coreDataFeedImage.id = $0.id
                coreDataFeedImage.imageDescription = $0.description
                coreDataFeedImage.location = $0.location
                coreDataFeedImage.url = $0.url
                cache.addToFeed(coreDataFeedImage)
            })
            cache.timestamp = timestamp
            
            try! context.save()
            completion(nil)
        }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        queue.async { [weak self] in
            guard let self = self else { return }
            let context = self.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<CoreDataCache>(entityName: "CoreDataCache")
            do {
                let fetchResponse = try context.fetch(fetchRequest)
                if let cache = fetchResponse.last {
                    let feed = cache.localFeed
                    let timestamp = cache.timestamp
                    completion(.found(feed: feed, timestamp: timestamp))
                } else {
                    completion(.empty)
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}
