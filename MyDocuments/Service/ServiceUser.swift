//
//  ServiceUser.swift
//  MyDocuments
//
//  Created by Filipe Augusto on 01/09/2018.
//  Copyright © 2018 Filipe Augusto. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias HandlerObject = (Any?) -> Void



class ServiceUser: NSObject {
    let url = "https://mydocuments.herokuapp.com/users"
    var repostitoryUser = [UserModel]()
    
    
    /// CREATE USER
    ///
    /// - Parameter user: Create user
    /// - Returns: return
    func addUser(user: UserModel?) -> Bool {
        if let objUser = user {
            Alamofire.request(url, method: .post, parameters: objUser.dictionaryRepresentation(), encoding: JSONEncoding.default, headers: nil).response { (result) in
                print(result)
            }
            UserSingleton.sharedUser = objUser
            return true
        }
        return false
    }
    
    
    /// READ
    ///
    /// - Parameter callback: 
    public func loadUser(callback: @escaping HandlerObject) {
        Alamofire.request(url).responseJSON { response in
            print(response.result)
            if let json = response.result.value as? [AnyObject]{
                for user in json {
                    let userRepostitory = UserModel(json:JSON(user))
                    self.repostitoryUser.append(userRepostitory)
                }
                let sortedUser = self.repostitoryUser.sorted { $0.nome ?? "z" < $1.nome ?? "z" }
                
                callback(sortedUser)
            } else {
                print("ERROR SERVICE USER -----------------------------")
                print(response.description)
                callback(nil)
            }
        }
    }
}
