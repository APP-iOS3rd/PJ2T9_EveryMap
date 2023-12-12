//
//  HomeViewController.swift
//  EveryMap
//
//  Created by 이성현 on 2023/12/07.
//

import UIKit
import TMapSDK

class HomeView: UIViewController {
    
    let homeviewController = HomeViewViewController()
    
    convenience init(title: String) {
        self.init()
        
        // 임시로 TMapView로 표현함
        let mapView = TMapView(frame: self.view.frame)
        self.view.addSubview(mapView)
        mapView.setApiKey(Bundle.main.TmapApiKey!)
        // title 있어도 되고 없어도 됨
        
        self.title = title
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
}

