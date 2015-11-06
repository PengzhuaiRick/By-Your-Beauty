//
//  ViewController.m
//  Uni
//  功能界面
//  Created by apple on 15/10/27.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate>
{
    CGPoint currentPoint;
   
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:_tv.view];

    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan1:)];
    pan.delegate = self;
    //[self.view addGestureRecognizer:pan];
    
    UISwipeGestureRecognizer* swipeL = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    swipeL.delegate = self;
    swipeL.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeL];
    
    UISwipeGestureRecognizer* swipeR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    swipeR.delegate = self;
    swipeR.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeR];
}
-(void)viewWillAppear:(BOOL)animated{
     self.navigationController.navigationBarHidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)shouye:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        _tv.view.frame = CGRectMake(100, 0, self.view.frame.size.width,self.view.frame.size.height);
    }];
}


-(void)handlePan1:(UIPanGestureRecognizer*)pan{
     CGPoint point = [pan translationInView:[self view]];
    //NSLog(@"%@",NSStringFromCGPoint(point));
    if (pan.state == UIGestureRecognizerStateBegan) {
        currentPoint = point;
    }if (pan.state == UIGestureRecognizerStateChanged) {
         _tv.view.frame = CGRectMake(_tv.view.frame.origin.x+(point.x-currentPoint.x), 0, self.view.frame.size.width,self.view.frame.size.height);
        currentPoint = point;
    }
}

-(void)handleSwipe:(UISwipeGestureRecognizer*)swipe{
    NSLog(@"%lu",(unsigned long)swipe.direction);
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
