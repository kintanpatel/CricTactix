//
//  DrawerView.swift
//  CricTactix
//
//  Created by kintan on 09/05/24.
//

import Foundation
import SwiftUI


// 1
struct DrawerView<MainContent: View, DrawerContent: View>: View {
    // 2
    @Binding var isOpen: Bool
    private let main: () -> MainContent
    private let drawer: () -> DrawerContent
    private let overlap: CGFloat = 0.7
    private let overlayColor = Color.gray
    private let overlayOpacity = 0.7

    
    init(isOpen: Binding<Bool>,
         @ViewBuilder main: @escaping () -> MainContent,
         @ViewBuilder drawer: @escaping () -> DrawerContent) {
        self._isOpen = isOpen
        self.main = main
        self.drawer = drawer
    }
    
    var body: some View {
            GeometryReader { proxy in
                let drawerWidth = proxy.size.width * overlap
                ZStack(alignment: .topLeading) {
                    main()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        // 3
                        .overlay(isOpen ? mainOverlay : nil).ignoresSafeArea()
                    drawer()
                        .frame(minWidth: drawerWidth, idealWidth: drawerWidth,
                               maxWidth: drawerWidth, maxHeight: .infinity)
                        .offset(x: isOpen ? 0 : -drawerWidth, y: 0)
                }
            }
        }
    
    private var mainOverlay: some View {
          overlayColor.opacity(overlayOpacity)
              .onTapGesture {
                  withAnimation {
                      isOpen.toggle()
                  }
              }
      }
}
