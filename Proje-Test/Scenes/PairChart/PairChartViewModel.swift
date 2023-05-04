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
        PairChartAPIManager().getPairChart(url: URL(string: urlString)!) { pairChartResponse in
            
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
}
