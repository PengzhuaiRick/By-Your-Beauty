//
//  LLARingSpinnerView.m
//  LLARingSpinnerView
//
//  Created by Lukas Lipka on 05/04/14.
//  Copyright (c) 2014 Lukas Lipka. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "LLARingSpinnerView.h"
#import "MBProgressHUD.h"

static NSString *kLLARingSpinnerAnimationKey = @"llaringspinnerview.rotation";

@interface LLARingSpinnerView ()

@property (nonatomic, readonly) CAShapeLayer *progressLayer;
@property (nonatomic, readwrite) BOOL isAnimating;

@end

@implementation LLARingSpinnerView

@synthesize progressLayer = _progressLayer;
@synthesize isAnimating = _isAnimating;

+(void)RingSpinnerViewStart{
    LLARingSpinnerView* view = [LLARingSpinnerView sharedInstance];
    view.lineWidth = 1.5;
    view.tintColor = [UIColor purpleColor];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    [view startAnimating];
}
+(void)RingSpinnerViewStop{
    LLARingSpinnerView* view = [LLARingSpinnerView sharedInstance];
    [view stopAnimating];
    [view removeFromSuperview];
}

+ (LLARingSpinnerView *)sharedInstance{
    static dispatch_once_t  onceToken;
    static LLARingSpinnerView *sSharedInstance;
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[LLARingSpinnerView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        sSharedInstance.center = CGPointMake(KMainScreenWidth/2, KMainScreenHeight/2);
    });
    return sSharedInstance;
}

+(void)RingSpinnerViewStart1andStyle:(int)style{
    
//    UIActivityIndicatorView* view = [LLARingSpinnerView sharedInstance1];
//    if(style == 1)
//        view.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//    if (style == 2) 
//         view.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    
//    //[[UIApplication sharedApplication].keyWindow addSubview:view];
//    [[[self class]getPresentedViewController].view addSubview:view]; 
//    [view startAnimating];
    
    [MBProgressHUD showHUDAddedTo:[[self class]getPresentedViewController].view animated:YES];
}
+(void)RingSpinnerViewStop1{
//    UIActivityIndicatorView* view = [LLARingSpinnerView sharedInstance1];
//    [view stopAnimating];
    //[view removeFromSuperview];
    
    [MBProgressHUD hideHUDForView:[[self class]getPresentedViewController].view animated:YES];
}
+ (UIActivityIndicatorView *)sharedInstance1{
    static dispatch_once_t  onceToken;
    static UIActivityIndicatorView *sSharedInstance;
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        sSharedInstance.center = CGPointMake(KMainScreenWidth/2, KMainScreenHeight/2);
    });
    return sSharedInstance;
}
#pragma mark 获取当前显示的viewController
+ (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
        
    }
    return self;
}

- (void)initialize {
    [self.layer addSublayer:self.progressLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.progressLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    [self updatePath];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];

    self.progressLayer.strokeColor = self.tintColor.CGColor;
}

- (void)startAnimating {
    if (self.isAnimating)
        return;

    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = 1.0f;
    animation.fromValue = @(0.0f);
    animation.toValue = @(2 * M_PI);
    animation.repeatCount = INFINITY;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    [self.progressLayer addAnimation:animation forKey:kLLARingSpinnerAnimationKey];
    self.isAnimating = true;
}

- (void)stopAnimating {
    if (!self.isAnimating)
        return;

    [self.progressLayer removeAnimationForKey:kLLARingSpinnerAnimationKey];
    self.isAnimating = false;
}

#pragma mark - Private

- (void)updatePath {
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = MIN(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2) - self.progressLayer.lineWidth / 2;
    CGFloat startAngle = (CGFloat)(-M_PI_4);
    CGFloat endAngle = (CGFloat)(3 * M_PI_2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.progressLayer.path = path.CGPath;
}

#pragma mark - Properties

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.strokeColor = self.tintColor.CGColor;
        _progressLayer.fillColor = nil;
        _progressLayer.lineWidth = 1.5f;
    }
    return _progressLayer;
}

- (BOOL)isAnimating {
    return _isAnimating;
}

- (CGFloat)lineWidth {
    return self.progressLayer.lineWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    self.progressLayer.lineWidth = lineWidth;
    [self updatePath];
}

@end
