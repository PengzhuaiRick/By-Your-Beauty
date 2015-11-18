//
//  MainMoveTransition.m
//  Uni
//
//  Created by apple on 15/11/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainMoveTransition.h"
#import "MainMidController.h"
#import "MainViewController.h"
#import "MainBottomController.h"
@implementation MainMoveTransition
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 1.f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    MainViewController* from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
      UIView *containerView = [transitionContext containerView];
    [containerView addSubview:to.view];
    to.view.alpha = 0;
    to.view.transform = CGAffineTransformMakeScale(0.8, 0.8);

    
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if ([to isKindOfClass:[MainMidController class]])
            from.midView.transform = CGAffineTransformMakeScale(2,2);
        else if ([to isKindOfClass:[MainBottomController class]])
            from.buttomView.transform = CGAffineTransformMakeScale(2,2);
        from.view.alpha = 0;
        
        to.view.transform = CGAffineTransformMakeScale(1, 1);
        to.view.alpha = 1;
   
       
    } completion:^(BOOL finished) {
       // from.view.transform = CGAffineTransformIdentity;
        //mv.midView.frame = re;
        //告诉系统动画结束
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];

}
@end
