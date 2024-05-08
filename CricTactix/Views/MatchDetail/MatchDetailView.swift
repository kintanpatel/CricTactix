//
//  MatchDetailView.swift
//  CricTactix
//
//  Created by kintan on 08/05/24.
//

import SwiftUI

struct MatchDetailView: View {
    var match : Match?
    @State var teamSelection: Int = 0
    @ObservedObject var viewModel : MatchDetailViewModel = MatchDetailViewModel()
    
    var body: some View {
        ScrollView{
            VStack(alignment : .leading){
                if let fixture = viewModel.fixture{
                    VStack(alignment : .leading,spacing: 5){
                        Text("Indian Premier League 2024")
                            .font(.title2.weight(.bold))
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        HStack{
                            TeamView(name: viewModel.teamA?.name ??  "", imageName: "\(viewModel.teamA?.id ?? 0)")
                            Text("VS").foregroundColor(.secondary).font(.caption2)
                            TeamView(name: viewModel.teamB?.name ??  "", imageName: "\(viewModel.teamB?.id ?? 0)")
                        }
                        
                        Text("Venue :  \(fixture.venue)").foregroundColor(.secondary).font(.subheadline).padding(.top,12)
                        Text("Match Date : \(fixture.startDate.toDate()?.toString() ?? "")").foregroundColor(.secondary).font(.subheadline)
                        if let liveDetail = viewModel.liveDetail{
                            Text("Toss : \(liveDetail.matchSummary.toss )").font(.caption2)
                            Text(liveDetail.matchSummary.status).foregroundColor(.red).font(.headline)
                        }
                    }.padding().background( // notice the change to parentheses
                        GeometryReader{ geometry in
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .strokeBorder(Color.black.opacity(0.2), lineWidth: 1) .shadow(radius: 10)
                        }
                    )
                }
                
                Text("ScoreCard").padding(.vertical,20).font(.title.weight(.bold)).pickerStyle(.segmented)
                
                Picker("", selection: $teamSelection){
                    Text(viewModel.teamA?.name ?? "").tag(0)
                    Text(viewModel.teamB?.name ?? "").tag(1)
                }.pickerStyle(.segmented)
                
                ScoreCardHeaderView()
                if let batting = viewModel.scoreCard?.batting{
                    ForEach(batting,id: \.playerID){player in
                        //VStack
                        ScoreCardViewBatsman(batsman: player)
                    }
                }
                HStack{
                    if let scoreCard = viewModel.scoreCard {
                        Text("Extras")
                        Spacer()
                        Text("\(scoreCard.extras)").font(.headline)
                        Text("\(scoreCard.extrasDetail)").foregroundColor(.gray)
                            .font(.subheadline)
                    }
                }
                VStack(alignment : .leading){
                    if let scoreCard = viewModel.scoreCard {
                        Text("Did Not Bat")
                        let stillToBat = scoreCard.stillToBat.map { it in
                            it.playerName
                        }.joined(separator: ",")
                        Text(stillToBat).foregroundColor(.gray)
                            .font(.subheadline)
                        
                    }
                }.padding(.top,12)
                ScoreCardHeaderView(isBatting: false).padding(.top,12)
                if let bowling = viewModel.scoreCard?.bowling{
                    ForEach(bowling,id: \.playerID){bowler in
                        //VStack
                        ScoreCardViewBowler(bowler: bowler)
                    }
                }
                FollOfWicketView(follOfWicket: viewModel.scoreCard?.fow ?? "")
            }.padding().navigationTitle("Match Info")
        }.onAppear{
            viewModel.getScoreCard()
        }.onChange(of: teamSelection, perform: viewModel.onTeamSelect(_:))
    }
}

struct FollOfWicketView: View {
    var follOfWicket : String = ""
    var body: some View{
        VStack(alignment : .leading){
             Text("Fall of Wicket")
                .bold().frame(maxWidth:.infinity)
            .padding()
            .background(Color.black.opacity(0.05))
            .cornerRadius(5)
        }
        Text(follOfWicket).padding()
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 1)
        
    }
}


#Preview{
    FollOfWicketView()
}
struct ScoreCardHeaderView: View {
    
    @State var isBatting:Bool = true
    
    var body: some View{
        HStack{
            HStack{
                Text(isBatting ? "Batsman" : "Bowler")
                    .bold()
                Spacer()
            }
            .frame(maxWidth:.infinity)
            
            Text(isBatting ? "R" : "O")
                .bold()
                .frame(width:40)
            Text(isBatting ? "B" : "M")
                .bold()
                .frame(width:30)
            Text(isBatting ? "4s" : "R")
                .bold()
                .frame(width:30)
            Text(isBatting ? "6s" : "W")
                .bold()
                .frame(width:30)
            Text(isBatting ? "SR" : "ER")
                .bold()
                .frame(width:55)
        }
        .padding()
        .background(Color.black.opacity(0.05))
        .cornerRadius(5)
    }
}



struct ScoreCardViewBatsman: View {
    var batsman : BattingDetail!
    var body: some View{
        HStack{
            HStack{
                VStack(alignment:.leading){
                    Text(batsman.playerName)
                        .font(.subheadline)
                        .bold()
                    Text( batsman.howOut)
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                Spacer()
            }
            .frame(maxWidth:.infinity)
            
            Text("\(batsman.runs)")
                .frame(width:40)
                .font(.subheadline)
            
            Text("\(batsman.balls)")
                .frame(width:30)
                .font(.subheadline)
            Text("\(batsman.fours)")
                .frame(width:30)
                .font(.subheadline)
            Text("\(batsman.sixes)")
                .frame(width:30)
                .font(.subheadline)
            Text(batsman.strikeRate)
                .frame(width:55)
                .font(.subheadline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}
struct ScoreCardViewBowler: View {
    var bowler : BowlingDetail!
    var body: some View{
        HStack{
            HStack{
                VStack(alignment:.leading){
                    Text(bowler.playerName)
                        .font(.subheadline)
                        .bold()
                }
                Spacer()
            }
            .frame(maxWidth:.infinity)
            
            Text("\(bowler.overs)")
                .frame(width:40)
                .font(.subheadline)
            
            Text("\(bowler.maidens)")
                .frame(width:30)
                .font(.subheadline)
            Text("\(bowler.runsConceded)")
                .frame(width:30)
                .font(.subheadline)
            Text("\(bowler.wickets)")
                .frame(width:30)
                .font(.subheadline)
            Text(bowler.economy)
                .frame(width:55)
                .font(.subheadline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}


#Preview {
    NavigationView{
        MatchDetailView()
    }
}
