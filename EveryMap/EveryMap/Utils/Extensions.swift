//
//  Extensions.swift
//  EveryMap
//
//  Created by 이성현 on 2023/12/07.
//
import UIKit
import Foundation

// APIKEY 를 가져오기 위한 Bundle extension
extension Bundle {
    var TmapApiKey : String? {
        guard let file = self.path(forResource: "APIKEY-Info", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["Tmap-apikey"] as? String else { return nil }
        return key
    }
    
    var KakaomapApiKey : String? {
        guard let file = self.path(forResource: "APIKEY-Info", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["Kakaomap-apikey"] as? String else { return nil }
        return key
    }  
    
    var NavermapClientId : String? {
        guard let file = self.path(forResource: "APIKEY-Info", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["Navermap-clientid"] as? String else { return nil }
        return key
    }
    
    var NavermapClientSecret : String? {
        guard let file = self.path(forResource: "APIKEY-Info", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["Navermap-clientsecret"] as? String else { return nil }
        return key
    }
    
    var NaversearchClientId : String? {
        guard let file = self.path(forResource: "APIKEY-Info", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["Naversearch-clientId"] as? String else { return nil }
        return key
    }
    
    var NaversearchClientSecret : String? {
        guard let file = self.path(forResource: "APIKEY-Info", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["Naversearch-clientsecret"] as? String else { return nil }
        return key
    }
    
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
}

extension UINavigationController {
    func setupBarAppearance() {
           let appearance = UINavigationBarAppearance()
           navigationBar.isTranslucent = true
       }
}



// MARK: - 경로 탐색 API를 위한 extension들
extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}

extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new URL.
     */
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}

