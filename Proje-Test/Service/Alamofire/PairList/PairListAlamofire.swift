//
//  PairListAlamofire.swift
//  Proje-Test
//
//  Created by BTCYZ188 on 6.04.2023.
//

import Foundation
import Alamofire

struct PairListAlamofire {
    
    func getPairListData() {
        let url = "https://api.btcturk.com/api/v2/ticker/currency?symbol=usdt"
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default , headers: nil, interceptor: nil, requestModifier: nil).response { response in
            
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let pairListJsonData = try decoder.decode(PairListApiData.self ,from: data!)
                    print(pairListJsonData)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    
}
