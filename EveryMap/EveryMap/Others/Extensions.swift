//
//  Extensions.swift
//  EveryMap
//
//  Created by 이성현 on 2023/12/07.
//

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
}
