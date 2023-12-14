//
//  CompareView.swift
//  EveryMap
//
//  Created by Taejun Ha on 12/11/23.
//

import UIKit

class CompareView: UIViewController {

    private var compareviewViewController: CompareViewViewController?
    
    var addressmodel : Address?
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
    
    private let routeOptionButton: UIButton = {
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
    
    let listChange: (UIButton, String) -> Void = {(btn: UIButton, title: String) in
 
        if title == "전체" {
            btn.setTitle(title, for: .normal)
            
        } else if title == "추천순" {
            btn.setTitle(title, for: .normal)

        } else if title == "최단 시간순" {
            btn.setTitle(title, for: .normal)

        } else { // 무료순
            btn.setTitle(title, for: .normal)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let start = startLocation, let end = addressmodel, let currentAddress = currentAddress else { return }
        compareviewViewController = CompareViewViewController(compareView: self, startX: start.lng, startY: start.lat, endX: Double(end.x)!, endY: Double(end.y)!)
        
        routeDataTableView.register(CompareViewTableViewCell.self, forCellReuseIdentifier: CompareViewTableViewCell.cellId)
        routeDataTableView.dataSource = self
        routeDataTableView.delegate = self
        
        setUI(currentAddress: currentAddress, destinationAddress: end.roadAddress)
        
    }
}

extension CompareView {
    private func setUI(currentAddress: String, destinationAddress: String){
        self.view.backgroundColor = .white
        self.view.addSubviews(currentLabel, destinationLabel, startTimeLabel, routeOptionButton, routeDataTableView)
        
        routeOptionButton.menu = UIMenu(title: "목록", children: [
            UIAction(title: "전체"){ _ in
                self.listChange(self.routeOptionButton, "전체")
            },
            UIAction(title: "추천순") { _ in
                self.listChange(self.routeOptionButton, "추천순")
            },
            UIAction(title: "최단 시간순") { _ in
                self.listChange(self.routeOptionButton, "최단 시간순")
            },
            UIAction(title: "무료순") { _ in
                self.listChange(self.routeOptionButton, "무료순")
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
        ])
    }
}

extension CompareView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compareviewViewController?.getData().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = routeDataTableView.dequeueReusableCell(withIdentifier: CompareViewTableViewCell.cellId, for: indexPath) as! CompareViewTableViewCell
        
        cell.backgroundColor = .systemBackground
        
        guard let data = compareviewViewController?.getIndexData(index: indexPath.row) else {return cell}
        cell.totalTimeLabel.text = data.totalTime
        cell.futureTimeLabel.text = "\(compareviewViewController?.getAMPMString() == "AM" ? "오전" : "오후")" + " " + (data.futureTime)
    
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
    
}
