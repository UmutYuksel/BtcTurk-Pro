//
//  PairTableViewModel.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 28.03.2023.
//

import Foundation
import UIKit

struct PairListPresitionModel {
    var pair : String
    var dailyPercent : String
    var last : String
    var volume : String
    var isFavorite : Bool
    var dailyPercentColor : UIColor
    var numeratorSymbol : String
    var denominatorSymbol : String
    var pairName : String
    var btnFavoriteColor : UIColor
    init(model : PairListResponseElement,favoriteList : [String]){
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 10
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.groupingSeparator = ","
        
        let volumeFormatter = NumberFormatter()
        volumeFormatter.numberStyle = .decimal
        volumeFormatter.maximumFractionDigits = 0
        volumeFormatter.groupingSeparator = ","
        
        last = formatter.string(from: model.last as NSNumber)!
        pair = String(format: "\(model.numeratorSymbol)\(model.denominatorSymbol)",model.pair)
        pairName = String(format: "\(model.numeratorSymbol)/\(model.denominatorSymbol)",model.pair)
        volume = volumeFormatter.string(from: model.volume as NSNumber)!
        isFavorite = favoriteList.contains(model.pair)
        numeratorSymbol = model.numeratorSymbol
        denominatorSymbol = model.denominatorSymbol
        
        if model.dailyPercent < 0 {
            dailyPercent = String(format: "%%%.2f", abs(model.dailyPercent)).replacingOccurrences(of: "-", with: "")
        } else if model.dailyPercent > 0 {
            dailyPercent = String(format: "%%%.2f", model.dailyPercent)
        } else {
            dailyPercent = String(format: "%%%.2f", model.dailyPercent)
        }
        
        if model.dailyPercent < 0 {
            dailyPercentColor = UIColor.redTint()
        } else if model.dailyPercent > 0 {
            dailyPercentColor = UIColor.greenTint()
        } else {
            dailyPercentColor = UIColor.white
        }
        
        if isFavorite == true {
            btnFavoriteColor = UIColor.goldTint()
        } else if isFavorite == false {
            btnFavoriteColor = UIColor.greyTint()
        } else {
            btnFavoriteColor = UIColor.white
        }
        
    }
}
