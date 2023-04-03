//
//  CryptoData.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 7.03.2023.
//

import Foundation

struct PairListData : Codable {
    let data : [PairListDataArray]
}

struct PairListDataArray : Codable {
    let pair : String
    let last : Float
    let dailyPercent : Float
    let volume : Float
    let pairNormalized : String
    let numeratorSymbol : String
    let denominatorSymbol : String
}



