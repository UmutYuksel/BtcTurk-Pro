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

    func getPairList(url: URL, completion: @escaping (Result<PairListResponse?, Error>) -> ()) {
        apiManager.send(method: .get, url: url) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

