//
//  PairChartsViewController.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 9.03.2023.
//

import Foundation
import Charts
import UIKit


class PairChartViewController : UIViewController {
    //Mark for: Variables
    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var pairChartNavBar: UINavigationBar!
    var viewModel = PairChartViewModel()
    
    //Mark for: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        getChartDataFromAPI()
        editChartView()
        setTitle()
    }
    
    //Mark for: LineChartView adjustment func
    private func editChartView() {
        viewModel.editLineChartView(lineChartView: lineChartView)
        lineChartView.delegate = self
    }
    
    //Mark for: set view Title
    private func setTitle() {
        titleLabel.title = viewModel.getPageTitle()
    }
    
    //Mark for: viewDidLoad get data from api func
    private func getChartDataFromAPI() {
        viewModel.segmentControlValueChange(selectedSegmentIndex: viewModel.selectedSegmentIndex, selectedPairName: viewModel.pairListGetData.selectedPair ?? "")
    }
   
    private func bindViewModel() {
        viewModel.dataUpdatedCallBack = { items in
            self.setGraphData(with: items)
            self.editChartView()
        }
    }
    
    //Mark for: SegmentedControl change segment action
    @IBAction func segmentedControlValueChange(_ sender: UISegmentedControl) {
        let selectedSegmentIndex = sender.selectedSegmentIndex
        viewModel.segmentControlValueChange(selectedSegmentIndex: selectedSegmentIndex,selectedPairName: viewModel.pairListGetData.selectedPair!)
    }
}

extension PairChartViewController : ChartViewDelegate {
    
    
    //Mark for: User tap to chart return func
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        closeLabel.text = viewModel.chartValueSelected(entry: entry)
    }
    //Mark for: Set to chart data func
    private func setGraphData(with Entities: [ChartDataEntry]) {
        viewModel.lineChartViewSetGraphData(Entities,lineChartView: lineChartView)
    }
    
}

