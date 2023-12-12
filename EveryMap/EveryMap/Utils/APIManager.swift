//
//  APIManager.swift
//  EveryMap
//
//  Created by Taejun Ha on 12/12/23.
//

import Foundation
import CoreLocation

class APIManager {
    static let manager = APIManager()
    private var tmapRouteData: TMapRoute?
    private var nmapRouteData: NMapRoute?
    
    private init() {}
    
    func loadRouteData(startX: CLLocationDegrees, startY: CLLocationDegrees, endX: CLLocationDegrees, endY: CLLocationDegrees) {
        
    }
}
