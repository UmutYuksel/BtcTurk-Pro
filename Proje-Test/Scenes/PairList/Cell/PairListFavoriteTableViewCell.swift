//
//  FavoritesTableViewCell.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 16.03.2023.
//

import UIKit

class PairListFavoriteTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    var favoritesData : [PairListFavoriteModel] = [] {
        didSet {
            self.favoritesCollectionView.reloadData()
        }
    }
    var cryptoListViewModel = PairListViewModel()
    var didSelectRowAt : ((Int) -> ())!
    var selectedPair : String?
    var numeratorSymbol : String?
    var denominatorSymbol : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        favoritesCollectionView.delegate = self
        favoritesCollectionView.dataSource = self
        
    }
}

extension PairListFavoriteTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoritesCollectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesCollectionViewCell", for: indexPath) as! PairListFavoriteCollectionViewCell
        let favoriteListView = favoritesData[indexPath.row]
        cell.configure(with: favoriteListView)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectRowAt!(indexPath.row)
        selectedPair = favoritesData[indexPath.row].pair
        numeratorSymbol = favoritesData[indexPath.row].numeratorSymbol
        denominatorSymbol = favoritesData[indexPath.row].denominatorSymbol
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 20, height: 70)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 85, height: 65)
    }
}

