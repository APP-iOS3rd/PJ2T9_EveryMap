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
    
    // Apikey 인증 성공 시 호출된다.
    func SKTMapApikeySucceed() {
        print("APIKEY 인증 성공")
    }
    
    // Apikey 인증 실패 시 호출된다.
    func SKTMapApikeyFailed(error: NSError?) {
        print("APIKEY 인증 실패....")
    }
    
}
