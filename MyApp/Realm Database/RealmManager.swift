//
//  RealmManager.swift
//  MyApp
//
//  Created by SAHIL AMRUT AGASHE on 15/12/23.
//

import RealmSwift

final class RealmManager {
    
    private init() {}
    
    static let shared = RealmManager()
    
    private var realm: Realm {
        let realm = try! Realm()
        return realm
    }
    
    var databasePath: String? {
        return Realm.Configuration.defaultConfiguration.fileURL?.absoluteString
    }
    
    var realmUserArray: [RealmUser] {
        let arr = realm.objects(RealmUser.self)
        return Array(arr)
    }

    
    func addRealmUser(user: RealmUser) {
        try! realm.write({
            realm.add(user)
        })
    }
    
    // delete all objects from the Realm
    func deleteDatabase() {
        try! realm.write({
            realm.deleteAll()
        })
    }
}
