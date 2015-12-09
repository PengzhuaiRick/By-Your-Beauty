//
//  UNIPurchaseController.m
//  Uni
//  购买界面
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIPurchaseController.h"
#import "UNIPurchaseCell.h"
#import "UNIPurChaseView.h"
@interface UNIPurchaseController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView* myTable;
@end

@implementation UNIPurchaseController

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
   
}
-(void)startRequest{
    
}
-(void)setupTableView{
    float tabX = 10;
    float tabY = 64+8;
    if (IOS_VERSION<9.0)
        tabY = 8;
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
    [self setupTabViewFooter];
}

-(void)setupTabViewFooter{
    UNIPurChaseView* view = [[UNIPurChaseView alloc]initWithFrame:CGRectMake(0, 0, _myTable.frame.size.width, 200) andPrice:12];
    self.myTable.tableFooterView = view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* name = @"cell";
    UNIPurchaseCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"UNIPurchaseCell" owner:self options:nil].lastObject;
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
