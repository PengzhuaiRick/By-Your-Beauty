//
//  UNIRewardListView.m
//  Uni
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIRewardListView.h"
//#import "UNIRewardListCell.h"
#import "UNIMyRewardRequest.h"
#import <MJRefresh/MJRefresh.h>
#import "UNIHttpUrlManager.h"
#import "UNITransfromX&Y.h"
#import "UNIShopManage.h"
#import "BaiduMobStat.h"
#import "UNIRewardListXibCell.h"
@implementation UNIRewardListView

-(id)initWithFrame:(CGRect)frame andState:(int)st{
    self = [super initWithFrame:frame];
    if (self) {
        self.status = st;
        self.backgroundColor = [UIColor clearColor];
        //[self setupTableView];
        self.allArray = [NSMutableArray array];
        [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
         [self startRequest];
       
    }
    return self;
}
-(void)startRequest{
    
    UNIMyRewardRequest* request = [[UNIMyRewardRequest alloc]init];
    [request postWithSerCode:@[API_URL_MYRewardList]
                      params:@{@"status":@(self.status),@"page":@(self.page),@"size":@(20)}];
    request.rewardListBlock=^(NSArray* array ,NSString* tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            [LLARingSpinnerView RingSpinnerViewStop1];
            [self.myTable.header endRefreshing];
            [self.myTable.footer endRefreshing];
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            if (self.page == 0)
                [self.allArray removeAllObjects];
            
            [self.allArray addObjectsFromArray:array];
            
            [self setupTableView:array];
        });
        
    };
}


-(void)setupTableView:(NSArray*)arr{
    noDataView.hidden = self.allArray.count>0;
    if (self.myTable){
        [self.myTable reloadData];
        if (arr.count<20){
            [self.myTable.footer endRefreshingWithNoMoreData];
        }
        return;
    }
    
    UITableView* tabview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                                                       style:UITableViewStylePlain];
    tabview.delegate = self;
    tabview.dataSource = self;
    tabview.showsVerticalScrollIndicator=NO;
    tabview.backgroundColor = [UIColor clearColor];
    tabview.separatorStyle = 0;
    [self addSubview:tabview];
    tabview.tableFooterView = [UIView new];
    self.myTable =tabview;
    [self setupNodataView];
    
    tabview.header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 0;
        [self startRequest];
    }];
    
    if (self.allArray.count>19) {
        tabview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.page++;
            [self startRequest];
        }];
    }
    
   //self.myTable.footer.automaticallyHidden = YES;
    tabview=nil;
}
-(void)setupNodataView{
    
    UIView* nodata = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _myTable.frame.size.width, _myTable.frame.size.height)];
    nodata.hidden=self.allArray.count>0;
    [_myTable addSubview:nodata];
    noDataView = nodata;
    
    UIImageView* img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"main_img_nodata3"]];
    float imgWH = KMainScreenWidth>400?60:50,
    imgX = (nodata.frame.size.width - imgWH)/2;
    img.frame = CGRectMake(imgX, 30, imgWH, imgWH);
    [nodata addSubview:img];
    
    //UNIHttpUrlManager* manager = [UNIHttpUrlManager sharedInstance];
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame)+20, nodata.frame.size.width, 30)];
   // lab.text=manager.NO_ORDER_TIPS;
    if (self.status == -1)
        lab.text = @"很抱歉，您暂时还没获得奖励哦！";
    if (self.status == 0)
        lab.text = @"很抱歉，您暂时没有未领取的奖励！";
    if (self.status == 1)
        lab.text = @"很抱歉，您暂时没有已领取的奖励！";
    
    lab.font = [UIFont systemFontOfSize:KMainScreenWidth>400?16:14];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor colorWithHexString:kMainTitleColor];
    [nodata addSubview:lab];
    
    nodata=nil;img=nil; lab=nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 15)];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KMainScreenWidth*85/414;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* name = @"cell";
    UNIRewardListXibCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell){
        cell = [[NSBundle mainBundle]loadNibNamed:@"UNIRewardListXibCell" owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [[cell.stateBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         UNIShopManage* shopMan = [UNIShopManage getShopData];
         double endLat = [shopMan.x doubleValue];
         double endLong = [shopMan.y doubleValue];
         UNITransfromX_Y* xy= [[UNITransfromX_Y alloc]initWithView:self withEndCoor:CLLocationCoordinate2DMake(endLat, endLong) withAim:shopMan.shopName];
         [xy setupUI];
         [[BaiduMobStat defaultStat]logEvent:@"btn_reward_get" eventLabel:@"奖励到店领取"];
     }];

    
    [cell setupCellContentWith:self.allArray[indexPath.section]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
