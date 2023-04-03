//
//  CryptoViewModel.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 6.03.2023.
//

import Foundation
import UIKit



class PairListViewModel {
    var pairFavoriteList = [String]()
    var pairList = [PairListDataArray]()
    var filteredPairList = [PairListDataArray]()
    var filteredFavoriteList = [String]()
    var dataUpdatedCallback : (()->())?
    let apiUrl = URL(string: "https://api.btcturk.com/api/v2/ticker")!
    var didSelectRowAt : ((Int) -> ())?
    var selectedPair : String?
    var numeratorSymbol : String?
    var denominatorSymbol : String?
    var selectedFavorite : Int?
    
    
    func filterPairList(denominatorName: String) {
        if denominatorName == "ALL" {
            for items in pairList {
                filteredPairList.append(items)
            }
        } else {
            filteredPairList = pairList.filter { items in
                return items.denominatorSymbol == denominatorName
            }
        }
    }
    
    func getPairList() {
        PairListAPI().getCryptoData(url: apiUrl) { cryptoData in
            if let cryptoData = cryptoData {
                self.pairList = cryptoData.data
                let denominatorName = UserDefaults.standard.string(forKey: "selectedDenominatorName")
                self.filterPairList(denominatorName: denominatorName ?? "TRY")
                DispatchQueue.main.async {
                    self.dataUpdatedCallback?()
                }
            } else {
                print("Hata")
            }
        }
    }
    
    func didTapFavorite(at index: Int) {
        let pair = self.filteredPairList[index]
        if let index = pairFavoriteList.firstIndex(of: pair.pair) {
            pairFavoriteList.remove(at: index)
        } else {
            pairFavoriteList.append(pair.pair)
        }
        UserDefaults.standard.set(pairFavoriteList, forKey: "pairFavoriteList")
        UserDefaults.standard.synchronize()
        self.dataUpdatedCallback?()
    }
    
    func numberOfRowsInSection() -> Int {
        return self.filteredPairList.count
    }
    
    func cryptoAtIndex(_ index: Int) -> PairListModel {
        let crypto = self.filteredPairList[index]
        return PairListModel(model: crypto,favoriteList: pairFavoriteList)
    }
    
    func getFavorites() -> [PairListFavoriteModel] {
        var favoriteArray = [PairListFavoriteModel]()
        for pairSymbol in pairFavoriteList {
            if let favorite = self.filteredPairList.first(where: {$0.pair == pairSymbol}) {
                favoriteArray.append(PairListFavoriteModel(model: favorite , favoriteList: pairFavoriteList))
            }
        }
        return favoriteArray
    }
    
    
    func getFavoritesFromUserDefaults() {
        if let favoriteArray = UserDefaults.standard.array(forKey: "pairFavoriteList") as? [String] {
            for favorite in favoriteArray {
                pairFavoriteList.append(favorite)
            }
        }
    }
}
