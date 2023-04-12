//
//  ChartDateFormatter.swift
//  Proje-Test
//
//  Created by BTCYZ188 on 5.04.2023.
//

import Foundation
import Charts

//Mark for: Chart view date values formatter
class ChartDateFormatter : NSObject, AxisValueFormatter {
    let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd/MM"
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
