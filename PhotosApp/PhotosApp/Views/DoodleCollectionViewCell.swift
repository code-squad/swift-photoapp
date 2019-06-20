//
//  DoodleCollectionViewCell.swift
//  PhotosApp
//
//  Created by 조재흥 on 19. 6. 20..
//  Copyright © 2019 hngfu. All rights reserved.
//

import UIKit

class DoodleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    static let identifier = "doodleCollectionViewCell"
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                      action: .targetDidLongPress)
        self.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == .saveMenuItemDidTap {
            return true
        }
        return false
    }
    
    func showHandler() -> (Data) -> Void {
        let show = { (data: Data) -> Void in
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        return show
    }
    
    @objc func targetDidLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            self.becomeFirstResponder()
            let menuItem = UIMenuItem(title: "Save", action: .saveMenuItemDidTap)
            UIMenuController.shared.menuItems = [menuItem]
            guard let superView = self.superview else { return }
            UIMenuController.shared.setTargetRect(self.frame,
                                                  in: superView)
            UIMenuController.shared.setMenuVisible(true, animated: true)
        }
    }
    
    @objc func saveMenuItemDidTap() {
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        NotificationCenter.default.post(name: .imageDidSave, object: nil)
    }
}

extension Selector {
    static let targetDidLongPress = #selector(DoodleCollectionViewCell.targetDidLongPress)
    static let saveMenuItemDidTap = #selector(DoodleCollectionViewCell.saveMenuItemDidTap)
}

extension NSNotification.Name {
    static let imageDidSave = NSNotification.Name("imageDidSave")
}
