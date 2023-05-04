//
//  ChartsApi.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 9.03.2023.
//

import Foundation

//Mark for: Get PairList scene data from API and push data PairListData
struct PairChartAPIManager {
    let apiManager = APIManager<PairChartResponse>()

    func getPairChart(url: URL, completion: @escaping (PairChartResponse?) -> ()) {
        apiManager.get(url: url, completion: completion)
    }
}
