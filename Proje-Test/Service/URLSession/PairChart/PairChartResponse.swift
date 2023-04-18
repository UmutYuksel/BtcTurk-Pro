//
//  ChartData.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 10.03.2023.
//

import Foundation

struct PairChartResponse : Decodable {
   
    let symbol: String?
    let time: [Double]?
    let high: [Double]?
    let open: [Double]?
    let low: [Double]?
    let close: [Double]?
    let volume: [Double]?

    private enum CodingKeys: String, CodingKey {
        case symbol = "s"
        case time = "t"
        case high = "h"
        case open = "o"
        case low = "l"
        case close = "c"
        case volume = "v"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        symbol = try container.decodeIfPresent(String.self, forKey: .symbol)
        time = try container.decodeIfPresent([Double].self, forKey: .time)
        high = try container.decodeIfPresent([Double].self, forKey: .high)
        open = try container.decodeIfPresent([Double].self, forKey: .open)
        low = try container.decodeIfPresent([Double].self, forKey: .low)
        close = try container.decodeIfPresent([Double].self, forKey: .close)
        volume = try container.decodeIfPresent([Double].self, forKey: .volume)
    }
}
