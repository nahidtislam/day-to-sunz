//
//  CalculationViewModel.swift
//  day percentage to sunz
//
//  Created by Nahid Islam on 09/04/2022.
//

import SwiftUI

class CalculationViewModel: ObservableObject {
    
    @Published var model = CalculationModel(longitude: -2.594, latitude: 51.468, duringDaytime: true)
    
    
    @Published var sliderValue: Double = 0.5
    
    var percentage: Double {
        get {
            sliderValue * 100
        }
        set(newPercent) {
            sliderValue = min(newPercent, 100) / 100
        }
    }
    
    var results:(elevation: Double, azimuth: Double) {
        model.compute(timeDecimal: sliderValue)
    }
    
    var azimuthDisplay: String {
        String(format: "%.2f", results.azimuth)
//        String(format: "%.2fπ", results.azimuth / Double.pi)
    }
    var elevationDisplay: String {
        results.elevation.roundTo(decimalPlace: 2)
//        String(format: "%.2f", results.elevation)
//        String(format: "%.2fπ", results.elevation / Double.pi)
    }
    
    var percentDisplay: String {
        String(format: "%.2f", percentage) + "%"
    }
    
    var timeOfDay: String {
        let hrFp = 24 * sliderValue
        let hr = Int(hrFp)

        let minFp = 60 * (hrFp - Double(hr))
        let min = Int(minFp)

        let secFp = 60 * (minFp - Double(min))
        let sec = Int(secFp)
        
        let digitFormat = "%02d"
        let hrStr = String(format: digitFormat, hr)
        let minStr = String(format: digitFormat, min)
        let secStr = String(format: digitFormat, sec)
        
        return "\(hrStr):\(minStr):\(secStr)"
    }
    
    func updateTimeInDate() {
//        let time = sliderValue
//
//        let hour = min(Int(time * 24), 23)
//        let minutes: Int = {
//            let decminal = (time * 24) - Double(hour)
//            return min(Int(decminal * 60), 59)
//        }()
//        let seconds: Int = {
//           let decimal =
//        }()
//
        let component = timeOfDay.components(separatedBy: ":").map { component in
            Int(component)!
        }
        let c = Calendar(identifier: .gregorian)
//        let new = c.date(bySettingHour: hour, minute: minutes, second: 00, of: model.targetDate)!
        
        let hrs = min(component[0], 23)
        let mins = min(component[1], 59)
        let secs = min(component[2], 59)
        
        let new = c.date(bySettingHour: hrs, minute: mins, second: secs, of: model.targetDate)!
        model.targetDate = new
    }
    
    func refreshTime() {
        let c = Calendar.current
        let sec = c.ordinality(of: .second, in: .day, for: model.targetDate)!
        
        sliderValue = Double(sec) / (3600 * 24)
    }
    
    func roundToNearestPercent() {
        sliderValue = percentage.rounded() / 100
    }
}

private extension Double {
    func roundTo(decimalPlace: Int) -> String {
        .init(format: "%.\(decimalPlace)f", self)
    }
}
