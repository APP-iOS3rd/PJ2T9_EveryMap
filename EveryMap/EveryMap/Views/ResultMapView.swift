//
//  ResultMapView.swift
//  EveryMap
//
//  Created by Taejun Ha on 12/11/23.
//

import UIKit

class ResultMapView: UIViewController, UISearchBarDelegate {
    private let searchController = UISearchController(searchResultsController: nil)
    
    let completeBtn : UIButton = {
       let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = #colorLiteral(red: 0.1647058824, green: 0.6, blue: 1, alpha: 1)
        config.cornerStyle = .dynamic
        config.buttonSize = .large
        btn.configuration = config
        btn.layer.shadowRadius = 5
        btn.layer.shadowOffset = CGSize(width: 3, height: 3)
        btn.layer.shadowOpacity = 0.3
//        btn.backgroundColor = #colorLiteral(red: 0.1647058824, green: 0.6, blue: 1, alpha: 1)
        btn.setAttributedTitle(NSAttributedString(string: "이 장소가 맞나요? 가장 빠른 경로 확인하기!",
                                                  attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]), for: .normal)
//        btn.layoutMargins = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
//        btn.setTitleColor(.white, for: .normal)
//        btn.layer.cornerRadius = 8
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchController()

        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        self.view.addSubviews(completeBtn)
        NSLayoutConstraint.activate([
            // completeBtn
            completeBtn.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            completeBtn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            completeBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
    }
    
    func setUpSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search"
        
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension ResultMapView : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("DEBUG PRINT:", searchController.searchBar.text)
    }
    
    
}

//#if DEBUG
//import SwiftUI
//
//struct ViewControllerRepresentable : UIViewControllerRepresentable{
//    //update
//    
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        
//    }
//    @available(iOS 13.0, *)
//    //makeui : 뷰를 다시 그리기 때문에 있어야함(아래 함수를 통해 viewcontroller를 반환함[반환하는 viewcontroller는 위에서 만든 것])
//    func makeUIViewController(context: Context) -> UIViewController {
//        ResultMapView()
//    }
//    
//}
//
//struct ViewController_Previews : PreviewProvider{
//    static var previews: some View{
//        ViewControllerRepresentable()
//            .ignoresSafeArea()
//            .previewDisplayName("아이폰 14")
//            .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
//    }
//}
//
//#endif
