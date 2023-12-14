//
//  HomeViewViewController.swift
//  EveryMap
//
//  Created by 이성현 on 2023/12/07.
//

import Foundation

class HomeViewViewController{
    
    var searchModel : SearchModel?
    var address : NMapAddressSearchModel?
    var place : SearchPlaceModel?
    
    init() {
        
    }
    
    func loadModelData(destanation: String, completion: @escaping (SearchModel?) -> Void){
        let queue1 = DispatchQueue(label: "queue1", attributes: .concurrent)
        let queue2 = DispatchQueue(label: "queue2", attributes: .concurrent)
        let dispatchGroup = DispatchGroup()
        
        queue1.async(group: dispatchGroup) {
            dispatchGroup.enter()
            APIManager.manager.loadSearchAddressResult(goalAddress: destanation) { result in
                self.address = result
                dispatchGroup.leave()
            }
        }
        
        queue2.async(group: dispatchGroup) {
            dispatchGroup.enter()
            APIManager.manager.loadSearchPlaceResult(placeAddress: destanation) { result in
                self.place = result
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.searchModel = SearchModel(addressmodel: self.address ?? NMapAddressSearchModel(status: nil, meta: nil, addresses: nil, errorMessage: nil), placemodel: self.place ?? SearchPlaceModel(lastBuildDate: "", total: 0, start: 0, display: 0, items: []))
            completion(self.searchModel)
        }
    }
}
