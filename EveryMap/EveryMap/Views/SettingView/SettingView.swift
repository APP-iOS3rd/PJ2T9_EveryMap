//
//  SettingView.swift
//  EveryMap
//
//  Created by 이성현 on 2023/12/07.
//

import UIKit

class SettingView: UIViewController {
    
    // MARK: - Label
    private let greetingLable = {
        var label = PaddingLabel()
        label.text = "안녕하세요, 회원님"
        label.topPadding = 65
        label.leftPadding = 25
        label.bottomPadding = 20
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .black
        label.textAlignment = .left
        label.backgroundColor = .white
        return label
    }()
    
    // MARK: - TableView
    private let tableView = {
        let tableview = UITableView()
        tableview.backgroundColor = .white
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
        self.view.backgroundColor = #colorLiteral(red: 0.949, green: 0.949, blue: 0.949, alpha: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}


// MARK: - Function
extension SettingView {
    private func setupView() {
        self.view.addSubviews(greetingLable ,tableView)
        self.tableView.register(SettingViewTableViewCell.self, forCellReuseIdentifier: SettingViewTableViewCell.cellId)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Set greetingLabel padding
        
        NSLayoutConstraint.activate([
            // greetingLabel
            greetingLable.topAnchor.constraint(equalTo: self.view.topAnchor),
            greetingLable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            greetingLable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            // tableView
            tableView.topAnchor.constraint(equalTo: self.greetingLable.bottomAnchor, constant: 10),
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
        
        cell.backgroundColor = .white
        
        let settingItem = SettingItem(rawValue: indexPath.row)!
        
        cell.itemLabel.text = settingItem.labelText
        cell.itemSubLabel.text = settingItem.subLabelText
        
        return cell
    }

}

// MARK: - TableView Delegate
extension SettingView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell 선택했을 때 수행할 동작 여기서 구현하면 됨
        print(indexPath.row)
        
        // cell 선택된 상태 해제
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
