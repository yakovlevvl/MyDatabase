//
//  ItemCell.swift
//  MyDatabase
//
//  Created by Vladyslav Yakovlev on 28.11.2017.
//  Copyright © 2017 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

final class ItemCell: UICollectionViewCell {
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.tableFont
        label.textAlignment = .center
        label.frame.size.height = 24
        return label
    }()
    
    private let borderLayer = CAShapeLayer()
    
    static let reuseId = "ItemCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.addSubview(valueLabel)
        contentView.layer.insertSublayer(borderLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let borderWidth = TableAttributes.gridWidth
        
        valueLabel.frame.size.width = bounds.width - borderWidth
        valueLabel.center.y = bounds.height/2 - borderWidth/2
        valueLabel.center.x = bounds.width/2 - borderWidth/2
        
        let value = borderWidth/2
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.width - value, y: 0))
        path.addLine(to: CGPoint(x: bounds.width - value, y: bounds.height - value))
        path.addLine(to: CGPoint(x: 0, y: bounds.height - value))
    
        borderLayer.path = path.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = TableAttributes.gridColor
        borderLayer.lineWidth = borderWidth
    }
    
    func setupValue(_ string: String) {
        valueLabel.text = string
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




