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
    CGPoint startPoint;
    CGPoint currentPoint;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:_tv.view];

    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan1:)];
    //pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    
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
   // NSLog(@" 恶风   %@",NSStringFromCGPoint(point));
    if (pan.state == UIGestureRecognizerStateBegan) {
        startPoint = point;
        currentPoint = point;
    }
    else if (pan.state == UIGestureRecognizerStateChanged) {
        float offX =_tv.view.frame.origin.x+(point.x-currentPoint.x);
        if (offX>-1 && offX<KMainScreenWidth-101){
            _tv.view.frame = CGRectMake(offX,
                                     0,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height);
            currentPoint = point;
        }
    }
    else if(pan.state == UIGestureRecognizerStateEnded){
        float offset = currentPoint.x - startPoint.x;
        if (offset>0) {
            if (offset>80)
            [UIView animateWithDuration:0.2 animations:^{
                _tv.view.frame = CGRectMake(KMainScreenWidth-100, 0, self.view.frame.size.width,self.view.frame.size.height);
            }];
            else
                [UIView animateWithDuration:0.2 animations:^{
                    _tv.view.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
                }];
        }else if (offset<0 ){
            if (offset < -80)
                [UIView animateWithDuration:0.2 animations:^{
                    _tv.view.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
                }];
            else
                [UIView animateWithDuration:0.2 animations:^{
                    _tv.view.frame = CGRectMake(KMainScreenWidth-100, 0, self.view.frame.size.width,self.view.frame.size.height);
                }];

            
        }
    }
}

//-(void)handleSwipe:(UISwipeGestureRecognizer*)swipe{
//    NSLog(@"谁打我  %lu",(unsigned long)swipe.direction);
//}
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}
@end
