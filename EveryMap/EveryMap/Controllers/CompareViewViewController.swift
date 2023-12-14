//
//  CompareViewViewController.swift
//  EveryMap
//
//  Created by Taejun Ha on 12/11/23.
//

import Foundation

class CompareViewViewController {
    private let compareView: CompareView
    
//    private var tmapRouteData = [Properties]()
//    private var nmapRouteData = [Route]()
    private var routeData = [RouteDataModel]()
    
    private let tmapSearchOption = ["0", "1", "2"] //0: 추천, 1: 무료, 2: 최소시간
    private let nmapSearchOption = ["traoptimal", "traavoidtoll", "trafast"] //traoptimal: 추천, traavoidtoll: 무료, trafast: 최소시간
    
    init(compareView: CompareView) {
        self.compareView = compareView
        print("CompareViewViewController - init() called")
        loadRouteData(startX: 126.928345, startY: 35.132873, endX: 126.9850380932383, endY: 37.566567545861645) { [weak self] in
            guard let self = self else { return }
            print("All API requests completed!")
            // 여기에서 필요한 작업 수행
            // 예: UI 업데이트, 결과 처리 등
        }
    }
    
    private func loadRouteData(startX: CLLocationDegrees, startY: CLLocationDegrees, endX: CLLocationDegrees, endY: CLLocationDegrees, completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        for index in 0..<3 {
            dispatchGroup.enter()
            
            APIManager.manager.loadTMapRoute(startX: startX, startY: startY, endX: endX, endY: endY, searchOption: tmapSearchOption[index]) { tRouteData in
                if let tRouteData = tRouteData {
                    //                    self.tmapRouteData.append(tRouteData)
                    self.routeData.append(RouteDataModel(mapName: .TMap, startX: startX, startY: startY, endX: endX, endY: endY, searchOption: SearchOption(rawValue: index)!.option, totalDistance: tRouteData.totalDistance, totalTime: tRouteData.totalTime, totalFare: tRouteData.totalFare, taxiFare: tRouteData.taxiFare))
                }
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            
            APIManager.manager.loadNMapRoute(startX: startX, startY: startY, endX: endX, endY: endY, searchOption: nmapSearchOption[index]) { nRouteData in
                if let nRouteData = nRouteData {
                    //                    self.nmapRouteData.append(nRouteData)
                    var distance = 0
                    var time = 0
                    var fare = 0
                    var taxiFare = 0
                    
                    if let data = nRouteData.trafast?.first?.properties ?? nRouteData.traoptimal?.first?.properties ?? nRouteData.traavoidtoll?.first?.properties {
                        distance = data.totalDistance
                        time = data.totalTime
                        fare = data.totalFare
                        taxiFare = data.taxiFare
                    }

                    
                    self.routeData.append(RouteDataModel(mapName: .NaverMap, startX: startX, startY: startY, endX: endX, endY: endY, searchOption: SearchOption(rawValue: index)!.option, totalDistance: distance, totalTime: time, totalFare: fare, taxiFare: taxiFare))
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            // 위의 그룹지어놓은 비동기 API 사용이 모두 끝나면 completion이 실행됨
            completion()
        }
    }
}

import CoreLocation

enum MapName {
    case NaverMap
    case TMap
}

enum SearchOption: Int, CaseIterable {
    case Fast
    case Optimal
    case AvoidToll
    
    var option: SearchOption {
        switch self {
        case .Fast: return .Fast // 빠른길
        case .Optimal: return .Optimal // 추천
        case .AvoidToll: return .AvoidToll // 무료
        }
    }
}

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
