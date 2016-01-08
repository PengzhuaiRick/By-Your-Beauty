//
//  MainMidMoveBackTransition.m
//  Uni
//
//  Created by apple on 15/11/6.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainMidMoveBackTransition.h"
#import "MainMidController.h"
#import "MainViewController.h"
#import "MainBottomController.h"
@implementation MainMidMoveBackTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.8f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    MainViewController* to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    //UIView* snapShow = [from.view snapshotViewAfterScreenUpdates:YES];
    to.view.alpha = 0.5;
    [containerView addSubview:to.view];
    

    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
        from.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
        from.view.alpha = 0.5;
        if ([from isKindOfClass:[MainMidController class]])
            to.midView.transform = CGAffineTransformIdentity;
        else if ([from isKindOfClass:[MainBottomController class]])
            to.buttomView.transform = CGAffineTransformIdentity;
        to.view.alpha = 1;
    } completion:^(BOOL finished) {
        //告诉系统动画结束
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
}

@end
