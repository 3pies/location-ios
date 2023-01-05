//
//  AppState.swift
//  location
//
//  Created by Daniel Ferrer on 27/12/22.
//

import Foundation
import SwiftUI
import Combine
import Realm
import RealmSwift

class AppState: ObservableObject {
    
    private var configuration: Configuration
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var error: Error?
    @Published var user: RLMUser?
    @Published var dbManager: AsyncDataManager?
    
    @Published var isAppLoaded = false
    
    private var loginPublisher = PassthroughSubject<RealmSwift.User, Error>()
    private var publicRealmPublisher = PassthroughSubject<Realm, Error>()
    
    private lazy var app: RealmSwift.App? = {
        guard let appId = configuration.realmSyncAppID else { return nil }
        
        let app: RealmSwift.App = RealmSwift.App(id: appId)
        
        let syncManager = app.syncManager
        
        //LOGS
        syncManager.logLevel = .info
        syncManager.logger = { (level: SyncLogLevel, message: String) in
            print("[\(level)] Sync - \(message)")
        }
        
        //ERRORS
        syncManager.errorHandler = { (error, session) in
            print("Sync Error: \(error)")
            
            if let syncError = error as? SyncError {
                switch syncError.code {
                case .permissionDeniedError:
                    //401
                    _ = app.currentUser?.logOut()
                        .sink(receiveCompletion: {
                            print($0)
                        }, receiveValue: {
                            print($0)
                        })
                case .clientResetError:
                    if let (path, clientResetToken) = syncError.clientResetInfo() {
                        SyncSession.immediatelyHandleError(clientResetToken, syncManager: app.syncManager)
                    }
                default:
                    print(syncError.localizedDescription)
                }
            
            }
            
            if let session = session {
                print("Sync session: \(session); Error: \(error.localizedDescription)")
            }
            
        }
        
        return app
    }()
    
    init(configuration: Configuration) {
        self.configuration = configuration
        
        guard let app = app else { return }
        
        app.login(credentials: Credentials.anonymous)
            .subscribe(on: DispatchQueue(label: "background queue"))
            .receive(on: DispatchQueue.main)
            .sink {
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            } receiveValue: { user in
                self.error = nil
                self.user = user
                
                self.loginPublisher.send(user)
                
                self.isAppLoaded = self.checkIsAppLoaded()
            }
            .store(in: &cancellables)
        
        loginPublisher
            .subscribe(on: DispatchQueue(label: "background queue"))
            .receive(on: DispatchQueue.main)
            .flatMap { user -> RealmPublishers.AsyncOpenPublisher in
                var realmConfig = user.configuration(partitionValue: "public")
                
                realmConfig.objectTypes = [
                    Location.self
                ]
                
                return Realm.asyncOpen(configuration: realmConfig)
            }
            .receive(on: DispatchQueue.main)
            .subscribe(publicRealmPublisher)
            .store(in: &cancellables)
        
        
        publicRealmPublisher
            .subscribe(on: DispatchQueue(label: "background queue"))
            .sink { result in
                if case let .failure(error) = result {
                    self.error = error
                }
            } receiveValue: { realm in
                print("Connected to Async database")
                self.dbManager = AsyncDataManager(database: realm)
                self.isAppLoaded = self.checkIsAppLoaded()
                
            }
            .store(in: &cancellables)
        
    }
    
    private func checkIsAppLoaded() -> Bool {
        return user != nil && dbManager != nil
    }
    
}
