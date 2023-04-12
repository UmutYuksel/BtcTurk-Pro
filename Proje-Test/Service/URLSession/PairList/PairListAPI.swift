//
//  CoinManager.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 7.03.2023.
//

import Foundation

struct PairListAPI {
    
    func getPairListData(url: URL, completion: @escaping (PairListData?) -> ()) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if let data = data {
                let cryptoList = try? JSONDecoder().decode(PairListData.self, from: data)
                    completion(cryptoList)
            }
        }.resume()
    }
}
