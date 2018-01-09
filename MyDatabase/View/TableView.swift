//
//  TableView.swift
//  MyDatabase
//
//  Created by Vladyslav Yakovlev on 29.12.2017.
//  Copyright © 2017 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

protocol TableViewDataSource: class {
    
    func numberOfRows(in: TableView) -> Int
    func numberOfColumns(in: TableView) -> Int
    
    func tableView(_ tableView: TableView, headerTitleForColumnAt index: Int) -> String
    func tableView(_ tableView: TableView, valueForRowAt rowIndex: Int, forColumnAt columnIndex: Int) -> String
}

protocol TableViewDelegate: class {
    
    func tableView(_ tableView: TableView, didSelectColumnHeaderAt index: Int)
    func tableView(_ tableView: TableView, didSelectRowEnumeratorAt index: Int)
    func tableView(_ tableView: TableView, didSelectItemAtRow rowIndex: Int, columnIndex: Int)
}

final class TableView: UIView {
    
    weak var delegate: TableViewDelegate!
    weak var dataSource: TableViewDataSource!
    
    var columnWidths = [CGFloat]()
    
    var enumeratorColumnWidth: CGFloat = 0
    
    var rowHeight: CGFloat = 56 {
        didSet {
            rowHeight += TableAttributes.gridWidth
        }
    }
    
    private var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        let layout = TableViewLayout(tableView: self)
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseId)
        collectionView.register(ColumnHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewType.columnHeader.rawValue, withReuseIdentifier: ColumnHeaderView.reuseId)
        collectionView.register(RowEnumeratorView.self, forSupplementaryViewOfKind: SupplementaryViewType.rowEnumerator.rawValue, withReuseIdentifier: RowEnumeratorView.reuseId)
        collectionView.register(EnumeratorHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewType.enumeratorHeader.rawValue, withReuseIdentifier: EnumeratorHeaderView.reuseId)
        addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = CGRect(origin: .zero, size: frame.size)
        collectionView.reloadData()
    }
    
    func reload() {
        (collectionView.collectionViewLayout as! TableViewLayout).clearLayoutCache()
        collectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TableView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.numberOfRows(in: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfColumns(in: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseId, for: indexPath) as! ItemCell
        let value = dataSource.tableView(self, valueForRowAt: indexPath.section, forColumnAt: indexPath.item)
        cell.setupValue(value)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch SupplementaryViewType(rawValue: kind)! {
        case .columnHeader : return dequeueColumnHeaderView(for: indexPath, collectionView: collectionView)
        case .rowEnumerator : return dequeueRowEnumeratorView(for: indexPath, collectionView: collectionView)
        case .enumeratorHeader : return dequeueEnumeratorHeaderView(for: indexPath, collectionView: collectionView)
        }
    }
    
    private func dequeueColumnHeaderView(for indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewType.columnHeader.rawValue, withReuseIdentifier: ColumnHeaderView.reuseId, for: indexPath) as! ColumnHeaderView
        view.setupColumnTitle(dataSource.tableView(self, headerTitleForColumnAt: indexPath.first!))
        view.didTapEvent = { [unowned self] in
            self.delegate.tableView(self, didSelectColumnHeaderAt: indexPath.first!)
        }
        return view
    }
    
    private func dequeueRowEnumeratorView(for indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewType.rowEnumerator.rawValue, withReuseIdentifier: RowEnumeratorView.reuseId, for: indexPath) as! RowEnumeratorView
        view.setupRowIndex(indexPath.first! + 1)
        view.didTapEvent = { [unowned self] in
            self.delegate.tableView(self, didSelectRowEnumeratorAt: indexPath.first!)
        }
        return view
    }
    
    private func dequeueEnumeratorHeaderView(for indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewType.enumeratorHeader.rawValue, withReuseIdentifier: EnumeratorHeaderView.reuseId, for: indexPath) as! EnumeratorHeaderView
        view.setupHeaderTitle("n")
        return view
    }
    
}

extension TableView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.tableView(self, didSelectItemAtRow: indexPath.section, columnIndex: indexPath.item)
    }

}

extension TableView {
    
    var numberOfRows: Int {
        return dataSource.numberOfRows(in: self)
    }
    
    var numberOfColumns: Int {
        return dataSource.numberOfColumns(in: self)
    }
    
    func widthForColumn(index: Int) -> CGFloat {
        return columnWidths[index]
    }
    
    func columnHeaderWidthForIndex(_ index: Int) -> CGFloat {
        return columnWidths[index]
    }
    
    func calculateEnumeratorColumnWidth() {
        let lastRowIndex = numberOfRows
        let indexString = String(lastRowIndex)
        let width = NSString(string: indexString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 24), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : Fonts.tableFont], context: nil).size.width
        let insetFromBorderToIndex: CGFloat = 16
        enumeratorColumnWidth = width + 2*insetFromBorderToIndex + 2*TableAttributes.gridWidth
    }
    
    func calculateColumnWidths() {
        columnWidths.removeAll()
        let insetFromBorderToText: CGFloat = 20
        for column in 0..<numberOfColumns {
            var itemsWidth = [CGFloat]()
            let headerString = dataSource.tableView(self, headerTitleForColumnAt: column)
            let columnTitleLenght = NSString(string: headerString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 24), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : Fonts.tableFont], context: nil).size.width
            let width = columnTitleLenght + 2*insetFromBorderToText + TableAttributes.gridWidth
            for row in 0..<numberOfRows {
                let value = dataSource.tableView(self, valueForRowAt: row, forColumnAt: column)
                let size = NSString(string: value).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 24), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : Fonts.tableFont], context: nil).size
                let stringWidth = size.width
                let itemWidth = stringWidth + 2*insetFromBorderToText + TableAttributes.gridWidth
                itemsWidth.append(itemWidth)
            }
            let maxLength = max(itemsWidth.max()!, width)
            columnWidths.append(maxLength)
        }
    }
    
}

extension TableView {
    
    enum SupplementaryViewType: String {
        
        case columnHeader = "TableViewColumnHeader"
        case rowEnumerator = "TableViewRowEnumerator"
        case enumeratorHeader = "TableViewEnumeratorHeader"
    }
}

enum TableAttributes {
    
    static let gridWidth: CGFloat = 2
    static let gridColor: CGColor = UIColor.lightGray.cgColor
    
}


