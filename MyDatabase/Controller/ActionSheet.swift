//
//  ActionSheetController.swift
//  MyDatabase
//
//  Created by Vladyslav Yakovlev on 02.01.2018.
//  Copyright © 2018 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

final class ActionSheet: UIViewController {
    
    private var window: UIWindow?
    
    private var actions = [Action]()
    
    var actionCellHeight: CGFloat = 68
    var separatorWidth: CGFloat = 2
    var separatorColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    var backgroundColor = UIColor.white
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize.width = UIScreen.main.bounds.width
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    
    init() {
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
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize.height = actionCellHeight
        layout.minimumLineSpacing = separatorWidth
        
        if separatorWidth == 0 {
            layout.sectionInset.top = actionCellHeight/6
            layout.sectionInset.bottom = actionCellHeight/6
            collectionView.backgroundColor = backgroundColor
        } else {
            collectionView.backgroundColor = separatorColor
        }
        
        let contentHeight = calculateContentHeight()
        
        collectionView.frame.origin.x = 0
        collectionView.frame.origin.y = view.frame.height
        collectionView.frame.size = CGSize(width: view.frame.width, height: contentHeight)
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ActionCell.self, forCellWithReuseIdentifier: ActionCell.reuseId)
        
        UIView.animate(withDuration: 0.45, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            self.collectionView.frame.origin.y -= self.collectionView.frame.height
            self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        })
    }
    
    func addAction(_ action: Action) {
        actions.append(action)
    }
    
    private func calculateContentHeight() -> CGFloat {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        return actionCellHeight*CGFloat(actions.count) + separatorWidth*CGFloat(actions.count - 1) + layout.sectionInset.top + layout.sectionInset.bottom
    }
    
    func present() {
        if actions.isEmpty { return }
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
        window!.isHidden = false
        if cancelActions.count == 1 {
            let cancelAction = cancelActions.first!
            let actionIndex = actions.index {
                $0.type == .cancel
            }
            actions.remove(at: actionIndex!)
            actions.append(cancelAction)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCancelAction))
            tapGesture.delegate = self
            view.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc private func dismiss() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: [], animations: {
            self.collectionView.frame.origin.y = self.view.frame.height
            self.view.backgroundColor = UIColor(white: 0, alpha: 0)
        }, completion: { _ in
            self.window = nil
        })
    }
    
    @objc private func tapCancelAction() {
        let cancelAction = actions.first {
            $0.type == .cancel
        }
        cancelAction!.handler?(cancelAction!)
        dismiss()
    }
    
}

extension ActionSheet: UICollectionViewDataSource {
    
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
}

extension ActionSheet: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.item]
        action.handler?(action)
        dismiss()
    }
}

extension ActionSheet: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == view
    }
}

final class ActionCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.actionSheet
        label.textAlignment = .center
        return label
    }()
    
    static let reuseId = "ActionCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        titleLabel.frame = contentView.bounds
        contentView.addSubview(titleLabel)
    }
    
    func setupTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setupTitleColor(_ color: UIColor) {
        titleLabel.textColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct Action {
    
    private(set) var title: String
    
    private(set) var type: ActionType
    
    private(set) var handler: ((Action) -> ())?
    
    init(title: String, type: ActionType, handler: ((Action) -> ())? = nil) {
        self.title = title
        self.type = type
        self.handler = handler
    }
}

enum ActionType {
    
    case normal

    case cancel
    
    case destructive
}
