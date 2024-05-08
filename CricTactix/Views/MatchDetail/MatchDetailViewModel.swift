//
//  MatchDetailViewModel.swift
//  CricTactix
//
//  Created by kintan on 08/05/24.
//

import Foundation

class MatchDetailViewModel: ObservableObject {
    @Published var isLoading : Bool = false
    var allScoreCard:[ScoreCard] = []
    @Published var scoreCard:ScoreCard?
    @Published var teamA:Team?
    @Published var teamB:Team?
    
    @Published var fixture:Fixture?
    @Published var liveDetail:LiveDetails?
    
    
    func getScoreCard(){
        if let data = loadJson(){
            allScoreCard = data.results.liveDetails.scorecard
            fixture = data.results.fixture
            liveDetail = data.results.liveDetails
            teamA = data.results.fixture.home
            teamB = data.results.fixture.away
            onTeamSelect(0)
        }
    }
    
    func onTeamSelect(_ selectedTeam: Int) {
        if(selectedTeam  == 0){
            scoreCard = allScoreCard.first
        }else{
            scoreCard = allScoreCard.last
        }
    }
    
    private func loadJson() -> MatchResponse? {
        // Read JSON data from file
        if let jsonFilePath = Bundle.main.path(forResource: "matchDetail", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: jsonFilePath))
                
                // Decode JSON data
                let decoder = JSONDecoder()
                let matchesData = try decoder.decode(MatchResponse.self, from: jsonData)
                
                return matchesData
            } catch {
                print("Error reading JSON file or decoding JSON data: \(error)")
                return nil
            }
        } else {
            print("JSON file not found in the project")
            return nil
        }
    }

}
