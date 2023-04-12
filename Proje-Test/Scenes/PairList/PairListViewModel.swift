//
//  CryptoViewModel.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 6.03.2023.
//

import Foundation
import UIKit

//struct PairListSection {
//    let title = String
//    let cellType = String
//    let cellHeight
//}



class PairListViewModel {
    var pairFavoriteList = [String]()
    var pairList = [PairListDataArray]()
    var filteredPairList = [PairListDataArray]()
    var dataUpdatedCallback : (()->())?
    let apiUrl = URL(string: "https://api.btcturk.com/api/v2/ticker")!
    var selectedPair : String?
    var numeratorSymbol : String?
    var denominatorSymbol : String?
    var viewController = PairListViewController()
    
    
    
    func filterPairList(denominatorName: String) {
        if denominatorName == "ALL" {
            filteredPairList = pairList
        } else {
            filteredPairList = pairList.filter { items in
                return items.denominatorSymbol == denominatorName
            }
        }
    }
    
    func getPairList() {
        PairListAPI().getPairListData(url: apiUrl) { cryptoData in
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
    
    func cryptoAtIndex(_ index: Int) -> PairListPresitionModel {
        let crypto = self.filteredPairList[index]
        return PairListPresitionModel(model: crypto,favoriteList: pairFavoriteList)
    }
    
    func getFavorites() -> [PairListFavoritePresitionModel] {
        var favoriteArray = [PairListFavoritePresitionModel]()
        for pairSymbol in pairFavoriteList {
            if let favorite = self.filteredPairList.first(where: {$0.pair == pairSymbol}) {
                favoriteArray.append(PairListFavoritePresitionModel(model: favorite , favoriteList: pairFavoriteList))
            }
        }
        
        return favoriteArray
    }
    
    
    func getFavoritesFromUserDefaults() {
        if let favoriteArray = UserDefaults.standard.array(forKey: "pairFavoriteList") as? [String] {
            for favorite in favoriteArray {
                pairFavoriteList.append(favorite)
            }
            print(pairFavoriteList)
        }
    }
    
    func segmentControlValueChange(selectedSegmentIndex : Int) {
        if selectedSegmentIndex == 0 {
            filterPairList(denominatorName: "TRY")
            UserDefaults.standard.set(selectedSegmentIndex, forKey: "selectedSegmentIndex")
            UserDefaults.standard.set("TRY", forKey: "selectedDenominatorName")
        } else if selectedSegmentIndex == 1 {
            filterPairList(denominatorName: "USDT")
            UserDefaults.standard.set(selectedSegmentIndex, forKey: "selectedSegmentIndex")
            UserDefaults.standard.set("USDT", forKey: "selectedDenominatorName")
        } else if selectedSegmentIndex == 2 {
            filterPairList(denominatorName: "BTC")
            UserDefaults.standard.set(selectedSegmentIndex, forKey: "selectedSegmentIndex")
            UserDefaults.standard.set("BTC", forKey: "selectedDenominatorName")
        } else if selectedSegmentIndex == 3 {
            filterPairList(denominatorName: "ALL")
            UserDefaults.standard.set(selectedSegmentIndex, forKey: "selectedSegmentIndex")
            UserDefaults.standard.set("ALL", forKey: "selectedDenominatorName")
        }
        //        let filter = denominatorFilter(rawValue: <#T##Int#>)
    }
    
    //    enum denominatorFilter : Int {
    //        case TRY = 0
    //
    //        var symbol : String {
    //            switch self {
    //            case .TRY : return "TRY"
    //            }
    //        }
    //
    //    }
}
