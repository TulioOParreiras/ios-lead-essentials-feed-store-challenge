//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Foundation

public struct LocalFeedImage: Equatable {
	public let id: UUID
	public let description: String?
	public let location: String?
	public let url: URL
    public let createdAt: Date
	
    public init(id: UUID, description: String?, location: String?, url: URL, createdAt: Date? = nil) {
		self.id = id
		self.description = description
		self.location = location
		self.url = url
        self.createdAt = createdAt ?? Date()
	}
}
