//
//  DoodleViewController.swift
//  PhotosApp
//
//  Created by 조재흥 on 19. 6. 20..
//  Copyright © 2019 hngfu. All rights reserved.
//

import UIKit

class DoodleViewController: UICollectionViewController {
    
    private let doodleManager = DoodleManager()
    private var longPressedImage: UIImage?
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == .saveMenuItemDidTap {
            return true
        }
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "DoodleCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: DoodleCollectionViewCell.identifier)
        doodleManager.setUp(with: Configuration.DoodleViewController.doodlesURL)
        self.collectionView.backgroundColor = .darkGray
        self.title = "Doodles"
        let closeButton = UIBarButtonItem(title: "Close",
                                          style: .done,
                                          target: self,
                                          action: .tapCloseButton)
        self.navigationItem.setRightBarButton(closeButton, animated: false)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadCollectionView),
                                               name: .doodlesDidDownload,
                                               object: doodleManager)
    }
    
    @objc func tapCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func reloadCollectionView(_ noti: Notification) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @objc func targetDidLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            guard let cell = sender.view as? DoodleCollectionViewCell else { return }
            longPressedImage = cell.imageView.image
            let menuItem = UIMenuItem(title: "Save", action: .saveMenuItemDidTap)
            UIMenuController.shared.menuItems = [menuItem]
            UIMenuController.shared.setTargetRect(cell.frame,
                                                  in: collectionView)
            UIMenuController.shared.setMenuVisible(true, animated: true)
        }
    }
    
    @objc func saveMenuItemDidTap() {
        guard let image = longPressedImage else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return doodleManager.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DoodleCollectionViewCell.identifier, for: indexPath)
        guard let doodleCell = cell as? DoodleCollectionViewCell else { return cell }
        doodleManager.perform(with: doodleCell.showHandler(), from: indexPath.item)
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                      action: .targetDidLongPress)
        doodleCell.addGestureRecognizer(longPressGestureRecognizer)
        return doodleCell
    }
}

extension Selector {
    static let tapCloseButton = #selector(DoodleViewController.tapCloseButton)
    static let targetDidLongPress = #selector(DoodleViewController.targetDidLongPress)
    static let saveMenuItemDidTap = #selector(DoodleViewController.saveMenuItemDidTap)
}
