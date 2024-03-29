//
//  AccountViewModel.swift
//  Proje-Test
//
//  Created by BTCYZ188 on 5.05.2023.
//

import Foundation
import UIKit
import Toast


class AccountViewModel {
    var accountCellData = [AccountPresitionModel]()
    var securityCellData = [AccountPresitionModel]()
    
    
    //Mark for: Functions
    
    
    func setSecurityCell() {
        securityCellData.append(AccountPresitionModel(cellName: "Security Center", cellImage: UIImage(named: "securityCenter.png")!))
        securityCellData.append(AccountPresitionModel(cellName: "Change Password", cellImage: UIImage(named: "resetPassword.png")!))
        securityCellData.append(AccountPresitionModel(cellName: "Device Management", cellImage: UIImage(named: "devices.png")!))
        securityCellData.append(AccountPresitionModel(cellName: "Login Notification", cellImage: UIImage(named: "login.png")!))
        securityCellData.append(AccountPresitionModel(cellName: "User Logs", cellImage: UIImage(named: "userLogs.png")!))
        securityCellData.append(AccountPresitionModel(cellName: "Timeout", cellImage: UIImage(named: "timeout.png")!))
        securityCellData.append(AccountPresitionModel(cellName: "Security Image", cellImage: UIImage(named: "security.png")!))
        securityCellData.append(AccountPresitionModel(cellName: "Mobile Log In Options", cellImage: UIImage(named: "finger.png")!))
    }
    func setAccountCell() {
        accountCellData.append(AccountPresitionModel(cellName: "Account Information", cellImage: UIImage(named: "user.png")!))
        accountCellData.append(AccountPresitionModel(cellName: "Profit/Loss", cellImage: UIImage(named: "profit.png")!))
        accountCellData.append(AccountPresitionModel(cellName: "Bank Accounts", cellImage: UIImage(named: "bank.png")!))
        accountCellData.append(AccountPresitionModel(cellName: "Fee Information", cellImage: UIImage(named: "percentage.png")!))
        accountCellData.append(AccountPresitionModel(cellName: "Coupons", cellImage: UIImage(named: "coupons.png")!))
        accountCellData.append(AccountPresitionModel(cellName: "Alarms", cellImage: UIImage(named: "alarm.png")!))
        accountCellData.append(AccountPresitionModel(cellName: "Convert", cellImage: UIImage(named: "convert.png")!))
        accountCellData.append(AccountPresitionModel(cellName: "Account History", cellImage: UIImage(named: "accHistory.png")!))
        accountCellData.append(AccountPresitionModel(cellName: "Order History", cellImage: UIImage(named: "orders.png")!))
        accountCellData.append(AccountPresitionModel(cellName: "Reports", cellImage: UIImage(named: "reports.png")!))
        accountCellData.append(AccountPresitionModel(cellName: "Donation", cellImage: UIImage(named: "donations.png")!))
        accountCellData.append(AccountPresitionModel(cellName: "Preferences", cellImage: UIImage(named: "preferences.png")!))
        accountCellData.append(AccountPresitionModel(cellName: "Log Out", cellImage: UIImage(named: "logout.png")!))
    }
    
    func getCellsData() {
        setAccountCell()
        setSecurityCell()
    }
    
    func numberOfRowsInSection(segmentedControl : UISegmentedControl) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return accountCellData.count
        } else {
            return securityCellData.count
        }
    }
    
    func cellForRowAt(_ indexPath: IndexPath, _ cell: AccountTableViewCell,segmentControl : UISegmentedControl) {
        if segmentControl.selectedSegmentIndex == 0 {
            let accountPresition = accountCellData[indexPath.row]
            cell.lblAccount.text = accountPresition.cellName
            cell.btnImage.image = accountPresition.cellImage
        } else {
            let securityPresition = securityCellData[indexPath.row]
            cell.lblAccount.text = securityPresition.cellName
            cell.btnImage.image = securityPresition.cellImage
        }
    }
    //Mark for: tableView didSelectItemAt Func
    func tableViewDidSelectItemAt(_ cell: AccountTableViewCell) {
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
