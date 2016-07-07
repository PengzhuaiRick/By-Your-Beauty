//
//  UNILoginShopList.m
//  Uni
//
//  Created by apple on 16/4/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNILoginShopList.h"
#import <MJRefresh/MJRefresh.h>
#import "BTKeyboardTool.h"
#import "UNIShopListCell.h"
#import "AccountManager.h"
#import "AppDelegate.h"
//#import "UNILoginShopModel.h"
#import "UNILoginViewRequest.h"
@interface UNILoginShopList ()<UITableViewDataSource,UITableViewDelegate,KeyboardToolDelegate,UISearchBarDelegate>
{
    int pageNum;
    int pageSize;
   // UILabel* noData;
    NSArray* resultArr;
}

@property(nonatomic,strong) UITableView* tableView;
@end

@implementation UNILoginShopList
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"请选择店铺"];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"请选择店铺"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupSelf];
    [self setupSearchBar];
    [self setupParams];
    [self setupTableView];
    //[self startRequest];
    
}
-(void)setupNavigation{
    self.title = @"请选择店铺";
  //  self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(leftBarButtonEvent:)];
}

-(void)leftBarButtonEvent:(UIBarButtonItem*)item{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupSelf{
    self.view.backgroundColor =[UIColor colorWithHexString:kMainBackGroundColor];
    
}
#pragma mark 设置参数
-(void)setupParams{
    pageNum = 0;
    pageSize = 20;
    resultArr = _myData;
   
}
#pragma mark 设置 searchBar
-(void)setupSearchBar{
    UISearchBar * bar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, KMainScreenWidth, 40)];
    bar.delegate =self;
   // self.navigationItem.titleView = bar;
    bar.placeholder = @"店铺名称或地址";
    [self.view addSubview:bar];
    
    BTKeyboardTool* tool = [BTKeyboardTool keyboardTool];
    tool.toolDelegate = self;
    [tool dismissTwoBtn];
    bar.inputAccessoryView = tool;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"searchText  %@",searchText);
    NSString* text = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (text.length>0) {
        NSMutableArray* result = [NSMutableArray array];
        for (UNILoginShopModel* model in _myData) {
            if ([model.shopName rangeOfString:searchText].location !=NSNotFound) {
                [result addObject:model];
            }else if ([model.address rangeOfString:searchText].location !=NSNotFound){
                [result addObject:model];
            }
        }
        resultArr = result;
    }else
        resultArr = _myData;
   
    [_tableView reloadData];
}
-(void)keyboardTool:(BTKeyboardTool *)tool buttonClick:(KeyBoardToolButtonType)type{
    [self.view endEditing:YES];
}

#pragma mark 初始化TableView
-(void)setupTableView{
    if (self.tableView){
        [self.tableView reloadData];
        return;
    }
    
    UITableView* tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, KMainScreenWidth, KMainScreenHeight-104) style:UITableViewStylePlain];
    tab.delegate = self;
    tab.dataSource = self;
    [self.view addSubview:tab];
    self.tableView = tab;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    
//    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self->pageNum =0;
//        self->pageSize =(int)self.myData.count;
//        //[self startRequest];
//    }];
//    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        ++self->pageNum;
//        self->pageSize =(int)self.myData.count+20;
//        //[self startRequest];
//    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return resultArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KMainScreenWidth*70/320;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* name = @"CellName";
    UNIShopListCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell)
        cell = [[UNIShopListCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, KMainScreenWidth*70/320) reuseIdentifier:name];
    UNILoginShopModel* model = resultArr[indexPath.row];
    cell.mainLab.text = model.shopName;
    cell.subLab.text = model.address;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
     UNILoginShopModel* model = resultArr[indexPath.row];
    __weak UNILoginShopList* myself = self;
        if (myself.extra == 2) {
            [AccountManager setToken:model.token];
            //[AccountManager setUserId:@(model.userId)];
            [AccountManager setShopId:@(model.shopId)];
            [AccountManager setLocalLoginName:myself.phone];
            [myself login];
        }else if(myself.extra == 0)
            [myself addUser:model.shopId];
   
   
    
}

-(void)addUser:(int)shopId{
    __weak UNILoginShopList* myself = self;
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
    UNILoginViewRequest* rq = [[UNILoginViewRequest alloc]init];
    [rq postWithSerCode:@[API_URL_addUser] params:@{@"phone":_phone,@"password":_randcode,@"shopId":@(shopId)}];
    rq.sAddUser=^(int userId,int shopId,NSString* token,NSString* tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            [LLARingSpinnerView RingSpinnerViewStop1];
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            if (token) {
                [AccountManager setToken:token];
               // [AccountManager setUserId:@(userId)];
                [AccountManager setShopId:@(shopId)];
                [AccountManager setLocalLoginName:myself.phone];
                [myself login];
            }else
                [YIToast showText:tips];

        });
            };
}
-(void)login{
    //跳转
   // [self dismissViewControllerAnimated:NO completion:nil];
    self.view.window.backgroundColor = [UIColor whiteColor];
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    [app setupViewController];
    
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
    
}

-(void)dismiss{
    [self dismissViewControllerAnimated:NO completion:nil];
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
