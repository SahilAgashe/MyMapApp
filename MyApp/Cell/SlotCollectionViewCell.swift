//
//  SlotCollectionViewCell.swift
//  MyApp
//
//  Created by SAHIL AMRUT AGASHE on 14/12/23.
//

import UIKit

class SlotCollectionViewCell: UICollectionViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amPmLabel: UILabel!
    
    // MARK: - Properties
    var isSelectingInTimeSlot = true
    var time: Date? {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            if let time {
                let str = formatter.string(from: time)
                print("DEBUG: dateString is \(str)")
                amPmLabel.text = str.contains("AM") ? "am" : "pm"
                timeLabel.text = String(str.prefix(5))
                
                if isDisabled {
                    bgView.backgroundColor = .systemGray
                }
            }
            
        }
    }
    
    var isDisabled: Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mm a"
        
        // here 15-12-2023 is constant date, as we required to check time!
        let startTime1 = formatter.date(from: "15-12-2023 08:00 AM")
        let endTime1 = formatter.date(from: "15-12-2023 09:30 AM")
        
        let startTime2 = formatter.date(from: "15-12-2023 01:00 PM")
        let endTime2 = formatter.date(from: "15-12-2023 02:30 PM")

        
        if let time, let startTime1, let endTime1, let startTime2, let endTime2 {
            if (time >= startTime1 && time <= endTime1) || (time >= startTime2 && time <= endTime2) {
                return true
            }
        }
        return false
    }
    
    var selectedInTimeIndex: Int? {
        didSet {
            if selectedInTimeIndex != nil {
                bgView.backgroundColor = .systemBlue
            }
        }
    }
    var selectedOutTimeIndex: Int? {
        didSet {
            if selectedOutTimeIndex != nil {
                bgView.backgroundColor = .systemRed
            }
        }
    }
    
    // MARK: - Overriding
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var isSelected: Bool {
        didSet {
            if isDisabled {
                bgView.backgroundColor = .systemGray
            } 
            else if selectedInTimeIndex != nil {
                bgView.backgroundColor = .systemBlue
            }
            else if selectedOutTimeIndex != nil {
                bgView.backgroundColor = .systemRed
            }
            else {
                bgView.backgroundColor = isSelected ? (isSelectingInTimeSlot ? .systemBlue : .systemRed) : .white
            }
        }
    }
    
}
