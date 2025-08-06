//
//  ViewController.swift
//  EveryMap
//
//  Created by 이성현 on 2023/12/06.
//

import UIKit

class MainTabBarView: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTabBarControllers()
        setupTabBarShadowAndLine()
    }
}

// MARK: - Methods

extension MainTabBarView {
    private func setUI() {
        self.tabBar.backgroundColor = .black
        self.tabBar.layer.cornerRadius = 20
    }
    
    func setTabBarControllers() {
        self.tabBar.backgroundColor = .white
        
        // bgColor -> "#colorLiteral(" 이라고 치면 사용할 수 있음
        let firstNC = UINavigationController(rootViewController: HomeView(title: TabBarItem.home.toName()))
        let secondNC =  UINavigationController(rootViewController: SettingView(title: TabBarItem.setting.toName(), bgColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
        
        self.viewControllers = [firstNC, secondNC]
        
        // 아이템 설정
        let firstTabBarItem = UITabBarItem(title: TabBarItem.home.toName(), image: UIImage(systemName: TabBarItem.home.toIconName()), tag: TabBarItem.home.toTag())
        let secondTabBarItem = UITabBarItem(title: TabBarItem.setting.toName(), image: UIImage(systemName: TabBarItem.setting.toIconName()), tag: TabBarItem.setting.toTag())
        
        firstNC.tabBarItem = firstTabBarItem
        secondNC.tabBarItem = secondTabBarItem
    }
    
    private func setupTabBarShadowAndLine() {
        // 그림자 효과 추가 (위쪽으로 연하게)
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOpacity = 0.08
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: -4)
        self.tabBar.layer.shadowRadius = 12
        self.tabBar.layer.masksToBounds = false
    }
}
