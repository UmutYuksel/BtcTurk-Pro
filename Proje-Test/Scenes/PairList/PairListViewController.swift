//
//  ViewController.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 6.03.2023.
//

import UIKit

class PairListViewController: UIViewController {
    //Mark for: Variables
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel = PairListViewModel()
    
    //Mark for: Functions
    fileprivate func registerViews() {
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.sectionHeaderTopPadding = 0
    }
    //Mark for: SegmentedControl adjust func
    fileprivate func adjustSegmentedControl() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "selectedSegmentIndex")
    }
    //Mark for: Get data's from api and UserDefaults
    fileprivate func getApiResult() {
        viewModel.getFavoritesFromUserDefaults()
        viewModel.getPairList()
    }
    //Mark for: SegmentedControl change segment action
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        let selectedSegmentIndex = sender.selectedSegmentIndex
        viewModel.segmentControlValueChange(selectedSegmentIndex: selectedSegmentIndex)
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    fileprivate func  bindViewModel() {
        viewModel.dataUpdatedCallback = {
            self.tableView.reloadData()
            self.collectionView.reloadData()
            if self.viewModel.pushFavorites().count == 0 {
                self.collectionView.isHidden = true
                self.favoriteLabel.isHidden = true
            } else {
                self.collectionView.isHidden = false
                self.favoriteLabel.isHidden = false
            }
        }
    }
    
    //Mark for: Tableview selected cell adjustment
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedPair = viewModel.filteredPairList[indexPath.row].pair
        viewModel.numeratorSymbol = viewModel.filteredPairList[indexPath.row].numeratorSymbol
        viewModel.denominatorSymbol = viewModel.filteredPairList[indexPath.row].denominatorSymbol
        performSegue(withIdentifier: "pairCharts", sender: self)
    }
    //Mark for: Segue adjustment
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "pairCharts" {
            if let destinationVC = segue.destination as? PairChartViewController {
                destinationVC.viewModel.selectedPair = viewModel.selectedPair
                destinationVC.viewModel.selectedNumerator = viewModel.numeratorSymbol
                destinationVC.viewModel.selectedDenominator = viewModel.denominatorSymbol
            }
        }
    }
    //Mark for: Tableview header adjustment
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        view.backgroundColor = UIColor.darkBlueTint()
        let lblPairs = UILabel(frame: CGRect(x: 20, y: 0, width: view.frame.width - 20, height: 40))
        lblPairs.textColor = .white
        lblPairs.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        view.addSubview(lblPairs)
        lblPairs.text = "Pairs"
        return view
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        registerViews()
        bindViewModel()
        adjustSegmentedControl()
        getApiResult()
    }
}

extension PairListViewController : UITableViewDelegate , UITableViewDataSource {
    //Mark For: TableView cells adjusment
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PairListCell", for: indexPath) as! PairListTableViewCell
        let pairAtIndex = viewModel.pairAtIndex(indexPath.row)
        cell.configure(with: pairAtIndex)
        cell.btnFavoritePressed = {
            self.viewModel.didTapFavorite(at: indexPath.row)
        }
        return cell
    }
    //Mark For: Adjustment how many cells in sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredPairList.count
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
        let favoriteList = viewModel.pushFavorites()[indexPath.row]
        favoriteCell.configure(with: favoriteList)
        return favoriteCell
    }
    //Mark for: CollectionView selected cell adjustment
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedPair = viewModel.pushFavorites()[indexPath.row].pair
        viewModel.numeratorSymbol = viewModel.pushFavorites()[indexPath.row].numeratorSymbol
        viewModel.denominatorSymbol = viewModel.pushFavorites()[indexPath.row].denominatorSymbol
        performSegue(withIdentifier: "pairCharts", sender: self)
    }
}
