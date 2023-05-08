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
        getCellsData()
    }
    
    func getCellsData() {
        viewModel.setAccountCell()
        viewModel.setSecurityCell()
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        accountTableView.reloadData()
    }
    
}

extension AccountViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControl.selectedSegmentIndex == 0 {
            return viewModel.accountCellData.count
        } else {
            return viewModel.securityCellData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountTableViewCell
        if segmentControl.selectedSegmentIndex == 0 {
            let accountPresition = viewModel.accountCellData[indexPath.row]
            cell.lblAccount.text = accountPresition.cellName
            cell.btnImage.image = accountPresition.cellImage
        } else {
            let securityPresition = viewModel.securityCellData[indexPath.row]
            cell.lblAccount.text = securityPresition.cellName
            cell.btnImage.image = securityPresition.cellImage
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? AccountTableViewCell else { return }
        let toastText = cell.lblAccount.text
        let accountToast = ToastConfiguration(
            direction: .bottom,
            autoHide: true,
            displayTime: 1.5,
            animationTime: 0.2
        )
        let toast = Toast.text("\(toastText ?? "") Pressed",config: accountToast)
        toast.show()
    }
}
