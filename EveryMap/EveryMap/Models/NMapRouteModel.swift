//
//  NaverMapRouteModel.swift
//  EveryMap
//
//  Created by Taejun Ha on 12/11/23.
//

//NMap API 경로탐색 DataModel

import Foundation

// MARK: - Post
struct NMapRoute: Codable {
    let code: Int
    let message: String
    let currentDateTime: String
    let route: Route
}

// MARK: - Route
struct Route: Codable {
    let traoptimal: [Traoptimal]
}

// MARK: - Traoptimal
struct Traoptimal: Codable {
    let properties: Summary
    
    enum CodingKeys: String, CodingKey {
        case properties = "summary"
    }
}


// MARK: - Summary
struct Summary: Codable {
    let totalDistance: Int //총 거리 : totalDistance/1000 km
    let totalTime: Int //총 시간  
    let totalFare: Int //총 요금
    let taxiFare: Int //예상 택시 요금
    
    enum CodingKeys: String, CodingKey {
        case totalDistance = "distance"
        case totalTime = "duration"
        case totalFare = "tollFare"
        case taxiFare
    }
}

// MARK: - Goal
struct Goal: Codable {
    let location: [Double]
    let dir: Int
}

// MARK: - Start
struct Start: Codable {
    let location: [Double]
}
