//
//  FloatingPoint+BeforeAndAfterDecimalPoint.swift
//
//  Created by Nahid Islam on 10/04/2022.
//

import Foundation

extension FloatingPoint {
    var beforeDecimalPoint: Self { modf(self).0 }
    var afterDecimalPoint: Self { modf(self).1 }
}
