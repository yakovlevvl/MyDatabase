
//
//  NewDatabaseVC.swift
//  MyDatabase
//
//  Created by Vladyslav Yakovlev on 27.11.2017.
//  Copyright © 2017 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

final class NewDatabaseVC: UIViewController {
    
    weak var delegate: NewDatabaseDelegate?
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.frame.size = CGSize(width: 150, height: 24)
        label.font = UIFont(name: "Circe-Bold", size: 19)
        label.textAlignment = .center
        label.text = "New Database"
        return label
    }()

    private let textField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 240, height: 24))
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.placeholder = "Name"
        textField.returnKeyType = .done
        textField.font = UIFont(name: "Circe-Bold", size: 19)
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(textField)
        textField.center.x = view.center.x
        textField.frame.origin.y = 180
        textField.delegate = self
        textField.becomeFirstResponder()
        
        topLabel.center.x = view.center.x
        topLabel.frame.origin.y = 46
        
        view.addSubview(topLabel)
    }

}

extension NewDatabaseVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let name = textField.text?.trimmingCharacters(in: .whitespaces), name.count > 0, name.count < 25 {
            textField.resignFirstResponder()
            delegate?.newDatabaseCreated(with: name)
            dismiss(animated: true)
        }
        return true
    }
}

protocol NewDatabaseDelegate: class {
    
    func newDatabaseCreated(with name: String)
}


