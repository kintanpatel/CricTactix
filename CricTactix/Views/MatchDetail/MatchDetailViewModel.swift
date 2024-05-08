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
    
    
    func processData(_ data : MatchResponse){
        if let d = data.results.liveDetails?.scorecard{
            allScoreCard = d
        }
        
        fixture = data.results.fixture
        liveDetail = data.results.liveDetails
        teamA = data.results.fixture.home
        teamB = data.results.fixture.away
        onTeamSelect(0)
    }
    
    func getScoreCard(_ matchId : Int){
//        if let data = loadJson(){
//            processData(data)
//        }
        
        let urlString = "https://cricket-live-data.p.rapidapi.com/match/\(matchId)"
        
        guard let url = URL(string: urlString) else{
            fatalError("invalid request URL")
        }
       
        
        WebServiceWrapper.shared.jsonGetTask(url: url) { (response) in
            switch response{
            case .Error(let error):
                print(error.localizedDescription)
                return
                
            case .ApiError(let apiError):
                print(apiError.debugDescription)
                
            case .Success(let json):
                self.isLoading = false
                print(json)
                //6 parsing the Json response
                if let jsonData = try? JSONSerialization.data(withJSONObject: json){
                    let responseData = try! JSONDecoder().decode(MatchResponse.self, from: jsonData)
                    self.processData(responseData)
                }
            }
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
