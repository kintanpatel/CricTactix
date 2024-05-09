//
//  FavoriteScreen.swift
//  CricTactix
//
//  Created by kintan on 09/05/24.
//

import SwiftUI

struct TeamsScreen: View {
    @StateObject var viewModel : TeamsViewModel = TeamsViewModel()
    var body: some View {
        List{
            ForEach(viewModel.teamList,id:  \.id){ team in
                LazyVStack{
                    HStack{
                        let imageTeam = UIImage(named: "\(team.id)") ?? UIImage(named: "placeholder")!
                        
                        Image(uiImage: imageTeam )
                            .resizable()
                            .frame(width: 80,height:80)
                            .clipShape(Circle())
                        Text(team.name).multilineTextAlignment(.center)
                        Spacer()
                    }
                }
            }
        }.navigationTitle("Teams")
        .onAppear{
            viewModel.getTeamList()
        }
    }
}

#Preview {
    NavigationView(content: {
        TeamsScreen()
    })
    
}
