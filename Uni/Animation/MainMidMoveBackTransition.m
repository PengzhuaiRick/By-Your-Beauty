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

@implementation MainMidMoveBackTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.6f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    MainViewController* mv = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    MainMidController* md = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    CGRect re = mv.midView.frame;
    UIView* snapShow = [md.view snapshotViewAfterScreenUpdates:YES];
    mv.view.frame = [transitionContext finalFrameForViewController:mv];
    [containerView addSubview:mv.view];
    [containerView addSubview:snapShow];

    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
        md.view.frame = re;
        md.view.alpha = 0;
        snapShow.frame = re;
        
    } completion:^(BOOL finished) {
        [mv.midView addSubview:md.view];
        [snapShow removeFromSuperview];
        //告诉系统动画结束
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
}

@end
