//
//  CompareViewTableViewCell.swift
//  EveryMap
//
//  Created by Taejun Ha on 12/14/23.
//

import UIKit

class CompareViewTableViewCell: UITableViewCell {
    static let cellId = "CompareViewTableViewCell"
    
    let totalTimeLabel = UILabel() //총 시간
    let futureTimeLabel = UILabel() //도착 시간
    let mapImage = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()//Tmap, NaverMap 이미지
    let searchOptionLabel = UILabel() //경로 탐색 옵션
    let distanceAndFareLabel = UILabel() //총 거리와 총 요금
    let mapNameLabel = UILabel() //앱 종류
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setLayout() {
        totalTimeLabel.textColor = .black
        totalTimeLabel.font = .h1
        
        futureTimeLabel.textColor = .black
        futureTimeLabel.font = .b2
        
        searchOptionLabel.textColor = .gray
        searchOptionLabel.font = .b2
        
        distanceAndFareLabel.textColor = .black
        distanceAndFareLabel.font = .b2
        
        mapNameLabel.textColor = .black
        mapNameLabel.font = .b2
        mapNameLabel.textAlignment = .center
        
        addSubviews(totalTimeLabel, futureTimeLabel, mapImage, searchOptionLabel, distanceAndFareLabel, mapNameLabel)
        
        NSLayoutConstraint.activate([
            totalTimeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            totalTimeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            futureTimeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            futureTimeLabel.bottomAnchor.constraint(equalTo: totalTimeLabel.bottomAnchor),
            
            mapImage.topAnchor.constraint(equalTo: totalTimeLabel.bottomAnchor, constant: 20),
            mapImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            mapImage.heightAnchor.constraint(equalToConstant: 50),
            mapImage.widthAnchor.constraint(equalToConstant: 50),
            
            mapNameLabel.topAnchor.constraint(equalTo: mapImage.bottomAnchor, constant: 15),
            mapNameLabel.centerXAnchor.constraint(equalTo: mapImage.centerXAnchor),
            mapNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),

            distanceAndFareLabel.leadingAnchor.constraint(equalTo: mapImage.trailingAnchor, constant: 20),
            distanceAndFareLabel.bottomAnchor.constraint(equalTo: mapNameLabel.bottomAnchor),
            
            searchOptionLabel.leadingAnchor.constraint(equalTo: mapImage.trailingAnchor, constant: 20),
            searchOptionLabel.bottomAnchor.constraint(equalTo: distanceAndFareLabel.topAnchor, constant:  -15),
        ])
    }
}
