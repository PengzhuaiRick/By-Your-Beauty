//
//  UNIAppointController.m
//  Uni
//  预约界面
//  Created by apple on 15/11/24.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppointController.h"
#import "UNIAppointTop.h"
#import "UNIAppontMid.h"
#import "UNIMyPojectList.h"
#import "AccountManager.h"
#import "UNIShopView.h"
#import "UNIShopListController.h"
//#import "UNIMyProjectModel.h"
@interface UNIAppointController ()<UNIMyPojectListDelegate,UNIAppontMidDelegate,UNIShopListControllerDelegate>
{
    UNIShopModel* shopModel;
    UNIShopView* shopView;
    UNIAppointTop* appointTop;
    UNIAppontMid* appontMid;
    //UNIAppointBotton* appointBotton;
    UIButton* sureBtn; //马上预约按钮
}
@end

@implementation UNIAppointController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_projectId) {
        UNIMypointRequest* req = [[UNIMypointRequest alloc]init];
        req.rqservice = ^(UNIMyProjectModel* model,NSString*tips,NSError* er){
            self.model = model;
            self.title =self.model.projectName;
            [self setupMyScroller];
            [self setupShopView];
            [self setupTopScrollerWithProjectId:self.model.projectId andCostime:self.model.costTime andShopId:[[AccountManager shopId] intValue]];
            [self setupMidScroller];
            [self setupBottomContent];
            [self regirstKeyBoardNotification];
        };
        [req postWithSerCode:@[API_PARAM_UNI,API_URL_GetProjectModel] params:@{@"projectId":_projectId}];
    }else{
    self.title =self.model.projectName;
    [self setupMyScroller];
    [self setupShopView];
    [self setupTopScrollerWithProjectId:_model.projectId andCostime:_model.costTime andShopId:[[AccountManager shopId] intValue]];
    [self setupMidScroller];
    [self setupBottomContent];
    [self regirstKeyBoardNotification];
    }
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(leftBarButtonEvent:)];
}

-(void)leftBarButtonEvent:(UIBarButtonItem*)item{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupMyScroller{
    self.myScroller.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    if (KMainScreenHeight<568)
        self.myScroller.contentSize = CGSizeMake(KMainScreenWidth, 568);
    else
        self.myScroller.contentSize = CGSizeMake(KMainScreenWidth, KMainScreenHeight-64);
}

#pragma mark 加载顶部店铺名字View
-(void)setupShopView{
    UNIShopView* shop =[[UNIShopView alloc]initWithFrame:CGRectMake(10,10, KMainScreenWidth - 20, (KMainScreenWidth>400?70:55))];
    shop.backgroundColor = [UIColor whiteColor];
    [self.myScroller addSubview:shop];
    shopView = shop;
    UNIShopManage* ma =[UNIShopManage getShopData];
    shopModel = [[UNIShopModel alloc]init];
    shopModel.x =[ma.x doubleValue];
    shopModel.y =[ma.y doubleValue];
    shopModel.address = ma.address;
    shopModel.shopName = ma.shopName;
    shopModel.telphone = ma.telphone;
    shopModel.shortName = ma.shortName;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]init];
    [tap.rac_gestureSignal subscribeNext:^(id x) {
        UNIShopListController* shopC = [[UNIShopListController alloc]init];
        shopC.delegate = self;
        [self.navigationController pushViewController:shopC animated:YES];
        shopC=nil;
        
    }];
    [shop addGestureRecognizer:tap];
    tap=nil;
    shop=nil;
//    [[shop.listBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
//    subscribeNext:^(id x) {
//        UNIShopListController* shop = [[UNIShopListController alloc]init];
//        shop.delegate = self;
//        [self.navigationController pushViewController:shop animated:YES];
//    }];
}
#pragma mark 店铺列表页面代理方法
-(void)UNIShopListControllerDelegateMethod:(id)model{
    UNIShopModel* info = model;
    shopModel = info;
    shopView.nameLab.text = info.shortName;
    shopView.addressLab.text = info.address;
    shopView.shopId = info.shopId;
//    [appointTop removeFromSuperview];
//    appointTop = nil;
//    [self setupTopScrollerWithProjectId:_model.projectId andCostime:_model.costTime andShopId:info.shopId];
    [appointTop changeShopId:info.shopId];
}
#pragma mark 加载顶部Scroller
-(void)setupTopScrollerWithProjectId:(int)project andCostime:(int)cost andShopId:(int)shopId{
    float topY = CGRectGetMaxY(shopView.frame)+10;
    UNIAppointTop* top = [[UNIAppointTop alloc]initWithFrame:CGRectMake(10,topY, KMainScreenWidth-20,KMainScreenWidth*210/320) andProjectId:project andCostime:cost andShopId:shopId];
    [self.myScroller addSubview:top];
    appointTop = top;
    top = nil;
}

#pragma mark 加载中部Scroller
-(void)setupMidScroller{
    float midY = CGRectGetMaxY(appointTop.frame)+10;
    float midH = self.myScroller.contentSize.height - midY - 10;
    UNIAppontMid* mid = [[UNIAppontMid alloc]initWithFrame:CGRectMake(10, midY, KMainScreenWidth-20,midH) andModel:_model];
    mid.delegate = self;
    [self.myScroller addSubview:mid];
    appontMid = mid;
    
    
    [[appontMid.addProBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         NSTimeInterval diffTime = [self->appointTop.finalTime timeIntervalSinceDate:self->appointTop.startTime];
         if (diffTime<10) {
             [UIAlertView showWithTitle:@"提示" message:@"您选择的预约时间点不能添加项目了！" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {}];
             return ;
         }
         int allCost =0;
         for (UNIMyProjectModel* model in self->appontMid.myData)
             allCost += (model.costTime*60);
         
         
         UIStoryboard* stroy = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         UNIMyPojectList* list = [stroy instantiateViewControllerWithIdentifier:@"UNIMyPojectList"];
         list.projectIdArr = self->appontMid.myData;
         list.delegate = self;
         list.restTime = diffTime - allCost + 30*60;
         [self.navigationController pushViewController:list animated:YES];
         stroy=nil;
         list=nil;
     }];
    mid=nil;
}
#pragma mark 加载底部Scroller
-(void)setupBottomContent{
    float btnWH = KMainScreenWidth*70/414;
    float btnY = self.myScroller.contentSize.height - btnWH-10 ;
    float btnX = (KMainScreenWidth - btnWH)/2;
    
    UIButton* btn = [UIButton buttonWithType: UIButtonTypeCustom];
    btn.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
    [btn setTitle:@"马上\n预约" forState:UIControlStateNormal];
    //[btn setBackgroundColor:[UIColor colorWithHexString:kMainThemeColor]];
    btn.titleLabel.lineBreakMode = 0;
    btn.titleLabel.numberOfLines = 0;
    btn.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth>400?17:14];
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius = btnWH/2;
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor =[UIColor colorWithHexString:kMainThemeColor].CGColor;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:kMainThemeColor] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:kMainThemeColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    [_myScroller addSubview:btn];
    sureBtn = btn;
    
    //检测是否有 预约时间点 存在，选择了预约时间点 才能进行 确定预约 否则预约按钮不可点击
    [RACObserve(appointTop, selectTime)
    subscribeNext:^(NSString* x) {
        if (x.length>0)
            self->sureBtn.enabled=YES;
        else
            self->sureBtn.enabled =NO;
    }];
    
    
        [[sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
//         if (self->appointTop.selectTime.length<1) {
//             return ;
//         }
#ifdef IS_IOS9_OR_LATER
         UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"是否确定预约?" message:nil preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
         [alertController addAction:cancelAction];
         
         UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"预约" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self startAppoint];
         }];
         [alertController addAction:sureAction];
         [self presentViewController:alertController animated:YES completion:nil];
#else
         [UIAlertView showWithTitle:@"是否确定预约?" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"预约"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
             if (buttonIndex == 1) {
                 [self startAppoint];
             }
         }];
#endif
             }];
    btn=nil;
}

-(void)startAppoint{
             [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
             UNIMypointRequest* req = [[UNIMypointRequest alloc]init];
             NSMutableArray* arr = [NSMutableArray array];
              NSString* date = [NSString stringWithFormat:@"%@ %@",self->appointTop.selectDay,self->appointTop.selectTime];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSDate *date1 = [dateFormatter dateFromString:date];
                int cost = 0;
             for (UNIMyProjectModel* model in self->appontMid.myData) {
                 NSDate* costDate = [date1 dateByAddingTimeInterval:cost];
                 NSString* str1 = [dateFormatter stringFromDate:costDate];
                 NSDictionary* dic1 = @{@"projectId":@(model.projectId),
                                        @"date":str1,
                                        @"costTime":@(model.costTime),
                                        @"num":@(1)};
                  [arr addObject:dic1];
                 cost +=model.costTime*60;
                 str1 =nil;
                 costDate = nil;
                 dic1 = nil;
             }
             [req postWithSerCode:@[API_PARAM_UNI,API_URL_SetAppoint]
                           params:@{@"data":arr,@"shopId":@(shopView.shopId)}];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [LLARingSpinnerView RingSpinnerViewStop1];
                 req.resetAppoint=^(NSString* order,NSString* tips,NSError* err){
                     if (err) {
                         [YIToast showText:NETWORKINGPEOBLEM];
                         return ;
                     }
                     if (order) {
                         //[YIToast showText:@"预约成功"];
#ifdef IS_IOS9_OR_LATER
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"您的预约已提交，请等待店家确认。预约结果以短信回复为准" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //[self locationNotificationTask:nil];
         [self locationNotificationTask:order];
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
#else
    [UIAlertView showWithTitle:@"您的预约已提交,请等待店家确认.\n预约结果以短信回复为准" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
            [self locationNotificationTask:order];
    }];
#endif
                     }else
                         [YIToast showText:@"您已经在这个点预约过了，请选择其他时间预约。"];
                 };
    
             });
    
    arr=nil; date = nil;
}

#pragma mark 添加本地通知任务
-(void)locationNotificationTask:(NSString*)order{

   UILocalNotification *localNotification = [[UILocalNotification alloc] init];

    NSArray* array = [appointTop.selectTime componentsSeparatedByString:@":"];
    int seleZhong = [array[0] intValue];
    NSString* sele = [NSString stringWithFormat:@"%@ %d:%@:00",appointTop.selectDay,--seleZhong,array[1]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate* strDate = [dateFormatter dateFromString:sele];
    //设置本地通知的触发时间（如果要立即触发，无需设置）
    localNotification.fireDate =strDate;
    
    //localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    //设置本地通知的时区
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    //设置通知的内容
    localNotification.alertBody =  @"您预约的服务时间还有一小时";
    //设置通知动作按钮的标题
    localNotification.alertAction = @"查看";
    //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    //设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
    
    
    NSDictionary *infoDic = @{@"OrderId":order,
                              @"shopId":@(shopView.shopId),
                              @"useId":[AccountManager userId],
                              @"shopX":@(shopModel.x),
                              @"shopY":@(shopModel.y),
                              @"shopAddress":shopModel.address,
                              @"shopName":shopModel.shopName};
    localNotification.userInfo = infoDic;
    //在规定的日期触发通知
   [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    NSDictionary* dib = @{@"time":strDate,
                          @"OrderId":order,
                          @"useId":[AccountManager userId],
                          @"shopId":@(shopView.shopId),
                          @"shopX":@(shopModel.x),
                          @"shopY":@(shopModel.y),
//                          @"shopAddress":shopModel.address,
//                          @"shopName":shopModel.shopName
                          };
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    NSArray* appointArr = [user objectForKey:@"appointArr"];
    NSMutableArray* arr;
    if (appointArr.count>0)
        arr =[NSMutableArray arrayWithArray:appointArr];
    else
        arr =[NSMutableArray array];
    
    [arr addObject:dib];
    [user setObject:arr forKey:@"appointArr"];
    [user synchronize];
    
    //预约成功刷新界面
    [[NSNotificationCenter defaultCenter] postNotificationName:APPOINTANDREFLASH object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)regirstKeyBoardNotification{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification*)notifi{
    NSDictionary *info = [notifi userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    self.view.frame = CGRectMake(0, -keyboardSize.height, KMainScreenWidth, KMainScreenHeight);
}
#pragma mark 键盘隐藏
-(void)keyboardWillHide:(NSNotification*)notifi{
    self.view.frame = CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight);
}

#pragma mark UNIMyPojectListDelegate 代理实现方法
-(void)UNIMyPojectListDelegateMethod:(NSArray *)arr{
    //UNIMyProjectModel* info = model;
    [appontMid addProject:arr];
    [self modifitacteAppontMid];
}

-(void)UNIAppontMidDelegateMethod{
    [self modifitacteAppontMid];
}

-(void)modifitacteAppontMid{
    // 添加项目和减少项目的时候 修改 appontMid 的高度 和 sureBtn 的位置
    NSArray* x = appontMid.myData;
    
    if (x.count>1) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect btnRe = self->sureBtn.frame;
            //btnRe.origin.x = (self->_myScroller.frame.size.width - btnRe.size.width)/2;
            btnRe.origin.x = self->_myScroller.frame.size.width - 10 - btnRe.size.width;
            self-> sureBtn.frame = btnRe;
        }];
    }else{
        CGRect btnRe = self->sureBtn.frame;
         btnRe.origin.x = (self->_myScroller.frame.size.width - btnRe.size.width)/2;
        //btnRe.origin.x = self->_myScroller.frame.size.width - 10 - btnRe.size.width;
        self-> sureBtn.frame = btnRe;
    }
    
    int count = (int)x.count;
    if (count>3)
        count= 3;
    CGRect tabRe = self->appontMid.myTableView.frame;
    tabRe.size.height = self->appontMid.cellH*count;
    self->appontMid.myTableView.frame =tabRe;
    
    CGRect addRec = self->appontMid.addProBtn.frame;
    addRec.origin.y =CGRectGetMaxY(tabRe)+5;
    self->appontMid.addProBtn.frame =addRec;
    
    
    CGRect midRec =self-> appontMid.frame;
    midRec.size.height = CGRectGetMaxY(addRec)+5; ;
    self-> appontMid.frame = midRec;
    
}
#pragma mark 颜色转图片
-(UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
