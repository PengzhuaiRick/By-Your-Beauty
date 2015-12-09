//
//  UNIGoodsDeatilController.m
//  Uni
//  客妆商品详情
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIGoodsDeatilController.h"
#import "UNIGoodsCell1.h"
#import "UNIGoodsCell2.h"
#import "UNIGoodsCell3.h"
#import "UNIGoodsCell4.h"
#import "UNIGoodsComment.h"
#import <MJRefresh/MJRefresh.h>
@interface UNIGoodsDeatilController ()<UITableViewDataSource,UITableViewDelegate>{
    UIView* midView;
}
@property(nonatomic,strong)UIScrollView* myScroller;
@property(nonatomic,strong)UITableView* myTable;
@property(nonatomic,strong)NSMutableArray* allArray;

@end

@implementation UNIGoodsDeatilController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupData];
    [self setupMyScroller];
    [self setupTableView];
}
-(void)setupNavigation{
    self.title = @"客妆";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
}
-(void)setupData{
    self.allArray = [NSMutableArray array];
}
-(void)startRequest{
    
}
-(void)setupMyScroller{
    float scX = 10;
    float scY = 64+8;
    float scW = KMainScreenWidth - scX*2;
    float scH = KMainScreenHeight - 64 - scX*2;
    if (IOS_VERSION<9.0){
        scY = 8;
        scH = KMainScreenHeight - scX*2;
    }

    self.myScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(scX, scY, scW, scH)];
    self.myScroller.delegate = self;
    self.myScroller.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.myScroller];
}
-(void)setupTableView{
    float tabW = self.myScroller.frame.size.width;
    float tabH = self.myScroller.frame.size.height;
    
    UITableView* tabview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, tabW, tabH) style:UITableViewStylePlain];
    tabview.delegate = self;
    tabview.dataSource = self;
    tabview.layer.masksToBounds=YES;
    tabview.layer.cornerRadius = 10;
    tabview.showsVerticalScrollIndicator=NO;
    [self.myScroller addSubview:tabview];
    self.myTable =tabview;
    [self setupHeaderview];
    tabview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.myTable.footer endRefreshing];
        //self.myTable.footer.hidden=YES;
        self.myScroller.contentSize = CGSizeMake(self.myScroller.frame.size.width, self.myScroller.frame.size.height*2);
        [self.myScroller setContentOffset:CGPointMake(0, self.myScroller.frame.size.height) animated:YES];
    }];
}

#pragma mark 设置头部View
-(void)setupHeaderview{
    
    float topW = KMainScreenWidth - 10*2;
    float topH = KMainScreenWidth* 100/320;
    UIView* top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, topW, topH)];
    self.myTable.tableHeaderView = top;
    
    UIImage* img = [UIImage imageNamed:@"mian_img_cellH"];
    float imgH = KMainScreenWidth* 16/320;
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, topW, imgH)];
    imgView.image =img;
    [top addSubview:imgView];
    
    float labX = KMainScreenWidth*5/320;
    float labY = 0;
    float labW = topW- labX*2;
    UILabel* lab =[[UILabel alloc]initWithFrame:CGRectMake(labX, labY, labW, imgH)];
    lab.text = @"团购满";
    lab.font = [UIFont boldSystemFontOfSize:KMainScreenWidth* 12/320];
    [top addSubview:lab];
    
    UIImage* img2 = [UIImage imageNamed:@"main_img_cellF"];
    float img2H = KMainScreenWidth*8/320;
    float img2Y = topH - img2H-10;
    UIImageView* imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, img2Y, topW, img2H)];
    imgView2.image = img2;
    [top addSubview:imgView2];
    
    float midH = topH - imgH - img2H;
    UIView * midview = [[UIView alloc]initWithFrame:CGRectMake(0, imgH, topW, midH)];
    midview.backgroundColor = [UIColor whiteColor];
    [top addSubview:midview];
    midView = midview;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float cell = 0;
    switch (indexPath.row) {
        case 0:
            cell = 255;
            break;
        case 1:
            cell = 110;
            break;
        case 2:
            cell = 44;
            break;
        case 3:
            cell = 125;
            break;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            UNIGoodsCell1* cell =[[NSBundle mainBundle]loadNibNamed:@"UNIGoodsCell1" owner:self options:nil].lastObject;
            [cell setupCellContentWith:nil];
            return cell;
        }
            break;
        case 1:{
            UNIGoodsCell2* cell =[[NSBundle mainBundle]loadNibNamed:@"UNIGoodsCell2" owner:self options:nil].lastObject;
            [cell setupCellContentWith:nil];
            return cell;
        }
            break;
        case 2:{
            UNIGoodsCell3* cell =[[NSBundle mainBundle]loadNibNamed:@"UNIGoodsCell3" owner:self options:nil].lastObject;
            return cell;
        }
            break;
        case 3:{
            UNIGoodsCell4* cell =[[NSBundle mainBundle]loadNibNamed:@"UNIGoodsCell4" owner:self options:nil].lastObject;
            [cell setupCellContentWith:nil];
            return cell;
        }
            break;
    }

    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:{
            UIStoryboard* st = [UIStoryboard storyboardWithName:@"KeZhuang" bundle:nil];
            UNIGoodsComment* comment = [st instantiateViewControllerWithIdentifier:@"UNIGoodsComment"];
            [self.navigationController pushViewController:comment animated:YES];
        }
            break;
        case 3:
            break;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float yy = scrollView.contentOffset.y;
    NSLog(@"scrollView.contentOffset.x  %f",yy);
    if (yy > scrollView.frame.size.height) {
        self.myTable.footer.hidden = YES;
    }
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
