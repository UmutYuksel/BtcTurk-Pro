//
//  CoinManager.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 7.03.2023.
//

import Foundation
import Toast

//Mark for: Get PairList scene data from API and push data PairListData
struct PairListAPIManager {
    let apiManager = APIManager<PairListResponse>()

    func getPairList(url: URL, completion: @escaping (PairListResponse?) -> ()) {
        apiManager.get(url: url, completion: completion)
    }
}
