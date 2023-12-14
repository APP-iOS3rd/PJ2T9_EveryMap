//
//  CompareView.swift
//  EveryMap
//
//  Created by Taejun Ha on 12/11/23.
//

import UIKit
import CoreLocation

class CompareView: UIViewController {

    private var compareviewViewController: CompareViewViewController?
    
    var searchAddress : Address?
    var searchPlace : Item?
    var currentAddress : String?
    var startLocation : StartLocationModel?
    
    private let currentLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textAlignment = .left
        label.topPadding = 10
        label.leftPadding = 25
        label.bottomPadding = 10
        label.font = .b3
        label.backgroundColor = .g1
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        return label
    }()
    
    private let destinationLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textAlignment = .left
        label.topPadding = 10
        label.leftPadding = 25
        label.bottomPadding = 10
        label.font = .b3
        label.backgroundColor = .g1
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        return label
    }()


    private let startTimeLabel = {
        let label = PaddingLabel()
        label.backgroundColor = .white
        label.font = .b2
        label.textColor = .lightGray
        return label
    }()
    
    private var routeOptionButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.adjustsFontForContentSizeCategory = true
        btn.setTitle("전체", for: .normal)
        btn.setImage(UIImage(systemName: "chevron.compact.down"), for: .normal)
        btn.tintColor = .lightGray
        btn.backgroundColor = .white
        btn.titleLabel?.font = .b2
        btn.setTitleColor(.lightGray, for: .normal)
        btn.semanticContentAttribute = .forceRightToLeft
        return btn
    }()
    
    let routeDataTableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        return tableView
    }()
    
    let showKakaoBtn = {
        let btn = UIButton()
         var config = UIButton.Configuration.filled()
         config.baseBackgroundColor = #colorLiteral(red: 0.1647058824, green: 0.6, blue: 1, alpha: 1)
         config.cornerStyle = .dynamic
         config.buttonSize = .large
         btn.configuration = config
         btn.layer.shadowRadius = 5
         btn.layer.shadowOffset = CGSize(width: 3, height: 3)
         btn.layer.shadowOpacity = 0.3
         btn.setAttributedTitle(NSAttributedString(string: "카카오내비 결과 확인하기!",
                                                   attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]), for: .normal)
         return btn
    }()
    
    let listChange: (UIButton, String, UITableView) -> Void = {(btn: UIButton, title: String, routeDataTableView: UITableView) in
 
        if title == "전체" { btn.setTitle(title, for: .normal) } 
        else if title == "추천순" { btn.setTitle(title, for: .normal) }
        else if title == "최단 시간순" { btn.setTitle(title, for: .normal) }
        else { btn.setTitle(title, for: .normal) } // 무료순
    
        routeDataTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routeDataTableView.register(CompareViewTableViewCell.self, forCellReuseIdentifier: CompareViewTableViewCell.cellId)
        routeDataTableView.dataSource = self
        routeDataTableView.delegate = self
        
        guard let start = startLocation/*, let end = searchAddress*/, let currentAddress = currentAddress else { return }
        
        if let end = searchAddress {
            compareviewViewController = CompareViewViewController(compareView: self, startX: start.lng, startY: start.lat, endX: Double(end.x)!, endY: Double(end.y)!)
            setUI(currentAddress: currentAddress, destinationAddress: end.roadAddress)
            print(end.x)
            print(end.y)
        } else if let end = searchPlace {
            var mapx = String(Int(Double(end.mapx)!)).map{ String($0) }
            var mapy = String(Int(Double(end.mapy)!)).map{ String($0) }
            mapx.insert(".", at: 3)
            mapy.insert(".", at: 2)
            guard let lat = Double(mapy.joined()),let lng = Double(mapx.joined()) else {return}
            
            compareviewViewController = CompareViewViewController(compareView: self, startX: start.lng, startY: start.lat, endX: lng, endY: lat)
            setUI(currentAddress: currentAddress, destinationAddress: end.roadAddress)
            print(lat)
            print(lng)
        }
        
        showKakaoBtn.addTarget(self, action: #selector(showKakaoNavi), for: .touchUpInside)
    }
}

extension CompareView {
    private func setUI(currentAddress: String, destinationAddress: String){
        self.view.backgroundColor = .white
        self.view.addSubviews(currentLabel, destinationLabel, startTimeLabel, routeOptionButton, routeDataTableView, showKakaoBtn)
        
        routeOptionButton.menu = UIMenu(title: "목록", children: [
            UIAction(title: "전체"){ _ in
                self.listChange(self.routeOptionButton, "전체", self.routeDataTableView)
            },
            UIAction(title: "추천순") { _ in
                self.listChange(self.routeOptionButton, "추천순", self.routeDataTableView)
            },
            UIAction(title: "최단 시간순") { _ in
                self.listChange(self.routeOptionButton, "최단 시간순", self.routeDataTableView)
            },
            UIAction(title: "무료순") { _ in
                self.listChange(self.routeOptionButton, "무료순", self.routeDataTableView)
            }
        ])
        routeOptionButton.showsMenuAsPrimaryAction = true
        
        currentLabel.text = currentAddress
        destinationLabel.text = destinationAddress
        
        guard let compareviewVC = compareviewViewController else {return}
        startTimeLabel.text = "오늘 \(compareviewVC.getAMPMString() == "AM" ? "오전" : "오후") \(compareviewVC.currentTime()) 출발"
        
        NSLayoutConstraint.activate([
            //currentLabel
            currentLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -15),
            currentLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            currentLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            currentLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            
            //destinationLabel
            destinationLabel.topAnchor.constraint(equalTo: currentLabel.bottomAnchor, constant: 10),
            destinationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            destinationLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            destinationLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            //selectionViewLabel
            startTimeLabel.topAnchor.constraint(equalTo: destinationLabel.bottomAnchor, constant: 20),
            startTimeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            
            //routeOptionButton
            routeOptionButton.topAnchor.constraint(equalTo: startTimeLabel.topAnchor),
            routeOptionButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            
            //routeDataTableView
            routeDataTableView.topAnchor.constraint(equalTo: startTimeLabel.bottomAnchor, constant: 20),
            routeDataTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            routeDataTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            routeDataTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            showKakaoBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            showKakaoBtn.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            showKakaoBtn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
        ])
    }
}

extension CompareView {
    @objc private func showKakaoNavi() {
        guard let compareviewVC = self.compareviewViewController, let start = self.startLocation else {return}
        
        if let end = self.searchAddress {
            compareviewVC.showKakaoMap(startX: start.lat, startY: start.lng, endX: Double(end.x)!, endY: Double(end.y)!)
        } else if let end = self.searchPlace {
            var mapx = String(Int(Double(end.mapx)!)).map{ String($0) }
            var mapy = String(Int(Double(end.mapy)!)).map{ String($0) }
            mapx.insert(".", at: 3)
            mapy.insert(".", at: 2)
            guard let lat = Double(mapy.joined()),let lng = Double(mapx.joined()) else {return}
            
            compareviewVC.showKakaoMap(startX: start.lat, startY: start.lng, endX: lng, endY: lat)
        }
    }
}

extension CompareView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.routeOptionButton.titleLabel?.text {
        case "추천순":
            return compareviewViewController?.getOptimalDataCount() ?? 0
        case "최단 시간순":
            return compareviewViewController?.getFastDataCount() ?? 0
        case "무료순":
            return compareviewViewController?.getAvoidtallDataCount() ?? 0
        default: return compareviewViewController?.getAllDataCount() ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = routeDataTableView.dequeueReusableCell(withIdentifier: CompareViewTableViewCell.cellId, for: indexPath) as! CompareViewTableViewCell
        
        cell.backgroundColor = .systemBackground
 
        guard let data = {
            switch self.routeOptionButton.titleLabel?.text {
            case "추천순": return self.compareviewViewController?.getIndexOptimalRouteData(index: indexPath.row)
            case "최단 시간순": return self.compareviewViewController?.getIndexFastRouteData(index: indexPath.row)
            case "무료순": return self.compareviewViewController?.getIndexAvoidtollRouteData(index: indexPath.row)
            default: return self.compareviewViewController?.getIndexData(index: indexPath.row)
            }
        }() else {return cell}
        
        
        cell.totalTimeLabel.text = data.totalTime
        cell.futureTimeLabel.text = "\(data.futureTime)"
    
        var option = ""
        switch data.searchOption {
        case .Fast: option = "최소시간"
        case .AvoidToll: option = "무료도로 우선"
        case .Optimal: option = "추천"
        }
        cell.searchOptionLabel.text = option
        
        cell.distanceAndFareLabel.text = "\(data.totalDistance) ￨ \(data.totalFare)"
        
        switch data.mapName {
        case .NaverMap:
            cell.mapImage.image = UIImage(named: "NaverMapIcon")
            cell.mapNameLabel.text = "Naver"
        case .TMap:
            cell.mapImage.image = UIImage(named: "TMapIcon")
            cell.mapNameLabel.text = "T Map"
        }
        
        return cell
    }
}

extension CompareView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = {
            switch self.routeOptionButton.titleLabel?.text {
            case "추천순": return self.compareviewViewController?.getIndexOptimalRouteData(index: indexPath.row)
            case "최단 시간순": return self.compareviewViewController?.getIndexFastRouteData(index: indexPath.row)
            case "무료순": return self.compareviewViewController?.getIndexAvoidtollRouteData(index: indexPath.row)
            default: return self.compareviewViewController?.getIndexData(index: indexPath.row)
            }
        }() else {return}
        
        switch data.mapName {
        case .NaverMap: self.compareviewViewController?.showNaverMap(startX: data.startX, startY: data.startY, endX: data.endX, endY: data.endY)
        case .TMap: self.compareviewViewController?.showTMap(startX: data.startX, startY: data.startY, endX: data.endX, endY: data.endY)
        }
    }
}
