//
//  ColumnTypeCell.swift
//  MyDatabase
//
//  Created by Vladyslav Yakovlev on 15.12.2017.
//  Copyright © 2017 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

final class ColumnTypeCell: UITableViewCell {
    
    static let reuseId = "ColumnTypeCell"
    
    private let typeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 24))
        label.font = UIFont(name: "Circe-Bold", size: 19)
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        typeLabel.center = contentView.center
    }
    
    private func setupViews() {
        contentView.addSubview(typeLabel)
    }
    
    func setType(_ type: String) {
        typeLabel.text = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
