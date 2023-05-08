//
//  AccountTableViewCell.swift
//  Proje-Test
//
//  Created by BTCYZ188 on 5.05.2023.
//

import Foundation
import UIKit

class AccountTableViewCell : UITableViewCell {
    
    @IBOutlet weak var btnImage : UIImageView!
    @IBOutlet weak var lblAccount : UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
