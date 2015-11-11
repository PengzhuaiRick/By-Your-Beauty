//
//  MainViewController.m
//  Uni
//  首页界面
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainViewController.h"
#import "MainMidController.h"
#import "MainBottomController.h"
#import "MainViewModel.h"
#import "MainMoveTransition.h"
#import "MainMidView.h"

@interface MainViewController ()<UINavigationControllerDelegate>{
    UIView* topView;
    MainMidController* midController;
    MainBottomController* buttomController;
    __weak IBOutlet UIScrollView *myScroller;
}

@end

@implementation MainViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupScroller];
    [self addChildController];
   
    
    NSNumber* num = [NSNumber numberWithInt:2];
    NSDictionary* dic = [NSDictionary dictionaryWithObject:num forKey:@"type"];
    MainViewModel* model = [[MainViewModel alloc]init];
    [model requestViewModelCheckVersion:API_URL_CheckVersion andParams:dic];
}
-(void)setupNavigation{
    self.title = @"首页";
    //[self.navigationController.navigationBar setBarTintColor:[UIColor yellowColor]];
}

#pragma mark 设置Scroller
-(void)setupScroller{
    int sgd = 736;
    int bj = 8;
    float gd = (sgd - bj*3)/3;
    
    myScroller.contentSize = CGSizeMake(KMainScreenWidth, sgd);
    
    topView= [[UIView  alloc]initWithFrame:CGRectMake(8, 8, KMainScreenWidth-16, gd)];
    topView.backgroundColor = [UIColor redColor];
    [myScroller addSubview:topView];
    
    _midView= [[UIView  alloc]initWithFrame:CGRectMake(8,CGRectGetMaxY(topView.frame)+8, KMainScreenWidth-16, gd)];
    _midView.backgroundColor = [UIColor blackColor];
    _midView.layer.borderWidth = 1;
    _midView.layer.borderColor = [UIColor blackColor].CGColor;
    [myScroller addSubview:_midView];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fangda)];
    [_midView addGestureRecognizer:tap];
    
    _buttomView= [[UIView  alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(_midView.frame)+8, KMainScreenWidth-16, gd)];
    _buttomView.backgroundColor = [UIColor blueColor];
    _buttomView.layer.borderWidth = 1;
    _buttomView.layer.borderColor = [UIColor blueColor].CGColor;
    [myScroller addSubview:_buttomView];
}

-(void)fangda{
    [self.navigationController pushViewController:midController animated:YES];
}
-(void)addChildController{
    UIStoryboard* main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    midController = [main instantiateViewControllerWithIdentifier:@"MainMidController"];
//    midController.tableView.frame = CGRectMake(0, 0, _midView.frame.size.width, _midView.frame.size.height);
    MainMidView* midview = [[MainMidView alloc]initWithFrame:CGRectMake(0, 0,  _midView.frame.size.width, _midView.frame.size.height) headerTitle:@"我已预约"];
    [_midView addSubview:midview];
    
//    buttomController = [main instantiateViewControllerWithIdentifier:@"MainBottomController"];
//    buttomController.tableView.scrollEnabled = NO;
   // [self addChildViewController:buttomController];
    //buttomController.view.frame = CGRectMake(0, 0, _buttomView.frame.size.width, _buttomView.frame.size.height);
    MainMidView* bottomView = [[MainMidView alloc]initWithFrame:CGRectMake(0, 0,  _buttomView.frame.size.width, _buttomView.frame.size.height) headerTitle:@"未预约"];
    [_buttomView addSubview:bottomView];
    
}

#pragma mark <UINavigationControllerDelegate>
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    
    if ([toVC isKindOfClass:[MainMidController class]]) {
        MainMoveTransition *transition = [[MainMoveTransition alloc]init];
        return transition;
    }else{
        return nil;
    }
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
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
