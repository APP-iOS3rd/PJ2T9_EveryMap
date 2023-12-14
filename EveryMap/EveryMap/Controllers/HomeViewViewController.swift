//
//  HomeViewViewController.swift
//  EveryMap
//
//  Created by 이성현 on 2023/12/07.
//

import Foundation
import TMapSDK

class HomeViewViewController : TMapTapiDelegate{
    
    init() { 
        TMapApi.setSKTMapAuthenticationWithDelegate(self, apiKey: Bundle.main.TmapApiKey!)
    }
    
}
