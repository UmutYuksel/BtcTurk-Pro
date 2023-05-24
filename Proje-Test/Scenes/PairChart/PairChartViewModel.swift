//
//  ChartsDataViewModel.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 10.03.2023.
//

import Foundation
import Charts
import Toast
import UIKit

class PairChartViewModel {
    //Mark for: Variables
    var chartsResponse : PairChartResponse?
    var dataUpdatedCallBack : (([ChartDataEntry])->())?
    let apiWithTime = "https://graph-api.btcturk.com/v1/klines/history?from="
    var selectedPair : String?
    var selectedNumerator : String?
    var selectedDenominator : String?
    let unixTimeStamp : Int = Int(Date().timeIntervalSince1970)
    var selectedSegmentIndex = 4
    var pairListGetData : ChartListViewControllerPassData!
    
    
    //Mark for: Functions
    
    //Mark for: The function whose parameters are set to the getChartsData function
    func getChartDataTime(from: String, to: String,chartPairName: String) {
        let apiURLWithTime = "\(apiWithTime)\(from)&resolution=60&to=\(to)&symbol=\(chartPairName)"
        getChartsData(with: apiURLWithTime)
    }
    
    //Mark for: Chart value selected return chart values func
    func chartValueSelected(entry: ChartDataEntry) -> String {
        let xValue = entry.x
        let yValue = entry.y
        let timestamp = Int(xValue)
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy mm:HH"
        let dateString = formatter.string(from: date)
        let labelString = "\(dateString) Tarihindeki \(selectedNumerator ?? "")/\(selectedDenominator ?? "") Değeri = \(yValue)"
        return labelString
    }
    
    //Mark for: Function that pulls graphics data through the api
    func getChartsData(with urlString: String) {
        PairChartAPIManager().getPairChart(url: URL(string: urlString)!) { result in
            switch result {
            case .success(let pairChartResponse):
                if let pairChartList = pairChartResponse {
                    self.chartsResponse = pairChartList
                    DispatchQueue.main.async {
                        self.dataUpdatedCallBack?(self.mapToChartModel())
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
    //Mark for: The function that maps the data received via the api for chart
    func mapToChartModel() -> [ChartDataEntry] {
        var chartDataArray = [ChartDataEntry]()
        
        for (i,_) in (chartsResponse?.time ?? []).enumerated() {
            let xValues = chartsResponse!.time![i]
            if (chartsResponse?.close?.count ?? 0) > i {
                let yValues = chartsResponse!.close![i]
                let chartData = ChartDataEntry(x: xValues, y: yValues)
                chartDataArray.append(chartData)
            } else {
                break
            }
        }
        return chartDataArray
    }
    //Mark for: Page title adjustment with segue pass data
    func getPageTitle() -> String {
        let pageTitle = "\(pairListGetData.numeratorSymbol ?? "")/\(pairListGetData.denominatorSymbol ?? "")"
        return pageTitle
    }
    
    //Mark for: The function that is triggered when the segmentedControl's value changes
    func segmentControlValueChange(selectedSegmentIndex: Int, selectedPairName: String) {
        
        switch selectedSegmentIndex {
        case 0:
            getChartDataWithTime(for: selectedPairName, to: .oneYear)
        case 1:
            getChartDataWithTime(for: selectedPairName, to: .sixMonths)
        case 2:
            getChartDataWithTime(for: selectedPairName, to: .threeMonths)
        case 3:
            getChartDataWithTime(for: selectedPairName, to: .oneMonth)
        case 4:
            getChartDataWithTime(for: selectedPairName, to: .fiveDays)
        case 5:
            getChartDataWithTime(for: selectedPairName, to: .oneDay)
        default:
            getChartDataWithTime(for: selectedPairName, to: .fiveDays)
        }
    }
    
    //Mark for: The function where the parameters of the getChartDataTime function are set
    func getChartDataWithTime(for selectedPairName: String, to timeRange: ChartTimeRange) {
        let fromTimeStamp = unixTimeStamp - Int(timeRange.days * 86400)
        let fromTimeStampString = String(fromTimeStamp)
        let toTimeStampString = String(unixTimeStamp)
        getChartDataTime(from: fromTimeStampString, to: toTimeStampString, chartPairName: selectedPairName)
    }
    //Mark for: The enum that sets the selectedSegment return values ​​on the PairChart screen
    enum ChartTimeRange {
        case oneYear
        case sixMonths
        case threeMonths
        case oneMonth
        case fiveDays
        case oneDay
        case custom(Int)
        
        var days: Int {
            switch self {
            case .oneDay:
                return 1
            case .fiveDays:
                return 5
            case .oneMonth:
                return 30
            case .threeMonths:
                return 90
            case .sixMonths:
                return 180
            case .oneYear:
                return 365
            case .custom(let day):
                return day
            }
        }
        
        var displayingText: String {
            switch self {
            case .oneMonth:
                return "1 Ay"
            case .threeMonths:
                return "3 Ay"
            case .sixMonths:
                return "6 Ay"
            case .oneYear:
                return "1 Yıl"
            default:
                return "\(self.days) Gün"
            }
        }
    }
    
    //Mark for: PairChart Scene LineChart adjusment
    func editLineChartView(lineChartView: LineChartView) {
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
    }
    
    //Mark for: Set lineChartView data func
    func lineChartViewSetGraphData(_ Entities: [ChartDataEntry],lineChartView: LineChartView) {
        let chartData = LineChartDataSet(entries: Entities, label: "Data")
        chartData.mode = .linear
        chartData.lineWidth = 3
        chartData.drawCirclesEnabled = false
        chartData.setColor(UIColor.chartTint())
        let gradientColors = [ChartColorTemplates.colorFromString("#141926").cgColor,
                              ChartColorTemplates.colorFromString("#182D3E").cgColor]
        
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        chartData.fillAlpha = 2
        chartData.fill = LinearGradientFill(gradient: gradient, angle: 90)
        chartData.drawFilledEnabled = true
        let data = LineChartData(dataSet: chartData)
        data.setDrawValues(false)
        lineChartView.data = data
    }
}
