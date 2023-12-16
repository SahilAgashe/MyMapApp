//
//  BookingTableViewCell.swift
//  MyApp
//
//  Created by SAHIL AMRUT AGASHE on 15/12/23.
//

import UIKit

class BookingTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileNoLabel: UILabel!
    @IBOutlet weak var bookingDateLabel: UILabel!
    @IBOutlet weak var inTimeLabel: UILabel!
    @IBOutlet weak var outTimeLabel: UILabel!
    
    //MARK: - Properties
    var realmUser: RealmUser? {
        didSet {
            if let realmUser = realmUser {
                nameLabel.text = realmUser.fullname
                emailLabel.text = realmUser.email
                mobileNoLabel.text = realmUser.mobileNumber
                bookingDateLabel.text = realmUser.bookingDate
                inTimeLabel.text = realmUser.inTime
                outTimeLabel.text = realmUser.outTime
            }
        }
    }
    
    // MARK: - Overriding
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
