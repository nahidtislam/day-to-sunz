//
//  ContentView.swift
//  Shared
//
//  Created by Nahid Islam on 09/04/2022.
//

import SwiftUI

struct CalculationView: View {
    
    @StateObject var vm = CalculationViewModel()
    
    
    var body: some View {
        VStack {
            sunSetRiseTexts
                .padding()
            Spacer()
            calc
            Spacer()
            coords
        }
    }
    
    var calc: some View {
        VStack {
            DatePicker("day:", selection: $vm.model.targetDate)
                .onHover { isHovering in
                    if !isHovering {
                        let c: Calendar = .current
                        let sec = c.ordinality(of: .second, in: .day, for: vm.model.targetDate)!
                        
                        vm.sliderValue = Double(sec) / (3600 * 24)
                    }
                }
//                .datePickerStyle(.field)
//            pic
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .frame(width: 150, height: 150)
                    .foregroundColor(.red)
                    .overlay {
                        Circle()
                            .frame(width: 20, height: 20)
                            .offset(
                                x: (vm.sliderValue * 100) - 50,
//                                x: vm.results.azimuth * 15 * Double.pi,
                                y: -vm.results.elevation * 25 * Double.pi
                            )
                            .foregroundColor(.white)
                            .shadow(radius: 12)
                    }
            }
            Slider(value: $vm.sliderValue, in: 0...0.99999) {
                Text("percent: ")
            }
            .onChange(of: vm.sliderValue, perform: { newValue in
                vm.updateTimeInDate()
            })
            .padding(.horizontal, 16)
            
            Text("\(vm.percentDisplay) (\(vm.timeOfDay))")
                .onTapGesture {
                    vm.roundToNearestPercent()
                }
            
            Text("azimuth: \(vm.azimuthDisplay)")
            Text("elevation: \(vm.elevationDisplay)")
//            Text("some time: \(vm.model.coomputeSunsetTime(azimuth: vm.results.azimuth, elevation: vm.results.elevation))")
        }
        .padding()
        .macWindowSize(width: 400...700)
//        .frame(minWidth: 250, maxWidth: 700)
    }
    
    var sunSetRiseTexts: some View {
        VStack {
            Text("sunrise: {x}")
            Text("sunset: {x}")
        }
    }
    
    var coords: some View {
        VStack {
            Text("longitude: \(vm.model.longitude)")
            Text("latitude:  \(vm.model.latitude)")
                .padding(.bottom, 8)
            Button("change") {
                print("ok")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalculationView()
    }
}
