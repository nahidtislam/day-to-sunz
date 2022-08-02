//
//  View+MacWindowSize.swift
//  day percentage to sunz
//
//  Created by Nahid Islam on 09/04/2022.
//

import SwiftUI

extension View {
    func macWindowSize(width: ClosedRange<CGFloat>?, height: ClosedRange<CGFloat>?) -> some View {
        #if os(macOS)
        return self
            .frame(minWidth: width?.lowerBound, maxWidth: width?.upperBound, minHeight: height?.lowerBound, maxHeight: height?.upperBound)
        #else
        return self
        #endif
    }
    
    func macWindowSize(width: ClosedRange<CGFloat>) -> some View {
        self.macWindowSize(width: width, height: nil)
    }
    func macWindowSize(height: ClosedRange<CGFloat>) -> some View {
        self.macWindowSize(width: nil, height: height)
    }
}
