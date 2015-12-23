//
//  FocusableCollectionViewCell.swift
//  ProductApp
//
//  Created by Gabriel Petrescu on 12/22/15.
//  Copyright © 2015 OwnZones. All rights reserved.
//

import UIKit

class FocusableCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var overlayedFocusableImageView:UIImageView!
    
    override func canBecomeFocused() -> Bool {
        return true
    }
    
    override func didUpdateFocusInContext(context:UIFocusUpdateContext, withAnimationCoordinator coordinator:UIFocusAnimationCoordinator) {
        
        if context.nextFocusedView == self {
            
            coordinator.addCoordinatedAnimations({
                self.transform = CGAffineTransformMakeScale(1.15, 1.15)
                
                }, completion: {
            })
            
//            UIView.animateWithDuration(0.3, animations: {
//                self.transform = CGAffineTransformMakeScale(1.15, 1.15)
//            })
            
        } else {
            
            coordinator.addCoordinatedAnimations({
                self.transform = CGAffineTransformMakeScale(1, 1)
                
                }, completion: {
            })
            
//            UIView.animateWithDuration(0.3, animations: {
//                self.transform = CGAffineTransformMakeScale(1.0, 1.0)
//            })
        }
    }
    
}