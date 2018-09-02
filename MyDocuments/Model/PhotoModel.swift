//
//  PhotoModel.swift
//
//  Created by Filipe Augusto on 01/09/2018.
//  Copyright © 2018 Filipe Augusto. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class PhotoModel: NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let img = "img"
        static let updatedAt = "updated_at"
        static let id = "id"
        static let createdAt = "created_at"
    }
    
    // MARK: Properties
    public var img: String?
    public var updatedAt: String?
    public var id: Int?
    public var createdAt: String?
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance.
    ///
    /// - returns: An initialized instance of the class.
    public init() {}
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public required init(json: JSON) {
        img = json[SerializationKeys.img].string
        updatedAt = json[SerializationKeys.updatedAt].string
        id = json[SerializationKeys.id].int
        createdAt = json[SerializationKeys.createdAt].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = img { dictionary[SerializationKeys.img] = value }
        if let value = updatedAt { dictionary[SerializationKeys.updatedAt] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = createdAt { dictionary[SerializationKeys.createdAt] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.img = aDecoder.decodeObject(forKey: SerializationKeys.img) as? String
        self.updatedAt = aDecoder.decodeObject(forKey: SerializationKeys.updatedAt) as? String
        self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
        self.createdAt = aDecoder.decodeObject(forKey: SerializationKeys.createdAt) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(img, forKey: SerializationKeys.img)
        aCoder.encode(updatedAt, forKey: SerializationKeys.updatedAt)
        aCoder.encode(id, forKey: SerializationKeys.id)
        aCoder.encode(createdAt, forKey: SerializationKeys.createdAt)
    }
    
}
