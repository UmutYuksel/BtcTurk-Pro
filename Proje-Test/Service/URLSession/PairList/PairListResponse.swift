//
//  CryptoData.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 7.03.2023.
//

import Foundation

struct PairListResponse : Decodable {
    let data : [PairListResponseElement]
}

struct PairListResponseElement : Decodable {
    let pair : String
    let last : Decimal
    let dailyPercent : Float
    let volume : Float
    let pairNormalized : String
    let numeratorSymbol : String
    let denominatorSymbol : String
}



