//
//  ViewController.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 6.03.2023.
//

import UIKit

struct ChartListViewControllerPassData {
    var selectedPair : String?
    var numeratorSymbol : String?
    var denominatorSymbol : String?
}

class PairListViewController: UIViewController {
    //Mark for: Variables
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pairButton: UIButton!
    @IBOutlet weak var lastButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = PairListViewModel()
    
    
    //Mark for: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        registerViews()
        bindViewModel()
        adjustSegmentedControl()
        getApiResult()
    }
    
    @IBAction func unwindToForm(_ unwindSegue: UIStoryboardSegue) {}
    
    private func registerViews() {
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //Mark for: SegmentedControl adjust func
    private func adjustSegmentedControl() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "selectedSegmentIndex")
    }
    
    //Mark for: Get data's from api and UserDefaults
    private func getApiResult() {
        viewModel.getFavoritesFromUserDefaults()
        viewModel.getPairList()
    }
    
    //Mark for: SegmentedControl change segment action
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        let selectedSegmentIndex = sender.selectedSegmentIndex
        viewModel.segmentControlValueChange(selectedSegmentIndex: selectedSegmentIndex,searchText: "")
        viewModel.sortButtonsSetImage(lastButton: lastButton, pairButton: pairButton,searchBar: searchBar)
        bindViewModel()
    }
    
    //Mark for: pairButton touchUpInside func
    @IBAction func pairSortTapped(_ sender: Any) {
        viewModel.sortListByPairs(selectedSegmentIndex: segmentControl.selectedSegmentIndex, searchText: "")
        viewModel.setSortingButtonImageCallback = { image in
            self.pairButton.setImage(image, for: .normal)
        }
        tableView.reloadData()
    }
    
    //Mark for: lastButton touchUpInside func
    @IBAction func lastSortTapped(_ sender: Any) {
        viewModel.sortListByLast(selectedSegmentIndex: segmentControl.selectedSegmentIndex, searchText: "")
        viewModel.setSortingButtonImageCallback = { image in
            self.lastButton.setImage(image, for: .normal)
        }
        tableView.reloadData()
    }    
    
    private func  bindViewModel() {
        viewModel.dataUpdatedCallback = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.collectionView.reloadData()
            
            if self.viewModel.pushFavorites().count == 0 {
                self.collectionView.isHidden = true
                self.favoriteLabel.isHidden = true
                self.sortStackView.isHidden = true
            } else {
                self.collectionView.isHidden = false
                self.favoriteLabel.isHidden = false
                self.sortStackView.isHidden = false
            }
        }
    }
    
    //Mark for: Tableview selected cell adjustment
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pairChartViewController = storyboard?.instantiateViewController(withIdentifier: "PairChartView") as! PairChartViewController
        pairChartViewController.viewModel.pairListGetData = viewModel.pairListPassData(indexPath: indexPath)
        navigationController?.pushViewController(pairChartViewController, animated: true)
    }
}

extension PairListViewController : UITableViewDelegate , UITableViewDataSource {
    
    //Mark For: TableView cells adjusment
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PairListCell", for: indexPath) as! PairListTableViewCell
        viewModel.tableViewCellForRowAt(indexPath, cell)
        return cell
    }
    
    //Mark For: Adjustment how many cells in sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return viewModel.filteredPairList.count
    }
}

extension PairListViewController : UISearchBarDelegate {
    
    //Mark for: searchBar textDidChange filter func
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.segmentControlValueChange(selectedSegmentIndex: segmentControl.selectedSegmentIndex, searchText: searchText)
    }
}

extension PairListViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    //Mark For: Adjustment how many cells in sections
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pushFavorites().count
    }
    
    //Mark For: CollectionView cells adjusment
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let favoriteCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PairListFavoriteCell", for: indexPath) as! PairListFavoriteCollectionViewCell
        viewModel.collectionViewCellForRowAt(indexPath, favoriteCell)
        return favoriteCell
    }
    
    //Mark for: CollectionView selected cell adjustment
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pairChartViewController = storyboard?.instantiateViewController(withIdentifier: "PairChartView") as! PairChartViewController
        pairChartViewController.viewModel.pairListGetData = viewModel.pairListPassData(indexPath: indexPath)
        navigationController?.pushViewController(pairChartViewController, animated: true)
    }
}


