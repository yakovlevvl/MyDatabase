//
//  TableViewLayout.swift
//  MyDatabase
//
//  Created by Vladyslav Yakovlev on 02.01.2018.
//  Copyright © 2018 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

final class TableViewLayout: UICollectionViewLayout {
    
    private let tableView: TableView
    
    private var numberOfRows = 0
    
    private var cache = [UICollectionViewLayoutAttributes]()
    private var headerAttributesCache = [UICollectionViewLayoutAttributes]()
    private var enumeratorAttributesCache = [UICollectionViewLayoutAttributes]()
    private var enumeratorHeaderAttributes = UICollectionViewLayoutAttributes()
    private var contentSize = CGSize.zero
    
    init(tableView: TableView) {
        self.tableView = tableView
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func prepare() {
        super.prepare()
        
        guard cache.isEmpty else { return }
        
        numberOfRows = tableView.numberOfRows
        let numberOfColumns = tableView.numberOfColumns
        
        if numberOfRows == 0 { return }
        
        tableView.calculateColumnWidths()
        tableView.calculateEnumeratorColumnWidth()
        
        contentSize.width += tableView.columnWidths.reduce(tableView.enumeratorColumnWidth) { $0 + $1 }
        contentSize.height += tableView.rowHeight + tableView.rowHeight*CGFloat(numberOfRows)
        
        var xOffsets = [CGFloat]()
        var yOffsets = [CGFloat]()
        
        for column in 0..<numberOfColumns {
            let columnXOffset = tableView.columnWidths[0..<column].reduce(tableView.enumeratorColumnWidth) { $0 + $1 }
            xOffsets.append(columnXOffset)
        }
        
        for row in 0..<numberOfRows {
            yOffsets.append(CGFloat(row) * tableView.rowHeight + tableView.rowHeight)
        }
        
        for column in 0..<numberOfColumns {
            let width = tableView.widthForColumn(index: column)
            for row in 0..<numberOfRows {
                let indexPath = IndexPath(item: column, section: row)
                let frame = CGRect(x: xOffsets[column], y: yOffsets[row], width: width, height: tableView.rowHeight)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                cache.append(attributes)
            }
        }
        
        for column in 0..<numberOfColumns {
            let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: TableView.SupplementaryViewType.columnHeader.rawValue, with: IndexPath(index: column))
            let frame = CGRect(x: xOffsets[column], y: 0, width: tableView.widthForColumn(index: column), height: tableView.rowHeight)
            headerAttributes.frame = frame
            headerAttributes.zIndex = 2
            headerAttributesCache.append(headerAttributes)
        }
        
        for row in 0..<numberOfRows {
            let enumeratorAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: TableView.SupplementaryViewType.rowEnumerator.rawValue, with: IndexPath(index: row))
            let frame = CGRect(x: 0, y: yOffsets[row], width: tableView.enumeratorColumnWidth, height: tableView.rowHeight)
            enumeratorAttributes.frame = frame
            enumeratorAttributes.zIndex = 2
            enumeratorAttributesCache.append(enumeratorAttributes)
        }
        
        enumeratorHeaderAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: TableView.SupplementaryViewType.enumeratorHeader.rawValue, with: IndexPath(index: 0))
        let frame = CGRect(x: 0, y: 0, width: tableView.enumeratorColumnWidth, height: tableView.rowHeight)
        enumeratorHeaderAttributes.frame = frame
        enumeratorHeaderAttributes.zIndex = 3
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if numberOfRows == 0 { return nil }
        
        let layoutAttributes = cache.filter { $0.frame.intersects(rect) }
        
        for headerAttributes in headerAttributesCache {
            if collectionView!.contentOffset.y >= 0 {
                headerAttributes.frame.origin.y = collectionView!.contentOffset.y
            } else {
                headerAttributes.frame.origin.y = cache.first!.frame.origin.y - tableView.rowHeight
            }
        }
        
        for enumeratorAttributes in enumeratorAttributesCache {
            if collectionView!.contentOffset.x >= 0 {
                enumeratorAttributes.frame.origin.x = collectionView!.contentOffset.x
            } else {
                enumeratorAttributes.frame.origin.x = cache.first!.frame.origin.x - tableView.enumeratorColumnWidth
            }
        }
        
        if let firstAttributes = enumeratorAttributesCache.first {
            enumeratorHeaderAttributes.frame.origin.x = firstAttributes.frame.origin.x
            enumeratorHeaderAttributes.frame.origin.y = headerAttributesCache.first!.frame.origin.y
        }
        
        return layoutAttributes + headerAttributesCache + enumeratorAttributesCache + [enumeratorHeaderAttributes]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func clearLayoutCache() {
        cache.removeAll()
        headerAttributesCache.removeAll()
        enumeratorAttributesCache.removeAll()
        contentSize = .zero
    }
}

