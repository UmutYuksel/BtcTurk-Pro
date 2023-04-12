//
//  ChartsDataViewModel.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 10.03.2023.
//

import Foundation
import Charts

class PairChartViewModel {
    //Mark for: Variables
    var chartsDataList : PairChartData?
    var dataUpdatedCallBack : (([ChartDataEntry])->())?
    let apiWithTime = "https://graph-api.btcturk.com/v1/klines/history?from="
    var selectedPair : String?
    var selectedNumerator : String?
    var selectedDenominator : String?
    let unixTimeStamp : Int = Int(Date().timeIntervalSince1970)
    
    //Mark for: Functions
    
    //Mark for: The function whose parameters are set to the getChartsData function
    func getChartDataTime(from: String, to: String,chartPairName: String) {
        let apiURLWithTime = "\(apiWithTime)\(from)&resolution=60&to=\(to)&symbol=\(chartPairName)"
        getChartsData(with: apiURLWithTime)
    }
    //Mark for: Function that pulls graphics data through the api
    func getChartsData(with urlString: String) {
        
        PairChartAPI().getPairChartData(url: URL(string: urlString)!) { chartsData in
            
            if let chartsData = chartsData {
                self.chartsDataList = chartsData
                DispatchQueue.main.async {
                    self.dataUpdatedCallBack?(self.mapToChartModel())
                }
            } else {
                print("Hata")
            }
        }
    }
    //Mark for: The function that maps the data received via the api for chart
    func mapToChartModel() -> [ChartDataEntry] {
        var chartDataArray = [ChartDataEntry]()
        
        for (i,_) in (chartsDataList?.time ?? []).enumerated() {
            let xValues = chartsDataList!.time![i]
            if (chartsDataList?.close?.count ?? 0) > i {
                let yValues = chartsDataList!.close![i]
                let chartData = ChartDataEntry(x: xValues, y: yValues)
                chartDataArray.append(chartData)
            } else {
                break
            }
        }
        return chartDataArray
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
        let fromTimeStamp = unixTimeStamp - Int(timeRange.rawValue)
        let fromTimeStampString = String(fromTimeStamp)
        let toTimeStampString = String(unixTimeStamp)
        getChartDataTime(from: fromTimeStampString, to: toTimeStampString, chartPairName: selectedPairName)
    }
    
    enum ChartTimeRange: TimeInterval {
        case oneYear = 31556926
        case sixMonths = 15778458
        case threeMonths = 7889229
        case oneMonth = 2629743
        case fiveDays = 432000
        case oneDay = 86400
    }
}
