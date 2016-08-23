//
//  UNIOrderListView.m
//  Uni
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIOrderListView.h"
//#import "UNIOrderListCell.h"
#import <MJRefresh/MJRefresh.h>
#import "UNIHttpUrlManager.h"
#import "UNITransfromX&Y.h"
#import "UNIShopManage.h"
#import "BaiduMobStat.h"

#import "UNIOrderListCell1.h"
#import "UNIOrderListCell2.h"
#import "UNIOrderListCell3.h"
#import "UNIOrderList4Cell.h"
#import "UNIOrderRequest.h"
@implementation UNIOrderListView

-(id)initWithFrame:(CGRect)frame andState:(int)st{
    self = [super initWithFrame:frame];
    if (self) {
        self.status = st;
        self.allArray = [NSMutableArray array];
//        [LLARingSpinnerView RingSpinnerViewStart1andStyle:1];
//         [self startRequest];
        [self setupTableView];
    }
    return self;
}
-(void)startRequest{
    
    UNIOrderRequest* request = [[UNIOrderRequest alloc]init];
    [request postWithSerCode:@[API_URL_MyOrderList]
                      params:@{@"status":@(self.status),@"page":@(self.page),@"size":@(20)}];
    request.myOrderListBlock=^(NSArray* array ,NSString* tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTable.header endRefreshing];
            [self.myTable.footer endRefreshing];
            [LLARingSpinnerView RingSpinnerViewStop1];
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            
            if (self.page == 0)
                [self.allArray removeAllObjects];
            
            if (array.count<20)
                [self.myTable.footer endRefreshingWithNoMoreData] ;
            
                [self.allArray addObjectsFromArray:array];
                [self setupTableView];
        });
    };
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
    
    UNIHttpUrlManager* manager = [UNIHttpUrlManager sharedInstance];
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame)+20, nodata.frame.size.width, 50)];
    lab.text=manager.NO_ORDER_TIPS;
    lab.font = [UIFont systemFontOfSize:KMainScreenWidth>400?16:14];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.lineBreakMode = 0;
    lab.numberOfLines = 0;
    lab.textColor = [UIColor colorWithHexString:kMainTitleColor];
    [nodata addSubview:lab];
    
    nodata=nil; img=nil; lab=nil;
}


-(void)setupTableView{

//   self->noDataView.hidden=self.allArray.count>0;
//    
//    if (self.myTable){
//        [self.myTable reloadData];
//        return;}
    
    UITableView* tabview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                                                       style:UITableViewStylePlain];
    tabview.delegate = self;
    tabview.dataSource = self;
    tabview.showsVerticalScrollIndicator=NO;
    tabview.separatorStyle = 0;
    tabview.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    [self addSubview:tabview];
    self.myTable =tabview;
    tabview.tableFooterView = [UIView new];
    //[self setupNodataView];
        tabview.header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 0;
            [self startRequest];
        }];
    
        tabview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.page++;
            [self startRequest];
        }];
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 15)];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   // return self.allArray.count;
    return 10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0)
        return KMainScreenWidth*38/414;
    if (indexPath.row == 1)
        return KMainScreenWidth*82/414;
    if (indexPath.row == 2)
        return KMainScreenWidth*49/414;
    if (indexPath.row == 3)
        return KMainScreenWidth*60/414;
    
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    static NSString* name = @"cell";
//    UNIOrderListCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
//    if (!cell){
//        cell = [[UNIOrderListCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, KMainScreenWidth*90/320) reuseIdentifier:name];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    [[cell.stateBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
//    subscribeNext:^(id x) {
//        UNIShopManage* shopMan = [UNIShopManage getShopData];
//        double endLat = [shopMan.x doubleValue];
//        double endLong = [shopMan.y doubleValue];
//        UNITransfromX_Y* xy= [[UNITransfromX_Y alloc]initWithView:self withEndCoor:CLLocationCoordinate2DMake(endLat, endLong) withAim:shopMan.shopName];
//        [xy setupUI];
//        [[BaiduMobStat defaultStat]logEvent:@"btn_reward_get" eventLabel:@"奖励到店领取"];
//    }];
//    [cell setupCellContentWith:self.allArray[indexPath.row]];
    
    
    //UNIOrderListModel* info = _allArray[indexPath.section];
    if (indexPath.row == 0) {
        UNIOrderListCell1* cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"UNIOrderListCell1" owner:self options:nil].lastObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.mainLab.text =@"订单编号：1243567";
        //cell.mainLab.text = [NSString stringWithFormat:@"订单编号:%@",info.orderCode];
        return cell;
    }
    if (indexPath.row == 1) {
        UNIOrderListCell2* cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"UNIOrderListCell2" owner:self options:nil].lastObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
//        cell.label1.text =info.projectName;
//        cell.label2.text = nil;
//        cell.label3.text = [NSString stringWithFormat:@"￥%@",info.price];
//        cell.label4.text = [NSString stringWithFormat:@"x%d",info.num];
//        if(info.specifications) cell.label2.text = [NSString stringWithFormat:@"规格: %@",info.specifications];
        return cell;
    }
    if (indexPath.row == 2) {
        UNIOrderListCell3* cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"UNIOrderListCell3" owner:self options:nil].lastObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
//        cell.label2.text =[NSString stringWithFormat:@"%d",info.num];
//        cell.label5.text = [NSString stringWithFormat:@"￥%@",info.price];
//        
//        CGSize size5 = [UNIOrderListCell3 contentSize:cell.label5];
//        CGRect rect5 = cell.label5.frame;
//        rect5.size.width = size5.width;
//        rect5.origin.x = KMainScreenWidth - 16 - size5.width;
//        cell.label5.frame = rect5;
//        
//        CGRect rect4 = cell.label4.frame;
//        rect4.origin.x = CGRectGetMinX(rect5);
//        cell.label4.frame =rect4;
        
        return cell;
    }
    if (indexPath.row == 3) {
        UNIOrderList4Cell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"UNIOrderList4Cell" owner:self options:nil].lastObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
//        cell.label1.text = [NSString stringWithFormat:@"下单时间: %@",info.time];
//        if (info.status == 0) {
//            [cell.handleBtn setTitle:@"到店领取" forState:UIControlStateNormal];
//            [cell.handleBtn setBackgroundImage:[UIImage imageNamed:@"order_btn_handle1"] forState:UIControlStateNormal];
//        }
//        if (info.status == 1) {
//            [cell.handleBtn setTitle:@"已领取" forState:UIControlStateNormal];
//            [cell.handleBtn setBackgroundImage:[UIImage imageNamed:@"order_btn_handle2"] forState:UIControlStateNormal];
//        }
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   //[self.delegate UNIOrderListViewDelegate:self.allArray[indexPath.row]];
    [self.delegate UNIOrderListViewDelegate:nil];
}


@end
