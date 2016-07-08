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
#import "UNIHttpUrlManager.h"
#import "UNIGuideView.h"
//#import "UNIMyProjectModel.h"
@interface UNIAppointController ()<UNIMyPojectListDelegate,UNIAppontMidDelegate,UNIShopListControllerDelegate>
{
   // UNIShopModel* shopModel;
    UNIShopView* shopView;
    UNIAppointTop* appointTop;
    UNIAppontMid* appontMid;
    //UNIAppointBotton* appointBotton;
    UIButton* sureBtn; //马上预约按钮
    
    int selectShopId; //选择的店铺Id
}
@end

@implementation UNIAppointController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"项目预约界面"];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"项目预约界面"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [UNIShopManage getShopData].shopName;
    
    if (_projectId) {
        [self goinFromGiftController];
    }else if(_model){
        self.title =self.model.projectName;
        [self setupUI];
    }else{
        [self setupUI];
    }
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(leftBarButtonEvent:)];

   [self showGuideView:APPOINTGUIDE1];
}

#pragma mark 从我的礼包跳进
-(void)goinFromGiftController{
    __weak UNIAppointController* myself = self;
    UNIMypointRequest* req = [[UNIMypointRequest alloc]init];
    req.rqservice = ^(UNIMyProjectModel* model,NSString*tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            if (!model) {
                [YIToast showText:tips];
                return ;
            }
            
            myself.model = model;
            myself.title =myself.model.projectName;
            [myself setupUI];
        });
    };
    [req postWithSerCode:@[API_URL_GetProjectModel] params:@{@"projectId":_projectId}];
}

-(void)setupUI{
    [self setupMyScroller];
   // [self setupShopView];
    if (_model)
    [self setupTopScrollerWithProjectId:self.model.projectId andCostime:self.model.costTime andShopId:[[AccountManager shopId] intValue]];
    else
        [self setupTopScrollerWithProjectId:0 andCostime:0 andShopId:[[AccountManager shopId] intValue]];
    [self setupMidScroller];
    [self setupBottomContent];
    [self regirstKeyBoardNotification];
}

-(void)leftBarButtonEvent:(UIBarButtonItem*)item{
    [LLARingSpinnerView RingSpinnerViewStop1];
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
    shop=nil;
}
#pragma mark 店铺列表页面代理方法
//-(void)UNIShopListControllerDelegateMethod:(id)model{
//    UNIShopModel* info = model;
//    shopModel = info;   
//    shopView.nameLab.text = info.shortName;
//    shopView.addressLab.text = info.address;
//    shopView.shopId = info.shopId;
//    [appointTop changeShopId:info.shopId];
//}
#pragma mark 加载顶部Scroller
-(void)setupTopScrollerWithProjectId:(int)project andCostime:(int)cost andShopId:(int)shopId{
    float topY = CGRectGetMaxY(shopView.frame)+10;
    UNIAppointTop* top = [[UNIAppointTop alloc]initWithFrame:CGRectMake(10,topY, KMainScreenWidth-20,KMainScreenWidth*210/320) andModel:_model  andShopId:shopId];
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
         
         [[BaiduMobStat defaultStat]logEvent:@"btn_add_projects" eventLabel:@"预约界面添加项目按钮"];
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
          UNIHttpUrlManager* httpUrl =[UNIHttpUrlManager sharedInstance];
         [UIAlertView showWithTitle:httpUrl.IS_APPOINT message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
             if (buttonIndex == 1) {
                 [self startAppoint];
             }
         }];
         [[BaiduMobStat defaultStat]logEvent:@"btn_appoint" eventLabel:@"预约页面马上预约按钮"];
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
    
    NSMutableString* projectIds=[NSMutableString string];
    NSMutableString* dates=[NSMutableString string];
    NSMutableString* costTimes=[NSMutableString string];
    if(appontMid.myData.count>0){
        for (int i = 0; i< self->appontMid.myData.count; i++) {
            UNIMyProjectModel* model = self->appontMid.myData[i];
            NSDate* costDate = [date1 dateByAddingTimeInterval:cost];
            NSString* str1 = [dateFormatter stringFromDate:costDate];
            if (i< self->appontMid.myData.count-1){
                [projectIds appendFormat:@"%d,",model.projectId];
                [costTimes appendFormat:@"%d,",model.costTime];
                [dates appendFormat:@"%@,",str1];
            }else{
                [projectIds appendFormat:@"%d",model.projectId];
                [costTimes appendFormat:@"%d",model.costTime];
                [dates appendFormat:@"%@",str1];
            }
            cost +=model.costTime*60;
        }
    }else{
        [projectIds appendString:@"0"];
        [dates appendString:date];
        [costTimes appendString:@"0"];
    }
            [req postWithSerCode:@[API_URL_SetAppoint]
                          params:@{@"projectIds":projectIds,
                                   @"costTimes":costTimes,
                                   @"dates":dates,
                                   @"shopId":@(shopView.shopId),
                                   @"num":@(1),
                                   @"remark":appontMid.remarkField.text}];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [LLARingSpinnerView RingSpinnerViewStop1];
                 req.resetAppoint=^(NSString* order,NSString* tips,NSError* err){
                     if (err) {
                         [YIToast showText:NETWORKINGPEOBLEM];
                         return ;
                     }
                     if (order) {
                         UNIHttpUrlManager* httpUrl =[UNIHttpUrlManager sharedInstance];
                         [UIAlertView showWithTitle:httpUrl.APPOINT_SUCCESS message:httpUrl.APPOINT_SUCCESS_TIPS cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                             [self locationNotificationTask:order];
                         }];
                     }else
                         [UIAlertView showWithTitle:tips message:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil tapBlock:nil];
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
    
   // localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    //设置本地通知的时区
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    //设置通知的内容
    localNotification.alertBody =  @"您预约的项目还有1小时就开始啦!";
    //设置通知动作按钮的标题
    localNotification.alertAction = @"查看";
    //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    //设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
    
    UNIShopManage* manager = [UNIShopManage getShopData];
    NSDictionary *infoDic = @{@"OrderId":order,
                              @"shopId" :@(shopView.shopId),
                              @"token"  :[AccountManager token],
                              @"shopX"  :manager.x,
                              @"shopY"  :manager.y,
                              @"shopAddress":manager.address,
                              @"shopName":manager.shopName};
    localNotification.userInfo = infoDic;
    //在规定的日期触发通知
   [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
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
    [appontMid.myData addObjectsFromArray:arr];
    [appontMid addProject:arr];
    if (appontMid.myData.count>0)
        appontMid.remarkField.placeholder = @"备注";
     else
        appontMid.remarkField.placeholder = @"填写您想预约的项目名称";
    
    [self modifitacteAppontMid];
    [appointTop changeProjectIds:appontMid.myData];
    [self performSelector:@selector(showGuideView) withObject:nil afterDelay:0.5];
}
-(void)showGuideView{
    [self showGuideView:APPOINTDELGUIDE];
}
-(void)UNIAppontMidDelegateMethod{
    
    [appointTop changeProjectIds:appontMid.myData];
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
