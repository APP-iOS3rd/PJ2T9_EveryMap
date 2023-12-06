//
//  ViewController.swift
//  EveryMap
//
//  Created by 이성현 on 2023/12/06.
//

import UIKit
import TMapSDK

class ViewController: UIViewController, TMapTapiDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let mapView = TMapView(frame: self.view.frame)
        self.view.addSubview(mapView)
        mapView.setApiKey(Bundle.main.TmapApiKey!)
        
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

