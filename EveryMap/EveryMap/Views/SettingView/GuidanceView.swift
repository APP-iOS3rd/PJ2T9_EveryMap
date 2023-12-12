//
//  GuidanceView.swift
//  EveryMap
//
//  Created by Taejun Ha on 12/12/23.
//

import UIKit

class GuidanceView: UIViewController {

    private let guidanceTitle = {
        let label = PaddingLabel()
        label.backgroundColor = .white
        label.topPadding = 30
        label.leftPadding = 12
        label.bottomPadding = 30
        label.text = "도움말 및 지원"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 32)
        return label
    }()
    
    private let guidanceHelpTitle = {
        let label = PaddingLabel()
        label.backgroundColor = .white
        label.topPadding = 30
        label.leftPadding = 15
        label.bottomPadding = 15
        label.text = "도움말"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let guidanceSupportTitle = {
        let label = PaddingLabel()
        label.backgroundColor = .white
        label.topPadding = 30
        label.leftPadding = 15
        label.bottomPadding = 15
        label.text = "지원"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let guidanceHelpDescription = {
        let label = PaddingLabel()
        label.backgroundColor = .white
        label.leftPadding = 18
        label.bottomPadding = 30
        label.text = "EveryMap의 사용은 간단합니다.\n목적지를 입력하면, EveryMap이 다양한 네비게이션 앱들의 데이터를 수집하여 비교 결과를 제공합니다.\n사용자는 이 정보를 바탕으로 가장 적합한 경로를 선택할 수 있습니다.\n또한, 교통 상황 변화에 따른 실시간 업데이트 기능을 통해 항상 최신 정보를 얻을 수 있습니다.\n"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 12
        return label
    }()
    
    private let guidanceSupportDescription = {
        let label = PaddingLabel()
        label.backgroundColor = .white
        label.leftPadding = 18
        label.text = "EveryMap은 다양한 네비게이션 앱의 경로를 한 번에 비교할 수 있는 유용한 도구입니다.\n사용자는 여러 네비게이션 앱의 경로, 예상 도착 시간, 교통 상황을 한눈에 비교하여 가장 효율적인 경로를 선택할 수 있습니다.\nEveryMap은 사용자에게 최적의 경로를 제공하여 시간과 비용을 절약할 수 있게 도와줍니다.\n"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 12
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = #colorLiteral(red: 0.949, green: 0.949, blue: 0.949, alpha: 1)
        self.view.addSubviews(guidanceTitle, guidanceHelpTitle, guidanceHelpDescription, guidanceSupportTitle, guidanceSupportDescription)
        
        guidanceSupportDescription.bottomPadding = self.view.frame.height - guidanceSupportDescription.frame.maxY
        
        NSLayoutConstraint.activate([
            //guidanceTitle
            guidanceTitle.topAnchor.constraint(equalTo: self.view.topAnchor),
            guidanceTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            guidanceTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            //guidanceHelpTitle
            guidanceHelpTitle.topAnchor.constraint(equalTo: guidanceTitle.bottomAnchor, constant: 10),
            guidanceHelpTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            guidanceHelpTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            //guidanceHelpDescription
            guidanceHelpDescription.topAnchor.constraint(equalTo: guidanceHelpTitle.bottomAnchor),
            guidanceHelpDescription.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            guidanceHelpDescription.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            //guidanceSupportTitle
            guidanceSupportTitle.topAnchor.constraint(equalTo: guidanceHelpDescription.bottomAnchor, constant: 2),
            guidanceSupportTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            guidanceSupportTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            //guidanceSupportDescription
            guidanceSupportDescription.topAnchor.constraint(equalTo: guidanceSupportTitle.bottomAnchor),
            guidanceSupportDescription.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            guidanceSupportDescription.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
}
