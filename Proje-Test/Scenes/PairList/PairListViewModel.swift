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
    var setSortingButtonImageCallback : ((UIImage)->())?
    var sortState = 0
    //Mark for: Functions
    
    //Mark for: Filter pairList from segmentedcontrol index
    func filterPairList(denominatorName: String,searchText: String) {
        if searchText.isEmpty {
            if denominatorName == "ALL" {
                filteredPairList = pairList
            } else {
                filteredPairList = pairList.filter { items in
                    return items.denominatorSymbol == denominatorName
                }
            } } else if searchText.isEmpty != true {
                let uppercaseSearchText = searchText.uppercased()
                filteredPairList = filteredPairList.filter{ $0.pair.contains(uppercaseSearchText) }
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
        PairListAPIManager().getPairList(url: apiURL) { result in
            switch result {
            case .success(let pairListResponse):
                if let pairList = pairListResponse?.data {
                    self.pairList = pairList
                    let denominatorName = UserDefaults.standard.string(forKey: "selectedDenominatorName")
                    self.filterPairList(denominatorName: denominatorName ?? DenominatorName.TRY.rawValue,searchText: "")
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
            case .failure(let error):
                DispatchQueue.main.async {
                    let configToast = ToastConfiguration(
                        direction: .bottom,
                        autoHide: true,
                        displayTime: 2,
                        animationTime: 0.2
                    )
                    let toast = Toast.text("\(error.localizedDescription)",config: configToast)
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
        let filteredPairListData = self.filteredPairList[index]
        return PairListPresitionModel(model: filteredPairListData,favoriteList: pairFavoriteList)
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
    
    //Mark for: Segue data pass with ChartListViewControllerPassData struct
    func pairListFavoritePassData(indexPath: IndexPath) -> ChartListViewControllerPassData {
        let selectedPair = pushFavorites()[indexPath.row].pair
        let numeratorSymbol = pushFavorites()[indexPath.row].numeratorSymbol
        let denominatorSymbol = pushFavorites()[indexPath.row].denominatorSymbol
        let pairListPassData = ChartListViewControllerPassData(selectedPair: selectedPair,numeratorSymbol: numeratorSymbol,denominatorSymbol: denominatorSymbol)
        return pairListPassData
    }
    //Mark for: Segue data pass with ChartListViewControllerPassData struct
    func pairListPassData(indexPath: IndexPath) -> ChartListViewControllerPassData {
        let selectedPair = filteredPairList[indexPath.row].pair
        let numeratorSymbol = filteredPairList[indexPath.row].numeratorSymbol
        let denominatorSymbol = filteredPairList[indexPath.row].denominatorSymbol
        let pairListPassData = ChartListViewControllerPassData(selectedPair: selectedPair,numeratorSymbol: numeratorSymbol,denominatorSymbol: denominatorSymbol)
        return pairListPassData
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
    
    //Mark for: segmentedControl valueChange func
    func segmentControlValueChange(selectedSegmentIndex: Int, searchText: String) {
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
        
        filterPairList(denominatorName: denominatorName.rawValue,searchText: searchText)
        
        UserDefaults.standard.set(selectedSegmentIndex, forKey: "selectedSegmentIndex")
        UserDefaults.standard.set(denominatorName.rawValue, forKey: "selectedDenominatorName")
    }
    
    //Mark for: sort filteredPairList by pair
    func sortListByPairs(selectedSegmentIndex: Int, searchText: String) {
        let image : UIImage
        switch sortState {
        case 0:
            filteredPairList.sort { $0.pair < $1.pair }
            image = UIImage(named: "sort-down.png")!
        case 1:
            filteredPairList.sort { $0.pair > $1.pair }
            image = UIImage(named: "sort-up.png")!
        default:
            segmentControlValueChange(selectedSegmentIndex: selectedSegmentIndex, searchText: searchText)
            image = UIImage(named: "sort.png")!
        }
        sortState = (sortState + 1) % 3
        setSortingButtonImageCallback?(image)
    }
    
    //Mark for: sort filteredPairList by last
    func sortListByLast(selectedSegmentIndex: Int, searchText: String) {
        let image : UIImage
        switch sortState {
        case 0:
            filteredPairList.sort { $0.last < $1.last }
            image = UIImage(named: "sort-down.png")!
        case 1:
            filteredPairList.sort { $0.last > $1.last }
            image = UIImage(named: "sort-up.png")!
        default:
            segmentControlValueChange(selectedSegmentIndex: selectedSegmentIndex, searchText: searchText)
            image = UIImage(named: "sort.png")!
        }
        sortState = (sortState + 1) % 3
        setSortingButtonImageCallback?(image)
    }
    
    //Mark for: stackView buttons set image func
    func sortButtonsSetImage(lastButton: UIButton,pairButton: UIButton,searchBar: UISearchBar) {
        lastButton.setImage(UIImage(named: "sort.png"), for: .normal)
        pairButton.setImage(UIImage(named: "sort.png"), for: .normal)
        searchBar.text = ""
    }
    
    //Mark for: CollectionView cellForRowAt func
    func collectionViewCellForRowAt(_ indexPath: IndexPath, _ favoriteCell: PairListFavoriteCollectionViewCell) {
        let favoriteList = pushFavorites()[indexPath.row]
        favoriteCell.configure(with: favoriteList)
    }
    
    //Mark for: TableView cellForRowAt func
    func tableViewCellForRowAt(_ indexPath: IndexPath, _ cell: PairListTableViewCell) {
        let pairAtIndex = pairAtIndex(indexPath.row)
        cell.configure(with: pairAtIndex)
        cell.btnFavoritePressed = {
            self.didTapFavorite(at: indexPath.row)
        }
    }
}
