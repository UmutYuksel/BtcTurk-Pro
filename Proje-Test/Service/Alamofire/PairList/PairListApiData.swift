//
//  PairListApiData.swift
//  Proje-Test
//
//  Created by BTCYZ188 on 6.04.2023.
//

import Foundation

struct PairListApiData : Codable {
    let data : [PairListApiDataArray]
}

struct PairListApiDataArray : Codable {
    let pair : String
    let last : Decimal
    let dailyPercent : Float
    let volume : Float
    let pairNormalized : String
    let numeratorSymbol : String
    let denominatorSymbol : String
}

