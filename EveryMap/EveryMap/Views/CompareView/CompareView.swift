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
    
    let currentLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textAlignment = .left
        label.topPadding = 10
        label.leftPadding = 25
        label.bottomPadding = 10
        label.font = .systemFont(ofSize: 15)
        label.backgroundColor = #colorLiteral(red: 0.949, green: 0.949, blue: 0.949, alpha: 1.0)
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        return label
    }()
    
    let destinationLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textAlignment = .left
        label.topPadding = 10
        label.leftPadding = 25
        label.bottomPadding = 10
        label.font = .systemFont(ofSize: 15)
        label.backgroundColor = #colorLiteral(red: 0.949, green: 0.949, blue: 0.949, alpha: 1.0)
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        return label
    }()


    let startTimeLabel = {
        let label = PaddingLabel()
        label.backgroundColor = .white
        label.font = .systemFont(ofSize: 20)
        label.textColor = .lightGray
        return label
    }()
    
    let routeOptionButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.adjustsFontForContentSizeCategory = true
        btn.setTitle("전체", for: .normal)
        btn.setImage(UIImage(systemName: "chevron.compact.down"), for: .normal)
        btn.tintColor = .lightGray
        btn.backgroundColor = .white
        btn.titleLabel?.font = .systemFont(ofSize: 20)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.semanticContentAttribute = .forceRightToLeft
        return btn
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
        
        setUI(currentAddress: currentAddress, destinationAddress: end.roadAddress)
        
    }
}

extension CompareView {
    private func setUI(currentAddress: String, destinationAddress: String){
        self.view.backgroundColor = .white
        self.view.addSubviews(currentLabel, destinationLabel, startTimeLabel, routeOptionButton)
        
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
        startTimeLabel.text = "오늘 \(compareviewVC.getAMPMString()) \(compareviewVC.currentTime()) 출발"
        
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
            routeOptionButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
        ])
    }
}
