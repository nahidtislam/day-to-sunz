import SwiftUI

let sv = 0.52

let hrFp = 24 * sv
let hr = Int(hrFp)

let minFp = 60 * (hrFp - Double(hr))
let min = Int(minFp)

let secFp = 60 * (minFp - Double(min))
let sec = Int(secFp)
//let min = hr * 60
//let sec = min * 60

let triPi = (3 * Double.pi) / 5

let c = Calendar(identifier: .gregorian)
c.ordinality(of: .day, in: .year, for: Date())


func expressPi(_ value: Double) -> String {
    let divider = value / Double.pi
    
    func convertToFraction(from decimal: Double) -> (numerator: Int, denominator: Int) {
        /// we need to know if we have a reoccurring trailing decimal place before we can compute fractions
        let decimalRepeats: Int = {
            /// just a hunch how big we should start checking otherwise we can safly say there's no
            /// reoccurring places
            let threshold = 4
            
            /// the charcters we actually care about
            let str: String = {
                var decs = String(decimal).components(separatedBy: ".")[1]
                decs.removeLast()
                return decs
            }()
            
            // save compute time
            if str.count <= threshold { return 0 }
            
            for i in ((threshold + 1)..<str.count).reversed() {
                let places = i - threshold
                
                let start = str.startIndex
                let end = str.endIndex
                let strIndex = str.index(start, offsetBy: str.count - i)
                
                let test = String(str[strIndex..<end])
                let unique: String = {
                    // we want to preserve order as raw sets are unordered
                    var set: Set<Character> = Set()
                    return test.filter { c in
                        set.insert(c).inserted
                    }
                }()
                
                if unique.count == places {
                    
                    let trailing: Substring = {
                        let trStarIndex = test.startIndex
                        let trIndex = test.index(trStarIndex, offsetBy: places - 1)
                        return test[trIndex..<test.endIndex]
                    }()
//                    print("test: \(test), trailing: \(trailing)")
                    if test.contains(trailing) && test.contains(unique) {
//                        print("yes: \(places) (test: \(test), unique: \(unique), traling(of test): \(trailing))")
                        return places
                    }
                }
            }
            
            return 0
        }()
        
        func gcf(of numerator: Int, by denominator: Int) -> (numerator: Int, denominator: Int)? {
            if numerator == denominator {
                return (1, 1)
            }
            for i in (2..<denominator).reversed() {
                if numerator.isMultiple(of: i) {
                    return (numerator / i, denominator / i)
                }
            }
            
            return nil
        }
        
        if decimalRepeats > 0 {
            let exponents = (pow(10, decimalRepeats) as NSDecimalNumber).doubleValue
            let unknownX = decimal * exponents
            let oneLessXAmount = exponents - 1
            let oneLessX = decimal * oneLessXAmount
            
            if let gcf = gcf(of: oneLessX, by: oneLessXAmount) {
                return gcf
            } else {
                return (oneLessX, oneLessXAmount)
            }
        }
        
        return (1, 2)
    }
    
    let aprox = Double(String(format: "%.8f", divider))!
    let multi = 1 / aprox
    convertToFraction(from: multi)
    return "\(multi)"
}

expressPi(triPi)
