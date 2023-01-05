//
//  LocationsRepository.swift
//  location
//
//  Created by Daniel Ferrer on 27/12/22.
//

import Foundation
import Combine

class LocationsRepository {
    
    private var appState: AppState
    private var cancellableSet: Set<AnyCancellable> = []
    
    @Published var locations: [LocationVO] = []
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    public func loadLocations() {
        appState.$dbManager
            .compactMap { $0 }
            .sink(receiveCompletion: { _ in}, receiveValue: { db in
                self.loadLocations(db: db)
            })
            .store(in: &self.cancellableSet)
    }
    
    private func loadLocations(db: AsyncDataManager) {
        try? db.get(type: Location.self)
            .collectionPublisher
            .subscribe(on: DispatchQueue(label: "background queue"))
            .freeze()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { results in
                let data: [LocationVO] = results.compactMap { LocationVO(id: $0._id?.stringValue ?? "" , title: $0.name ?? "") }
                self.locations = data
            })
            .store(in: &self.cancellableSet)
    }
    
}
