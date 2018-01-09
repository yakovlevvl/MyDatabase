//
//  ViewController.swift
//  MyDatabase
//
//  Created by Vladyslav Yakovlev on 27.11.2017.
//  Copyright © 2017 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

final class DatabasesVC: UIViewController {
    
    private let databasesManager = DatabasesManager()
    
    private let databasesView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset.top = 30
        flowLayout.sectionInset.bottom = 20
        flowLayout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = Colors.general
        return collectionView
    }()
    
    private let addDatabaseButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentMode = .center
        button.setImage(UIImage(named: "Plus"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 68, height: 68)
        button.layer.cornerRadius = button.frame.width/2
        button.backgroundColor = UIColor(red: 100/255, green: 144/255, blue: 215/255, alpha: 0.6)
        button.layer.shadowPath = UIBezierPath(ovalIn: button.bounds).cgPath
        button.layer.shadowOpacity = 0.65
        button.layer.shadowOffset = .zero
        button.layer.shadowColor = button.backgroundColor!.cgColor
        button.layer.shadowRadius = 6
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(addDatabaseButton)
        addDatabaseButton.frame.origin = CGPoint(x: view.frame.width - addDatabaseButton.frame.width - 20, y: view.frame.height - addDatabaseButton.frame.height - 20)
        addDatabaseButton.addTarget(self, action: #selector(tapAddDatabaseButton), for: .touchUpInside)
        
        databasesView.frame = view.frame
        databasesView.delegate = self
        databasesView.dataSource = self
        databasesView.register(DatabaseCell.self, forCellWithReuseIdentifier: DatabaseCell.reuseId)
        view.insertSubview(databasesView, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: .UIApplicationWillTerminate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: .UIApplicationDidEnterBackground, object: nil)
    }
    
    @objc private func saveData() {
        databasesManager.saveDatabasesToJson()
    }
    
    @objc private func tapAddDatabaseButton() {
        let newDatabaseVC = NewDatabaseVC()
        newDatabaseVC.delegate = self
        present(newDatabaseVC, animated: true)
    }
    
}

extension DatabasesVC: DatabaseDelegate {
    
    func databaseDeleted(_ database: Database) {
        databasesManager.deleteDatabase(database)
        databasesView.reloadData()
    }
}

extension DatabasesVC: NewDatabaseDelegate {
    
    func newDatabaseCreated(with name: String) {
        databasesManager.createDatabase(name: name)
        databasesView.reloadData()
    }
}

extension DatabasesVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return databasesManager.databasesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DatabaseCell.reuseId, for: indexPath) as! DatabaseCell
        let name = databasesManager.databases[indexPath.item].name
        cell.setDatabaseName(name)
        return cell
    }
}

extension DatabasesVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let database = databasesManager.databases[indexPath.item]
        let databaseVC = DatabaseVC()
        databaseVC.database = database
        databaseVC.delegate = self
        present(databaseVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 60, height: 100)
    }
}


