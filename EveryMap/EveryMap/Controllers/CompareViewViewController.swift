//
//  CompareViewViewController.swift
//  EveryMap
//
//  Created by Taejun Ha on 12/11/23.
//

import Foundation
import CoreLocation
import UIKit

class CompareViewViewController {
    private let compareView: CompareView
    
    private var routeData = [RouteDataModel]()
    
    private let tmapSearchOption = ["0", "1", "2"] //0: 추천, 1: 무료, 2: 최소시간
    private let nmapSearchOption = ["traoptimal", "traavoidtoll", "trafast"] //traoptimal: 추천, traavoidtoll: 무료, trafast: 최소시간
    
    init(compareView: CompareView, startX: CLLocationDegrees, startY: CLLocationDegrees, endX: CLLocationDegrees, endY: CLLocationDegrees) {
        self.compareView = compareView
        print("CompareViewViewController - init() called")
        loadRouteData(startX: startX, startY: startY, endX: endX, endY: endY) {
            print("All API requests completed!")
            // 여기에서 필요한 작업 수행
            // 예: UI 업데이트, 결과 처리 등
            compareView.routeDataTableView.reloadData()
        }
    }
}

extension CompareViewViewController {
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

extension CompareViewViewController {
    func getAMPMString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a"
        let currentTimeOfDay = dateFormatter.string(from: Date())
        
        return currentTimeOfDay
    }
    
    func currentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let currentTime = Date()
        let formattedCurrentTime = dateFormatter.string(from: currentTime)
        
        return formattedCurrentTime
    }
}

extension CompareViewViewController {
    func getData() -> [RouteDataModel] {
        return routeData
    }
    
    func getIndexData(index: Int) -> RouteDataModel {
        return routeData[index]
    }
    
    func getIndexOptimalRouteData(index: Int) -> RouteDataModel {
        return routeData.filter{ $0.searchOption == .Optimal }[index]
    }
    
    func getIndexFastRouteData(index: Int) -> RouteDataModel {
        return routeData.filter{ $0.searchOption == .Fast }[index]
    }
    
    func getIndexAvoidtollRouteData(index: Int) -> RouteDataModel {
        return routeData.filter{ $0.searchOption == .AvoidToll }[index]
    }
    
    func getAllDataCount() -> Int {
        return routeData.count
    }
    
    func getOptimalDataCount() -> Int {
        return routeData.filter{ $0.searchOption == .Optimal }.count
    }
    
    func getFastDataCount() -> Int {
        return routeData.filter{ $0.searchOption == .Fast }.count
    }
    
    func getAvoidtallDataCount() -> Int {
        return routeData.filter{ $0.searchOption == .AvoidToll }.count
    }
}

extension CompareViewViewController {
    // MARK: - Naver 길찾기
    func showNaverMap(startX: CLLocationDegrees, startY: CLLocationDegrees, endX: CLLocationDegrees, endY: CLLocationDegrees) {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return }
        // 자동차 길찾기 + 도착지 좌표 + 앱 번들 id
      
        guard let url = URL(string: "nmap://route/car?slat=\(startY)&slng=\(startX)&dlat=\(endY)&dlng=\(endX)&appname=\(bundleIdentifier)") else { return }
        
        // 네이버지도 앱스토어 url
        guard let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8") else { return }
        
        // 네이버지도 앱이 존재 한다면,
        if UIApplication.shared.canOpenURL(url) {
            // 길찾기 open
            UIApplication.shared.open(url)
        } else { // 네이버지도 앱이 없다면,
            // 네이버지도 앱 설치 앱스토어로 이동
            UIApplication.shared.open(appStoreURL)
        }
    }
    
    // MARK: - TMap 길찾기
    func showTMap(startX: CLLocationDegrees, startY: CLLocationDegrees, endX: CLLocationDegrees, endY: CLLocationDegrees) {
        // 도착지 이름 + 도착지 좌표
        let urlStr = "tmap://route?rStx=\(startX)&rSty=\(startY)&rGoX=\(endX)&rGoY=\(endY)"
        
        // url에 한글이 들어가있기 때문에 인코딩을 따로 해줘야함
        guard let encodedStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: encodedStr) else { return }
        
        // tmap 앱스토어 url
        guard let appStoreURL = URL(string: "http://itunes.apple.com/app/id431589174") else { return }

        // tmap 앱이 있다면,
        if UIApplication.shared.canOpenURL(url) {
            // 길찾기 open
            UIApplication.shared.open(url)
        } else { // tmap 앱이 없다면,
            // tmap 설치 앱스토어로 이동
            UIApplication.shared.open(appStoreURL)
        }
    }
    
    // MARK: - 카카오 길찾기
    func showKakaoMap(startX: CLLocationDegrees, startY: CLLocationDegrees, endX: CLLocationDegrees, endY: CLLocationDegrees) {
        // 도착지 좌표 + 자동차 길찾기
        guard let url = URL(string: "kakaomap://route?sp=\(startX),\(startY)&ep=\(endY),\(endX)&by=CAR") else { return }
        // 카카오맵 앱스토어 url
        guard let appStoreUrl = URL(string: "itms-apps://itunes.apple.com/app/id304608425") else { return }
        let urlString = "kakaomap://open"

        if let appUrl = URL(string: urlString) {
            // 카카오맵 앱이 존재한다면,
            if UIApplication.shared.canOpenURL(appUrl) {
                // 길찾기 open
                UIApplication.shared.open(url)
            } else { // 카카오맵 앱이 없다면,
                // 카카오맵 앱 설치 앱스토어로 이동
                UIApplication.shared.open(appStoreUrl)
            }
        }
    }
}
