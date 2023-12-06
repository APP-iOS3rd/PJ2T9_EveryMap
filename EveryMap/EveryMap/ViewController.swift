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
        
        view.backgroundColor = .blue
        var mapView = TMapView(frame: self.view.frame)
        self.view.addSubview(mapView)
    }


}

