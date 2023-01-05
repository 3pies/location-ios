//
//  Configuration.swift
//  location
//
//  Created by Daniel Ferrer on 27/12/22.
//

import Foundation

class Configuration {
    
    let realmSyncAppID: String? = Bundle.main.infoDictionary?["REALM_SYNC_APP_ID"] as? String
    
}
