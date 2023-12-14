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
    
    private init() {}
    
    // MARK: - TMap 경로탐색 API
    func loadTMapRoute(startX: CLLocationDegrees, startY: CLLocationDegrees, endX: CLLocationDegrees, endY: CLLocationDegrees, searchOption: String, completion: @escaping (Properties?) -> Void) {
        //총 거리, 총 시간, 총 요금, 예상 택시 요금 담아서 return 해줄 변수
        var routeData: Properties?
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard var tmapUrl = URL(string: "https://apis.openapi.sk.com/tmap/routes"), let tmapAppKey = Bundle.main.TmapApiKey else {
            completion(nil)
            return
        }
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
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil, let data = data {
                let result = try? JSONDecoder().decode(TMapRoute.self, from: data)
                routeData = result?.features[0].properties
            }
            
            // 비동기 작업 완료 후 completion 클로저를 호출하여 결과를 전달
            completion(routeData)
        }
        task.resume()
        
        session.finishTasksAndInvalidate()
    }
    
    // MARK: - NMap 경로탐색 API
    func loadNMapRoute(startX: CLLocationDegrees, startY: CLLocationDegrees, endX: CLLocationDegrees, endY: CLLocationDegrees, searchOption: String, completion: @escaping (Route?) -> Void) {
        var routeData: Route?
        
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard var nmapUrl = URL(string: "https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving") else {
            completion(nil)
            return
        }
        
        let URLParams = [
            "start": "\(startX),\(startY)",
            "goal": "\(endX),\(endY)",
            "option": "\(searchOption)",
        ]
        nmapUrl = nmapUrl.appendingQueryParameters(URLParams)
        var request = URLRequest(url: nmapUrl)
        request.httpMethod = "GET"
        
        // Headers
        guard let nmapClientId = Bundle.main.NavermapClientId, let nmapClientSecret = Bundle.main.NavermapClientSecret else {
            completion(nil)
            return
        }
        request.addValue(nmapClientId, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.addValue(nmapClientSecret, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        
        /* Start a new Task */
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error == nil, let data = data {
                let result = try? JSONDecoder().decode(NMapRoute.self, from: data)
                routeData = result?.route
            } else {
                // 에러 처리 등을 수행
                print("URL Session Task Failed: %@", error!.localizedDescription)
            }
            
            // 비동기 작업 완료 후 completion 클로저를 호출하여 결과를 전달
            completion(routeData)
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    // MARK: - 주소 검색 API
    func loadSearchAddressResult(goalAddress : String, completion: @escaping (NMapAddressSearchModel?) -> Void) {
        var addressdata : NMapAddressSearchModel?
        
        let sessionConfig = URLSessionConfiguration.default
        
        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard var URL = URL(string: "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode") else { return }
        let URLParams = [
            "query": goalAddress,
        ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        // Headers
        guard let nmapClientId = Bundle.main.NavermapClientId, let nmapClientSecret = Bundle.main.NavermapClientSecret else { return }
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
                addressdata = result
                completion(addressdata)
            } catch {
                print("JSON 디코딩 에러 : \(error)")
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    // MARK: - 지역 검색 API
    func loadSearchPlaceResult(placeAddress : String, completion: @escaping (SearchPlaceModel?) -> Void) {
        var placedata : SearchPlaceModel?
        
        let sessionConfig = URLSessionConfiguration.default
        
        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard var URL = URL(string: "https://openapi.naver.com/v1/search/local.json") else { 
            print("URL 에러 발생")
            completion(nil)
            return }
        let URLParams = [
            "query": placeAddress,
            "display": "5",
            "sort": "random",
        ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        // Headers
        guard let nmapClientId = Bundle.main.NaversearchClientId, let nmapClientSecret = Bundle.main.NaversearchClientSecret else { 
            print("id, secret 에러 발생")
            completion(nil)
            return }
        request.addValue(nmapClientId, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(nmapClientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        /* Start a new Task */
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("에러발생.")
                return
            }
            do {
                let result = try JSONDecoder().decode(SearchPlaceModel.self, from: data)
                placedata = result
                completion(placedata)
            } catch {
                print("JSON 디코딩 에러 : \(error)")
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    // MARK: - 좌표값 기준 주소명 검색 API
    func loadAddressResult(lat: Double, lng: Double, completion: @escaping (Region?) -> Void) {
        var region : Region?
        
        let sessionConfig = URLSessionConfiguration.default
        
        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard var URL = URL(string: "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc") else { 
            print("URL 에러 발생")
            completion(nil)
            return }
        let URLParams = [
            "coords": "\(lng),\(lat)",
            "output": "json",
        ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        // Headers
        guard let nmapClientId = Bundle.main.NavermapClientId, let nmapClientSecret = Bundle.main.NavermapClientSecret else { return }
        request.addValue(nmapClientId, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.addValue(nmapClientSecret, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        
        /* Start a new Task */
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("에러발생.")
                return
            }
            do {
                let result = try JSONDecoder().decode(ReverseGeoModel.self, from: data)
                region = result.results?.first?.region
                completion(region)
            } catch {
                print("JSON 디코딩 에러 : \(error)")
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
}

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

