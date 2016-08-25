//
//  UNIShopCarController.m
//  Uni
//
//  Created by apple on 16/8/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIShopCarController.h"
#import "UNIShopCarCell.h"
#import "UNIShopCarRequest.h"

@interface UNIShopCarController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *allSelectBtn;//全选按钮
@property (weak, nonatomic) IBOutlet UILabel *priceLab; //合计

@end

@implementation UNIShopCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupUI];
    [self startRequest];
    [self requestBottomInfo];
}
-(void)setupNavigation{
    self.title = @"购物车";
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(navigationControllerLeftBarAction:)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}
-(void)navigationControllerLeftBarAction:(UIBarButtonItem*)bar{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setupUI{
    _allSelectBtn.titleLabel.font = kWTFont(15);
    _priceLab.font = kWTFont(18);
    _payBtn.titleLabel.font = kWTFont(18);
    
    [_allSelectBtn setImage:[UIImage imageNamed:@"addpro_btn_selelct1"] forState:UIControlStateNormal];
    [_allSelectBtn setImage:[UIImage imageNamed:@"addpro_btn_selelct2"] forState:UIControlStateSelected];
}
#pragma mark 请求购物车列表
-(void)startRequest{
    UNIShopCarRequest* rq = [[UNIShopCarRequest alloc]init];
    [rq postWithSerCode:@[API_URL_GetCartList] params:nil];
    rq.getCartList=^(NSArray* arr,NSString* tips,NSError* err){
        
    };
}

#pragma mark 请求购物车底部信息
-(void)requestBottomInfo{
    UNIShopCarRequest* rq = [[UNIShopCarRequest alloc]init];
    [rq postWithSerCode:@[API_URL_GetCartBottomInfo] params:nil];
    rq.getCartBottomInfo=^(float endPrice,int isAll,int isCheckNum,NSString* tips,NSError* err){
        
    };
}
#pragma mark 添加到购物车，修改购物车数量，减少购物车数量
-(void)requestChangeNumOfShopCar{
    UNIShopCarRequest* rq = [[UNIShopCarRequest alloc]init];
    [rq postWithSerCode:@[API_URL_ChangeNumOfShopCar] params:@{@"num":@"",@"goodId":@"",@"goodType":@"",@"isCheck":@""}];
    rq.changeGoodsToCart=^(NSString* tips,NSError* err){
        
    };
}

#pragma mark 删除购物车物品
-(void)requestDelCartGoods{
    UNIShopCarRequest* rq = [[UNIShopCarRequest alloc]init];
    [rq postWithSerCode:@[API_URL_DelCartGoods] params:@{@"isAll":@"",@"goodsKeys":@""}];
    rq.delCartGoods=^(NSString* tips,NSError* err){
        
    };
}

#pragma mark 是否全选
-(void)requestChangeCartGoodsIsCheck{
    UNIShopCarRequest* rq = [[UNIShopCarRequest alloc]init];
    [rq postWithSerCode:@[API_URL_ChangeCartGoodsIsCheck] params:@{@"isAll":@""}];
    rq.changeCartGoodsIsCheck=^(NSString* tips,NSError* err){
        
    };
}
#pragma mark 修改某个商品是否选中
-(void)requestCartIsCheck{
    UNIShopCarRequest* rq = [[UNIShopCarRequest alloc]init];
    [rq postWithSerCode:@[API_URL_CartIsCheck] params:@{@"goodId":@"",@"goodType":@"",@"isCheck":@""}];
    rq.changeCartGoodsIsCheck=^(NSString* tips,NSError* err){
        
    };
}


#pragma mark 支付按钮事件
- (IBAction)payBtnAction:(UIButton *)sender {
}
#pragma mark 全选按钮事件
- (IBAction)allSelectBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 15)];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KMainScreenWidth* 111/414;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* name = @"cell";
    UNIShopCarCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"UNIShopCarCell" owner:self options:nil].lastObject;
        cell.selectionStyle = 0;
    }
    [[cell.selectBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(UIButton* x) {
        x.selected = !x.selected;
    }];
    [[cell.delectBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         NSLog(@"删除");
     }];
    [[cell.addBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         NSLog(@"删除");
     }];
    [[cell.cutBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         NSLog(@"删除");
     }];
    
    
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
