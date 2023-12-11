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
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
}
