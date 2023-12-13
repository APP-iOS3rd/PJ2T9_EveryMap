//
//  APIManager.swift
//  EveryMap
//
//  Created by Taejun Ha on 12/12/23.
//

import Foundation
import CoreLocation

final class APIManager {
    static let manager = APIManager()
    
//    private var tmapRouteData = [TMapRoute]()
//    private var nmapRouteData = [NMapRoute]()
//    
//    private let tmapSearchOption = ["0", "1", "2"] //0: 추천, 1: 무료, 2: 최소시간
//    private let nmapSearchOption = ["traoptimal", "traavoidtoll", "trafast"] //traoptimal: 추천, traavoidtoll: 무료, trafast: 최소시간
    
    private init() {}
    
    // MARK: - TMap 경로탐색 API
    func loadTMapRoute(startX: CLLocationDegrees, startY: CLLocationDegrees, endX: CLLocationDegrees, endY: CLLocationDegrees, searchOption: String) -> Properties? {
        //총 거리, 총 시간, 총 요금, 예상 택시 요금 담아서 return 해줄 변수
        var routeData: Properties?
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard var tmapUrl = URL(string: "https://apis.openapi.sk.com/tmap/routes"), let tmapAppKey = Bundle.main.TmapApiKey else {return nil}
        //TMap 경로탐색 Params
        let urlParams = [
            "version": "1",
            "format": "json",
            "callback": "result",
            "appKey": "\(tmapAppKey)",
            "startX": "\(startX)",
            "startY": "\(startY)",
            "endX": "\(endX)",
            "endY": "\(endY)",
            "searchOption": "\(searchOption)",
            "totalValue": "2",
            "tollgateFareInfo": "Y",
        ]
        
        tmapUrl = tmapUrl.appendingQueryParameters(urlParams)
        
        var request = URLRequest(url: tmapUrl)
        request.httpMethod = "POST"
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                guard let data = data, error == nil else { return }
                let result = try? JSONDecoder().decode(TMapRoute.self, from: data)
                routeData = result?.features[0].properties
                //                print(result)
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
        
        session.finishTasksAndInvalidate()
        
        return routeData
    }
    
    // MARK: - NMap 경로탐색 API
    func loadNMapRoute(startX: CLLocationDegrees, startY: CLLocationDegrees, endX: CLLocationDegrees, endY: CLLocationDegrees, searchOption: String) -> Route? {
        var routeData: Route?
        
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard var nmapUrl = URL(string: "https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving") else {return nil}
        let URLParams = [
            "start": "\(startX),\(startY)",
            "goal": "\(endX),\(endY)",
            "option": "\(searchOption)",
        ]
        nmapUrl = nmapUrl.appendingQueryParameters(URLParams)
        var request = URLRequest(url: nmapUrl)
        request.httpMethod = "GET"
        
        // Headers
        guard let nmapClientId = Bundle.main.NavermapClientId, let nmapClientSecret = Bundle.main.NavermapClientSecret else { return nil }
        request.addValue(nmapClientId, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.addValue(nmapClientSecret, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                guard let data = data, error == nil else { return }
                let result = try? JSONDecoder().decode(NMapRoute.self, from: data)
                routeData = result?.route
//                print(result)
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
        
        return routeData
    }
    
    func sendRequest(goalAddress : String) -> Address? {
        var addressdata : Address?
        
        let sessionConfig = URLSessionConfiguration.default
        
        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard var URL = URL(string: "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode") else { return nil }
        let URLParams = [
            "query": goalAddress,
        ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        // Headers
        guard let nmapClientId = Bundle.main.NavermapClientId, let nmapClientSecret = Bundle.main.NavermapClientSecret else { return nil }
        request.addValue(nmapClientId, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.addValue(nmapClientSecret, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        
        /* Start a new Task */
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("에러발생.")
                return
            }
            do {
                let result = try JSONDecoder().decode(NMapAddressSearchModel.self, from: data)
                print(result)
                addressdata = result.addresses?.first
            } catch {
                print("JSON 디코딩 에러 : \(error)")
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
        
        return addressdata
    }
}

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

