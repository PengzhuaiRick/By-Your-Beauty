//
//  UNIWalletList.m
//  Uni
//  钱包明细
//  Created by apple on 15/12/8.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIWalletList.h"
#import "UNIWalletCell.h"
#import <MJRefresh/MJRefresh.h>
@interface UNIWalletList ()<UITableViewDataSource,UITableViewDelegate>{
}
@property(nonatomic,strong)UITableView* myTable;
@property(nonatomic, assign)int page;  ////当前
@property(nonatomic,strong)NSMutableArray* allArray;
@end

@implementation UNIWalletList

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupData];
    [self setupTableView];
}
-(void)setupNavigation{
    self.title = @"钱包明细";
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
    
    UITableView* tabview = [[UITableView alloc]initWithFrame:CGRectMake(tabX, tabY, tabW, tabH) style:UITableViewStylePlain];
    tabview.delegate = self;
    tabview.dataSource = self;
    tabview.layer.masksToBounds=YES;
    tabview.layer.cornerRadius = 10;
    tabview.showsVerticalScrollIndicator=NO;
    [self.view addSubview:tabview];
    self.myTable =tabview;
    
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
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* name = @"cell";
    UNIWalletCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"UNIWalletCell" owner:self options:nil].lastObject;
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
