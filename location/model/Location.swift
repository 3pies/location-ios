//
//  Location.swift
//  location
//
//  Created by Daniel Ferrer on 27/12/22.
//

import Foundation
import RealmSwift

class Location: Object {
    @Persisted(primaryKey: true) var _id: ObjectId?

    @Persisted var _partition: String = ""

    @Persisted var latitude: Double?

    @Persisted var longitude: Double?

    @Persisted var name: String?
}
