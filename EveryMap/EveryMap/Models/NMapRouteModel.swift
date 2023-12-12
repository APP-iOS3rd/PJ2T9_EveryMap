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
    let summary: Summary
//    let path: [[Double]]
//    let section: [Section]
//    let guide: [Guide]
}

// MARK: - Guide
//struct Guide: Codable {
//    let pointIndex:Int
//    let type: Int
//    let instructions: String
//    let distance: Int
//    let duration: Int
//}

// MARK: - Section
//struct Section: Codable {
//    let pointIndex: Int
//    let pointCount: Int
//    let distance: Int
//    let name: String
//    let congestion: Int
//    let speed: Int
//}

// MARK: - Summary
struct Summary: Codable {
    let start: Start
    let goal: Goal
    let distance: Int
    let duration: Int
    let etaServiceType: Int
    let departureTime: String
    let bbox: [[Double]]
    let tollFare: Int
    let taxiFare: Int
    let fuelPrice: Int
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
