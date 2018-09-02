//
//  UserModel.swift
//
//  Created by Filipe Augusto on 01/09/2018.
//  Copyright © 2018 Filipe Augusto. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class UserModel: NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let createdAt = "created_at"
        static let updatedAt = "updated_at"
        static let email = "email"
        static let id = "id"
        static let telefone = "telefone"
        static let nome = "nome"
    }
    
    // MARK: Properties
    public var createdAt: String?
    public var updatedAt: String?
    public var email: String?
    public var id: Int?
    public var telefone: String?
    public var nome: String?
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance.
    ///
    /// - returns: An initialized instance of the class.
    public init() {}
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public required init(json: JSON) {
        createdAt = json[SerializationKeys.createdAt].string
        updatedAt = json[SerializationKeys.updatedAt].string
        email = json[SerializationKeys.email].string
        id = json[SerializationKeys.id].int
        telefone = json[SerializationKeys.telefone].string
        nome = json[SerializationKeys.nome].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = createdAt { dictionary[SerializationKeys.createdAt] = value }
        if let value = updatedAt { dictionary[SerializationKeys.updatedAt] = value }
        if let value = email { dictionary[SerializationKeys.email] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = telefone { dictionary[SerializationKeys.telefone] = value }
        if let value = nome { dictionary[SerializationKeys.nome] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.createdAt = aDecoder.decodeObject(forKey: SerializationKeys.createdAt) as? String
        self.updatedAt = aDecoder.decodeObject(forKey: SerializationKeys.updatedAt) as? String
        self.email = aDecoder.decodeObject(forKey: SerializationKeys.email) as? String
        self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
        self.telefone = aDecoder.decodeObject(forKey: SerializationKeys.telefone) as? String
        self.nome = aDecoder.decodeObject(forKey: SerializationKeys.nome) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(createdAt, forKey: SerializationKeys.createdAt)
        aCoder.encode(updatedAt, forKey: SerializationKeys.updatedAt)
        aCoder.encode(email, forKey: SerializationKeys.email)
        aCoder.encode(id, forKey: SerializationKeys.id)
        aCoder.encode(telefone, forKey: SerializationKeys.telefone)
        aCoder.encode(nome, forKey: SerializationKeys.nome)
    }
    
    
    
}
