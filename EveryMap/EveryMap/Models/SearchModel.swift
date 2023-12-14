//
//  SearchModel.swift
//  EveryMap
//
//  Created by 이성현 on 2023/12/14.
//

import Foundation

struct SearchModel {
    let addressmodel : NMapAddressSearchModel?
    let placemodel : SearchPlaceModel?
    
    var count : Int {
        return (addressmodel?.meta?.totalCount ?? 0) + (placemodel?.items.count ?? 0)
    }
    
    var list : [String?] {
        var totalArray : [String?] = []
        if let address = addressmodel, let place = placemodel{
            for i in 0..<(address.meta?.totalCount ?? 0){
                totalArray.append(address.addresses?[i].roadAddress)
            }
            for i in 0..<(placemodel?.items.count ?? 0) {
                totalArray.append(place.items[i].title.clearStr())
            }
        }
        return totalArray
    }
}

// MARK: - NMapAddressSearchModel
struct NMapAddressSearchModel: Codable {
    let status: String?
    let meta: Meta?
    let addresses: [Address]?
    let errorMessage: String?
}

struct Address: Codable {
    let roadAddress, jibunAddress, englishAddress: String
//    let addressElements: [AddressElement]
    let x, y: String
    let distance: Int
}

//struct AddressElement: Codable {
//    let types: [String]
//    let longName, shortName, code: String
//}

struct Meta: Codable {
    let totalCount: Int
    let page: Int?
    let count: Int
}


// MARK: - SearchLocalPlaceModel
struct SearchPlaceModel: Codable {
    let lastBuildDate: String
    let total : Int
    let start, display: Int
    let items: [Item]
}

struct Item: Codable {
    let title: String
    let link: String
    let category, description, telephone, address: String
    let roadAddress, mapx, mapy: String
}
