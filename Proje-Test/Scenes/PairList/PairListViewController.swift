//
//  ViewController.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 6.03.2023.
//

import UIKit

class PairListViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var viewModel = PairListViewModel()
    
    
    fileprivate func registerTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderTopPadding = 0
        let cellNib = UINib(nibName: "FavoritesTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "FavoritesViewCell")
    }
    
    fileprivate func adjustSegmentedControl() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "selectedSegmentIndex")
    }
    
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        let segmentIndex = segmentControl.selectedSegmentIndex
        if sender.selectedSegmentIndex == 0 {
            viewModel.filterPairList(denominatorName: "TRY")
            self.tableView.reloadData()
            UserDefaults.standard.set(segmentIndex, forKey: "selectedSegmentIndex")
            UserDefaults.standard.set("TRY", forKey: "selectedDenominatorName")
        } else if sender.selectedSegmentIndex == 1 {
            viewModel.filterPairList(denominatorName: "USDT")
            self.tableView.reloadData()
            UserDefaults.standard.set(segmentIndex, forKey: "selectedSegmentIndex")
            UserDefaults.standard.set("USDT", forKey: "selectedDenominatorName")
        } else if sender.selectedSegmentIndex == 2 {
            viewModel.filterPairList(denominatorName: "BTC")
            self.tableView.reloadData()
            UserDefaults.standard.set(segmentIndex, forKey: "selectedSegmentIndex")
            UserDefaults.standard.set("BTC", forKey: "selectedDenominatorName")
        } else if sender.selectedSegmentIndex == 3 {
            viewModel.filterPairList(denominatorName: "ALL")
            self.tableView.reloadData()
            UserDefaults.standard.set(segmentIndex, forKey: "selectedSegmentIndex")
            UserDefaults.standard.set("ALL", forKey: "selectedDenominatorName")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func  bindViewModel() {
        viewModel.dataUpdatedCallback = {
            self.tableView.reloadData()
        }
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.selectedPair = viewModel.filteredPairList[indexPath.row].pair
        viewModel.numeratorSymbol = viewModel.filteredPairList[indexPath.row].numeratorSymbol
        viewModel.denominatorSymbol = viewModel.filteredPairList[indexPath.row].denominatorSymbol
        performSegue(withIdentifier: "pairCharts", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "pairCharts" {
            if let destinationVC = segue.destination as? PairChartViewController {
                destinationVC.viewModel.selectedPair = viewModel.selectedPair
                destinationVC.viewModel.selectedNumerator = viewModel.numeratorSymbol
                destinationVC.viewModel.selectedDenominator = viewModel.denominatorSymbol
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        view.backgroundColor = UIColor.darkBlueTint()
        let lblPairs = UILabel(frame: CGRect(x: 20, y: 0, width: view.frame.width - 20, height: 40))
        lblPairs.textColor = .white
        lblPairs.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        view.addSubview(lblPairs)
        if viewModel.pairFavoriteList.count == 0 {
            lblPairs.text = "Pairs"
        } else {
            if section == 0 {
                lblPairs.text = "Favorites"
            } else {
                lblPairs.text = "Pairs"
            }
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            if viewModel.pairFavoriteList.count == 0 {
                return 0
            } else {
                return 40
            }
        } else {
            return 40
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if viewModel.pairFavoriteList.count == 0 {
                return 0
            } else {
                return 70
            }
        } else {
            return 55
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        viewModel.getFavoritesFromUserDefaults()
        viewModel.getPairList()
        bindViewModel()
        adjustSegmentedControl()
    }
}

extension PairListViewController : UITableViewDelegate , UITableViewDataSource {
    //Mark For: TableView cells adjusment
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if viewModel.pairFavoriteList.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PairCell", for: indexPath) as! PairListTableViewCell
            let cryptoViewModel = viewModel.cryptoAtIndex(indexPath.row)
            cell.configure(with: cryptoViewModel)
            cell.btnFavoritePressed = {
                self.viewModel.didTapFavorite(at: indexPath.row)
            }
            return cell
        } else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as! PairListFavoriteTableViewCell
                let favoriteList = viewModel.getFavorites()
                cell.favoritesData = favoriteList
                cell.didSelectRowAt = { index in
                    self.viewModel.selectedPair = favoriteList[index].pair
                    self.viewModel.numeratorSymbol = favoriteList[index].numeratorSymbol
                    self.viewModel.denominatorSymbol = favoriteList[index].denominatorSymbol
                    self.performSegue(withIdentifier: "pairCharts", sender: self)
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PairCell", for: indexPath) as! PairListTableViewCell
                let cryptoViewModel = viewModel.cryptoAtIndex(indexPath.row)
                
                cell.configure(with: cryptoViewModel)
                cell.btnFavoritePressed = {
                    self.viewModel.didTapFavorite(at: indexPath.row)
                }
                return cell
            }
            
        }
        
        
        //        if indexPath.section == 0 {
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as! PairListFavoriteTableViewCell
        //            let favoriteList = viewModel.getFavorites()
        //            cell.favoritesData = favoriteList
        //            cell.didSelectRowAt = { index in
        //                self.selectedValue = favoriteList[index].pair
        //                self.numeratorSymbol = favoriteList[index].numeratorSymbol
        //                self.denominatorSymbol = favoriteList[index].denominatorSymbol
        //                self.performSegue(withIdentifier: "pairCharts", sender: self)
        //            }
        //
        //            return cell
        //        } else {
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "PairCell", for: indexPath) as! PairListTableViewCell
        //            let cryptoViewModel = viewModel.cryptoAtIndex(indexPath.row)
        //
        //            cell.configure(with: cryptoViewModel)
        //            cell.btnFavoritePressed = {
        //                self.viewModel.didTapFavorite(at: indexPath.row)
        //            }
        //            return cell
        //        }
    }
    //Mark For: Adjustment how many cells in sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if viewModel.pairFavoriteList.count == 0 {
            return viewModel.numberOfRowsInSection()
        } else {
            if section == 0 {
                return 1
            } else {
                return viewModel.numberOfRowsInSection()
            }
        }
    }
}
