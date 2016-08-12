//
//  UNICardInfoController.m
//  Uni
//  会员卡使用详情
//  Created by apple on 15/12/3.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNICardInfoController.h"
#import "UNICardInfoRequest.h"
#import <MJRefresh/MJRefresh.h>
#import "UNIAppointDetail.h"
#import "AccountManager.h"

#import "UNIMyRewardController.h"

#import "UNIVIPMemberCell.h"
#import "UNICardInfoProgress.h"

@interface UNICardInfoController ()<UITableViewDataSource,UITableViewDelegate>{
    int pageNum;
    UIView* noDataView;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *clockimg;
@property (weak, nonatomic) IBOutlet UIButton *intimebtn;
@property (weak, nonatomic) IBOutlet UILabel *rewardNameLab;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong)NSMutableArray* myData;
@property(nonatomic, strong)UNICardInfoProgress* progressView;
@property(nonatomic, strong)UIImageView* rewardImg;
@end

@implementation UNICardInfoController
-(void)viewWillAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"我的详情"];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"我的详情"];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupUI];
    [self setupTableView];
    [self startRequestInTimeInfo];
    [self startRequestCardInfo];
}

-(void)setupNavigation{
    self.title = @"会员详情";
   
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:0 target:self action:nil];
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(leftBarButtonEvent:)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

-(void)leftBarButtonEvent:(UIBarButtonItem*)item{
    [LLARingSpinnerView RingSpinnerViewStop1];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupUI{
    _intimebtn.titleLabel.font = kWTFont(16);
    _rewardNameLab.font = kWTFont(14);
    
    _rewardNameLab.layer.masksToBounds = YES;
    _rewardNameLab.layer.borderWidth = 0.5;
    _rewardNameLab.layer.borderColor = [UIColor whiteColor].CGColor;
    _rewardNameLab.layer.cornerRadius = _rewardNameLab.frame.size.height/2;
    
    CGFloat proWH = KMainScreenWidth* 182/414;
    UNICardInfoProgress* view = [[UNICardInfoProgress alloc]initWithFrame:CGRectMake(0, 0, proWH, proWH) andData:@[@(0),@(0)]];
    view.center = _clockimg.center;
    view.backgroundColor = [UIColor clearColor];
    [_headerView addSubview:view];
    _progressView = view;
    
    UIImageView* img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"appoint_img_intime"]];
    img.contentMode = UIViewContentModeScaleAspectFit;
    img.center = view.center;
    img.hidden=YES;
    [_headerView addSubview:img];
    _rewardImg = img;
}

#pragma mark 开始请求准时奖励信息
-(void)startRequestInTimeInfo{
    __weak UNICardInfoController* myself = self;
     [LLARingSpinnerView RingSpinnerViewStart1andStyle:1];
    UNICardInfoRequest* request = [[UNICardInfoRequest alloc]init];
    [request postWithSerCode:@[API_URL_ITRewardInfo]
                      params:nil];
    request.rqrewardBlock=^(int total,int num,NSString* projectName,NSString* tips,NSError* err){
        dispatch_async(dispatch_get_main_queue(), ^{
             [LLARingSpinnerView RingSpinnerViewStop1];
            if (err) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            if (total>0) {
                if (num<total) {
                    myself.clockimg.hidden=NO;
                    myself.progressView.hidden=NO;
                    myself.rewardImg.hidden=YES;
                    [myself.intimebtn setTitle:[NSString stringWithFormat:@"准时到店满%d次",total] forState:UIControlStateNormal];
                    [myself.progressView setProgrssLayerEndStroke:num and:total];
                }else{
                    myself.clockimg.hidden=YES;
                    myself.progressView.hidden=YES;
                    myself.rewardImg.hidden=NO;
                    [myself.intimebtn setTitle:@"点击领取" forState:UIControlStateNormal];
                }
                
                myself.rewardNameLab.text =projectName;
            }else
                [YIToast showText:tips];
        });
    };
}

#pragma mark 开始请求会员卡信息
-(void)startRequestCardInfo{
    __weak UNICardInfoController* myself = self;
    UNICardInfoRequest* request = [[UNICardInfoRequest alloc]init];
    [request postWithSerCode:@[API_URL_GetCardInfo]
                      params:@{@"page":@(pageNum),@"size":@(20)}];
    request.cardInfoBlock=^(NSArray* arr,NSString* tips,NSError* err){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [myself.tableView.header endRefreshing];
            [myself.tableView.footer endRefreshing];
            if (err) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
           NSMutableArray* muArr = [NSMutableArray arrayWithArray:arr];
             NSMutableArray* muArr1 = [NSMutableArray arrayWithArray:arr];
            for (UNIMyAppointInfoModel* model  in muArr) {
                if (model.status<2) {
                    [muArr1 removeObject:model];
                }
            }
            if (arr.count<20)
                [myself.tableView.footer endRefreshingWithNoMoreData];
           
            if (self->pageNum == 0)
                [self.myData removeAllObjects];
                
                [myself.myData addObjectsFromArray:muArr1];
                [myself.tableView reloadData];
            self->noDataView.hidden = self.myData.count>0;
            
//            else
//                [YIToast showText:tips];
        });
    };
}



-(void)setupTableView{
    self.myData = [NSMutableArray array];

    [self setupNodataView];
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self startRequestInTimeInfo];
        self->pageNum =0;
        [self startRequestCardInfo];
    }];
        _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            ++self->pageNum;
            [self startRequestCardInfo];
        }];
  
}
-(void)setupNodataView{
    
    UIView* nodata = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, _tableView.frame.size.height)];
    nodata.hidden=self.myData.count>0;
    [_tableView addSubview:nodata];
    noDataView = nodata;
    
    UIImageView* img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"main_img_nodata3"]];
    float imgWH = KMainScreenWidth>400?60:50,
    imgX = (nodata.frame.size.width - imgWH)/2,
    ImgY=nodata.frame.size.height/2 - imgWH - 10;
    
    img.frame = CGRectMake(imgX, ImgY, imgWH, imgWH);
    [nodata addSubview:img];
    
   // UNIHttpUrlManager* manager = [UNIHttpUrlManager sharedInstance];
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame)+10, nodata.frame.size.width, 30)];
    lab.text=@"抱歉您还没有完成的预约哦！";
    lab.font = [UIFont systemFontOfSize:KMainScreenWidth>400?16:14];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor colorWithHexString:kMainTitleColor];
    [nodata addSubview:lab];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return KMainScreenWidth*20/414;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenWidth*20/414)];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.myData.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KMainScreenWidth* 85/414;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* name = @"cell";
     UNIVIPMemberCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell){
        //__weak UNICardInfoController* myself = self;
        cell = [[NSBundle mainBundle]loadNibNamed:@"UNIVIPMemberCell" owner:self options:nil].lastObject;
    }
     UNIMyAppointInfoModel* info = _myData[indexPath.section];
     cell.mainLab.text = info.projectName;
    
    NSString* text2 = [info.date substringWithRange:NSMakeRange(5, 11)];
    cell.subLab.text = text2;
    
    NSString* imgUrl = info.logoUrl;
    NSArray* arr = [info.logoUrl componentsSeparatedByString:@","];
    if (arr.count>0)
        imgUrl = arr[0];
    [cell.mainImage sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                      placeholderImage:[UIImage imageNamed:@"main_img_cellbg"]];
    
    switch (info.status) {
        case 2:{
            [cell.handleBtn setTitle:@"已完成" forState:UIControlStateNormal];
            cell.handleImg.image = [UIImage imageNamed:@"main_btn_cell1"];
        }
            break;
        case 3:{
            [cell.handleBtn setTitle:@"已取消" forState:UIControlStateNormal];
            cell.handleImg.image = [UIImage imageNamed:@"main_btn_cell3"];
        }
            break;
    }
    
    
    if (info.ifIntime == 0) {
        [cell.handleBtn setTitle:@"准时" forState:UIControlStateNormal];
        cell.handleImg.image = [UIImage imageNamed:@"main_btn_cell2"];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UNIAppointDetail* appoint = [story instantiateViewControllerWithIdentifier:@"UNIAppointDetail"];
    UNIMyAppointInfoModel* model =_myData[indexPath.section];
    appoint.order =model.order;
    appoint.shopId = model.shopId;
    appoint.ifMyDetail = YES;
    [self.navigationController pushViewController:appoint animated:YES];
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
