//
//  UNIWalletController.m
//  Uni
//  我的卡包
//  Created by apple on 15/12/8.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIWalletController.h"
#import "UNIWalletCell.h"
@interface UNIWalletController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView* myTable;
@end

@implementation UNIWalletController
-(void)viewWillAppear:(BOOL)animated{
    NSArray* array =self.containController.view.gestureRecognizers;
    for (UIGestureRecognizer* ges in array) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled=YES;
        }
    }
    [super viewWillAppear:animated];

}
-(void)viewWillDisappear:(BOOL)animated{
    NSArray* array =self.containController.view.gestureRecognizers;
    for (UIGestureRecognizer* ges in array) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled=NO;
        }
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
   // [self setupTableView];
    [self noDataView];
}
-(void)noDataView{
    UILabel*lab = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, KMainScreenWidth - 32, KMainScreenHeight)];
    lab.text = @"很抱歉您暂时没有可用现金券。马上开始预约服务，大把现金券等你拿！";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.lineBreakMode = 0;
    lab.numberOfLines = 0;
    lab.font = [UIFont systemFontOfSize:KMainScreenWidth>320?16:14];
    lab.textColor = [UIColor colorWithHexString:kMainTitleColor];
    [self.view addSubview:lab];
}
-(void)setupNavigation{
    self.title = @"我的卡包";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(navigationControllerLeftBarAction:)];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:0 target:self action:nil];
}

-(void)setupTableView{
    UITableView* tabview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+10, KMainScreenWidth,KMainScreenHeight - 64 - 10) style:UITableViewStylePlain];
    tabview.delegate = self;
    tabview.dataSource = self;
    tabview.showsVerticalScrollIndicator=NO;
    [self.view addSubview:tabview];
    tabview.tableFooterView = [UIView new];
    if (IOS_VERSION>8.0) {
        tabview.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    }
    self.myTable =tabview;
    
//    self.myTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        self.myScroller.contentSize = CGSizeMake(self.myScroller.frame.size.width, self.myScroller.frame.size.height*2);
//        [self.myScroller setContentOffset:CGPointMake(0,self.myScroller.frame.size.height) animated:YES];
//        self.myTable.footer = nil;
//        [self setupWebView];
//        
//    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KMainScreenWidth* 120/320;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
         static NSString* name = @"cell";
    UNIWalletCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell = [[UNIWalletCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, KMainScreenWidth* 120/320) reuseIdentifier:name];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
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


-(void)navigationControllerRightBarAction:(UIBarButtonItem*)bar{
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Function" bundle:nil];
    UIViewController* view = [st instantiateViewControllerWithIdentifier:@"UNIWalletList"];
    [self.navigationController pushViewController:view animated:YES];

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
