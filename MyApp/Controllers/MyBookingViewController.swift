//
//  MyBookingViewController.swift
//  MyApp
//
//  Created by SAHIL AMRUT AGASHE on 12/12/23.
//

import UIKit

class MyBookingViewController: UITableViewController {
    
    // MARK: - Properties
    private let identifier = "BookingTableViewCell"
    private var realmUsers: [RealmUser]?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG: Database path is \(RealmManager.shared.databasePath ?? "")")
        print("DEBUG: Realm User array count \(RealmManager.shared.realmUserArray.count )")
        realmUsers = RealmManager.shared.realmUserArray
        tableView.reloadData()
    }
    
    // MARK: - Private Helpers
    private func setupUI() {
        title = "My Booking"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.backgroundColor = .white
        tableView.register(UINib(nibName: "BookingTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        tableView.rowHeight = 120
        tableView.separatorStyle = .none
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmUsers?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? BookingTableViewCell else { return UITableViewCell() }
        cell.realmUser = realmUsers?[indexPath.row]
        return cell
    }
    
}
