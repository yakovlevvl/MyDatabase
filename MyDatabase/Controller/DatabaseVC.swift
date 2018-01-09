//
//  DatabaseVC.swift
//  MyDatabase
//
//  Created by Vladyslav Yakovlev on 27.11.2017.
//  Copyright © 2017 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

final class DatabaseVC: UIViewController {
    
    var database: Database!
    
    weak var delegate: DatabaseDelegate?
    
    private let tablesView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset.top = 20
        flowLayout.sectionInset.bottom = 20
        flowLayout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 1)
        return collectionView
    }()
    
    private let deleteDatabaseButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Delete Database", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel!.font = UIFont(name: "Circe-Bold", size: 19)
        button.frame = CGRect(x: 0, y: 0, width: 0, height: 80)
        return button
    }()
    
    private let addTableButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentMode = .center
        button.setImage(UIImage(named: "Plus"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 68, height: 68)
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentMode = .center
        button.setImage(UIImage(named: "Back"), for: .normal)
        button.frame = CGRect(x: 8, y: 0, width: 68, height: 68)
        return button
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.frame.size = CGSize(width: 150, height: 24)
        label.font = UIFont(name: "Circe-Bold", size: 19)
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = tablesView.backgroundColor
        
        tablesView.frame = view.frame
        tablesView.frame.origin.y = 72
        tablesView.frame.size.height = view.frame.height - tablesView.frame.origin.y
        tablesView.delegate = self
        tablesView.dataSource = self
        tablesView.register(TableCell.self, forCellWithReuseIdentifier: TableCell.reuseId)
        view.insertSubview(tablesView, at: 0)
        
        deleteDatabaseButton.frame.size.width = view.frame.width
        deleteDatabaseButton.frame.origin.y = view.frame.height - deleteDatabaseButton.frame.height
        deleteDatabaseButton.addTarget(self, action: #selector(deleteDatabase), for: .touchUpInside)
        view.addSubview(deleteDatabaseButton)
        
        backButton.center.y = tablesView.frame.origin.y/2 + 8
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        view.addSubview(backButton)
        
        addTableButton.center.y = backButton.center.y
        addTableButton.frame.origin.x = view.frame.width - addTableButton.frame.width - 13
        addTableButton.addTarget(self, action: #selector(addTable), for: .touchUpInside)
        view.addSubview(addTableButton)
        
        topLabel.text = database.name
        topLabel.center.x = view.center.x
        topLabel.center.y = backButton.center.y + 1
        view.addSubview(topLabel)
    }
    
    @objc private func addTable() {
        let newTableVC = NewTableVC()
        newTableVC.delegate = self
        present(newTableVC, animated: true)
    }
    
    @objc private func deleteDatabase() {
        let alertVC = AlertController(message: "Delete database ?")
        alertVC.addAction(Action(title: "Cancel", type: .cancel))
        let removeAction = Action(title: "Delete", type: .destructive) { _ in
            self.delegate?.databaseDeleted(self.database)
            self.dismiss(animated: true)
        }
        alertVC.addAction(removeAction)
        alertVC.present()
    }
    
    @objc private func back() {
        dismiss(animated: true)
    }
    
}

extension DatabaseVC: NewTableDelegate {
    
    func newTableCreated(table: Table) {
        database.tables.append(table)
        tablesView.reloadData()
    }
}

extension DatabaseVC: TableDelegate {
    
    func tableRenamed() {
        tablesView.reloadData()
    }

    func tableDeleted(_ table: Table) {
        let index = database.tables.index { $0.id == table.id }
        database.tables.remove(at: index!)
        tablesView.reloadData()
    }
    
    func tableWithNameExists(name: String) -> Bool {
        return database.tables.contains { $0.name == name }
    }
}

extension DatabaseVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return database.tables.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableCell.reuseId, for: indexPath) as! TableCell
        let name = database.tables[indexPath.item].name
        cell.setTableName(name)
        return cell
    }
}

extension DatabaseVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let table = database.tables[indexPath.item]
        let manageTableVC = TableVC()
        manageTableVC.table = table
        manageTableVC.delegate = self
        present(manageTableVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 60, height: 100)
    }
}

protocol DatabaseDelegate: class {
    
    func databaseDeleted(_ database: Database)
}
