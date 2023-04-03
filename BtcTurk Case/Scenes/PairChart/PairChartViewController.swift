//
//  PairChartsViewController.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 9.03.2023.
//

import Foundation
import Charts
import UIKit
import TinyConstraints

class PairChartViewController : UIViewController {
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var btnTimeStackView: UIStackView!
    @IBOutlet weak var pairChartNavBar: UINavigationBar!
   
   
    var viewModel = PairChartViewModel()
    func getVariableFromViewModel() {
        
    }
    
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
        lineChartView.xAxis.valueFormatter = ChartFormatter()
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
    }
    
    func editView() {
        titleLabel.title = "\(viewModel.selectedNumerator ?? "")/\(viewModel.selectedDenominator ?? "")"
        btnTimeStackView.layer.cornerRadius = 5
    }
    
    func getChartDataFromAPI() {
        let unixTimeStamp : Int = Int(Date().timeIntervalSince1970)
        let oneYearAgoTimeStamp = unixTimeStamp - 432000
        let unixTimeStampString = String(unixTimeStamp)
        let oneYearAgoTimeStampString = String(oneYearAgoTimeStamp)
        let selectedCoinName = viewModel.selectedPair
        viewModel.getChartDataTime(from: oneYearAgoTimeStampString, to: unixTimeStampString,chartPairName: selectedCoinName!)
    }
    
    @IBAction func btnOneYear(_ sender: Any) {
        viewModel.getOneYearData(selectedPairName: viewModel.selectedPair!)
    }
    
    @IBAction func btnSixMonth(_ sender: Any) {
        viewModel.getSixMonthData(selectedPairName: viewModel.selectedPair!)
    }
    
    @IBAction func btnThreeMonth(_ sender: Any) {
        viewModel.getThreeMonthData(selectedPairName: viewModel.selectedPair!)
    }
    
    @IBAction func btnOneMonth(_ sender: Any) {
        viewModel.getOneMonthData(selectedPairName: viewModel.selectedPair!)
    }
    
    @IBAction func btnFiveDay(_ sender: Any) {
        viewModel.getFiveDayData(selectedPairName: viewModel.selectedPair!)
    }
    
    @IBAction func btnOneDay(_ sender: Any) {
        viewModel.getOneDayData(selectedPairName: viewModel.selectedPair!)
    }
   
    func bindViewModel() {
        viewModel.dataUpdatedCallBack = { items in
            self.setGraphData(with: items)
            self.editChartView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        getChartDataFromAPI()
        lineChartView.delegate = self
        editChartView()
        editView()
    }
}

extension PairChartViewController : ChartViewDelegate {
    
    
    //Mark for: User tap to chart return func
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        let xValue = entry.x
        let yValue = entry.y
        let timestamp = Int(xValue)
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy mm:HH"
        let dateString = formatter.string(from: date)
        let labelString = "\(dateString) Tarihindeki \(viewModel.selectedNumerator ?? "")/\(viewModel.selectedDenominator ?? "") Değeri = \(yValue)"
        closeLabel.text = labelString
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

class ChartFormatter: NSObject, AxisValueFormatter {
    let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd/MM"
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
