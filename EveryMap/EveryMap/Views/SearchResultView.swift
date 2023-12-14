//
//  SearchResultView.swift
//  EveryMap
//
//  Created by Taejun Ha on 12/11/23.
//

import UIKit

class SearchResultView: UIViewController {

    var address : Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchResultView {
    func setUI() {
        if let address = address {
            print("정상")
        }
    }
}
