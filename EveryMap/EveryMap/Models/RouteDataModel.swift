//
//  RouteDataModel.swift
//  EveryMap
//
//  Created by Taejun Ha on 12/14/23.
//

import Foundation
import CoreLocation

class RouteDataModel {
    let mapName: MapName // Naver, TMap 구분
    let startX, startY: CLLocationDegrees // 출발 위치
    let endX, endY: CLLocationDegrees // 도착 위치
    let searchOption: SearchOption // 경로 탐색 옵션
    let totalDistance: String // 총 거리km
    let futureTime: String // 도착 시간
    let totalTime: String // 현재 시간
    let totalFare: String // 총 요금
    let taxiFare: String // 예상 택시 요금
    
    init(mapName: MapName, startX: CLLocationDegrees, startY: CLLocationDegrees, endX: CLLocationDegrees, endY: CLLocationDegrees, searchOption: SearchOption, totalDistance: Int, totalTime: Int, totalFare: Int, taxiFare: Int) {
        self.mapName = mapName
        self.startX = startX
        self.startY = startY
        self.endX = endX
        self.endY = endY
        self.searchOption = searchOption
        self.totalDistance = "\(totalDistance/1000)km"
        
        switch mapName {
        case .NaverMap:
            self.futureTime = RouteDataModel.calculateFutureTime(fromNow: Double(totalTime)/1000.0)
            self.totalTime = "\(totalTime/1000/60/60)시간 \(totalTime/1000/60%60)분"
        case .TMap:
            self.futureTime = RouteDataModel.calculateFutureTime(fromNow: Double(totalTime))
            self.totalTime = "\(totalTime/60/60)시간 \(totalTime/60%60)분"
        }
        
        self.totalFare = "\(String(describing: RouteDataModel.formatNumberWithComma(totalFare as NSNumber)))원"
        self.taxiFare = "\(String(describing: RouteDataModel.formatNumberWithComma(taxiFare as NSNumber)))원"
    }
    
    private static func calculateFutureTime(fromNow secondsToAdd: TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let currentTime = Date()
        let futureTime = currentTime.addingTimeInterval(secondsToAdd)
        
        let formattedFutureTime = dateFormatter.string(from: futureTime)
        
        return formattedFutureTime
    }
    
    private static func formatNumberWithComma(_ number: NSNumber) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: number)
    }
}
