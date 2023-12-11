//
//  ResultMapView.swift
//  EveryMap
//
//  Created by Taejun Ha on 12/11/23.
//

import UIKit

class ResultMapView: UIViewController {
    
    let search : UISearchBar = {
       let text = UISearchBar()
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
