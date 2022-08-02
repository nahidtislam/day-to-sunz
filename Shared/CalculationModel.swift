//
//  CalculationModel.swift
//  day percentage to sunz
//
//  Created by Nahid Islam on 09/04/2022.
//

import Foundation

struct CalculationModel {
    let longitude: Double
    let latitude: Double
    
    var duringDaytime: Bool
    static let egDate: Date = {
        let year = Calendar.current.component(.year, from: Date())
        
        return Date("23/07/\(year)", withFormat: "dd/MM/yyyy")!
    }()
    
    var targetDate = CalculationModel.egDate
    var verboseDetails = ""
    
    var dayOfYear: Int {
        let c = Calendar(identifier: .gregorian)
        
        return c.ordinality(of: .day, in: .year, for: targetDate)!
    }
    
    private var declination: Double {
        let doy = Double(dayOfYear)
        
        let magicDegree1 = rad(fromDeg: 23.45)
        let magicDegree2 = rad(fromDeg: 360 / 365)
        
        return magicDegree1 * sin(magicDegree2 * rad(fromDeg: (doy - 81)))
    }
    
    @available(*, deprecated, message: "result is inaccurate")
    func angle(hour: Double) -> Double {
        // https://solarsena.com/solar-azimuth-angle-calculator-sol ar-panels/
        let hr = (15 * Double.pi / 180) * (hour - 12)
        let dec: Double = {
            let magicRad = rad(fromDeg: -23.44)
            let anotherMagicRad = rad(fromDeg: 360/365)
            
            return magicRad * cos(anotherMagicRad * Double(dayOfYear + 10))
        }()
        
//        let lat: Double = {
//
//        }()
        
        let solarElevationAngle: Double = {
            asin(sin(latitude) * sin(dec)) + (cos(latitude) * cos(dec) * cos(hr))
        }()
        
        return ((sin(dec) * cos(latitude)) - (cos(dec) * sin(latitude) * cos(hr))) / solarElevationAngle
    }
    
    func compute(hr: Int, min: Int = 0) -> (elevation: Double, azimuth: Double) {
        let hourDecimal: Double = {
            let hourPart = Double(Swift.min(hr, 23))
            let minPart = Swift.min(Double(min), 59) / 60
            return hourPart + minPart
        }()
        
        let equOfTime: Double = {
            let b: Double = rad(fromDeg: (360 / 360) * (Double(dayOfYear) - 81))
            
            return (9.78 * sin(2 * b)) - (7.53 * cos(b)) - (1.5 * sin(b))
        }()
        
        let lstm: Double = {
            let gmt: Double = 1
            return rad(fromDeg: 15) * gmt
        }()
        
        let timeCorrection: Double = 4 * (longitude - lstm) + equOfTime
        let localSolarTime = hourDecimal + (timeCorrection / 60)
        let hourAngle = rad(fromDeg: 15) * (localSolarTime - 12)
        
        let declination = self.declination
        
        let elevation: Double = {
            let sins = sin(declination) * sin(rad(fromDeg: latitude))
            let coses = cos(declination) * cos(rad(fromDeg: latitude)) * cos(hourAngle)
            return asin(sins + coses)
            
        }()
        
        let azimuth = asin((sin(hourAngle) * cos(declination)) / cos(elevation))
        let _ = """
        hourDecimal:     \(hourDecimal)
        equOfTime:       \(equOfTime)
        lstm:            \(lstm)
        timeCorrection:  \(timeCorrection)
        localSolarTime:  \(localSolarTime)
        hourAngle:       \(hourAngle)
        declination:     \(declination)
        elevation:       \(elevation)
        azimuth:         \(azimuth)
        """
        
        return (elevation, azimuth)
    }
    
    func compute(timeDecimal: Double) -> (elevation: Double, azimuth: Double) {
        let time = min(0.9999, timeDecimal)
        
        let hour = Int(time * 24)
        let minutes: Int = {
            let decimal = (time * 24) - Double(hour)
            return Int(decimal * 60)
        }()
        
        return compute(hr: hour, min: minutes)
    }
    
    func coomputeSunsetTime(azimuth: Double, elevation: Double) -> Double {
        // https://astronomy.stackexchange.com/a/21054
        (12 / Double.pi) * acos(-1 * ((tan(latitude) * cos(latitude) * cos(azimuth) * cos(elevation) + sin(latitude) * sin(elevation)) / sqrt(pow(cos(latitude) * sin(elevation) - sin(latitude) * cos(azimuth) * cos(elevation), 2) + pow(sin(azimuth), 2) * pow(cos(elevation), 2)))) - atan(cos(latitude) * sin(elevation) - sin(latitude) * cos(azimuth) * cos(elevation) * sin(azimuth) * -1 * cos(elevation))
    }
}

func rad(fromDeg degrees: Double) -> Double {
    degrees * Double.pi / 180
}

extension Double {
//    var inTermsOfPi: String {
//        let div = self / .pi
//    }
}
