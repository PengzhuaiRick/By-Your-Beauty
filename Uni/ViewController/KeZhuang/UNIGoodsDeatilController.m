//
//  UNIGoodsDeatilController.m
//  Uni
//  客妆商品详情
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIGoodsDeatilController.h"
#import "UNIGoodsCell1.h"
//#import "UNIGoodsComment.h"
#import "UNIPurchaseController.h"
#import <MJRefresh/MJRefresh.h>
#import "UNIImageAndTextController.h"
#import "BTKeyboardTool.h"
#import "UNIPurChaseView.h"
#import "UNIOrderListController.h"
#import "UNIUrlManager.h"
#import "UNIShopCarRequest.h"
@interface UNIGoodsDeatilController ()<UIWebViewDelegate,UIScrollViewDelegate,UITableViewDataSource,
UITableViewDelegate,KeyboardToolDelegate,UNIPurChaseViewDelegate>{
    UIView* midView;
    //UIView* bottomView;
    //UILabel* priceLab;
//    UILabel* nonPriceLab;
//    CALayer* nonLine;
    //UITextField* numField;
    NSString* orderNo;//生成订单号
    float cell1H;
    UNIGoodsModel* model;
    
    UNIPurChaseView* purView;
    UIView* bgView;
 //   BOOL ifFirst; //是否第一次消失
    UIWebView* myWeb;
}
@property(nonatomic,assign)int num; //购买数量
@property(nonatomic,strong)NSMutableArray* allArray;
@property (weak, nonatomic) IBOutlet UIScrollView *myScroller;
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet UITextField *numField;
@property (weak, nonatomic) IBOutlet UIButton *cutBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *numerView;

@end

@implementation UNIGoodsDeatilController

-(void)viewWillDisappear:(BOOL)animated{
   
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIKeyboardWillShowNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIKeyboardWillHideNotification
                                                 object:nil];
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:@"dealWithResultOfTheZFB" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"dealWithResultOfTheWCpay" object:nil];
    [super viewWillDisappear:animated];
}
-(void)viewDidDisappear:(BOOL)animated{
//    if (!ifFirst) {
//        ifFirst = YES;
//        self.myScroller.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
//    }
    [super viewDidDisappear:animated];
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
     [[BaiduMobStat defaultStat] pageviewEndWithName:@"客妆界面"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [[BaiduMobStat defaultStat] pageviewStartWithName:@"客妆界面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupData];
    [self regirstKeyBoardNotification];
    [self setupMyScroller];
    [self setupBottomView];
    [self setupTableView];
    [self startRequestReward];
}
#pragma mark 开始请求
-(void)startRequestReward{
  //  _type = @"2";
    if ([_type isEqualToString:@"2"]) {
        [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
        UNIGoodsDetailRequest* requet = [[UNIGoodsDetailRequest alloc]init];
        [requet postWithSerCode:@[API_URL_GetSellInfo2] params:@{@"projectId":_projectId,
                                                                 // @"type":_type,
                                                                 @"isHeadShow":@(_isHeadShow)}];
        requet.kzgoodsInfoBlock =^(NSArray* array,NSString* tips,NSError* er){
            dispatch_async(dispatch_get_main_queue(), ^{
                [LLARingSpinnerView RingSpinnerViewStop1];
                if (er) {
                    [YIToast showText:NETWORKINGPEOBLEM];
                    return ;
                }
                if(array){
                    self->model = array.lastObject;
                    self.title = self->model.projectName;
                    self.priceLab.text = [NSString stringWithFormat:@"￥%.2f",self->model.shopPrice];
                    [self.myTable reloadData];
                    [self.myScroller setContentOffset:CGPointMake(0, 0) animated:YES];
                    
                }else
                    [YIToast showText:tips];
            });
        };
    }
    if ([_type isEqualToString:@"3"]) {
        [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
        UNIGoodsDetailRequest* requet = [[UNIGoodsDetailRequest alloc]init];
        [requet postWithSerCode:@[API_URL_GetSellInfo3] params:@{@"projectId":_projectId,
                                                                 // @"type":_type,
                                                                 @"isHeadShow":@(_isHeadShow)}];
        requet.gserviceInfoBlock =^(NSArray* array,NSString* tips,NSError* er){
            dispatch_async(dispatch_get_main_queue(), ^{
                [LLARingSpinnerView RingSpinnerViewStop1];
                if (er) {
                    [YIToast showText:NETWORKINGPEOBLEM];
                    return ;
                }
                if(array){
                    self->model = array.lastObject;
                    self.title = self->model.projectName;
                     self.priceLab.text = [NSString stringWithFormat:@"￥%.2f",self->model.shopPrice];
                    [self.myTable reloadData];
                    [self.myScroller setContentOffset:CGPointMake(0, 0) animated:YES];
                    
                }else
                    [YIToast showText:tips];
            });
        };
    }
}

-(void)setupNavigation{
    //self.title = @"客妆";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(leftBarButtonEvent:)];
}

-(void)leftBarButtonEvent:(UIBarButtonItem*)item{
    if (self.myScroller.contentOffset.y == 0) {
        [LLARingSpinnerView RingSpinnerViewStop1];
       // [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.myScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
}

-(void)setupData{
    _num = 1;
    cell1H = KMainScreenWidth*528/414;
    self.allArray = [NSMutableArray array];
}

-(void)setupBottomView{
    
    __weak UNIGoodsDeatilController* myself = self;
    
    _numerView.layer.masksToBounds = YES;
    _numerView.layer.borderColor =[UIColor colorWithHexString:@"959595"].CGColor;
    _numerView.layer.borderWidth = 1;
    _numerView.layer.cornerRadius = _numerView.frame.size.height/2;
    
    [_addBtn setImage:[UIImage imageNamed:@"appoint_btn_sjia"] forState:UIControlStateNormal];
//    [_addBtn setImage:[UIImage imageNamed:@"appoint_btn_sjia"] forState:UIControlStateHighlighted];
//    [_addBtn setImage:[UIImage imageNamed:@"appoint_btn_sjia"] forState:UIControlStateSelected];
   // _addBtn.selected=YES;
    
    [_cutBtn setImage:[UIImage imageNamed:@"appoint_btn_jian"] forState:UIControlStateNormal];
    [_cutBtn setImage:[UIImage imageNamed:@"appoint_btn_sjian"] forState:UIControlStateHighlighted];
    [_cutBtn setImage:[UIImage imageNamed:@"appoint_btn_sjian"] forState:UIControlStateSelected];
   
    
    _priceLab.font = kWTFont(23);
    _numField.font = kWTFont(13);
    

    [[_cutBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         if (myself.num>1) {
             --myself.num;
         }
    }];
 
    [_numField.rac_textSignal subscribeNext:^(NSString* x) {
        int k =[x intValue];
        if (k>0)
            myself.num =k ;
         [[BaiduMobStat defaultStat]logEvent:@"btn_buy_sub_num" eventLabel:@"购买减少数量按钮"];
    }];
    
    
    [RACObserve(self,num)subscribeNext:^(id x) {
        myself.numField.text = [NSString stringWithFormat:@"%d",self.num];
        myself.priceLab.text = [NSString stringWithFormat:@"￥%.2f",self->model.shopPrice*self.num - self->model.reduceMoney];
        
        if (self.num>1)
            self.cutBtn.selected=YES;
        else
            self.cutBtn.selected=NO;
    }];
    
    
    BTKeyboardTool* tool = [BTKeyboardTool keyboardTool];
    tool.toolDelegate=self;
    [tool dismissTwoBtn];
    _numField.inputAccessoryView = tool;

    [[_addBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         ++myself.num;
         [[BaiduMobStat defaultStat]logEvent:@"btn_buy_add_num" eventLabel:@"购买添加数量按钮"];
    }];
}

#pragma mark 放入购物车按钮
- (IBAction)addToShopCar:(id)sender {
    [self requestChangeNumOfShopCar];
}
#pragma mark 添加到购物车，修改购物车数量，减少购物车数量
-(void)requestChangeNumOfShopCar{
    UNIShopCarRequest* rq = [[UNIShopCarRequest alloc]init];
    [rq postWithSerCode:@[API_URL_ChangeNumOfShopCar] params:@{@"num":_numField.text,@"goodId":@(model.projectId),@"goodType":@(model.type),@"isCheck":@"1"}];
    rq.changeGoodsToCart=^(int code,NSString* tips,NSError* err){
        if (err) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
        [YIToast showText:tips];
    };
}
#pragma mark 马上购买按钮
- (IBAction)payNow:(id)sender {
   // [self showThePayStyle];
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"KeZhuang" bundle:nil];
    UNIPurchaseController* vc = [st instantiateViewControllerWithIdentifier:@"UNIPurchaseController"];
    model.sellNum = _num;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
    [[BaiduMobStat defaultStat]logEvent:@"btn_buy_product_detail" eventLabel:@"产品详情购买按"];
}
-(void)showThePayStyle{
    UIView* bg = [[UIView alloc]initWithFrame:self.view.frame];
    bg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    bg.alpha = 0;
    [self.view addSubview:bg];
    bgView = bg;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [bg addGestureRecognizer:tap];
    
    UNIPurChaseView* pur = [[UNIPurChaseView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth*0.7,KMainScreenWidth*0.6)
                                                          andNum:[_numField.text intValue]
                                                        andModel:model];
    pur.delegate = self;
    pur.alpha = 0;
    pur.center = CGPointMake(KMainScreenWidth/2, KMainScreenHeight/2);
    pur.layer.masksToBounds = YES;
    pur.layer.cornerRadius = 3;
    [self.view addSubview:pur];
    purView = pur;
    
    [UIView animateWithDuration:0.3 animations:^{
        bg.alpha = 1;
        pur.alpha = 1;
    }];
    
    bg = nil; tap=nil; pur=nil;
}

#pragma mark 隐藏 purView 和 bgView
-(void)tapAction:(UIGestureRecognizer*)gesture{
    
    purView.delegate=nil;
    [UIView animateWithDuration:0.3 animations:^{
        self->bgView.alpha = 0;
        self->purView.alpha = 0;
    } completion:^(BOOL finished) {
        [self->bgView removeFromSuperview];
        [self->purView removeFromSuperview];
        self->bgView = nil;
        self->purView = nil;
    }];
   
}
-(void)setupMyScroller{
    
    self.myScroller.contentSize = CGSizeMake(KMainScreenWidth, cell1H);
    self.myScroller.backgroundColor = [UIColor clearColor];
    self.myScroller.pagingEnabled =YES;
    self.myScroller.scrollsToTop=YES;
}
-(void)setupTableView{

    self.myTable.scrollsToTop = NO;
    self.myTable.backgroundColor = [UIColor clearColor];
  
    __weak UNIGoodsDeatilController* myself = self;
    MJRefreshAutoNormalFooter* footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            myself.myScroller.contentSize = CGSizeMake(myself.myScroller.frame.size.width,self->cell1H*2);
            [myself.myScroller setContentOffset:CGPointMake(0,self->cell1H) animated:YES];
            myself.myTable.footer = nil;
            [myself setupWebView];
        });
    }];
    [footer setTitle:@"继续拖动，查看图文详情" forState:1];
    
    self.myTable.footer =footer;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _myScroller) {
        if (scrollView.contentOffset.y<-80) {
            if (self->myWeb) {
                
                if (self->myWeb.loading)
                    return ;
                
                //清除UIWebView的缓存
                [[NSURLCache sharedURLCache] removeAllCachedResponses];
                [self->myWeb reload];
            }
        }
    }
}
#pragma mark 加载webView
-(void)setupWebView{
    UIWebView* web = [[UIWebView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_myTable.frame), _myTable.frame.size.width, cell1H)];
    web.scrollView.delegate = self;
    web.delegate= self;
    web.scrollView.scrollsToTop = NO;
   // NSString* urlString = [NSString stringWithFormat:@"%@/%@",API_IMG_URL,model.url];
   // NSString* urlString = [NSString stringWithFormat:@"%@/%@",[UNIUrlManager sharedInstance].img_url,model.url];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:model.url]];
    [web loadRequest:request];
    [_myScroller addSubview:web];
    myWeb = web;
    web=nil;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"didFailLoadWithError  %@",error);
    [LLARingSpinnerView RingSpinnerViewStop1];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [LLARingSpinnerView RingSpinnerViewStop1];
    [_myTable.header endRefreshing];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cell1H;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UNIGoodsCell1* cell =[[UNIGoodsCell1 alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, cell1H) reuseIdentifier:@"cell"];
    [cell setupCellContentWith:model];
    [[cell.prideBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        self.myScroller.contentSize = CGSizeMake(self.myScroller.frame.size.width, self->cell1H*2);
        [self.myScroller setContentOffset:CGPointMake(0,self->cell1H) animated:YES];
        self.myTable.footer = nil;
        [self setupWebView];
    }];
            return cell;
}


-(CGSize)suanziti:(NSString*)text andFont:(float)font andWidth:(float)width{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font]}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}
#pragma mark 注册键盘是事件
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
    
    //处理ZFB支付结果
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealWithResultOfTheZFB:) name:@"dealWithResultOfTheZFB" object:nil];
    
    //处理WC支付结果
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealWithResultOfTheWCpay:) name:@"dealWithResultOfTheWCpay" object:nil];
}
#pragma mark 点击支付方式 隐藏 purView 和 bgView
-(void)UNIPurChaseViewDelegateMethod:(NSString*)payStyle andNum:(int)num{
    [self tapAction:nil];
    if (payStyle)
        [self requestTheOrderNo:payStyle andNum:num];
    
    if ( [payStyle isEqualToString:@"WXPAY_APP"])
        [[BaiduMobStat defaultStat]logEvent:@"btn_pay_weixin" eventLabel:@"产品详情微信支付按钮"];
  
    if ( [payStyle isEqualToString:@"ALIPAY_APP"])
         [[BaiduMobStat defaultStat]logEvent:@"btn_pay_alipay" eventLabel:@"产品详情支付宝支付"];
}
#pragma mark 请求订单号
-(void)requestTheOrderNo:(NSString*)payStyle andNum:(int)num{
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
    NSDictionary* dic=@{@"goodsId":@(model.projectId),@"goodsType":@(model.type),@"payType":payStyle,@"shopPrice":[NSString stringWithFormat:@"%.f",model.shopPrice*num],@"price":@(model.shopPrice),
                        @"num":@(num)};
    __weak id myself = self;
    UNIGoodsDetailRequest* requet = [[UNIGoodsDetailRequest alloc]init];
    [requet postWithSerCode:@[API_URL_GetOutTradeNo] params:dic];
    requet.kzgoodsGetOrderBlock=^(NSDictionary* dictionary,NSString*tips,NSError* err){
        [LLARingSpinnerView RingSpinnerViewStop1];
        if (err) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
        if (dictionary) {
            self->orderNo =[dictionary objectForKey:@"out_trade_no"];
            if ( [payStyle isEqualToString:@"WXPAY_APP"]){
                [myself jumpToBizPay:dictionary];}
            if ( [payStyle isEqualToString:@"ALIPAY_APP"]){
                [myself payWithZFB:dictionary];}
        }else
            [YIToast showText:tips];
    };
}

-(void)payWithZFB:(NSDictionary*)dic{
    
    Order *order = [[Order alloc] init];
    NSString* str =[dic valueForKey:@"orderstr"];
    if (str) {
        [order loadOrderString:str];
    }
    
    NSString *appScheme = @"UniZFBPay";
    NSString *orderString = order.orderString;
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        //NSLog(@"reslut = %@",resultDic);
        [self dealWithResultOfTheZFB:resultDic];
       // [self resultOfZFBpay:resultDic];
        
    }];
}

- (void)jumpToBizPay:(NSDictionary*)dia{
    if (![WXApi isWXAppInstalled]) {
        [UIAlertView showWithTitle:@"提示" message:@"请检查是否安装微信客户端" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {}];
        return;
    }
    
    PayReq* req = [[PayReq alloc] init];
    req.openID = [dia objectForKey:@"appid"];
    req.prepayId= [dia objectForKey:@"prepayid"];
    req.partnerId= [dia objectForKey:@"partnerid"];
    req.nonceStr= [dia objectForKey:@"noncestr"];
    req.timeStamp=[[dia objectForKey:@"timestamp"] intValue];
    req.package = [dia objectForKey:@"package"];
    req.sign = [dia objectForKey:@"sign"];
    NSString* tip = nil;
    if (!req.openID)  tip = @"参数有误";
    if (!req.prepayId) tip = @"参数有误";
    if (!req.partnerId) tip = @"参数有误";
    if (!req.nonceStr) tip = @"参数有误";
    if (!req.timeStamp) tip = @"参数有误";
    if (!req.package) tip = @"参数有误";
    if (!req.sign) tip = @"参数有误";
    if(tip){
        [UIAlertView showWithTitle:@"提示" message:tip cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
    }else
        [WXApi sendReq:req];
}

-(void)dealWithResultOfTheZFB:(NSDictionary*)noiti{
    int num = [[noiti objectForKey:@"resultStatus"] intValue];
    NSString* string = @"支付失败!";
    NSString* message = [noiti objectForKey:@"memo"];
    if (num == 9000){
        string = @"支付成功!";
        [self checkTradeOrderStatus];
        return;
    }
    switch (num) {
        case 4000: message=@"支付宝系统异常"; break;
        case 4001: message=@"数据格式不正确";  break;
        case 4003: message=@"该用户绑定的支付宝账户被冻结或不允许支付"; break;
        case 4004: message=@"该用户已解除绑定";  break;
        case 4005: message=@"绑定失败或没有绑定"; break;
        case 4006: message=@"订单支付失败"; break;
        case 4010: message=@"重新绑定账户";  break;
        case 6000: message=@"支付服务正在进行升级操作"; break;
        case 6001: message=@"用户中途取消支付操作";  break;
        case 7001: message=@"网页支付失败"; break;
    }
    [UIAlertView showWithTitle:string message:message cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
    }];
}

-(void)dealWithResultOfTheWCpay:(NSNotification*)noiti{
     int num = [[noiti.userInfo objectForKey:@"result"] intValue];
    NSString* errString = nil;
    switch (num) {
        case 0:
            errString = @"交易成功";
            break;
        case -1:
            errString = @"交易失败";
            break;
        case -2:
            errString = @"用户点击取消并返回";
            break;
        case -3:
            errString = @"发送失败";
            break;
        case -4:
            errString = @"授权失败";
            break;
        case -5:
            errString = @"微信不支持";
            break;
            
    }
    NSString* result=nil;
    if (num == 0){
        result = @"支付成功!";
         [self checkTradeOrderStatus];
    }else{
        result = @"支付失败!";
    [UIAlertView showWithTitle:result message:errString cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
    }];
}
    
}

#pragma mark 支付成功后 和后台验证
-(void)checkTradeOrderStatus{
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
    UNIGoodsDetailRequest* req = [[UNIGoodsDetailRequest alloc]init];
    req.ctorderStatusBlock=^(int code, NSString* tip,NSError* err){
        dispatch_async(dispatch_get_main_queue(), ^{
            [LLARingSpinnerView RingSpinnerViewStop1];
            [UIAlertView showWithTitle:tip message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (code == 0) {
                    UNIOrderListController* view = [[UNIOrderListController alloc]init];
                    view.type = 1;
                    [self.navigationController pushViewController:view animated:YES];
                }
            }];
        });
        
    };
    [req postWithSerCode:@[API_URL_GetOrderStatus] params:@{@"out_trade_no":orderNo}];
}


#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification*)notifi{
    NSDictionary *info = [notifi userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    CGRect boRe = _bottomView.frame;
    boRe.origin.y -=keyboardSize.height;
    _bottomView.frame = boRe;

}
#pragma mark 键盘隐藏
-(void)keyboardWillHide:(NSNotification*)notifi{
    CGRect boRe = _bottomView.frame;
    boRe.origin.y =KMainScreenHeight - boRe.size.height;
    _bottomView.frame = boRe;
    
    int k = [_numField.text intValue];
    if (k==0 || [_numField.text isEqualToString:@""]) {
        self.num = 1;
    }
}
-(void)keyboardTool:(BTKeyboardTool*)tool buttonClick:(KeyBoardToolButtonType)type{
    [self.view endEditing:YES];
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
#pragma mark 计算Label 高度
-(CGSize)contentSize:(UILabel*)lab{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lab.lineBreakMode;
    paragraphStyle.alignment = lab.textAlignment;
    
    NSDictionary * attributes = @{NSFontAttributeName : lab.font,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    
    CGSize contentSize = [lab.text boundingRectWithSize:CGSizeMake(KMainScreenWidth, MAXFLOAT)
                                                options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                             attributes:attributes
                                                context:nil].size;
    return contentSize;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
 
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
