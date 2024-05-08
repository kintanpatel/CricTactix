//
//  HomeView.swift
//  CricTactix
//
//  Created by kintan on 04/05/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel : HomeViewModel = HomeViewModel()
    @State private var matchType: MatchType = .live // Default match type is live
    
    
    var body: some View {
        NavigationView{
            if(viewModel.isLoading){
                LoaderView()
            }else{
                VStack{
                    Picker("Match Type", selection: $matchType) {
                        ForEach(MatchType.allCases,id : \.self){ matchType in
                            Text(matchType.statusName)
                        }
                    }
                    .pickerStyle(.segmented).padding(.horizontal,14)
                    List{
                        if(viewModel.matchList.isEmpty){
                            Text("No \(matchType.statusName) Match Found")
                        }else{
                            ForEach(viewModel.matchList,id: \.id){match in
                                
                                //VStack
                                LazyVStack{
                                    ZStack {
                                        MatchInfo(match: match)
                                        NavigationLink(destination: MatchDetailView(match: match)) {
                                        }.buttonStyle(PlainButtonStyle()).frame(width:0).opacity(0)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                .navigationBarTitleDisplayMode(.inline).navigationTitle("Cricket")
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            Text("Profile")
                        } label: {
                            Image(systemName: "person.crop.circle.fill")
                        }
                    }
                })
            }
        }
        .onChange(of: matchType, perform: viewModel.updateMatchList(_:))
        .onAppear{
            viewModel.getScheduledMatchList()
        }
    }
    
}
struct MatchInfo : View {
    var match : Match
    @State var cardColor : Color = .white
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25.0).fill(cardColor)
                .shadow(radius: 10)
            RoundedRectangle(cornerRadius: 25.0).fill(.white.opacity(0.4))
            VStack(alignment : .leading){
                Text(match.matchTitle).lineLimit(2).font(.subheadline)
                
                HStack{
                    TeamView(name: match.home.name, imageName: "\(match.home.id)")
                    
                    VStack{
                        Text("VS").foregroundColor(.secondary).font(.caption2)
                        Text(match.getMathDate()).foregroundColor(.secondary).font(.caption2).multilineTextAlignment(.center)
                    }.padding(.bottom,56).frame(maxWidth: .infinity)
                    
                    TeamView(name: match.away.name, imageName: "\(match.away.id)")
                }
                
                Text(match.venue)
                    .font(.caption2).padding(.top,2)
            }.padding()
        }
        .onAppear{
            // Extract dominant colors from the images
            if let uiImage1 = UIImage(named: "\(match.home.id)"),
               let uiImage2 = UIImage(named: "\(match.away.id)") {
                let colors1 = uiImage1.dominantColors()
                let colors2 = uiImage2.dominantColors()
                let combinedColors = colors1 + colors2 // Combine colors from both images
                if let averageColor = combinedColors.averageColor() {
                    cardColor = Color(averageColor)
                }
            }
        }
    }
}

struct TeamView: View {
    var name : String
    var imageName : String
    var body: some View {
        let imageTeam = UIImage(named: imageName) ?? UIImage(named: "placeholder")!
            
        VStack(alignment : .center){
            Image(uiImage: imageTeam)
            .resizable()
                .frame(width: 80,height:80)
                .clipShape(Circle())
            Text(name).multilineTextAlignment(.center)
        }.frame(maxWidth: .infinity)
    }
}

//#Preview {
//    TeamView(name: "Gujarat",imageName: "161268")
//}

#Preview {
    HomeView()
}
