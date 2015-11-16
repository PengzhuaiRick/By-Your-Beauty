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
#import "MainMoveTransition.h"
#import "MainMidView.h"
#import "MainViewRequest.h"
#import "AccountManager.h"

@interface MainViewController ()<UINavigationControllerDelegate>{
    MainMidController* midController;
    MainBottomController* buttomController;
    __weak IBOutlet UIScrollView *myScroller;
    UIView* hahview;
    
    UIImageView* topView;
    UILabel* shopNameLab;
    UILabel* shopAddressLab;
    UIImageView* VIPImage;
    UIImageView* shopLogo;
}

@end

@implementation MainViewController

-(void)setupNavigation{
    self.title = @"首页";
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
    
}
-(void)viewWillDisappear:(BOOL)animated{
   self.navigationController.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self startRequestShopInfo];
    [self startRequestAppointInfo];
    [self setupNavigation];
    [self setupScroller];
    [self addChildController];
}

#pragma mark 请求店铺信息
-(void)startRequestShopInfo{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //AccountManager* manager = [AccountManager shared];
        MainViewRequest* request = [[MainViewRequest alloc]init];
        [request postWithSerCode:@[API_PARAM_UNI,API_URL_ShopInfo]
                          params:@{@"shopId":@(1),
                                   @"token":@"abcdxxa",
                                   @"userId":@(1)}];
        request.reshopInfoBlock=^(UNIShopManage* manager,NSString*tips,NSError* er){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!er) {
                    if (manager) {
                        self->shopNameLab.text = manager.shopName;
                        [self->shopLogo sd_setImageWithURL:[NSURL URLWithString:manager.logoUrl]
                                          placeholderImage:[UIImage imageNamed:@"main_img_shopLog"]];
                    }else
                        [YIToast showText:tips];
                    
                }else{
                    
                }
                
            });

        };
        
        //请求约满奖励
        MainViewRequest* request1 = [[MainViewRequest alloc]init];
        [request1 postWithSerCode:@[API_PARAM_UNI,API_URL_MRInfo]
                          params:@{@"shopId":@(1),
                                   @"token":@"abcdxxa",
                                   @"userId":@(1)}];
        request1.rerewardBlock=^(int nextRewardNum,int num,NSString*tips,NSError* er){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!er) {
                    if (nextRewardNum!=-1) {
                        float jc = (self->topView.frame.size.width-30)/nextRewardNum;
                        for (int i = 0; i<nextRewardNum; i++) {
                            UIImageView* img = [[UIImageView alloc]initWithFrame:
                                                CGRectMake(10+(jc*i), self->topView.frame.size.height-40, jc, 14)];
                            if (i<num)
                                img.image = [UIImage imageNamed:@"main_img_bluePro"];
                            else
                                img.image = [UIImage imageNamed:@"main_img_proLess"];
                             [self->topView addSubview:img];
                            
                            UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(img.frame.size.width-10, 2, 10, 10)];
                            lab.text = [NSString stringWithFormat:@"%i",i+1];
                            lab.textColor = [UIColor whiteColor];
                            lab.textAlignment = NSTextAlignmentCenter;
                            lab.font = [UIFont boldSystemFontOfSize:8];
                            [img addSubview:lab];
                        }
                        UIImageView* awardImge = [[UIImageView alloc]initWithFrame:CGRectMake(self->topView.frame.size.width-35, self->topView.frame.size.height-55,30,35)];
                        if (nextRewardNum ==num)
                            awardImge.image = [UIImage imageNamed:@"main_img_award"];
                        else
                            awardImge.image = [UIImage imageNamed:@"main_img_unaward"];
                        [self->topView addSubview:awardImge];
                    }else
                        [YIToast showText:tips];
                }else{
                    
                }
            });
        };
    });

}

#pragma mark 开始请求我已预约项目
-(void)startRequestAppointInfo{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        MainViewRequest* request = [[MainViewRequest alloc]init];
        [request postWithSerCode:@[API_PARAM_UNI,API_URL_Appoint]
                          params:@{@"userId":@(1),
                                   @"token":@"abcdxxa",
                                   @"shopId":@(1),
                                   @"page":@(0),@"size":@(20)}];
    });
}

#pragma mark 设置Scroller
-(void)setupScroller{
    int sgd = 736;//最大高度
    int bj = 8;   //边界
    float gd = (sgd - bj*3)/3; //view 高度
    
    myScroller.contentSize = CGSizeMake(KMainScreenWidth, sgd);

    UIImage* imag =[UIImage imageNamed:@"main_img_top"];
    float imgH = imag.size.height*(KMainScreenWidth-bj*2)/imag.size.width;
    UIImageView* topImg = [[UIImageView alloc]initWithFrame:CGRectMake(bj,bj,KMainScreenWidth-bj*2,imgH)];
    topImg.image = imag;
    [myScroller addSubview:topImg];
    topView = topImg;
    
    [self setupTopImageSubView];
    
    
    _midView= [[UIView  alloc]initWithFrame:CGRectMake(bj,CGRectGetMaxY(topImg.frame)+bj, KMainScreenWidth-bj*2, gd)];
    _midView.layer.borderWidth = 1;
    _midView.layer.borderColor = [UIColor blackColor].CGColor;
    [myScroller addSubview:_midView];
    
    _buttomView= [[UIView  alloc]initWithFrame:CGRectMake(bj, CGRectGetMaxY(_midView.frame)+bj, KMainScreenWidth-bj*2, gd)];
    _buttomView.layer.borderWidth = 1;
    _buttomView.layer.borderColor = [UIColor blueColor].CGColor;
    [myScroller addSubview:_buttomView];
}

#pragma mark 设置顶图的子视图
-(void)setupTopImageSubView{
    
    float imgW = topView.frame.size.width*0.16;
    UIImageView* shopLog = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, imgW, imgW)];
    shopLog.image = [UIImage imageNamed:@"main_img_shopLog"];
    shopLog.contentMode = UIViewContentModeScaleAspectFit;
    [topView addSubview:shopLog];
    shopLogo = shopLog;
    
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shopLog.frame)+10,
                                                            15, topView.frame.size.width*0.7, 20)];
    lab.textColor = [UIColor colorWithRed:226/255.f green:52/255.f blue:105/255.f alpha:1];
    lab.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*0.041];
    lab.text = @"动静界健身美容尊尚会所";
    [topView addSubview:lab];
    shopNameLab = lab;
    
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shopLog.frame)+10,
                                                            CGRectGetMaxY(lab.frame), 100, 15)];
    lab2.textColor = [UIColor colorWithRed:226/255.f green:52/255.f blue:105/255.f alpha:1];
    lab2.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*0.03];
    lab2.text = @"体育东店";
    [topView addSubview:lab2];
    shopAddressLab = lab2;
    
    UIImageView* VIPimg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shopLog.frame)+10,
                                                                   CGRectGetMaxY(lab2.frame)+3, 100, 15)];
    VIPimg.image = [UIImage imageNamed:@"main_img_VIP"];
    VIPimg.contentMode = UIViewContentModeScaleAspectFit;
    [topView addSubview:VIPimg];
    VIPImage = VIPimg;
}

-(void)updataShopInfo{
    UNIShopManage* manager = [UNIShopManage getShopData];
    shopNameLab.text = manager.shopName;
}

-(void)fangda:(UIGestureRecognizer*)gesture{
  
       [self.navigationController pushViewController:midController animated:YES];
    
}
-(void)addChildController{
    UIStoryboard* main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    midController = [main instantiateViewControllerWithIdentifier:@"MainMidController"];
//    midController.tableView.frame = CGRectMake(0, 0, _midView.frame.size.width, _midView.frame.size.height);
    MainMidView* midview = [[MainMidView alloc]initWithFrame:CGRectMake(0, 0,  _midView.frame.size.width, _midView.frame.size.height) headerTitle:@"我已预约"];
    hahview = midview;
    [_midView addSubview:midview];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fangda:)];
    [_midView addGestureRecognizer:tap];
    
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
