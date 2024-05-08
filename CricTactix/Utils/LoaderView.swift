//
//  LoaderView.swift
//  CricTactix
//
//  Created by kintan on 04/05/24.
//

import Foundation
import SwiftUI

struct LoaderView: View {
    @State var isAnimated: Bool = false
    
    var body: some View {
        ZStack{
            ZStack{
                Color.white
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 14)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: 0.2)
                    .stroke(Color.green, lineWidth: 7)
                    .frame(width: 80, height: 80)
                    .rotationEffect(Angle(degrees: isAnimated ? 360 : 0))
                    .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false))
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear{
            DispatchQueue.main.async {
                isAnimated = true
            }
        }
        .onDisappear{
            DispatchQueue.main.async {
                isAnimated = false
            }
        }
    }
}
#Preview {
    LoaderView()
}
 
