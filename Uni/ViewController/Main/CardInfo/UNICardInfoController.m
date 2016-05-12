//
//  UNICardInfoController.m
//  Uni
//  会员卡使用详情
//  Created by apple on 15/12/3.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNICardInfoController.h"
#import "UNICardInfoCell.h"
#import "UNICardInfoRequest.h"
#import <MJRefresh/MJRefresh.h>
#import "UNIAppointDetail.h"
#import "AccountManager.h"
@interface UNICardInfoController ()<UITableViewDataSource,UITableViewDelegate>{
    int pageNum;
    UIView* topView;
    UITableView* myTableView;
    UILabel* topLab1;
    UILabel* topLab2;
    UIView* noDataView;
    
}
@property(nonatomic, strong)NSMutableArray* myData;
@end

@implementation UNICardInfoController
-(void)viewWillAppear:(BOOL)animated{
    NSArray* array =self.containController.view.gestureRecognizers;
    for (UIGestureRecognizer* ges in array) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled=YES;
        }
    }
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"我的详情"];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    NSArray* array =self.containController.view.gestureRecognizers;
    for (UIGestureRecognizer* ges in array) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled=NO;
        }
    }
    myTableView.delegate = nil;
    myTableView.dataSource = nil;
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"我的详情"];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupTopview];
    [self setupTableView];
    [self startRequestInTimeInfo];
    [self startRequestCardInfo];
}

-(void)setupNavigation{
    self.title = @"我的详情";
    self.view .backgroundColor= [UIColor colorWithHexString: kMainBackGroundColor];
    
      self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_function"] style:0 target:self action:@selector(navigationControllerLeftBarAction:)];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"card_bar_user"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction:)];
//    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:0 target:self action:nil];
}
#pragma mark 功能按钮事件
-(void)navigationControllerLeftBarAction:(UIBarButtonItem*)bar{
    if (self.containController.closing) {
        [[NSNotificationCenter defaultCenter]postNotificationName:CONTAITVIEWOPEN object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:CONTAITVIEWCLOSE object:nil];
    }
    
    
}
-(void)rightBarButtonItemAction:(UIBarButtonItem*)item{
    NSString* msg = [NSString stringWithFormat:@"用户账号: %@",[AccountManager localLoginName]];
#ifdef IS_IOS9_OR_LATER
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"用户信息" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
#else
    [UIAlertView showWithTitle:@"用户信息" message:msg cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
    }];
#endif

}

#pragma mark 开始请求准时奖励信息
-(void)startRequestInTimeInfo{
    UNICardInfoRequest* request = [[UNICardInfoRequest alloc]init];
    [request postWithSerCode:@[API_URL_ITRewardInfo]
                      params:nil];
    request.rqrewardBlock=^(int total,int num,NSString* projectName,NSString* tips,NSError* err){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (err) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            if (total>0) {
                self->topLab1.text = [NSString stringWithFormat:@"满%d次奖励价值",total];
                [self->topLab1 sizeToFit];
                self->topLab2.text = projectName;
                float x = CGRectGetMaxX(self->topLab1.frame);
                CGRect top2 = self->topLab2.frame;
                top2.origin.x = x;
                top2.size.width = self->topView.frame.size.width - x;
                top2.size.height =self->topLab1.frame.size.height;
                self->topLab2.frame = top2;
                [self setupmidView:total and:num];
                // [self setupmidView:6 and:2];
            }
        });
    };
}

#pragma mark 开始请求会员卡信息
-(void)startRequestCardInfo{
    UNICardInfoRequest* request = [[UNICardInfoRequest alloc]init];
    [request postWithSerCode:@[API_URL_GetCardInfo]
                      params:@{@"page":@(pageNum),@"size":@(20)}];
    request.cardInfoBlock=^(NSArray* arr,NSString* tips,NSError* err){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->myTableView.header endRefreshing];
            [self->myTableView.footer endRefreshing];
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
                [self->myTableView.footer endRefreshingWithNoMoreData];
           
            if (self->pageNum == 0)
                [self.myData removeAllObjects];
                
                [self.myData addObjectsFromArray:muArr1];
                [self->myTableView reloadData];
            self->noDataView.hidden = self.myData.count>0;
            
//            else
//                [YIToast showText:tips];
        });
    };
}

#pragma mark 开始加载准时奖励视图
-(void)setupTopview{
    float topX = 16;
    float topY = 64+16;
    float topW = KMainScreenWidth - topX*2;
    float topH = KMainScreenWidth* 110/320;
    UIView* top = [[UIView alloc]initWithFrame:CGRectMake(topX, topY, topW, topH)];
    top.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:top];
    topView = top;
    
    float labX = 10;
    float labY = 10;
    float labW = topW- labX*2;
    float labH = KMainScreenWidth>400?25:20;
    UILabel* lab =[[UILabel alloc]initWithFrame:CGRectMake(labX, labY, labW, labH)];
    lab.text = @"准时到店";
    lab.font = [UIFont systemFontOfSize:KMainScreenWidth>400?17:15];
    [top addSubview:lab];
    
    float layX = labX;
    float layY = CGRectGetMaxY(lab.frame)+5;
    float layW = labW;
    CALayer* lay =[CALayer layer];
    lay.frame = CGRectMake(layX, layY, layW, 0.5);
    lay.backgroundColor = [UIColor colorWithHexString:kMainTitleColor].CGColor;
    [top.layer addSublayer:lay];
    
    float lab1X = labX;
    float lab1Y = CGRectGetMaxY(lab.frame)+10;
    float lab1W = KMainScreenWidth*100/320;
    float lab1H = KMainScreenWidth*20/320;
    UILabel* lab1 =[[UILabel alloc]initWithFrame:CGRectMake(lab1X, lab1Y, lab1W, lab1H)];
    lab1.font = [UIFont systemFontOfSize:KMainScreenWidth>400?15:13];
    [top addSubview:lab1];
    topLab1 = lab1;
    
    float lab2X = CGRectGetMaxX(lab1.frame);
    float lab2W =topW- CGRectGetMaxX(lab1.frame);
    UILabel* lab2 =[[UILabel alloc]initWithFrame:CGRectMake(lab2X, lab1Y, lab2W, lab1H)];
   // lab2.text = @"准时到店";
    lab2.font = [UIFont systemFontOfSize:KMainScreenWidth>400?15:13];
    lab2.textColor = [UIColor colorWithHexString:kMainThemeColor];
    [top addSubview:lab2];
    topLab2 = lab2;

}
-(void)setupmidView:(int)total and:(int)num{
    if (num>total)
       num=total;

    for (UIView* view in topView.subviews) {
        if ([view isKindOfClass:[UIImageView class]])
            [view removeFromSuperview];
        if ([view isKindOfClass:[UIButton class]])
            [view removeFromSuperview];
    }
    
    UIImage* img4 =[UIImage imageNamed:@"card_img_unopen"];
    
    float img4Y =CGRectGetMaxY(topLab2.frame)+5;
    float img4H = topView.frame.size.height - img4Y - 5;
    float img4W = img4.size.width*img4H / img4.size.height;
    float img4X = topView.frame.size.width - 10 - img4W;
    
    
    UIButton* awardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    awardBtn.frame =CGRectMake(img4X,img4Y,img4W,img4H);
    [awardBtn setBackgroundImage:img4 forState:UIControlStateNormal];
    if (total ==num){
        awardBtn.frame =CGRectMake(img4X,img4Y-15,img4W,img4H+20);
        [awardBtn setBackgroundImage:[UIImage imageNamed:@"card_img_open"] forState:UIControlStateNormal];
        [[awardBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {
             [[NSNotificationCenter defaultCenter]postNotificationName:@"jumpToMyReward" object:nil];
             [[BaiduMobStat defaultStat]logEvent:@"btn_yueman_intime" eventLabel:@"准时到店满足次数盖子点击"];
         }];
    }
    else{
        UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0, img4H*0.45, img4W, img4H/2)];
        lab.text = [NSString stringWithFormat:@"%d",total];
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:KMainScreenWidth*11/320];
        lab.textAlignment = NSTextAlignmentCenter;
        [awardBtn addSubview:lab];
    }
    [topView addSubview:awardBtn];
    
    
    
    int time =total> 5 ? 5 :total;
    if (time >1)  --time;
    
    int xx = total-num>4?num:total - 4;
    if (xx < 1) xx = 1;
    float jc = (topView.frame.size.width-20 - img4W)/(time);
    
    if (total <= 1 && num <= 1) xx = 0;
    
    float btnWH = img4H*0.6;
    float btnY =  topView.frame.size.height - 5 - btnWH;
    float lw = jc -btnWH;
    for (int i = 0; i<time; i++) {
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSString* tit = [NSString stringWithFormat:@"%i",i+xx];
        [btn setTitle:tit forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*11/320];
        if ((i+xx) <= num) {
            [btn setBackgroundImage:[UIImage imageNamed:@"card_btn_get"] forState:UIControlStateNormal];
        }else
            [btn setBackgroundImage:[UIImage imageNamed:@"card_btn_unget"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(10+(jc*i), btnY, btnWH,btnWH);
        [topView addSubview:btn];
        
        
        
        if (i<time) {
            float imgX = CGRectGetMaxX(btn.frame)-1;
            float imgH = KMainScreenWidth*5/320;
            float imgW = lw+2;
            float imgY =btnY+(btnWH-imgH)/2;
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgW, imgH)];
            [topView addSubview:img];
            
            NSString* imgName = nil;
            if (xx+i+1<=num)
                imgName = @"card_img_line2";
            else
                imgName = @"card_img_line1";
            
            if (i == time - 1) {
                if(total == num)
                    imgName = @"card_img_line2";
                else{
                    if(total-xx-i ==1)
                        imgName = @"card_img_line1";
                    
                    if (total-xx-i>1)
                        imgName = @"card_img_line3";
                }
            }
            img.image = [UIImage imageNamed:imgName];
        }
    }
    
}

-(void)setupTableView{
    self.myData = [NSMutableArray array];
    
    float tabX = 16;
    float tabY = CGRectGetMaxY(topView.frame)+16;
    float tabW = KMainScreenWidth - tabX*2;
    float tabH = KMainScreenHeight - tabY - 16;
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(tabX, tabY, tabW, tabH) style:UITableViewStylePlain];
    myTableView.delegate=self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = 0;
    [self.view addSubview:myTableView];
    [self setupNodataView];
    myTableView.tableFooterView = [UIView new];
    
    myTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self startRequestInTimeInfo];
        self->pageNum =0;
        [self startRequestCardInfo];
    }];
        myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            ++self->pageNum;
            [self startRequestCardInfo];
        }];
  
}
-(void)setupNodataView{
    
    UIView* nodata = [[UIView alloc]initWithFrame:CGRectMake(0, 0, myTableView.frame.size.width, myTableView.frame.size.height)];
    nodata.hidden=self.myData.count>0;
    [myTableView addSubview:nodata];
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
    
    nodata=nil; img=nil; lab=nil;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KMainScreenWidth* 80/320;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* name = @"cell";
    UNICardInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell =[[UNICardInfoCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, KMainScreenWidth* 80/320) reuseIdentifier:name];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setupCellContentWith:self.myData[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UNIAppointDetail* appoint = [story instantiateViewControllerWithIdentifier:@"UNIAppointDetail"];
    UNIMyAppointInfoModel* model =_myData[indexPath.row];
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
