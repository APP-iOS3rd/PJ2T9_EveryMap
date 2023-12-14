//
//  ResultMapView.swift
//  EveryMap
//
//  Created by Taejun Ha on 12/11/23.
//

import UIKit
import NMapsMap

class ResultMapView: UIViewController, UISearchBarDelegate {
    
    var searchAddress : Address?
    var searchPlace : Item?
    var currentAddress : String?
    var startLocation : StartLocationModel?
    
    let destination : PaddingLabel = {
        let label = PaddingLabel()
        label.textAlignment = .left
        label.topPadding = 10
        label.leftPadding = 25
        label.bottomPadding = 10
        label.font = .systemFont(ofSize: 15)
        label.backgroundColor = .g1
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        return label
    }()
    
    let mainMapView : NMFNaverMapView = {
        let naverMapView = NMFNaverMapView()
        naverMapView.showLocationButton = true
        naverMapView.showZoomControls = false
        naverMapView.mapView.positionMode = .normal
        
        return naverMapView
    }()
    
    let completeBtn : UIButton = {
       let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .b1
        config.cornerStyle = .dynamic
        config.buttonSize = .large
        btn.configuration = config
        btn.layer.shadowRadius = 5
        btn.layer.shadowOffset = CGSize(width: 3, height: 3)
        btn.layer.shadowOpacity = 0.3
        btn.setAttributedTitle(NSAttributedString(string: "이 장소가 맞나요? 가장 빠른 경로 확인하기!",
                                                  attributes: [NSAttributedString.Key.font : UIFont.b4]), for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setMapview()
    }
}

// MARK: - UI & Layout

extension ResultMapView {
    func setUI() {
        self.view.backgroundColor = .systemBackground
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        self.view.addSubviews(destination, mainMapView, completeBtn)
        if let address = searchAddress {
            print("ResultMapView - Address called")
            destination.text = address.roadAddress
        } else {
            if let address = searchPlace {
                print("ResultMapView - Place called")
                destination.text = address.title.clearStr()
            }
        }
        
        completeBtn.addTarget(self, action: #selector(pushCompareView), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            destination.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            destination.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -15),
            destination.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            destination.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            mainMapView.topAnchor.constraint(equalTo: destination.bottomAnchor, constant: 10),
            mainMapView.bottomAnchor.constraint(equalTo: completeBtn.topAnchor, constant: -10),
            mainMapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainMapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            // completeBtn
            completeBtn.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            completeBtn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            completeBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    func setMapview(){
        print("ResultMapView - setMapview() called")
        if let address = searchAddress {
            let lat = Double(address.y)
            let lng = Double(address.x)
            cameraUpdate(lat: lat ?? 0.0, lng: lng ?? 0.0)
            markerUpdate(lat: lat ?? 0.0, lng: lng ?? 0.0)
        } else {
            if let address = searchPlace {
                var mapx = String(Int(Double(address.mapx)!)).map{ String($0) }
                var mapy = String(Int(Double(address.mapy)!)).map{ String($0) }
                mapx.insert(".", at: 3)
                mapy.insert(".", at: 2)
                let lat = Double(mapy.joined())
                let lng = Double(mapx.joined())
                cameraUpdate(lat: lat ?? 0.0, lng: lng ?? 0.0)
                markerUpdate(lat: lat ?? 0.0, lng: lng ?? 0.0)
            }
        }
    }
    
    
}

// MARK: - Methods

extension ResultMapView {
    @objc private func pushCompareView() {
//        let vc = CompareView()
//        vc.addressmodel = addressmodel
//        vc.currentAddress = currentAddress
//        vc.startLocation = startLocation
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func cameraUpdate(lat: Double, lng: Double) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng), zoomTo: 14)
        self.mainMapView.mapView.moveCamera(cameraUpdate)
    }
    
    func markerUpdate(lat: Double, lng: Double) {
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: lat, lng: lng)
        marker.mapView = mainMapView.mapView
    }
}

// MARK: - ViewWillAppear

extension ResultMapView {
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
}
