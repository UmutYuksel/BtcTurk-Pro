//
//  AccountViewController.swift
//  Proje-Test
//
//  Created by BTCYZ188 on 5.05.2023.
//

import Foundation
import UIKit
import Toast


class AccountViewController : UIViewController {
    
    //Mark for: Variables
    var viewModel = AccountViewModel()
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var accountTableView : UITableView!
    
    //Mark for: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        accountTableView.dataSource = self
        accountTableView.delegate = self
        setButtonsData()
    }
    
    
    //Mark for: segmentedControl value change function
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        accountTableView.reloadData()
    }
    //Mark for: AccountViewController tableView buttons sets data 
    func setButtonsData() {
        viewModel.getCellsData()
    }
}

extension AccountViewController : UITableViewDelegate , UITableViewDataSource {
    
    //Mark For: Adjustment how many cells in sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(segmentedControl: segmentControl)
    }
    
    //Mark For: TableView cells adjusment
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountTableViewCell
        viewModel.cellForRowAt(indexPath, cell,segmentControl: segmentControl)
        return cell
    }
    
    //Mark for: Tableview selected cell adjustment
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? AccountTableViewCell else { return }
        viewModel.tableViewDidSelectItemAt(cell)
    }
}
