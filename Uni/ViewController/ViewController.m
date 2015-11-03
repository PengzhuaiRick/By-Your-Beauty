//
//  ViewController.m
//  Uni
//
//  Created by apple on 15/10/27.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    CGPoint currentPoint;
   
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.view addSubview:_tv.view];

    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan1:)];
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
       // self.navigationController.navigationBar.frame = CGRectMake(self.navigationController.navigationBar.frame.origin.x+100, self.navigationController.navigationBar.frame.origin.y, self.navigationController.navigationBar.frame.size.width,self.navigationController.navigationBar.frame.size.height);
        _tv.view.frame = CGRectMake(100, 0, self.view.frame.size.width,self.view.frame.size.height);
    }];
}


-(void)handlePan1:(UIPanGestureRecognizer*)pan{
     CGPoint point = [pan translationInView:[self view]];
    NSLog(@"%@",NSStringFromCGPoint(point));
    if (pan.state == UIGestureRecognizerStateBegan) {
        currentPoint = point;
    }if (pan.state == UIGestureRecognizerStateChanged) {
         _tv.view.frame = CGRectMake(_tv.view.frame.origin.x+(point.x-currentPoint.x), 0, self.view.frame.size.width,self.view.frame.size.height);
        currentPoint = point;
    }

   
}

@end
