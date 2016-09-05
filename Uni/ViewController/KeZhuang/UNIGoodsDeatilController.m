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
#import "UNIGoodsDetailRequest.h"
#import "UNIUrlManager.h"
#import "UNIShopCarRequest.h"
@interface UNIGoodsDeatilController ()<UIWebViewDelegate,UIScrollViewDelegate,UITableViewDataSource,
UITableViewDelegate,KeyboardToolDelegate>{
    UIView* midView;
    NSString* orderNo;//生成订单号
    float cell1H;
    UNIGoodsModel* model;
    
    UIView* bgView;
    UIWebView* myWeb;
    UILabel* shopNumLab;
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
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self requestShopCarNum];
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
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = view.bounds;
    [btn setImage:[UIImage imageNamed:@"function_img_car"] forState:UIControlStateNormal];
    [view addSubview:btn];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoShopCarController" object:nil];
    }];
    
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(15, -10, 15, 15)];
    lab.textColor = [UIColor whiteColor];
    lab.backgroundColor = [UIColor colorWithHexString:kMainPinkColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font =kWTFont(10);
    lab.layer.masksToBounds = YES;
    lab.layer.cornerRadius = 7.5;
    [view addSubview:lab];
    shopNumLab = lab;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    
    __weak UNIGoodsDeatilController* myself = self;
    [self addPanGesture:^(id model) {
        [myself leftBarButtonEvent:nil];
    }];
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
- (IBAction)rightBarBtnAction:(id)sender {
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
    __weak UNIGoodsDeatilController* myself = self;
    UNIShopCarRequest* rq = [[UNIShopCarRequest alloc]init];
    [rq postWithSerCode:@[API_URL_ChangeNumOfShopCar] params:@{@"num":_numField.text,@"goodId":@(model.projectId),@"goodType":@(model.type),@"isCheck":@"1"}];
    rq.changeGoodsToCart=^(int code,NSString* tips,NSError* err){
        if (err) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
        [myself requestShopCarNum];
        [YIToast showText:tips];
    };
}
#pragma mark 获取购物车类型数量
-(void)requestShopCarNum{
    UNIShopCarRequest* rq = [[UNIShopCarRequest alloc]init];
    [rq postWithSerCode:@[API_URL_GetKindOfShopCar] params:nil];
    rq.getCartGoodsCount=^(int count,NSString* tips,NSError* err){
        if (err) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
        if (count == -1)
            [YIToast showText:tips];
        else
            self->shopNumLab.text = [NSString stringWithFormat:@"%d",count];
    };
}
#pragma mark 马上购买按钮
- (IBAction)payNow:(id)sender {
   // [self showThePayStyle];
    if (!model)
        return;
    
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"KeZhuang" bundle:nil];
    UNIPurchaseController* vc = [st instantiateViewControllerWithIdentifier:@"UNIPurchaseController"];
    model.sellNum = _num;
    vc.model = model;
    __weak UNIGoodsDeatilController* myself= self;
    vc.handleBlock =^(id model){
        [myself setupOrderListController];
    };
    [self.navigationController pushViewController:vc animated:YES];
    [[BaiduMobStat defaultStat]logEvent:@"btn_buy_product_detail" eventLabel:@"产品详情购买按"];
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
//订单列表
-(void)setupOrderListController{
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Guide" bundle:nil];
    UIViewController* view = [st instantiateViewControllerWithIdentifier:@"UNIOrderListController"];
    [self.navigationController pushViewController:view animated:YES];
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
