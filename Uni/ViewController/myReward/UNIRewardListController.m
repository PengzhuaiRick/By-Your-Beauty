//
//  UNIRewardListController.m
//  Uni
//  我的奖励列表
//  Created by apple on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIRewardListController.h"
#import "UNIRewardListCell.h"
#import "UNIRewardDetail.h"
#import <MJRefresh/MJRefresh.h>
@interface UNIRewardListController ()<UITableViewDataSource,UITableViewDelegate>{
    UIView* topView;
}
@property(nonatomic,strong)CALayer* lineLayer;
@property(nonatomic,strong)UITableView* myTable;
@end

@implementation UNIRewardListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupTopView];
    [self setupTableView];
}
-(void)setupNavigation{
    self.title = @"我的奖励";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
}
-(void)setupTopView{
    float topH = KMainScreenWidth * 40/320;
    UIView* top = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KMainScreenWidth, topH)];
    top.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:top];
    topView = top;
    
    NSArray* titil = @[@"全部",@"未领取",@"已领取"];
    float btnX = 10;
    float btnW = (KMainScreenWidth-btnX*2)/3;
    for (int i = 0; i <titil.count; i++) {
        NSString* str = titil[i];
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnX+i*btnW, 0, btnW, topH);
        btn.tag = i+1;
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:kMainTitleColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:kMainThemeColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor colorWithHexString:kMainThemeColor] forState:UIControlStateSelected];
        if (i == 0)
            btn.selected = YES;
        if (i<titil.count-1) {
            float layX =btnX+i*btnW+btnW;
            float layH = topH*0.7;
            float layY = (topH - layH)/2;
            CALayer* lay = [CALayer layer];
            lay.backgroundColor = kMainGrayBackColor.CGColor;
            lay.frame = CGRectMake(layX, layY, 1, layH);
            [top.layer addSublayer:lay];
        }
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*13/320];
            [top addSubview:btn];
        
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(UIButton* x) {
             x.selected=YES;
             for (int i = 1; i<4; i++) {
                 UIButton* bt = (UIButton*)[top viewWithTag:i];
                 if (x!=bt) {
                     bt.selected = NO;
                 }
             }
             
             [self lineLayerMoveAction:x];
        }];
    }
    
    float layY = topH-2;
    CALayer* lay = [CALayer layer];
    lay.backgroundColor = [UIColor colorWithHexString:kMainThemeColor].CGColor;
    lay.frame = CGRectMake(btnX, layY, btnW, 1);
    [top.layer addSublayer:lay];
    self.lineLayer = lay;
}
#pragma mark 顶部红色底线滑动事件
-(void)lineLayerMoveAction:(UIButton*)btn{
    CGRect layRe = self.lineLayer.frame;
    [UIView animateWithDuration:0.2 animations:^{
        self.lineLayer.frame = CGRectMake(btn.frame.origin.x,
                                          layRe.origin.y,
                                          layRe.size.width,
                                          layRe.size.height);
    }];
}
-(void)setupTableView{
    float tabX = 10;
    float tabY = CGRectGetMaxY(topView.frame)+tabX;
    float tabW = KMainScreenWidth - tabX*2;
    float tabH = KMainScreenHeight - tabX - tabY;
    UITableView* tabview = [[UITableView alloc]initWithFrame:CGRectMake(tabX, tabY, tabW, tabH) style:UITableViewStylePlain];
    tabview.delegate = self;
    tabview.dataSource = self;
    tabview.layer.masksToBounds=YES;
    tabview.layer.cornerRadius = 10;
    tabview.showsVerticalScrollIndicator=NO;
    [self.view addSubview:tabview];
    self.myTable =tabview;
    
    tabview.header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    }];
    
    tabview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* name = @"cell";
    UNIRewardListCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell){
        cell = [[NSBundle mainBundle]loadNibNamed:@"UNIRewardListCell" owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setupCellContentWith:nil];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Function" bundle:nil];
    UNIRewardDetail* rd = [st instantiateViewControllerWithIdentifier:@"UNIRewardDetail"];
    [self.navigationController pushViewController:rd animated:YES];
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
