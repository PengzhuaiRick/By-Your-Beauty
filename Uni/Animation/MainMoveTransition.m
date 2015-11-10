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

@implementation MainMoveTransition
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.6f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    MainViewController* mv = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MainMidController* md = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
      UIView *containerView = [transitionContext containerView];
    
    CGRect re = mv.midView.frame;
    md.view.frame = [transitionContext finalFrameForViewController:md];
    md.view.alpha = 0;
    [md.view removeFromSuperview];
    [containerView addSubview:md.view];
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
        md.view.alpha = 1;
        mv.midView.frame = CGRectMake(0, 64,KMainScreenWidth, KMainScreenHeight-64);
        
    } completion:^(BOOL finished) {
        mv.midView.frame = re;
        //告诉系统动画结束
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];

}
@end
