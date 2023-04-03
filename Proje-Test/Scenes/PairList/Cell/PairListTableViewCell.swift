//
//  PairTableViewCell.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 6.03.2023.
//

import UIKit


class PairListTableViewCell: UITableViewCell {
    var btnFavoritePressed : (()->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var btnFavorites: UIButton!
    @IBOutlet weak var pairLabel: UILabel!
    @IBOutlet weak var dailyPercentLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var lastLabel: UILabel!
    
    func configure(with vm : PairListModel) {
        pairLabel.text = vm.pairName
        volumeLabel.text = vm.volume
        dailyPercentLabel.text = vm.dailyPercent
        dailyPercentLabel.textColor = vm.dailyPercentColor
        lastLabel.text = vm.last
        btnFavorites.tintColor = vm.btnFavoriteColor
    }
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        btnFavoritePressed?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
