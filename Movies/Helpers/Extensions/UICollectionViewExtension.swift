//
//  UICollectionViewExtension.swift
//  Movies
//
//  Created by Yves Bastos on 08/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import UIKit

extension UICollectionView {
    func showRefreshControl() {
        DispatchQueue.main.async {
            let controlHeight = self.refreshControl?.frame.height ?? 0
            self.setContentOffset(CGPoint(x: 0, y: -controlHeight), animated: true)
            self.refreshControl?.beginRefreshing()
        }
    }
    
    func hideRefreshControl() {
        DispatchQueue.main.async {
            self.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.refreshControl?.endRefreshing()
        }
    }
}
