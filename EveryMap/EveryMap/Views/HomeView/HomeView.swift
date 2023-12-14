//
//  HomeViewController.swift
//  EveryMap
//
//  Created by 이성현 on 2023/12/07.
//

import UIKit
import CoreLocation
import NMapsMap

class HomeView: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let apiManager = APIManager.manager
    private var searchAddress : NMapAddressSearchModel?
    
    let mainMapView : NMFNaverMapView = {
        let naverMapView = NMFNaverMapView()
        naverMapView.showLocationButton = true
        naverMapView.mapView.positionMode = .normal
        naverMapView.isHidden = false
        return naverMapView
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
//    let homeviewController = HomeViewViewController()
    var locationManager = CLLocationManager()
    
    convenience init(title: String) {
        self.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = false
        setupHomeView()
    }
}

// MARK: - HomeView Function
extension HomeView {
    // MARK: - HomeView 화면 설정 함수
    func setupHomeView() {
        self.view.backgroundColor = .systemBackground
        setUpSearchController()
        self.view.addSubviews(mainMapView,lastSearchLable,tableView)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        startUpdatingUserLocation()
        
        self.tableView.register(HomeViewTableViewCell.self, forCellReuseIdentifier: HomeViewTableViewCell.cellId)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        setupConstraints()
    }
    
    
    // MARK: - HomeView 화면에 있는 Constraints 설정 함수
    func setupConstraints() {
        // 임시로 TMapView로 표현함
        NSLayoutConstraint.activate([
            mainMapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mainMapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            mainMapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainMapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
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
        self.searchController.searchBar.searchTextField.backgroundColor = .systemBackground
        
        self.navigationItem.searchController = searchController
        self.navigationItem.searchController?.searchBar.layer.shadowOpacity = 0.3
        self.navigationItem.searchController?.searchBar.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.navigationItem.searchController?.searchBar.searchTextField.textColor = .black
        
        self.navigationController?.setupBarAppearance()
        self.definesPresentationContext = true
    }
    
    
}

// MARK: - HomeView - TableView
extension HomeView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let search = searchAddress else { return 0 }
        return search.meta?.totalCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewTableViewCell.cellId, for: indexPath) as! HomeViewTableViewCell
        cell.backgroundColor = .white
        cell.placeLabel.text = searchAddress?.addresses?[indexPath.row].roadAddress
        return cell
    }
}

extension HomeView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell 선택했을 때 수행할 동작 여기서 구현하면 됨
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ResultMapView()
        vc.address = searchAddress?.addresses?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - 지도 관련 Methods
extension HomeView {
    // MARK: - HomeView 현재 위치 버튼 함수
    func startUpdatingUserLocation() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                print("위치 서비스 On 상태")
                self.locationManager.startUpdatingLocation()
                print(self.locationManager.location?.coordinate)
            } else {
                print("위치 서비스 Off 상태")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("현재 위치 업데이트 완료.")
        if let location = locations.first {
            print("위도 : \(location.coordinate.latitude), 경도 : \(location.coordinate.longitude)")
            let lat = location.coordinate.latitude
            let lng = location.coordinate.longitude
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat ?? 0.0, lng: lng ?? 0.0), zoomTo: 15)
            
            self.mainMapView.mapView.moveCamera(cameraUpdate)
        }
    }
    
}

// MARK: - SearchController 내의 텍스트가 변경될 때마다 호출되는 프로토콜
extension HomeView : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("DEBUG PRINT:", searchController.searchBar.text)
        guard let text = searchController.searchBar.text else { return }
        if text != "" {
            apiManager.loadSearchResult(goalAddress: text) { [weak self] result in
                DispatchQueue.main.async {
                    if let result = result {
                        // API 응답 도착 시 주소 검색 결과 모델 업데이트
                        self?.searchAddress = result
                        print("Search Address Count: \(self?.searchAddress?.meta?.totalCount ?? 0)")
                        // 테이블 뷰 업데이트
                        self?.tableView.reloadData()
                    } else {
                        print("결과가 없습니다.")
                    }
                }
            }
        }
    }
}

// MARK: - SearchController 내에 응답자가 있는지 없는지 확인하는 프로토콜
extension HomeView : UISearchControllerDelegate, UISearchBarDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        tableView.isHidden = false
        lastSearchLable.isHidden = false
        mainMapView.isHidden = true
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        tableView.isHidden = true
        lastSearchLable.isHidden = true
        mainMapView.isHidden = false
    }
    
}

extension HomeView : CLLocationManagerDelegate {
    
}

extension HomeView {
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
}
