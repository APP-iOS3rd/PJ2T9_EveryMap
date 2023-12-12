//
//  HomeViewController.swift
//  EveryMap
//
//  Created by 이성현 on 2023/12/07.
//

import UIKit
import TMapSDK

class HomeView: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    let tmapcontainer : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = false
        let mapView = TMapView(frame: view.frame)
        view.addSubview(mapView)
        mapView.setApiKey(Bundle.main.TmapApiKey!)
        return view
    }()
    // 추후 테이블뷰로 변경 예정
    let testview : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        view.isHidden = true
        return view
    }()
    
    let homeviewController = HomeViewViewController()
    
    convenience init(title: String) {
        self.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupHomeView()
    }
    
    // MARK: - HomeView 화면 설정 함수
    func setupHomeView() {
        self.view.backgroundColor = .white
        setUpSearchController()
        self.view.addSubviews(tmapcontainer,testview)
        setupConstraints()
    }
    // MARK: - HomeView 화면에 있는 Constraints 설정 함수
    func setupConstraints() {
        // 임시로 TMapView로 표현함
        NSLayoutConstraint.activate([
            tmapcontainer.topAnchor.constraint(equalTo: self.view.topAnchor),
            tmapcontainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tmapcontainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tmapcontainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            testview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            testview.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            testview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            testview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    // MARK: - HomeView - SearchController 설정 함수
    func setUpSearchController() {
        self.searchController.delegate = self
        // searchConroller에 UISearchResultsUpdating 프로토콜을 사용하기 위해서
        self.searchController.searchResultsUpdater = self
        // 응답자가 가게 되면 나머지 뷰들을 어둡게 한다 -> true, 그렇지 않으면 -> false
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "장소, 주소 검색"
        self.searchController.hidesNavigationBarDuringPresentation = true
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            textField.leftView?.tintColor = .black
//            if let placeholder = textField.value(forKey: "placeholderLabel") as? UILabel{
//                print("placeholder 발견")
//            }
            if let iconbtn = textField.value(forKey: "clearButton") as? UIButton {
                iconbtn.tintColor = .black
            }
        }
        
        self.navigationItem.searchController = searchController
        self.navigationItem.searchController?.searchBar.layer.shadowOpacity = 0.5
        self.navigationItem.searchController?.searchBar.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.navigationItem.searchController?.searchBar.searchTextField.textColor = .black
        
//        btn.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.navigationController?.setupBarAppearance()
        self.definesPresentationContext = true
    }
}
// MARK: - SearchController 내의 텍스트가 변경될 때마다 호출되는 프로토콜
extension HomeView : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("DEBUG PRINT:", searchController.searchBar.text)
    }
}

// MARK: - SearchController 내에 응답자가 있는지 없는지 확인하는 프로토콜
extension HomeView : UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        testview.isHidden = false
        tmapcontainer.isHidden = true
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        testview.isHidden = true
        tmapcontainer.isHidden = false
    }
}

//extension HomeView : UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        print("\(selectedScope)")
//    }
//}

