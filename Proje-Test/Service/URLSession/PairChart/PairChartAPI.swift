//
//  ChartsApi.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 9.03.2023.
//

import Foundation

struct PairChartAPI {
    
    func getPairChartData(url: URL, completion: @escaping (PairChartData?) -> ()) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if let data = data {
                let cryptoChartData = try? JSONDecoder().decode(PairChartData.self, from: data)
                    completion(cryptoChartData)
                    
            } else {
                print(error!.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
}
