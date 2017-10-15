//
//  user.swift
//  
//
//  Created by Nick Grah on 10/14/17.
//

import Foundation


class user {
    //MARK: Properties
    
    var name: String
    var password: String

    
    //MARK: Initialization
    init?(name: String, password: String) {
    if (name.isEmpty || password.isEmpty) {
        return nil
    }
    
  
        self.name = "n"
        self.password = "p"
    }
    
}
