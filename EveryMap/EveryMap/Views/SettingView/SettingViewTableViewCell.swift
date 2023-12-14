//
//  SettingViewTableViewCell.swift
//  EveryMap
//
//  Created by Taejun Ha on 12/11/23.
//

import UIKit

class SettingViewTableViewCell: UITableViewCell {
    static let cellId = "SettingVIewTableViewCell"
    
    let itemLabel = PaddingLabel()
    var itemSubLabel = PaddingLabel()

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
        itemLabel.textColor = .black
        itemLabel.font = .b1
        itemLabel.topPadding = 15
        itemLabel.bottomPadding = 15
        itemLabel.leftPadding = 25
        
        itemSubLabel.textColor = .black
        itemSubLabel.layer.opacity = 0.35
        itemSubLabel.font = .b2
        itemSubLabel.topPadding = 15
        itemSubLabel.bottomPadding = 15
        itemSubLabel.rightPadding = 25
        
        self.addSubviews(itemLabel, itemSubLabel)
        
        NSLayoutConstraint.activate([
            itemLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            itemLabel.topAnchor.constraint(equalTo: self.topAnchor),
            itemLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            itemSubLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            itemSubLabel.centerYAnchor.constraint(equalTo: itemLabel.centerYAnchor)
        ])
    }

}
