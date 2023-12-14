//
//  CompareViewViewController.swift
//  EveryMap
//
//  Created by Taejun Ha on 12/11/23.
//

import Foundation
import CoreLocation

class CompareViewViewController {
    private let compareView: CompareView
    
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
