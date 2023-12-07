//
//  ViewController.swift
//  EveryMap
//
//  Created by 이성현 on 2023/12/06.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Tabbar 설정
        setUpViews()
        
    }
    
    func setUpViews() {
        self.tabBar.backgroundColor = .white
        
        // bgColor -> "#colorLiteral(" 이라고 치면 사용할 수 있음
        let firstNC = UINavigationController(rootViewController: HomeView(title: "Home"))
        let secondNC = UINavigationController(rootViewController: SettingView(title: "Setting", bgColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
        
        self.viewControllers = [firstNC, secondNC]
        
        // 아이템 설정
        let firstTabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        let secondTabBarItem = UITabBarItem(title: "Setting", image: UIImage(systemName: "gearshape.fill"), tag: 1)
        
        firstNC.tabBarItem = firstTabBarItem
        secondNC.tabBarItem = secondTabBarItem
    }
}

