//
//  FavoriteCollectionViewModel.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 28.03.2023.
//

import Foundation
import UIKit

struct PairListFavoriteModel {
    var pair : String
    var dailyPercent : String
    var last : String
    var dailyPercentColor : UIColor
    var numeratorSymbol : String
    var denominatorSymbol : String
    var pairName : String
   
    init(model : PairListDataArray,favoriteList : [String]){
        pair = String(format: "\(model.numeratorSymbol)\(model.denominatorSymbol)",model.pair)
        pairName = String(format: "\(model.numeratorSymbol)/\(model.denominatorSymbol)",model.pair)
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
        
        if model.last > 9999 {
            last = String(format: "%0.f", model.last)
        } else if model.last > 999 {
            last = String(format: "%.1f", model.last)
        } else if model.last > 99 {
            last = String(format: "%.2f", model.last)
        } else if model.last > 9 {
            last = String(format: "%.3f", model.last)
        } else if model.last > 1 {
            last = String(format: "%.4f", model.last)
        } else if model.last > 0.1 {
            last = String(format: "%.4f", model.last)
        } else if model.last > 0.01 {
            last = String(format: "%.5f", model.last)
        } else if model.last > 0.001 {
            last = String(format: "%.6f", model.last)
        } else if model.last > 0.0001 {
            last = String(format: "%.7f", model.last)
        } else {
            last = String(format: "%.8f", model.last)
        }
    }
}
