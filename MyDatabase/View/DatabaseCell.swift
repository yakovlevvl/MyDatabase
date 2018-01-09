//
//  TableCell.swift
//  MyDatabase
//
//  Created by Vladyslav Yakovlev on 27.11.2017.
//  Copyright © 2017 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

final class DatabaseCell: UICollectionViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Circe-Bold", size: 19)
        label.textAlignment = .center
        return label
    }()
    
    static let reuseId = "databaseCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .white
        
        contentView.layer.cornerRadius = 12
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
        layer.shadowOpacity = 0.12
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowRadius = 6
        
        contentView.addSubview(nameLabel)
        nameLabel.frame.size = CGSize(width: frame.width - 32, height: 24)
        nameLabel.center = contentView.center
    }
    
    func setDatabaseName(_ name: String) {
        nameLabel.text = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
