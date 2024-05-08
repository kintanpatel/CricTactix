//
//  HomeViewModel.swift
//  CricTactix
//
//  Created by kintan on 04/05/24.
//

import Foundation


class HomeViewModel: ObservableObject {
    @Published var isLoading : Bool = false
    @Published var matchList:[Match] = []
    var matchListCopy:[Match] = []
    
    func getScheduledMatchList(){
        isLoading = true
        //        if let data = loadJson(){
        //            matchListCopy = data
        //            updateMatchList(.upcoming)
        //            self.isLoading = false
        //        }
        
//        let urlString = "https://cricket-live-data.p.rapidapi.com/fixtures"
        let urlString = "https://cricket-live-data.p.rapidapi.com/fixtures-by-series/2002"
        
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
                // Decode JSON data
                
                if let jsonData = try? JSONSerialization.data(withJSONObject: json){
                    let responseData = try! JSONDecoder().decode([String: [Match]].self, from: jsonData)
                    // Access the matches array
                    if let matches = responseData["results"] {
                        self.matchListCopy = matches
                        self.updateMatchList(.upcoming)
                    }
                    self.isLoading = false
                }
            }
        }
    }
    
    func updateMatchList(_ newValue: MatchType) {
        isLoading = true
        // Update the list based on the selected match type
        switch newValue {
        case .live: // Live matches
            matchList = matchListCopy.filter{ $0.status == "Live" }
        case .upcoming: // Upcoming matches
            matchList = matchListCopy.filter { $0.status == "Fixture" }
        case .completed: // Completed matches
            matchList = matchListCopy.filter { $0.status == "Complete" }
        }
        isLoading = false
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


enum MatchType : CaseIterable {
    case live
    case upcoming
    case completed
    
    var statusString: String {
        switch self {
        case .live:
            return "Live"
        case .upcoming:
            return "Fixture"
        case .completed:
            return "Complete"
        }
    }
    var statusName: String {
        switch self {
        case .live:
            return "Live"
        case .upcoming:
            return "Upcoming"
        case .completed:
            return "Complete"
        }
    }
}
