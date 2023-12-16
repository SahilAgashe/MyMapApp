//
//  SlotSelectionController.swift
//  MyApp
//
//  Created by SAHIL AMRUT AGASHE on 14/12/23.
//

import UIKit

class SlotSelectionController: UIViewController {
    
    // MARK: - Properties
    private let slotCollectionCellIdentifier = "SlotCollectionViewCell"
    private var isSelectingInTimeSlot = true
    private var selectedInTimeIndex: Int?
    private var selectedOutTimeIndex: Int?
    private var inTimeString: String = ""
    private var outTimeString: String = ""
    
    var bookingSlotHandler: ((String, String) -> ())?
    
    private lazy var slotCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UINib(nibName: "SlotCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: slotCollectionCellIdentifier)
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemCyan
        button.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var selecteInTimeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select In Time", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(selecteInTimeButtonAction), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var selecteOutTimeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select Out Time", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray5
        button.addTarget(self, action: #selector(selecteOutTimeButtonAction), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var bookNowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Book Now", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(bookNowButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return button
    }()
    
    private var slotDataArr: [Date] = {
        let startTime = 7
        let endTime = 21 // 9 pm
        let totalSlots = (endTime - startTime + 1) + endTime - startTime
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mm a"
        // here 15-12-2023 is constant date, as we required to check time!
        let start = formatter.date(from: "15-12-2023 07:00 AM")
        if var start {
            var arr = [Date]()
            arr.append(start)
            
            for x in 1 ... (totalSlots - 1) {
                start = start + (30 * 60)
                arr.append(start)
            }
            return arr
        }

        
        return []
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        
        //view.addSubview(doneButton)
        view.addSubview(backButton)
        view.addSubview(bookNowButton)
        view.addSubview(slotCollectionView)
        
        let hStack = UIStackView(arrangedSubviews: [selecteInTimeButton, selecteOutTimeButton])
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .horizontal
        hStack.spacing = 30
        view.addSubview(hStack)
        
        NSLayoutConstraint.activate([
            
            slotCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slotCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            slotCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            slotCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            hStack.bottomAnchor.constraint(equalTo: slotCollectionView.topAnchor, constant: -20),
            hStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
//            doneButton.bottomAnchor.constraint(equalTo: slotCollectionView.topAnchor, constant: -15),
//            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            bookNowButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            bookNowButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            bookNowButton.widthAnchor.constraint(equalToConstant: 100),
            bookNowButton.heightAnchor.constraint(equalToConstant: 40),
            
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            backButton.widthAnchor.constraint(equalToConstant: 100),
            backButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Selectors
    @objc private func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func doneButtonAction() {
        isSelectingInTimeSlot.toggle()
        slotCollectionView.reloadData()
    }
    
    @objc private func bookNowButtonAction() {
        print("DEBUG: bookNowButtonAction called.....")
        
        if let selectedInTimeIndex, let selectedOutTimeIndex, selectedOutTimeIndex > selectedInTimeIndex {
            
            bookingSlotHandler?(inTimeString, outTimeString)

            let successController = UIAlertController(title: "Success!", message: "Your slot is booked successfully!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default) { action in
                self.navigationController?.popToRootViewController(animated: true)
            }
            successController.addAction(ok)
            present(successController, animated: true)
        } else {
            showAlerControllerMessage(title: "Invalid Selected times", message: "Selected out-time must be greater than selected in-time!", presentingViewController: self)
        }
    }
    
    @objc private func selecteInTimeButtonAction() {
        print("DEBUG: selecteInTimeButtonAction called.....")
        isSelectingInTimeSlot = true
        selecteInTimeButton.backgroundColor = .systemBlue
        selecteOutTimeButton.backgroundColor = .systemGray5
        selectedInTimeIndex = nil
        slotCollectionView.reloadData()
    }
    
    @objc private func selecteOutTimeButtonAction() {
        print("DEBUG: selecteOutTimeButtonAction called.....")
        isSelectingInTimeSlot = false
        selecteInTimeButton.backgroundColor = .systemGray5
        selecteOutTimeButton.backgroundColor = .systemRed
        selectedOutTimeIndex = nil
        slotCollectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDataSource
extension SlotSelectionController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slotDataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: slotCollectionCellIdentifier, for: indexPath) as? SlotCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.bgView.backgroundColor = .white
        cell.isSelectingInTimeSlot = isSelectingInTimeSlot
        cell.time = slotDataArr[indexPath.row]
        
        if indexPath.row == selectedInTimeIndex {
            cell.selectedInTimeIndex = selectedInTimeIndex
        } else if indexPath.row == selectedOutTimeIndex {
            cell.selectedOutTimeIndex = selectedOutTimeIndex
        } else {
            cell.selectedInTimeIndex = nil
            cell.selectedOutTimeIndex = nil
        }
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegate
extension SlotSelectionController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DEBUG: collectionView didSelectItemAt indexPath => \(indexPath.row) called...")
        guard let cell = collectionView.cellForItem(at: indexPath) as? SlotCollectionViewCell else { return }
        if cell.isDisabled {
            if isSelectingInTimeSlot { selectedInTimeIndex = nil }
            else { selectedOutTimeIndex = nil }
            return
        }
        
        if isSelectingInTimeSlot {
            selectedInTimeIndex = indexPath.row
            if let timeLabelText = cell.timeLabel.text,
               let amPmLabelText = cell.amPmLabel.text {
                inTimeString = timeLabelText + amPmLabelText
            }
        } else if !isSelectingInTimeSlot {
            selectedOutTimeIndex = indexPath.row
            if let timeLabelText = cell.timeLabel.text,
               let amPmLabelText = cell.amPmLabel.text {
                outTimeString = timeLabelText + amPmLabelText
            }
        }
        
    }
    
}

