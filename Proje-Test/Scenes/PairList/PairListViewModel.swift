//
//  CryptoViewModel.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 6.03.2023.
//

import Foundation
import UIKit
import Toast

class PairListViewModel {
    //Mark for: Variables
    var pairFavoriteList = [String]()
    var pairList = [PairListResponseElement]()
    var filteredPairList = [PairListResponseElement]()
    var dataUpdatedCallback : (()->())?
    
    //Mark for: Functions
    
    //Mark for: Filter pairList from segmentedcontrol index
    func filterPairList(denominatorName: String) {
        if denominatorName == "ALL" {
            filteredPairList = pairList
        } else {
            filteredPairList = pairList.filter { items in
                return items.denominatorSymbol == denominatorName
            }
        }
        DispatchQueue.main.async {
            self.dataUpdatedCallback?()
        }
    }
    //Mark for: Get pairlist from api
    func getPairList() {
        guard let apiURL = URL(string: "https://api.btcturk.com/api/v2/ticker") else {
            print("URL Hatalı")
            return
        }
        PairListAPIManager().getPairList(url: apiURL) { pairListResponse in
            if let pairList = pairListResponse {
                self.pairList = pairList.data
                let denominatorName = UserDefaults.standard.string(forKey: "selectedDenominatorName")
                self.filterPairList(denominatorName: denominatorName ?? DenominatorName.TRY.rawValue)
                DispatchQueue.main.async {
                    self.dataUpdatedCallback?()
                }
            } else {
                DispatchQueue.main.async {
                    let configToast = ToastConfiguration(
                        direction: .bottom,
                        autoHide: true,
                        displayTime: 2,
                        animationTime: 0.2
                    )
                    let toast = Toast.text("Grafik Verileri Getirilirken Hata Oluştu",config: configToast)
                    toast.show()
                }
            }
        }
    }
    //Mark for: TableView favorite button tap func
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
    //Mark for: Pair at tableview index
    func pairAtIndex(_ index: Int) -> PairListPresitionModel {
        let crypto = self.filteredPairList[index]
        return PairListPresitionModel(model: crypto,favoriteList: pairFavoriteList)
    }
    //Mark for: Push favorites to viewController
    func pushFavorites() -> [PairListFavoritePresitionModel] {
        var favoriteArray = [PairListFavoritePresitionModel]()
        for pairSymbol in pairFavoriteList {
            if let favorite = self.filteredPairList.first(where: {$0.pair == pairSymbol}) {
                let denominatorName = UserDefaults.standard.string(forKey: "selectedDenominatorName")
                if denominatorName == DenominatorName.ALL.rawValue || favorite.denominatorSymbol == denominatorName {
                    favoriteArray.append(PairListFavoritePresitionModel(model: favorite , favoriteList: pairFavoriteList))
                }
            }
        }
        return favoriteArray
    }
    //Mark for: Get favoritearray from UserDefaults
    func getFavoritesFromUserDefaults() {
        if let favoriteArray = UserDefaults.standard.array(forKey: "pairFavoriteList") as? [String] {
            for favorite in favoriteArray {
                pairFavoriteList.append(favorite)
            }
        }
    }
    
    enum DenominatorName: String {
        case TRY = "TRY"
        case USDT = "USDT"
        case BTC = "BTC"
        case ALL = "ALL"
    }
    
    func segmentControlValueChange(selectedSegmentIndex: Int) {
        var denominatorName: DenominatorName
        
        switch selectedSegmentIndex {
        case 0:
            denominatorName = .TRY
        case 1:
            denominatorName = .USDT
        case 2:
            denominatorName = .BTC
        default:
            denominatorName = .ALL
        }
        
        filterPairList(denominatorName: denominatorName.rawValue)
        
        UserDefaults.standard.set(selectedSegmentIndex, forKey: "selectedSegmentIndex")
        UserDefaults.standard.set(denominatorName.rawValue, forKey: "selectedDenominatorName")
    }
}
    
    
    

