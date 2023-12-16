//
//  RealmUser.swift
//  MyApp
//
//  Created by SAHIL AMRUT AGASHE on 15/12/23.
//

import RealmSwift
import Foundation

class RealmUser: Object {
    @Persisted var id = UUID()
    @Persisted var fullname: String?
    @Persisted var email: String?
    @Persisted var mobileNumber: String?
    @Persisted var bookingDate: String?
    @Persisted var inTime: String?
    @Persisted var outTime: String?
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(user: User) {
        self.init()
        self.fullname = user.fullname
        self.email = user.email
        self.mobileNumber = user.mobileNumber
        self.bookingDate = user.bookingDate
        self.inTime = user.inTime
        self.outTime = user.outTime
    }
    
}
