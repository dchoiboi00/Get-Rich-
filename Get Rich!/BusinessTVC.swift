//
//  BusinessTVC.swift
//  Get Rich!
//
//  Created by Daniel Choi on 11/26/19.
//  Copyright © 2019 Daniel Choi. All rights reserved.
//

import UIKit

class BusinessTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as? BusinessTVCell else {
            fatalError("Expected BusinessCell")
        }

        // Configure the cell...

        return cell
    }

}
