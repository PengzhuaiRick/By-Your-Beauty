//
//  UNIGoodsComment.m
//  Uni
//  客妆商品评价
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIGoodsComment.h"
#import "UNIGoodsCommentCell.h"
#import <MJRefresh/MJRefresh.h>
@interface UNIGoodsComment ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView* myTable;
@property(nonatomic, assign)int page;  ////当前
@property(nonatomic,strong)NSMutableArray* allArray;
@end

@implementation UNIGoodsComment

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupData];
    [self setupTableView];
}
-(void)setupNavigation{
    self.title = @"商品评论";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
}
-(void)setupData{
    self.page = 0;
    self.allArray = [NSMutableArray array];
}
-(void)startRequest{
    
}
-(void)setupTableView{
    float tabX = 10;
    float tabY = 64+8;
    float tabW = KMainScreenWidth - tabX*2;
    float tabH = KMainScreenHeight - 64 - tabX*2;
//    if (IOS_VERSION<9.0){
//        tabY = 8;
//        tabH = KMainScreenHeight - tabX*2;
//    }
    
    UITableView* tabview = [[UITableView alloc]initWithFrame:CGRectMake(tabX, tabY, tabW, tabH) style:UITableViewStylePlain];
    tabview.delegate = self;
    tabview.dataSource = self;
    tabview.layer.masksToBounds=YES;
    tabview.layer.cornerRadius = 10;
    tabview.showsVerticalScrollIndicator=NO;
    [self.view addSubview:tabview];
    self.myTable =tabview;
    if (IOS_VERSION>9.0)
        tabview.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    
    tabview.header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 0;
        [self.allArray removeAllObjects];
        [self startRequest];
    }];
    
    tabview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self startRequest];
    }];
    
    if (IOS_VERSION<9.0){
        tabview.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    }

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* name = @"cell";
    UNIGoodsCommentCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"UNIGoodsCommentCell" owner:self options:nil].lastObject;
    }
    [cell setupCellContentWith:nil];
    return cell;
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
