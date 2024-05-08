//
//  MatchList.swift
//  CricTactix
//
//  Created by kintan on 04/05/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let matchList = try? JSONDecoder().decode(MatchList.self, from: jsonData)

import Foundation
struct Match: Codable {
    let id: Int
    let seriesId: Int
    let venue: String
    let date: String
    let status: String
    let result: String
    let matchTitle: String
    let matchSubtitle: String
    let home: Team
    let away: Team

    enum CodingKeys: String, CodingKey {
        case id
        case seriesId = "series_id"
        case venue
        case date
        case status
        case result
        case matchTitle = "match_title"
        case matchSubtitle = "match_subtitle"
        case home
        case away
    }
    
    func getMathDate() -> String{
        return date.toDate()?.toString() ?? ""
    }
}


struct Team: Codable {
    let id: Int
    let name: String
    let code: String
}
