//
//  YLPopAnimator.swift
//  YLPhotoBrowser
//
//  Created by yl on 2017/7/25.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit

class YLPopAnimator: NSObject,UIViewControllerAnimatedTransitioning {
    
    var transitionImage: UIImage?
    var transitionImageView: UIView?
    var transitionOriginalImgFrame: CGRect = CGRect.zero
    var transitionBrowserImgFrame: CGRect = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 转场过渡的容器view
        let containerView = transitionContext.containerView
        
        // FromVC
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let fromView = fromViewController?.view
        fromView?.isHidden = true
        
        // ToVC
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let toView = toViewController?.view
        containerView.addSubview(toView!)
        toView?.isHidden = false
        
        // 有渐变的黑色背景
        let bgView = UIView.init(frame: containerView.bounds)
        bgView.backgroundColor = PhotoBrowserBG
        bgView.alpha = 1
        containerView.addSubview(bgView)
        
        if transitionOriginalImgFrame == CGRect.zero ||
            (transitionImage == nil && transitionImageView == nil) {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                bgView.alpha = 0
                
            }, completion: { (finished:Bool) in
                
                bgView.removeFromSuperview()
                
                // 设置transitionContext通知系统动画执行完毕
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
            return
        }
        
        // 过渡的图片
        let transitionImgView = transitionImageView ?? UIImageView.init(image: self.transitionImage)
        transitionImgView.frame = self.transitionBrowserImgFrame
        containerView.addSubview(transitionImgView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.curveLinear, animations: { [weak self] in
            
            transitionImgView.frame = (self?.transitionOriginalImgFrame)!
            bgView.alpha = 0
            
        }) { (finished:Bool) in
            
            bgView.removeFromSuperview()
            transitionImgView.removeFromSuperview()
            
            //  设置transitionContext通知系统动画执行完毕
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        }
    }
    
}
