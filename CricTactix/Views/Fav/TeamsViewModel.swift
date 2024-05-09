//
//  FavoriteViewModel.swift
//  CricTactix
//
//  Created by kintan on 09/05/24.
//

import Foundation

class TeamsViewModel: ObservableObject {
    @Published var teamList:[Team] = []
    
    func getTeamList(){
        if let data = loadJson(){
            let teams = data.map{$0.home}
            // Use reduce to filter out duplicate teams based on their IDs
            let distinctTeams = teams.reduce(into: [Int: Team]()) { result, team in
                result[team.id] = team
            }.values.sorted { $0.id < $1.id }
            teamList = distinctTeams
        }
        
    }
    
    private func loadJson() -> [Match]? {
        // Read JSON data from file
        if let jsonFilePath = Bundle.main.path(forResource: "matches", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: jsonFilePath))
                
                // Decode JSON data
                let decoder = JSONDecoder()
                let matchesData = try decoder.decode([String: [Match]].self, from: jsonData)
                
                // Access the matches array
                if let matches = matchesData["results"] {
                    return matches
                }
            } catch {
                print("Error reading JSON file or decoding JSON data: \(error)")
                return nil
            }
        } else {
            print("JSON file not found in the project")
            return nil
        }
        return nil
    }


}
