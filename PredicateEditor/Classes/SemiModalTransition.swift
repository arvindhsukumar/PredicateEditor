//
//  SemiModalTransition.swift
//  Pods
//
//  Created by Arvindh Sukumar on 18/07/16.
//
//

import UIKit

protocol SemiModalViewable {
    var dimView: UIView! {get set}
}

class SemiModalTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var presenting: Bool = false
        
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return presenting ? 0.5 : 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey), let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey), let containerView = transitionContext.containerView() else
        {
            return
        }
        
        if(presenting)
        {
            containerView.addSubview(toViewController.view)
        }
        
        let animatingVC = presenting ? toViewController: fromViewController
        let animatingView = animatingVC.view
        
        var appearedFrame = transitionContext.finalFrameForViewController(animatingVC)
        var dismissedFrame = appearedFrame;
        dismissedFrame.origin.y += dismissedFrame.size.height
        
        var initialFrame = presenting ? dismissedFrame : appearedFrame
        var finalFrame = presenting ? appearedFrame : dismissedFrame
        
        animatingView.frame = initialFrame
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            
            animatingView.frame = finalFrame
            
        }) {
            finished in
            
            if !self.presenting {
                fromViewController.view.removeFromSuperview()
            }
            transitionContext.completeTransition(true)
            
        }
    }
}
