//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import XCTest
import FeedStoreChallenge

import CoreData

class CoreDataFeedStore: FeedStore {
    
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
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        completion(nil)
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        
        let context = persistentContainer.viewContext
        let cache = NSEntityDescription.insertNewObject(forEntityName: "CoreDataCache", into: context) as! CoreDataCache
        feed.forEach({
            let coreDataFeedImage = NSEntityDescription.insertNewObject(forEntityName: "CoreDataFeedImage", into: context) as! CoreDataFeedImage
            coreDataFeedImage.id = $0.id
            coreDataFeedImage.imageDescription = $0.description
            coreDataFeedImage.location = $0.location
            coreDataFeedImage.url = $0.url
            coreDataFeedImage.createdAt = $0.createdAt
            cache.addToFeed(coreDataFeedImage)
        })
        cache.timestamp = timestamp
        
        try! context.save()
        completion(nil)
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CoreDataCache>(entityName: "CoreDataCache")
        let fetchResponse = try! context.fetch(fetchRequest)
        if let cache = fetchResponse.last {
            let feed = cache.localFeed
            let timestamp = cache.timestamp
            completion(.found(feed: feed, timestamp: timestamp))
        } else {
            completion(.empty)
        }
    }
    
}


class FeedStoreChallengeTests: XCTestCase, FeedStoreSpecs {
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private  func deleteStoreArtifacts() {
        let context = CoreDataFeedStore().persistentContainer.viewContext
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
    }
    
    override func setUp() {
        super.setUp()
        
        self.setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        self.undoStoreSideEffects()
    }
	
//
//   We recommend you to implement one test at a time.
//   Uncomment the test implementations one by one.
// 	 Follow the process: Make the test pass, commit, and move to the next one.
//

	func test_retrieve_deliversEmptyOnEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
	}

	func test_retrieve_hasNoSideEffectsOnEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
	}

	func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
	}

	func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
	}

	func test_insert_deliversNoErrorOnEmptyCache() {
		let sut = makeSUT()

		assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
	}

	func test_insert_deliversNoErrorOnNonEmptyCache() {
		let sut = makeSUT()

		assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
	}

	func test_insert_overridesPreviouslyInsertedCacheValues() {
		let sut = makeSUT()

		assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
	}

	func test_delete_deliversNoErrorOnEmptyCache() {
		let sut = makeSUT()

		assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
	}

	func test_delete_hasNoSideEffectsOnEmptyCache() {
		let sut = makeSUT()

		assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
	}

	func test_delete_deliversNoErrorOnNonEmptyCache() {
		let sut = makeSUT()

		assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
	}

	func test_delete_emptiesPreviouslyInsertedCache() {
//		let sut = makeSUT()
//
//		assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
	}

	func test_storeSideEffects_runSerially() {
//		let sut = makeSUT()
//
//		assertThatSideEffectsRunSerially(on: sut)
	}
	
	// - MARK: Helpers
	
	private func makeSUT() -> FeedStore {
        let sut = CoreDataFeedStore()
        return sut
	}
	
}

//
// Uncomment the following tests if your implementation has failable operations.
// Otherwise, delete the commented out code!
//

//extension FeedStoreChallengeTests: FailableRetrieveFeedStoreSpecs {
//
//	func test_retrieve_deliversFailureOnRetrievalError() {
////		let sut = makeSUT()
////
////		assertThatRetrieveDeliversFailureOnRetrievalError(on: sut)
//	}
//
//	func test_retrieve_hasNoSideEffectsOnFailure() {
////		let sut = makeSUT()
////
////		assertThatRetrieveHasNoSideEffectsOnFailure(on: sut)
//	}
//
//}

//extension FeedStoreChallengeTests: FailableInsertFeedStoreSpecs {
//
//	func test_insert_deliversErrorOnInsertionError() {
////		let sut = makeSUT()
////
////		assertThatInsertDeliversErrorOnInsertionError(on: sut)
//	}
//
//	func test_insert_hasNoSideEffectsOnInsertionError() {
////		let sut = makeSUT()
////
////		assertThatInsertHasNoSideEffectsOnInsertionError(on: sut)
//	}
//
//}

//extension FeedStoreChallengeTests: FailableDeleteFeedStoreSpecs {
//
//	func test_delete_deliversErrorOnDeletionError() {
////		let sut = makeSUT()
////
////		assertThatDeleteDeliversErrorOnDeletionError(on: sut)
//	}
//
//	func test_delete_hasNoSideEffectsOnDeletionError() {
////		let sut = makeSUT()
////
////		assertThatDeleteHasNoSideEffectsOnDeletionError(on: sut)
//	}
//
//}
