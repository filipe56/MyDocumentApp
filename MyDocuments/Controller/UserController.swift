//
//  UserController.swift
//  MyDocuments
//
//  Created by Filipe Augusto on 01/09/2018.
//  Copyright © 2018 Filipe Augusto. All rights reserved.
//

import Foundation

class UserController: NSObject {
    
    
    func loadUser(callback: @escaping HandlerObject) {
        ServiceUser().loadUser { result in
            if result != nil {
                callback(result)
            } else {
                callback(nil)
            }
        }
    }
        
    
    func saveUser(userName: String?, userEmail: String?, userPhone: String? ) -> Bool {
        
        if let name = userName, let email  = userEmail, let phone = userPhone {
            
            let objUser = UserModel()
            objUser.nome = name
            objUser.email = email
            objUser.telefone = phone

            return ServiceUser().addUser(user: objUser)
        }
        return false
    }
    
    
}
