//
//  AsyncDataManager.swift
//  location
//
//  Created by Daniel Ferrer on 27/12/22.
//

import Foundation
import RealmDataManager
import RealmSwift

class AsyncDataManager: Database {
    var database: Realm? = nil
    var configuration: DatabaseConfiguration
    
    public init(database: RealmSwift.Realm) {
        self.configuration = DatabaseConfiguration()
        self.database = database
    }
    
    func reset() {
        database = nil
    }
    
    
}
