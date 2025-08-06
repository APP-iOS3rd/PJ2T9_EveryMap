//
//  SettingView.swift
//  EveryMap
//
//  Created by 이성현 on 2023/12/07.
//

import UIKit

class SettingView: UIViewController {
    
    // MARK: - Custom NavigationBar
    private let navBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.89, green: 0.94, blue: 1.0, alpha: 1.0) // 연한 파랑색 #E3F0FF
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    private let backButton: UIButton = {
//        let button = UIButton(type: .system)
//        let image = UIImage(systemName: "chevron.left")
//        button.setImage(image, for: .normal)
//        button.tintColor = .black
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    private let navTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "설정"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - TableView
    private let tableView = {
        let tableview = UITableView()
        tableview.backgroundColor = .systemBackground
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    

    enum SettingItem: Int, CaseIterable {
        case appVersion
        case customerService
        case helpAndSupport

        var labelText: String {
            switch self {
            case .appVersion: return "앱 버전"
            case .customerService: return "고객 센터"
            case .helpAndSupport: return "도움말 및 지원"
            }
        }

        var subLabelText: String {
            switch self {
            case .appVersion: return "최신 버전입니다."
            case .customerService, .helpAndSupport: return ""
            }
        }
    }


    convenience init(title: String, bgColor: UIColor) {
        self.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 1.0, green: 0.94, blue: 0.94, alpha: 1.0) // 연한 빨강색 #FFF0F0
        setupView()
    }

    @objc private func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: - Function
extension SettingView {
    private func setupView() {
        self.view.addSubviews(navBar, tableView)
        navBar.addSubviews(navTitleLabel)
        self.tableView.register(SettingViewTableViewCell.self, forCellReuseIdentifier: SettingViewTableViewCell.cellId)
        self.tableView.dataSource = self
        self.tableView.delegate = self
//        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 44),
//            backButton.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 8),
//            backButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
//            backButton.widthAnchor.constraint(equalToConstant: 32),
//            backButton.heightAnchor.constraint(equalToConstant: 32),
            navTitleLabel.centerXAnchor.constraint(equalTo: navBar.centerXAnchor),
            navTitleLabel.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

// MARK: - TableView DataSource
extension SettingView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewTableViewCell.cellId, for: indexPath) as! SettingViewTableViewCell
        
        cell.backgroundColor = .systemBackground
        
        let settingItem = SettingItem(rawValue: indexPath.row)!
        
        cell.itemLabel.text = settingItem.labelText
        cell.itemSubLabel.text = settingItem.subLabelText
        
        return cell
    }

}

// MARK: - TableView Delegate (각 셀 선택 되었을 때 동작)
extension SettingView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell 선택했을 때 수행할 동작 여기서 구현하면 됨
        let settingItem = SettingItem(rawValue: indexPath.row)!
        
        switch settingItem {
        case .appVersion: break
        case .customerService: break
        case .helpAndSupport: self.present(GuidanceView(), animated: true)
        }
        
        // cell 선택된 상태 해제
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
