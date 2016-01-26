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
@interface UNIGoodsDeatilController ()<UITableViewDataSource,UITableViewDelegate,KeyboardToolDelegate,UNIPurChaseViewDelegate>{
    UIView* midView;
    UIView* bottomView;
    UILabel* priceLab;
    UITextField* numField;
    
    float cell1H;
    UNIGoodsModel* model;
    
    UNIPurChaseView* purView;
    UIView* bgView;
}
@property(nonatomic,assign)int num; //购买数量
@property(nonatomic,strong)UIScrollView* myScroller;
@property(nonatomic,strong)UITableView* myTable;
@property(nonatomic,strong)NSMutableArray* allArray;

@end

@implementation UNIGoodsDeatilController
-(void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIKeyboardWillShowNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIKeyboardWillHideNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"dealWithResultOfTheZFB" object:nil];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
   // [self startRequestReward];
    [self setupData];
    [self setupBottomView];
    [self setupMyScroller];
    [self setupTableView];
    [self regirstKeyBoardNotification];
}
#pragma mark 开始请求
-(void)startRequestReward{
    UNIGoodsDetailRequest* requet = [[UNIGoodsDetailRequest alloc]init];
    [requet postWithSerCode:@[API_PARAM_UNI,API_URL_GetSellInfo] params:nil];
    requet.kzgoodsInfoBlock =^(NSArray* array,NSString* tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            if(array){
                self->model = array.lastObject;
                [self setupBottomView];
                [self setupMyScroller];
                // [self setupData];
                [self setupTableView];
            }else
                [YIToast showText:tips];
        });
    };
}

-(void)setupNavigation{
    self.title = @"客妆";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
}
-(void)setupData{
    _num = 1;
    self.allArray = [NSMutableArray array];
}

-(void)setupBottomView{
    float boH = KMainScreenWidth* 80/320;
    float boY = KMainScreenHeight - boH;
    UIView* bottom = [[UIView alloc]initWithFrame:CGRectMake(0, boY, KMainScreenWidth, boH)];
    bottom.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottom];
    bottomView = bottom;
    
    float labX = KMainScreenWidth*30/414;
    float labH = KMainScreenWidth*40/414;
    float labY = (boH/2 - labH)/2;
    float labW = KMainScreenWidth*200/414;
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(labX, labY, labW, labH)];
    lab.font = [UIFont systemFontOfSize:KMainScreenWidth*36/414];
    lab.textColor = [UIColor colorWithHexString:kMainThemeColor];
   // lab.text = [NSString stringWithFormat:@"%f",model.shopPrice];
    lab.text = @"￥899";
    [bottom addSubview:lab];
    priceLab = lab;
    
    float lab2H = KMainScreenWidth*25/414;
    float lab2Y =boH/2;
    float lab2W = KMainScreenWidth*100/414;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab2Y, lab2W, lab2H)];
    lab2.font = [UIFont systemFontOfSize:KMainScreenWidth*20/414];
    lab2.text = @"购买数量:";
    [bottom addSubview:lab2];

    float btn1WH = lab2H;
    float btn1X = CGRectGetMaxX(lab2.frame);
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(btn1X, lab2Y, btn1WH, btn1WH);
    [btn1 setImage:[UIImage imageNamed:@"appoint_btn_jian"] forState:UIControlStateNormal];
    [bottom addSubview:btn1];
    [[btn1 rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         if (self.num>1) {
             --self.num;
         }
    }];
    
    float teX = CGRectGetMaxX(btn1.frame);
    float teW = KMainScreenWidth* 40/320;
    UITextField* text = [[UITextField alloc]initWithFrame:CGRectMake(teX, lab2Y, teW, btn1WH)];
    text.keyboardType = UIKeyboardTypeNumberPad;
    text.textAlignment = NSTextAlignmentCenter;
    text.text=@"1";
    [bottom addSubview:text];
    numField = text;
    [text.rac_textSignal subscribeNext:^(NSString* x) {
        int k =[x intValue];
        if (k>0)
            self.num =k ;
        
    }];
    
    [RACObserve(self,num)subscribeNext:^(id x) {
        self->numField.text = [NSString stringWithFormat:@"%d",self.num];
    }];
    
    
    BTKeyboardTool* tool = [BTKeyboardTool keyboardTool];
    tool.toolDelegate=self;
    [tool dismissTwoBtn];
    text.inputAccessoryView = tool;
    
    
    float btn2X = CGRectGetMaxX(text.frame);
    UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(btn2X, lab2Y, btn1WH, btn1WH);
    [btn2 setImage:[UIImage imageNamed:@"appoint_btn_jia"] forState:UIControlStateNormal];
    [bottom addSubview:btn2];
    [[btn2 rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         ++self.num;
    }];

    float btn3Y = 10;
    float btn3WH = boH - 2*btn3Y;
    float btn3X =KMainScreenWidth - labX - btn3WH;
    UIButton* btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(btn3X, btn3Y, btn3WH, btn3WH);
    btn3.layer.masksToBounds = YES;
    btn3.layer.cornerRadius = btn3WH/2;
    [btn3 setTitle:@"马上\n购买" forState:UIControlStateNormal];
    btn3.titleLabel.lineBreakMode = 0;
    btn3.titleLabel.numberOfLines = 0;
    [btn3 setBackgroundColor:[UIColor colorWithHexString:kMainThemeColor]];
    btn3.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*15/320];
    [bottom addSubview:btn3];
    [[btn3 rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {

         [self showThePayStyle];
     }];
}
-(void)showThePayStyle{
    UIView* bg = [[UIView alloc]initWithFrame:self.view.frame];
    bg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    bg.alpha = 0;
    [self.view addSubview:bg];
    bgView = bg;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [bg addGestureRecognizer:tap];
    
    
    UNIPurChaseView* pur = [[UNIPurChaseView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth*0.8,KMainScreenWidth*0.6) andNum:[numField.text intValue] andModel:nil];
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
#pragma mark 点击支付方式 隐藏 purView 和 bgView
-(void)UNIPurChaseViewDelegateMethod{
    [self tapAction:nil];
}
-(void)setupMyScroller{
    float scX =0 ;
    float scY = 64;
    float scW = KMainScreenWidth ;
    float scH = KMainScreenHeight - 64 -bottomView.frame.size.height;
    if (KMainScreenHeight<568)
        cell1H = 568 -bottomView.frame.size.height;
    else
        cell1H = scH;
    
    self.myScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(scX, scY, scW, scH)];
    self.myScroller.delegate = self;
    self.myScroller.contentSize = CGSizeMake(scW, scH);
    self.myScroller.backgroundColor = [UIColor clearColor];
    self.myScroller.pagingEnabled =YES;
    [self.view addSubview:self.myScroller];
}
-(void)setupTableView{
    
    float tabW = self.myScroller.frame.size.width;
    UITableView* tabview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, tabW,_myScroller.frame.size.height) style:UITableViewStylePlain];
    tabview.delegate = self;
    tabview.dataSource = self;
    tabview.backgroundColor = [UIColor clearColor];
    tabview.showsVerticalScrollIndicator=NO;
    [self.myScroller addSubview:tabview];
    self.myTable =tabview;
    self.myTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.myScroller.contentSize = CGSizeMake(self.myScroller.frame.size.width, self.myScroller.frame.size.height*2);
        [self.myScroller setContentOffset:CGPointMake(0,self.myScroller.frame.size.height) animated:YES];
        self.myTable.footer = nil;
        [self setupWebView];

    }];
}

#pragma mark 加载webView
-(void)setupWebView{
    UIWebView* web = [[UIWebView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_myTable.frame), _myTable.frame.size.width, _myScroller.frame.size.height)];
    NSString* urlString = [NSString stringWithFormat:@"%@/shopadmin/Public/Home/Detail/goods?id=%d",API_URL,model.projectId];
    NSLog(@"urlString %@",urlString);
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [web loadRequest:request];
    [_myScroller addSubview:web];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float cell = 0;
    cell = cell1H;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UNIGoodsCell1* cell =[[UNIGoodsCell1 alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, cell1H) reuseIdentifier:@"cell"];
   // [cell setupCellContentWith:model];
            return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
            UIStoryboard* st = [UIStoryboard storyboardWithName:@"KeZhuang" bundle:nil];
            UNIImageAndTextController* imgAndText = [st instantiateViewControllerWithIdentifier:@"UNIImageAndTextController"];
            imgAndText.projectId = model.projectId;
            [self.navigationController pushViewController:imgAndText animated:YES];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealWithResultOfTheZFB:) name:@"dealWithResultOfTheZFB" object:nil];
}
-(void)dealWithResultOfTheZFB:(NSNotification*)noiti{
    int num = [[noiti.userInfo objectForKey:@"result"] intValue];
    NSString* string = @"支付失败!";
    if (num == 9000)
        string = @"支付成功!";
    
#ifdef IS_IOS9_OR_LATER
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:string message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
#else
    [UIAlertView showWithTitle:string message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
    }];
#endif

    
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification*)notifi{
    NSDictionary *info = [notifi userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    CGRect boRe = bottomView.frame;
    boRe.origin.y -=keyboardSize.height;
    bottomView.frame = boRe;
}
#pragma mark 键盘隐藏
-(void)keyboardWillHide:(NSNotification*)notifi{
    CGRect boRe = bottomView.frame;
    boRe.origin.y =KMainScreenHeight - boRe.size.height;
    bottomView.frame = boRe;
    
    int k = [numField.text intValue];
    if (k==0 || [numField.text isEqualToString:@""]) {
        self.num = 1;
    }
}
-(void)keyboardTool:(BTKeyboardTool*)tool buttonClick:(KeyBoardToolButtonType)type{
    [self.view endEditing:YES];
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
