//
//  FavoriteCollectionViewCell.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 17.03.2023.
//

import UIKit

class PairListFavoriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pairNameLabel: UILabel!
    
    @IBOutlet weak var lastLabel: UILabel!
    
    @IBOutlet weak var dailyPercentLabel: UILabel!
    
    
    //Mark for: Configure CollectionViewCell func
    func configure(with vm : PairListFavoritePresitionModel) {
        pairNameLabel.text = vm.pairName
        dailyPercentLabel.text = vm.dailyPercent
        dailyPercentLabel.textColor = vm.dailyPercentColor
        lastLabel.text = vm.last
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.height / 10
        contentView.layer.cornerRadius = layer.cornerRadius
        contentView.clipsToBounds = true
    }
    
}
