//
//  ResultMapView.swift
//  EveryMap
//
//  Created by Taejun Ha on 12/11/23.
//

import UIKit
import NMapsMap

class ResultMapView: UIViewController, UISearchBarDelegate {
    
    var address : Address?
    
    let destination : PaddingLabel = {
        let label = PaddingLabel()
        label.textAlignment = .left
        label.topPadding = 15
        label.leftPadding = 25
        label.bottomPadding = 15
        label.font = .systemFont(ofSize: 18)
        label.backgroundColor = .gray
        label.layer.cornerRadius = 15
//        label.layer.shadowOpacity = 0.3
//        label.layer.shadowOffset = CGSize(width: 3, height: 3)
        label.layer.masksToBounds = true
        return label
    }()
    
    let mainMapView : NMFNaverMapView = {
        let naverMapView = NMFNaverMapView()
        naverMapView.showLocationButton = true
        naverMapView.mapView.positionMode = .normal
        naverMapView.isHidden = false
        return naverMapView
    }()
    
    let completeBtn : UIButton = {
       let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = #colorLiteral(red: 0.1647058824, green: 0.6, blue: 1, alpha: 1)
        config.cornerStyle = .dynamic
        config.buttonSize = .large
        btn.configuration = config
        btn.layer.shadowRadius = 5
        btn.layer.shadowOffset = CGSize(width: 3, height: 3)
        btn.layer.shadowOpacity = 0.3
//        btn.backgroundColor = #colorLiteral(red: 0.1647058824, green: 0.6, blue: 1, alpha: 1)
        btn.setAttributedTitle(NSAttributedString(string: "이 장소가 맞나요? 가장 빠른 경로 확인하기!",
                                                  attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]), for: .normal)
//        btn.layoutMargins = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
//        btn.setTitleColor(.white, for: .normal)
//        btn.layer.cornerRadius = 8
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

extension ResultMapView {
    func setUI() {
        self.view.backgroundColor = .systemBackground
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        self.view.addSubviews(destination,completeBtn)
        destination.text = address?.roadAddress
        
        NSLayoutConstraint.activate([
            destination.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            destination.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            destination.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            destination.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            // completeBtn
            completeBtn.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            completeBtn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            completeBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}
