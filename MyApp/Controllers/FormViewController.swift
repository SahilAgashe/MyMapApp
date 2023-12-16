//
//  FormViewController.swift
//  MyApp
//
//  Created by SAHIL AMRUT AGASHE on 14/12/23.
//

import UIKit

class FormViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .wheels
        return dp
    }()
    
    private lazy var fullNameTextField: UITextField = {
        return getTextField(textFieldPlaceholder: "Enter your full name")
    }()
    
    private lazy var emailTextField: UITextField = {
        return getTextField(textFieldPlaceholder: "Enter your email address")
    }()
    
    private lazy var mobileNumberTextField: UITextField = {
        return getTextField(textFieldPlaceholder: "Enter your mobile number")
    }()
    
    private lazy var bookingDateTextField: UITextField = {
        let tf = getTextField(textFieldPlaceholder: "Enter your booking date")
        tf.addTarget(self, action: #selector(openDatePicker), for: .touchDown)
        return tf
    }()
    
    private var fullname: String = ""
    private var email: String = ""
    private var mobileNumber = ""
    private var bookingDate = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // for dismissing keyboard, if tap on screen.
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Selectors
    @objc func openDatePicker() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 45))
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnAction))
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtnAction))
        let flexibleBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelBtn, flexibleBtn, doneBtn], animated: false)
        
        bookingDateTextField.inputAccessoryView = toolbar
        bookingDateTextField.inputView = datePicker
    }
    
    @objc func cancelBtnAction() {
        print("DEBUG: cancelBtnAction called...")
        bookingDateTextField.resignFirstResponder()
    }
    
    @objc func doneBtnAction() {
        print("DEBUG: doneBtnAction called...")
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long

        if let datePicker = bookingDateTextField.inputView as? UIDatePicker {
            let dateString = dateFormatter.string(from: datePicker.date)
            print("DEBUG: dateString is \(dateString)")
            bookingDateTextField.text = dateString
        }
        
        bookingDateTextField.resignFirstResponder()
    }
    
    @objc private func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextButtonAction() {
        let isValid = textFieldValidations()
        if isValid {
            let slotSelectionVC = SlotSelectionController()
            slotSelectionVC.bookingSlotHandler = { inTimeString , outTimeString in
                let user = User(fullname: self.fullname, email: self.email, mobileNumber: self.mobileNumber, bookingDate: self.bookingDate, inTime: inTimeString, outTime: outTimeString)
                print("DEBUG: user booking data is \(dump(user))")
                let realmUser = RealmUser(user: user)
                RealmManager.shared.addRealmUser(user: realmUser)
            }
            slotSelectionVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(slotSelectionVC, animated: true)
        }
    }
    
    // MARK: - Private Helpers
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        let fullNameVstack = getLabelAndTextfieldVstack(labelText: "Full Name", textField: fullNameTextField)
        let emailVstack = getLabelAndTextfieldVstack(labelText: "Email Address", textField: emailTextField)
        let mobileNumberVstack = getLabelAndTextfieldVstack(labelText: "Mobile Number", textField: mobileNumberTextField)
        let bookingDate = getLabelAndTextfieldVstack(labelText: "Booking Date", textField: bookingDateTextField)
        
        let vstack = UIStackView(arrangedSubviews: [fullNameVstack, emailVstack, mobileNumberVstack, bookingDate])
        vstack.translatesAutoresizingMaskIntoConstraints = false
        vstack.spacing = 20
        vstack.axis = .vertical
        view.addSubview(vstack)
        view.addSubview(backButton)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            // vstack
            vstack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vstack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            // nextButton
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 90),
            nextButton.heightAnchor.constraint(equalToConstant: 30),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 90),
            backButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func textFieldValidations() -> Bool {
        guard let fullname = fullNameTextField.text,
              let email = emailTextField.text,
              let mobileNumber = mobileNumberTextField.text,
              let bookingDate = bookingDateTextField.text else { return false}
        
        print("DEBUG: fullname => \(fullname), email => \(email), mobileNumber => \(mobileNumber), bookingDate => \(bookingDate)")
        if fullname.isEmpty {
            showAlerControllerMessage(title: "Invalid text field entry!", message: "Please enter your fullname",presentingViewController: self)
            return false
        }
        
        if email.isEmpty {
            showAlerControllerMessage(title: "Invalid text field entry!", message: "Please enter your email", presentingViewController: self)
            return false
        }
        
        if mobileNumber.isEmpty {
            showAlerControllerMessage(title: "Invalid text field entry!", message: "Please enter your mobile number", presentingViewController: self)
            return false
        }
        
        if mobileNumber.count != 10 {
            showAlerControllerMessage(title: "Invalid text field entry!", message: "Mobile number must be 10 digits", presentingViewController: self)
            return false
        }
        
        guard let _ = Int(mobileNumber) else {
            showAlerControllerMessage(title: "Invalid text field entry!", message: "Mobile number must contain digits", presentingViewController: self)
            return false
        }
        
        if bookingDate.isEmpty {
            showAlerControllerMessage(title: "Invalid text field entry!", message: "Please enter you booking date", presentingViewController: self)
            return false
        }
        
        // After successfully textfield validation get user data
        self.fullname = fullname
        self.mobileNumber = mobileNumber
        self.email = email
        self.bookingDate = bookingDate
        return true
    }
    
}


