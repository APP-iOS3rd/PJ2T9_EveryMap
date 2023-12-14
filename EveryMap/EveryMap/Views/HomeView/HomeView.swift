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
    private var region : Region?
    private var currentAddress : String?
    private var startLocation : StartLocationModel?
    private var homeViewViewController = HomeViewViewController()
    //테스트용
    private var searchModel : SearchModel?
    
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
    
    private let searchPlaceLable = {
       var label = PaddingLabel()
        label.text = "검색어를 입력하세요!"
        label.topPadding = 20
        label.leftPadding = 25
        label.bottomPadding = 10
        label.font = .h2
        label.textColor = .g1
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    private let searchResultLable = {
        var label = PaddingLabel()
        label.text = "검색 결과"
        label.topPadding = 20
        label.leftPadding = 10
        label.font = .h2
        label.textColor = .black
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.isHidden = true
        return label
    }()
    
    private let searchCountLable = {
        var label = PaddingLabel()
        label.text = ""
        label.topPadding = 10
        label.leftPadding = 25
        label.bottomPadding = 20
        label.font = .s1
        label.textColor = .black
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    var locationManager = CLLocationManager()
    
    convenience init(title: String) {
        self.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = false
        setupHomeView()
        setupSearchController()
        startUpdatingUserLocation()
        setupConstraints()
        
    }
}

// MARK: - UI & Layout

extension HomeView {
    func setupHomeView() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubviews(mainMapView, searchPlaceLable, searchResultLable, searchCountLable,  tableView)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        self.tableView.register(HomeViewTableViewCell.self, forCellReuseIdentifier: HomeViewTableViewCell.cellId)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func setupConstraints() {
        // 임시로 TMapView로 표현함
        NSLayoutConstraint.activate([
            mainMapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mainMapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            mainMapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainMapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            searchPlaceLable.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchPlaceLable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            
            searchResultLable.leadingAnchor.constraint(equalTo: self.searchPlaceLable.trailingAnchor),
            searchResultLable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            searchResultLable.firstBaselineAnchor.constraint(equalTo: searchPlaceLable.firstBaselineAnchor),
            
            searchCountLable.topAnchor.constraint(equalTo: self.searchPlaceLable.bottomAnchor),
            searchCountLable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchCountLable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: self.searchCountLable.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func setupSearchController() {
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
    
    func setupMapView() {
        let lat = startLocation?.lat
        let lng = startLocation?.lng
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat ?? 0.0, lng: lng ?? 0.0), zoomTo: 15)
        
        self.mainMapView.mapView.moveCamera(cameraUpdate)
    }
    
}

// MARK: - UITableViewDataSource

extension HomeView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let search = searchModel else { return 0 }
        return search.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewTableViewCell.cellId, for: indexPath) as! HomeViewTableViewCell
        cell.backgroundColor = .white
        cell.placeLabel.text = searchModel?.list[indexPath.row]
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell 선택했을 때 수행할 동작 여기서 구현하면 됨
        tableView.deselectRow(at: indexPath, animated: true)
        // 현재
        currentAddress = [region?.area1.name, region?.area2.name, region?.area3.name]
            .reduce("") { (result, areaName) in
                return result + " " + (areaName ?? "")
            }
        let vc = ResultMapView()
        if indexPath.row >= searchModel?.addressmodel?.meta?.totalCount ?? 0 {
            let addressCount = searchModel?.addressmodel?.meta?.totalCount
            if addressCount == 0 {
                vc.searchPlace = searchModel?.placemodel?.items[indexPath.row]
            } else {
                vc.searchPlace = searchModel?.placemodel?.items[indexPath.row - addressCount!]
            }
        } else {
            vc.searchAddress = searchModel?.addressmodel?.addresses?[indexPath.row]
        }
        vc.currentAddress = currentAddress?.trimmingCharacters(in: .whitespaces)
        vc.startLocation = startLocation
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - CoreLocation

extension HomeView {
    func startUpdatingUserLocation() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                print("위치 서비스 On 상태")
                DispatchQueue.main.async {
                    self.locationManager.startUpdatingLocation()
                    self.startLocation = StartLocationModel(lat: Double(self.locationManager.location?.coordinate.latitude ?? 0.0), lng: Double(self.locationManager.location?.coordinate.longitude ?? 0.0))
                    self.setupMapView()
                }
            } else {
                print("위치 서비스 Off 상태")
            }
        }
    }
    
}

// MARK: - SearchController

extension HomeView : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text != "" {
            homeViewViewController.loadModelData(destanation: text) { [weak self] result in
                DispatchQueue.main.async {
                    if let result = result {
                        self?.searchModel = result
                        print("Search Model : \(self?.searchModel?.count)")
                        if self?.searchModel?.count ?? 0 > 0 {
                            self?.searchCountLable.isHidden = false
                            self?.searchCountLable.text = "총 \(self?.searchModel?.count ?? 0)개 장소를 발견했어요!"
                        } else {
                            self?.searchCountLable.isHidden = true
                        }
                        self?.tableView.reloadData()
                        self?.searchPlaceLable.text = "\"" + text + "\""
                        self?.searchPlaceLable.font = .h3
                        self?.searchPlaceLable.textColor = .black
                    }
                    else {
                        print("결과가 없습니다.")
                    }
                }
            }
        } else {
            searchPlaceLable.text = "목적지를 입력하세요!"
            searchPlaceLable.font = .h2
            searchPlaceLable.textColor = .g1
            searchCountLable.isHidden = true
            searchModel = nil
            tableView.reloadData()
        }
    }
}

// MARK: - UISearchControllerDelegate

extension HomeView : UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        tableView.isHidden = false
        searchPlaceLable.isHidden = false
        searchResultLable.isHidden = false
        searchCountLable.isHidden = false
        mainMapView.isHidden = true
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        tableView.isHidden = true
        searchPlaceLable.isHidden = true
        searchResultLable.isHidden = true
        searchCountLable.isHidden = true
        mainMapView.isHidden = false
    }
    
}

// MARK: - CLLocationManagerDelegate

extension HomeView : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("현재 위치 업데이트 완료.")
        if let location = locations.first {
            print("위도 : \(location.coordinate.latitude), 경도 : \(location.coordinate.longitude)")
            let lat = location.coordinate.latitude
            let lng = location.coordinate.longitude
            apiManager.loadAddressResult(lat: lat, lng: lng) { [weak self] result in
                DispatchQueue.main.async {
                    if let result = result {
                        // API 응답 도착 시 주소 검색 결과 모델 업데이트
                        self?.region = result
                    } else {
                        print("결과가 없습니다.")
                    }
                }
            }
            startLocation = StartLocationModel(lat: lat, lng: lng)
        }
    }
}

// MARK: - ViewWillAppear

extension HomeView {
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
}
