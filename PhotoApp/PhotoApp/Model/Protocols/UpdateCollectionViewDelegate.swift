//
//  UpdateCollectionViewDelegate.swift
//  PhotoApp
//
//  Created by 심 승민 on 2018. 4. 17..
//  Copyright © 2018년 심 승민. All rights reserved.
//

import Photos

protocol UpdateCollectionViewDelegate {
    func updateCollectionView(_ changes: PHFetchResultChangeDetails<PHAsset>)
}
