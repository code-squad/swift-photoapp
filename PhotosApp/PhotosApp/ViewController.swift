//
//  ViewController.swift
//  PhotosApp
//
//  Created by TaeHyeonLee on 2018. 5. 21..
//  Copyright © 2018년 ChocOZerO. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photo", for: indexPath)
        let redElement = getRandomColor()
        let greenElement = getRandomColor()
        let blueElement = getRandomColor()
        let color = UIColor.init(red: redElement, green: greenElement, blue: blueElement, alpha: 1)
        cell.backgroundColor = color
        return cell
    }

    private func getRandomColor() -> CGFloat {
        return  CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

