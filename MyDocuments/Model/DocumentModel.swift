//
//  DocumentModel.swift
//
//  Created by Filipe Augusto on 01/09/2018.
//  Copyright © 2018 Filipe Augusto. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class DocumentModel: NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let data = "data"
        static let updatedAt = "updated_at"
        static let id = "id"
        static let createdAt = "created_at"
        static let photoId = "photo_id"
        static let userId = "user_id"
        static let nome = "nome"
    }
    
    // MARK: Properties
    public var data: String?
    public var updatedAt: String?
    public var id: Int?
    public var createdAt: String?
    public var photoId: Int?
    public var userId: Int?
    public var nome: String?
    
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
        data = json[SerializationKeys.data].string
        updatedAt = json[SerializationKeys.updatedAt].string
        id = json[SerializationKeys.id].int
        createdAt = json[SerializationKeys.createdAt].string
        photoId = json[SerializationKeys.photoId].int
        userId = json[SerializationKeys.userId].int
        nome = json[SerializationKeys.nome].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = data { dictionary[SerializationKeys.data] = value }
        if let value = updatedAt { dictionary[SerializationKeys.updatedAt] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = createdAt { dictionary[SerializationKeys.createdAt] = value }
        if let value = photoId { dictionary[SerializationKeys.photoId] = value }
        if let value = userId { dictionary[SerializationKeys.userId] = value }
        if let value = nome { dictionary[SerializationKeys.nome] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.data = aDecoder.decodeObject(forKey: SerializationKeys.data) as? String
        self.updatedAt = aDecoder.decodeObject(forKey: SerializationKeys.updatedAt) as? String
        self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
        self.createdAt = aDecoder.decodeObject(forKey: SerializationKeys.createdAt) as? String
        self.photoId = aDecoder.decodeObject(forKey: SerializationKeys.photoId) as? Int
        self.userId = aDecoder.decodeObject(forKey: SerializationKeys.userId) as? Int
        self.nome = aDecoder.decodeObject(forKey: SerializationKeys.nome) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(data, forKey: SerializationKeys.data)
        aCoder.encode(updatedAt, forKey: SerializationKeys.updatedAt)
        aCoder.encode(id, forKey: SerializationKeys.id)
        aCoder.encode(createdAt, forKey: SerializationKeys.createdAt)
        aCoder.encode(photoId, forKey: SerializationKeys.photoId)
        aCoder.encode(userId, forKey: SerializationKeys.userId)
        aCoder.encode(nome, forKey: SerializationKeys.nome)
    }
    
}
