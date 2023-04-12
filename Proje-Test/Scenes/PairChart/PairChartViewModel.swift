//
//  ChartsDataViewModel.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 10.03.2023.
//

import Foundation
import Charts

class PairChartViewModel {
    
    var chartsDataList : PairChartData?
    var dataUpdatedCallBack : (([ChartDataEntry])->())?
    let apiWithTime = "https://graph-api.btcturk.com/v1/klines/history?from="
    var selectedPair : String?
    var selectedNumerator : String?
    var selectedDenominator : String?
    let unixTimeStamp : Int = Int(Date().timeIntervalSince1970)
    
    func getChartDataTime(from: String, to: String,chartPairName: String) {
        
        let apiURLWithTime = "\(apiWithTime)\(from)&resolution=60&to=\(to)&symbol=\(chartPairName)"
        getChartsData(with: apiURLWithTime)
    }
    
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
    
    func getOneYearData(selectedPairName: String) {
        let oneYearAgoTimeStamp = unixTimeStamp - 31556926
        let unixTimeStampString = String(unixTimeStamp)
        let oneYearAgoTimeStampString = String(oneYearAgoTimeStamp)
        let pairName = selectedPairName
        getChartDataTime(from: oneYearAgoTimeStampString, to: unixTimeStampString,chartPairName: pairName)
    }
    
    func getSixMonthData(selectedPairName: String) {
        let SixMonthAgoTimeStamp = unixTimeStamp - 15778458
        let unixTimeStampString = String(unixTimeStamp)
        let SixMonthAgoTimeStampString = String(SixMonthAgoTimeStamp)
        let pairName = selectedPairName
        getChartDataTime(from: SixMonthAgoTimeStampString, to: unixTimeStampString,chartPairName: pairName)
    }
    
    func getThreeMonthData(selectedPairName: String) {
        let threeMonthAgoTimeStamp = unixTimeStamp - 7889229
        let unixTimeStampString = String(unixTimeStamp)
        let threeMonthAgoTimeStampString = String(threeMonthAgoTimeStamp)
        let pairName = selectedPairName
        getChartDataTime(from: threeMonthAgoTimeStampString, to: unixTimeStampString,chartPairName: pairName)
    }
    
    func getOneMonthData(selectedPairName: String) {
        let oneMonthAgoTimeStamp = unixTimeStamp - 2629743
        let unixTimeStampString = String(unixTimeStamp)
        let oneMonthAgoTimeStampString = String(oneMonthAgoTimeStamp)
        let pairName = selectedPairName
        getChartDataTime(from: oneMonthAgoTimeStampString, to: unixTimeStampString,chartPairName: pairName)
    }
    
    func getFiveDayData(selectedPairName: String) {
        let fiveDayAgoTimeStamp = unixTimeStamp - 432000
        let unixTimeStampString = String(unixTimeStamp)
        let fiveDayAgoTimeStampString = String(fiveDayAgoTimeStamp)
        let pairName = selectedPairName
        getChartDataTime(from: fiveDayAgoTimeStampString, to: unixTimeStampString,chartPairName: pairName)
    }
    
    func getOneDayData(selectedPairName: String) {
        let oneDayAgoTimeStamp = unixTimeStamp - 86400
        let unixTimeStampString = String(unixTimeStamp)
        let oneDayAgoTimeStampString = String(oneDayAgoTimeStamp)
        let pairName = selectedPairName
        getChartDataTime(from: oneDayAgoTimeStampString, to: unixTimeStampString,chartPairName: pairName)
    }
}
