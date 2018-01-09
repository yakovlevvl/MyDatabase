//
//  AlertController.swift
//  MyDatabase
//
//  Created by Vladyslav Yakovlev on 05.01.2018.
//  Copyright © 2018 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

final class AlertController: UIViewController {
    
    private var window: UIWindow?
    
    private var actions = [Action]()
    
    private(set) var message: String
    
    var includeTextField = false
    var allowEmptyTextField = true
    
    private let actionCellHeight: CGFloat = 58
    private let separatorWidth: CGFloat = 2
    var separatorColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    var backgroundColor = UIColor.white
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isScrollEnabled = false
        collectionView.layer.cornerRadius = 12
        return collectionView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.actionSheet
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private(set) var textField: UITextField?
    
    
    init(message: String) {
        self.message = message
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        
        var alertHeaderHeight: CGFloat = 0
        let alertWidth = view.frame.width - 50
        let messageHorizontalInset: CGFloat = 20
        let messageVerticalInset: CGFloat = 28
        let textFieldHorizontalInset: CGFloat = 24
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        style.alignment = .center
        let attrString = NSAttributedString(string: message, attributes: [NSAttributedStringKey.paragraphStyle : style, NSAttributedStringKey.font : Fonts.actionSheet])
        
        let messageSize = attrString.boundingRect(with: CGSize(width: alertWidth - 2*messageHorizontalInset, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).size
        messageLabel.frame.size = messageSize
        messageLabel.center.x = alertWidth/2
        messageLabel.attributedText = attrString
        
        if includeTextField {
            textField = UITextField()
            textField!.font = Fonts.actionSheet
            textField!.borderStyle = .none
            textField!.textAlignment = .center
            textField!.frame.size = CGSize(width: alertWidth - 2*textFieldHorizontalInset, height: 26)
            alertHeaderHeight = 3*messageVerticalInset + messageSize.height + textField!.frame.height
            messageLabel.frame.origin.y = messageVerticalInset
            textField!.center.x = alertWidth/2
            textField!.frame.origin.y = messageLabel.frame.maxY + messageVerticalInset
        } else {
            alertHeaderHeight = 2*messageVerticalInset + messageSize.height
            messageLabel.center.y = alertHeaderHeight/2
        }
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.sectionInset.top = separatorWidth
        
        if actions.count == 2 {
            layout.minimumInteritemSpacing = separatorWidth
            layout.itemSize = CGSize(width: (alertWidth - separatorWidth)/2, height: actionCellHeight)
        } else {
            layout.minimumLineSpacing = separatorWidth
            layout.itemSize = CGSize(width: alertWidth, height: actionCellHeight + 2)
        }
        
        layout.headerReferenceSize = CGSize(width: alertWidth, height: alertHeaderHeight)
        
        let contentHeight = calculateContentHeight()
        
        collectionView.frame.origin.y = view.frame.height
        collectionView.frame.size = CGSize(width: alertWidth, height: contentHeight)
        collectionView.center.x = view.center.x
        collectionView.backgroundColor = separatorColor
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ActionCell.self, forCellWithReuseIdentifier: ActionCell.reuseId)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "cell")
        
        if includeTextField {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: .UIKeyboardWillChangeFrame, object: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.textField!.becomeFirstResponder()
            }
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
                self.collectionView.center = self.view.center
                self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            })
        }
    }
    
    func addAction(_ action: Action) {
        actions.append(action)
    }
    
    private func calculateContentHeight() -> CGFloat {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        var height: CGFloat = 0
        if actions.count == 2 {
            height = layout.itemSize.height
        } else {
            height = layout.itemSize.height*CGFloat(actions.count) + layout.minimumLineSpacing*CGFloat(actions.count - 1)
        }
        return height + layout.sectionInset.top + layout.headerReferenceSize.height
    }
    
    func present() {
        if actions.isEmpty {
            fatalError("AlertController must include at least one action.")
        }
        let cancelActions = actions.filter {
            $0.type == .cancel
        }
        if cancelActions.count > 1 {
            fatalError("ActionSheet can include only one cancel action.")
        }
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = self
        window!.backgroundColor = .clear
        window!.windowLevel = UIWindowLevelAlert
        window!.makeKeyAndVisible()
        if cancelActions.count == 1 {
            let cancelAction = cancelActions.first!
            let actionIndex = actions.index {
                $0.type == .cancel
            }
            actions.remove(at: actionIndex!)
            if actions.count == 1 {
                actions.insert(cancelAction, at: 0)
            } else {
               actions.append(cancelAction)
            }
        }
    }
    
    @objc private func dismiss() {
        let duration = includeTextField ? 0.5 : 0.45
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: [], animations: {
            self.collectionView.frame.origin.y = self.view.frame.height
            self.view.backgroundColor = UIColor(white: 0, alpha: 0)
            self.textField?.resignFirstResponder()
        }, completion: { _ in
            self.window = nil
        })
    }
    
    @objc private func keyboardWillChangeFrame(notification: Notification) {
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue!
        if frame.origin.y == view.frame.height { return }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            self.collectionView.frame.origin.y = frame.origin.y - 40 - self.collectionView.frame.height
            self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension AlertController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActionCell.reuseId, for: indexPath) as! ActionCell
        let action = actions[indexPath.item]
        cell.setupTitle(action.title)
        cell.backgroundColor = backgroundColor
        if action.type == .destructive {
            cell.setupTitleColor(.red)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "cell", for: indexPath)
        view.backgroundColor = backgroundColor
        view.addSubview(messageLabel)
        if let textField = textField {
            view.addSubview(textField)
        }
        return view
    }
}

extension AlertController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.item]
        if includeTextField, !allowEmptyTextField, action.type != .cancel {
            if textField!.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                return
            }
        }
        action.handler?(action)
        dismiss()
    }
}


