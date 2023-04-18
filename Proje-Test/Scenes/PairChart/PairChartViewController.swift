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
    
    //Mark for: LineChartView adjustment func
    func editChartView() {
        lineChartView.backgroundColor = UIColor.chartBackground()
        lineChartView.chartDescription.enabled = false
        lineChartView.animate(xAxisDuration: 1.0)
        lineChartView.setScaleEnabled(false)
        lineChartView.leftAxis.enabled = false
        lineChartView.xAxis.enabled = true
        lineChartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        lineChartView.xAxis.labelTextColor = UIColor.white
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.setLabelCount(5, force: false)
        lineChartView.xAxis.valueFormatter = ChartDateFormatter()
        lineChartView.rightAxis.labelFont = .boldSystemFont(ofSize: 10)
        lineChartView.rightAxis.labelTextColor = UIColor.white
        lineChartView.rightAxis.setLabelCount(6, force: false)
        lineChartView.tintColor = UIColor.chartTint()
        lineChartView.rightAxis.labelPosition = .outsideChart
        lineChartView.xAxis.axisLineColor = .systemCyan
        lineChartView.rightAxis.axisLineColor = UIColor.darkBlueTint()
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.gridColor = UIColor.gray.withAlphaComponent(0.2)
        lineChartView.rightAxis.gridColor = UIColor.gray.withAlphaComponent(0.2)
        lineChartView.legend.enabled = false
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.setViewPortOffsets(left: 20, top: 20, right: 50, bottom: 20)
        lineChartView.delegate = self
    }
    //Mark for: set view Title
    func setTitle() {
        titleLabel.title = "\(viewModel.selectedNumerator ?? "")/\(viewModel.selectedDenominator ?? "")"
    }
    //Mark for: viewDidLoad get data from api func
    func getChartDataFromAPI() {
        viewModel.segmentControlValueChange(selectedSegmentIndex: viewModel.selectedSegmentIndex, selectedPairName: viewModel.selectedPair ?? "")
    }
   
    func bindViewModel() {
        viewModel.dataUpdatedCallBack = { items in
            self.setGraphData(with: items)
            self.editChartView()
        }
    }
    
    //Mark for: SegmentedControl change segment action
    @IBAction func segmentedControlValueChange(_ sender: UISegmentedControl) {
        let selectedSegmentIndex = sender.selectedSegmentIndex
        viewModel.segmentControlValueChange(selectedSegmentIndex: selectedSegmentIndex,selectedPairName: viewModel.selectedPair!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        getChartDataFromAPI()
        editChartView()
        setTitle()
    }
}

extension PairChartViewController : ChartViewDelegate {
    
    
    //Mark for: User tap to chart return func
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        closeLabel.text = viewModel.chartValueSelected(entry: entry)
    }
    //Mark for: Set to chart data func
    func setGraphData(with Entities: [ChartDataEntry]) {
        let set1 = LineChartDataSet(entries: Entities, label: "Data")
        set1.mode = .linear
        set1.lineWidth = 3
        set1.drawCirclesEnabled = false
        set1.setColor(UIColor.chartTint())
        let gradientColors = [ChartColorTemplates.colorFromString("#141926").cgColor,
                              ChartColorTemplates.colorFromString("#182D3E").cgColor]
        
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        set1.fillAlpha = 2
        set1.fill = LinearGradientFill(gradient: gradient, angle: 90)
        set1.drawFilledEnabled = true
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        lineChartView.data = data
    }
    
}

