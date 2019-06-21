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
        
        NotificationCenter.default.addObserver(self,
                                               selector: .tapCloseButton,
                                               name: .imageDidSave,
                                               object: nil)
    }
    
    @objc func tapCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func reloadCollectionView(_ noti: Notification) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
    
        return doodleCell
    }
}

extension Selector {
    static let tapCloseButton = #selector(DoodleViewController.tapCloseButton)
}
