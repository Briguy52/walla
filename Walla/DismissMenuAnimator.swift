//
//  DismissMenuAnimator.swift
//  Walla
//
//  Created by Timothy Choh on 6/24/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit

class DismissMenuAnimator : NSObject {
}

extension DismissMenuAnimator : UIViewControllerAnimatedTransitioning {
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
		return 0.6
	}
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		guard
			let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
			let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
			let containerView = transitionContext.containerView()
			else {
				return
		}
		// 1
		let snapshot = containerView.viewWithTag(MenuHelper.snapshotNumber)
		
		UIView.animateWithDuration(
			transitionDuration(transitionContext),
			animations: {
				// 2
				snapshot?.frame = CGRect(origin: CGPoint.zero, size: UIScreen.mainScreen().bounds.size)
			},
			completion: { _ in
				let didTransitionComplete = !transitionContext.transitionWasCancelled()
				if didTransitionComplete {
					// 3
					containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
					snapshot?.removeFromSuperview()
				}
				transitionContext.completeTransition(didTransitionComplete)
			}
		)
	}
}