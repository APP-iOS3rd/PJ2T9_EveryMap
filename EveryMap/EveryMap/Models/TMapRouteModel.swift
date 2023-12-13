//
//  TMapRouteModel.swift
//  EveryMap
//
//  Created by Taejun Ha on 12/11/23.
//

import Foundation

//TMap API 경로탐색 DataModel

import Foundation

// MARK: - Post
struct TMapRoute: Codable {
//    let type: String
    let features: [Feature]
}

// MARK: - Feature
struct Feature: Codable {
//    let type: String
    let properties: Properties
}

// MARK: - Properties
struct Properties: Codable {
    let totalDistance: Int // 총 거리 : totalDistance/1000 km
    let totalTime: Int // 총 시간 : totalTime/60 분
    let totalFare: Int // 총 요금 : totalFare 원
    let taxiFare: Int // 예상 택시 요금 : taxiFare 원
}
