//
//  UserSingleton.swift
//  MyDocuments
//
//  Created by Filipe Augusto on 01/09/2018.
//  Copyright © 2018 Filipe Augusto. All rights reserved.
//

import UIKit

class UserSingleton: NSObject {
    static var sharedUser: UserModel?
    static var arraySharedUser: [UserModel]?
    static var sharedUserSelect = 0
}
