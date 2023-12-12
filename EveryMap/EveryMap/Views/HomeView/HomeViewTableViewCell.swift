//
//  HomeViewTableViewCell.swift
//  EveryMap
//
//  Created by 이성현 on 2023/12/12.
//

import UIKit

class HomeViewTableViewCell: UITableViewCell {

    static let cellId = "HomeViewTableViewCell"
    
    let placeLabel : PaddingLabel = {
        let label = PaddingLabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        label.topPadding = 15
        label.bottomPadding = 15
        label.leftPadding = 25
        return label
    }()
    
    let placeImg : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "magnifyingglass.circle")
        return imgView
    }()
    
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
        self.addSubviews(placeImg, placeLabel)
        
        NSLayoutConstraint.activate([
            placeImg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            placeImg.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            placeImg.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            placeImg.widthAnchor.constraint(equalToConstant: 30),
            placeImg.heightAnchor.constraint(equalToConstant: 30),
            
            placeLabel.leadingAnchor.constraint(equalTo: placeImg.trailingAnchor, constant: 5),
            placeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10),
            placeLabel.centerYAnchor.constraint(equalTo: placeImg.centerYAnchor)
        ])
    }
}
