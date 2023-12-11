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
    
    // HomeView 화면 설정 함수
    func setupHomeView() {
        self.view.backgroundColor = #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
        setUpSearchController()
        self.view.addSubviews(tmapcontainer,testview)
        setupConstraints()
    }
    // HomeView 화면에 있는 Constraints 설정 함수
    func setupConstraints() {
        tmapcontainer.translatesAutoresizingMaskIntoConstraints = false
        
        // 임시로 TMapView로 표현함
        NSLayoutConstraint.activate([
            tmapcontainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tmapcontainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tmapcontainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tmapcontainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            testview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            testview.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            testview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            testview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        let mapView = TMapView(frame: tmapcontainer.frame)
        tmapcontainer.addSubview(mapView)
        mapView.setApiKey(Bundle.main.TmapApiKey!)
        
    }
    // HomeView - SearchController 설정 함수
    func setUpSearchController() {
        self.searchController.delegate = self
        // searchConroller에 UISearchResultsUpdating 프로토콜을 사용하기 위해서
        self.searchController.searchResultsUpdater = self
        // 응답자가 가게 되면 나머지 뷰들을 어둡게 한다 -> true, 그렇지 않으면 -> false
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "장소, 주소 검색"
        // 돋보기 색상 변경
//        self.searchController.searchBar.searchTextField.leftView?.tintColor = .gray
        
        // scope 설정들
//        self.searchController.searchBar.scopeButtonTitles = ["최근검색", "장소", "주소"]
//        self.searchController.searchBar.delegate = self
//        self.searchController.searchBar.setShowsScope(false, animated: true)
        // 스크롤을 할 때 searchBar 부분을 계속 유지시킬건지 hide 할지 정하는 값(ture -> 숨김, false -> 보임)
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Home"
        self.navigationController?.setupBarAppearance()
        self.definesPresentationContext = true
    }
}
// SearchController 내의 텍스트가 변경될 때마다 호출되는 프로토콜
extension HomeView : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("DEBUG PRINT:", searchController.searchBar.text)
    }
}

// SearchController 내에 응답자가 있는지 없는지 확인하는 프로토콜
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

