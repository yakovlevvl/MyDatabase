//
//  TableSupplementaryViews.swift
//  MyDatabase
//
//  Created by Vladyslav Yakovlev on 01.01.2018.
//  Copyright © 2018 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

class TableReusableView: UICollectionReusableView {
    
    fileprivate let label: UILabel = {
        let label = UILabel()
        label.font = Fonts.tableFont
        label.textAlignment = .center
        label.frame.size.height = 24
        return label
    }()
    
    var didTapEvent: (() -> ())?
    
    fileprivate let borderLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    fileprivate func setupViews() {
        backgroundColor = .white
        
        addSubview(label)
        layer.insertSublayer(borderLayer, at: 0)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView)))
    }
    
    @objc private func didTapView() {
        didTapEvent?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ColumnHeaderView: TableReusableView {
    
    static let reuseId = "ColumnHeaderView"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let borderWidth = TableAttributes.gridWidth
        
        label.frame.size.width = bounds.width - borderWidth
        label.center.y = bounds.height/2
        label.center.x = bounds.width/2 - borderWidth/2   /// check !!!
        
        let value = borderWidth/2
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: value))
        path.addLine(to: CGPoint(x: bounds.width - value, y: value))
        path.addLine(to: CGPoint(x: bounds.width - value, y: bounds.height - value))
        path.addLine(to: CGPoint(x: 0, y: bounds.height - value))
        
        borderLayer.path = path.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = TableAttributes.gridColor
        borderLayer.lineWidth = borderWidth
    }
    
    func setupColumnTitle(_ string: String) {
        label.text = string
    }
}

final class RowEnumeratorView: TableReusableView {
    
    static let reuseId = "RowEnumeratorView"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let borderWidth = TableAttributes.gridWidth
        
        label.frame.size.width = bounds.width - 2*borderWidth
        label.center.x = bounds.width/2
        label.center.y = bounds.height/2 - borderWidth/2   /// check !!!
        
        let value = borderWidth/2
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: value, y: 0))
        path.addLine(to: CGPoint(x: value, y: bounds.height - value))
        path.addLine(to: CGPoint(x: bounds.width - value, y: bounds.height - value))
        path.addLine(to: CGPoint(x: bounds.width - value, y: 0))
        
        borderLayer.path = path.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = TableAttributes.gridColor
        borderLayer.lineWidth = borderWidth
    }
    
    func setupRowIndex(_ index: Int) {
        label.text = String(index)
    }
}

final class EnumeratorHeaderView: TableReusableView {
    
    static let reuseId = "EnumeratorHeaderView"
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        label.frame.size.width = bounds.width - 2*TableAttributes.gridWidth
        label.center.x = bounds.width/2
        label.center.y = bounds.height/2
        
        layer.borderWidth = TableAttributes.gridWidth
        layer.borderColor = TableAttributes.gridColor
    }
    
    func setupHeaderTitle(_ string: String) {
        label.text = string
    }
}




