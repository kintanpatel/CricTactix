//
//  SideMenuView.swift
//  CricTactix
//
//  Created by kintan on 09/05/24.
//

import Foundation
import SwiftUI

struct SideMenuView: View {
    @Binding var presentSideMenu: Bool
    var onDrawerItemClick : (SideMenuRowType) -> ()
    var body: some View {
        HStack {
            ZStack{
                Rectangle()
                    .fill(.white)
                    .frame(width: 270)
                    .shadow(color: .purple.opacity(0.1), radius: 5, x: 0, y: 3)
                
                VStack(alignment: .leading, spacing: 0) {
                    ProfileImageView()
                        .frame(height: 140)
                        .padding(.bottom, 30)
                    
                    ForEach(SideMenuRowType.allCases, id: \.self){ row in
                        RowView(imageName: row.iconName, title: row.title) {
                            withAnimation{
                                presentSideMenu.toggle()
                                onDrawerItemClick(row)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, 100)
                .frame(width: 270)
                .background(
                    Color.white
                )
            }
            
            
            Spacer()
        }.background( // notice the change to parentheses
            GeometryReader
            { geometry in
                Color.clear
                    
            }
        )
        
    }
    
    func ProfileImageView() -> some View{
        VStack(alignment: .center){
            HStack{
                Spacer()
                Image("ic_user")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(.gray.opacity(0.5), lineWidth: 5).shadow(radius: 10)
                    )
                    .cornerRadius(50)
                Spacer()
            }
            
            Text("Kintan Patel")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            
            Text("Mobile Developer")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black.opacity(0.5))
        }
    }
    
    
    
    func RowView(imageName: String, title: String, hideDivider: Bool = false, action: @escaping (()->())) -> some View{
        
        return Button{
               action()
           } label: {
               VStack(alignment: .leading){
                   HStack(spacing: 20){
                       Rectangle()
                           .fill(.white)
                           .frame(width: 5)
                       
                       ZStack{
                           Image(imageName)
                               .resizable()
                               .frame(width: 26, height: 26)
                       }
                       .frame(width: 30, height: 30)
                       Text(title)
                           .font(.system(size: 16, weight: .regular))
                           .foregroundColor(.black)
                       Spacer()
                   }
               }
           }
           .frame(height: 50)
       }
   }
 
enum SideMenuRowType: Int, CaseIterable{
    case home = 0
    case teams
    case profile
    case share
    case rate
    
    var title: String{
        switch self {
        case .home:
            return "Home"
        case .teams:
            return "Teams"
        case .profile:
            return "Profile"
        case .share:
            return "Share"
        case .rate:
            return "Rate"
        }
    }
    
    var iconName: String{
        switch self {
        case .home:
            return "ic_house"
        case .teams:
            return "ic_fav"
        case .profile:
            return "ic_user"
        case .share:
            return "ic_share"
        case .rate:
            return "ic_rate"
        }
    }
}
