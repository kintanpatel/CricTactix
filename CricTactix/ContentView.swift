//
//  ContentView.swift
//  CricTactix
//
//  Created by kintan on 04/05/24.
//

import SwiftUI

struct ContentView: View {
    @State var isLoading : Bool = true
    
    var body: some View {
        ZStack{
            if(isLoading){
                LoaderView()
            }else{
                if #available(iOS 14.0, *) {
                    HomeView()
                } else {
                    Text("Welcome")
                }
            }
        }.onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                isLoading = false
            })
        }
    }
}

#Preview {
    ContentView()
}
