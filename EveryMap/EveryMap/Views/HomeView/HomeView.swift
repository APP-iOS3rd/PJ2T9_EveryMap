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
        view.isHidden = false
        let mapView = TMapView(frame: view.frame)
        view.addSubview(mapView)
        mapView.setApiKey(Bundle.main.TmapApiKey!)
        return view
    }()
    
    let tableView : UITableView = {
        let view = UITableView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()
    
    private let lastSearchLable = {
        var label = PaddingLabel()
        label.text = "최근검색"
        label.topPadding = 20
        label.leftPadding = 25
        label.bottomPadding = 20
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .black
        label.textAlignment = .left
        label.backgroundColor = .white
        label.isHidden = true
        return label
    }()
    
    var testArr : [String] = ["인천국제공항", "학동평화맨션", "서울역"]
    let homeviewController = HomeViewViewController()
    
    convenience init(title: String) {
        self.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupHomeView()
    }
}

// MARK: - HomeView Function
extension HomeView {
    // MARK: - HomeView 화면 설정 함수
    func setupHomeView() {
        self.view.backgroundColor = .white
        setUpSearchController()
        self.view.addSubviews(tmapcontainer,lastSearchLable,tableView)
        self.tableView.register(HomeViewTableViewCell.self, forCellReuseIdentifier: HomeViewTableViewCell.cellId)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
//        self.tableView.rowHeight = UITableView.automaticDimension
//        self.tableView.estimatedRowHeight = UITableView.automaticDimension
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
            
            lastSearchLable.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            lastSearchLable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            lastSearchLable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: self.lastSearchLable.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
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

// MARK: - HomeView - TableView
extension HomeView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewTableViewCell.cellId, for: indexPath) as! HomeViewTableViewCell
        
        cell.backgroundColor = .white
        
        cell.placeLabel.text = testArr[indexPath.row]
        
        return cell
    }
}

extension HomeView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell 선택했을 때 수행할 동작 여기서 구현하면 됨
        tableView.deselectRow(at: indexPath, animated: true)
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
        tableView.isHidden = false
        lastSearchLable.isHidden = false
        tmapcontainer.isHidden = true
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        tableView.isHidden = true
        lastSearchLable.isHidden = true
        tmapcontainer.isHidden = false
    }
}

//extension HomeView : UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        print("\(selectedScope)")
//    }
//}

