//
//  UNWelcomeController.m
//  Uni
//  欢迎界面
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNWelcomeController.h"
//#import "EAIntroView.h"
#import "AppDelegate.h"
#import "BaseRequest.h"
@interface UNWelcomeController (){
    
}
@property (weak, nonatomic) IBOutlet UIImageView *rotationImg;

@end

@implementation UNWelcomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self rotationTheImg];
    [self startRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 旋转光圈 开始旋转
-(void)rotationTheImg{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;
    [_rotationImg.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [self performSelector:@selector(rotationTheImg) withObject:nil afterDelay:2.5];
}
-(void)startRequest{
    BaseRequest* rq = [[BaseRequest alloc]init];
    rq.rqfirstUrl=^(int code){
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self intoSystem];
            [self performSelector:@selector(intoSystem) withObject:nil afterDelay:3];
        });
    };
    [rq firstRequestUrl];
}


#pragma mark 跳转到主页面

- (void)intoSystem
{
    AppDelegate* app =  [UIApplication sharedApplication].delegate;
    [app judgeFirstTime];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
