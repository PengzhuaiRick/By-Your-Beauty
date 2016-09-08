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
#import "BTKeyboardTool.h"
//#import "UNIOrderDetailController.h"

@interface UNIShopCarController ()<UITableViewDelegate,UITableViewDataSource,KeyboardToolDelegate,UITextFieldDelegate>{
    CGRect tabRect;
}
@property(assign,nonatomic) int selectNum;
@property(strong,nonatomic) NSArray* myData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *allSelectBtn;//全选按钮
@property (weak, nonatomic) IBOutlet UILabel *priceLab; //合计

@end

@implementation UNIShopCarController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self startRequest];
    [self requestBottomInfo];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupUI];
//    [self startRequest];
//    [self requestBottomInfo];
}
-(void)setupNavigation{
    self.title = @"购物车";
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(navigationControllerLeftBarAction:)];
    __weak UNIShopCarController* myself = self;
    [self addPanGesture:^(id model) {
        [myself navigationControllerLeftBarAction:nil];
    }];
}
-(void)navigationControllerLeftBarAction:(UIBarButtonItem*)bar{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setupUI{
    tabRect = _tableView.frame;
    _allSelectBtn.titleLabel.font = kWTFont(15);
    _priceLab.font = kWTFont(18);
    _payBtn.titleLabel.font = kWTFont(18);
    
    [_allSelectBtn setImage:[UIImage imageNamed:@"addpro_btn_selelct1"] forState:UIControlStateNormal];
    [_allSelectBtn setImage:[UIImage imageNamed:@"addpro_btn_selelct2"] forState:UIControlStateSelected];
}
#pragma mark 请求购物车列表
-(void)startRequest{
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:1];
    __weak UNIShopCarController* myself = self;
    UNIShopCarRequest* rq = [[UNIShopCarRequest alloc]init];
    [rq postWithSerCode:@[API_URL_GetCartList] params:nil];
    rq.getCartList=^(NSArray* arr,NSString* tips,NSError* err){
         [LLARingSpinnerView RingSpinnerViewStop1];
        if (err) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
        myself.myData = arr;
        [myself.tableView reloadData];
        [myself setupNodata];
        if (!arr)
            [YIToast showText:tips];
    };
}
-(void)setupNodata{
    if (_myData.count>0) {
        return;
    }
    UIView* view = [[UIView alloc]initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [self.view addSubview:view];
    
    UIImageView* img =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    img.center = CGPointMake(KMainScreenWidth/2, KMainScreenHeight/2 - 50);
    img.image = [UIImage imageNamed:@"shopCar_empty_shop"];
    [view addSubview:img];
    
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame)+20,KMainScreenWidth, 50)];
    lab.text = @"购物车空空如也，快去选购商品吧！";
    lab.textColor = [UIColor colorWithHexString:@"b5b4b4"];
    lab.font = kWTFont(16);
    lab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lab];
}

#pragma mark 请求购物车底部信息
-(void)requestBottomInfo{
    
    __weak UNIShopCarController* myself = self;
    UNIShopCarRequest* rq = [[UNIShopCarRequest alloc]init];
    [rq postWithSerCode:@[API_URL_GetCartBottomInfo] params:nil];
    rq.getCartBottomInfo=^(float endPrice,int isAll,int isCheckNum,NSString* tips,NSError* err){
        if (err) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
        if (endPrice>-1) {
            myself.selectNum = isCheckNum;
            myself.priceLab.text = [NSString stringWithFormat:@"合计:￥%.2f",endPrice];
            myself.allSelectBtn.selected = isAll;
            [myself.payBtn setTitle:[NSString stringWithFormat:@"付款(%d)",isCheckNum] forState:UIControlStateNormal];
        }else
            [YIToast showText:tips];

    };
}
#pragma mark 添加到购物车，修改购物车数量，减少购物车数量
-(void)requestChangeNumOfShopCar:(UNIShopCarModel*)model{
    __weak UNIShopCarController* myself = self;
    UNIShopCarRequest* rq = [[UNIShopCarRequest alloc]init];
    [rq postWithSerCode:@[API_URL_ChangeNumOfShopCar] params:@{@"num":@(model.num),
                                                               @"goodId":@(model.goodId),
                                                               @"goodType":@(model.goodsType),
                                                               @"isCheck":@(model.isCheck)}];
    rq.changeGoodsToCart=^(int code ,NSString* tips,NSError* err){
        if (err) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
        [YIToast showText:tips];
        if (code == 0){
           // [myself startRequest];
            [myself requestBottomInfo];
        }
    };
}

#pragma mark 删除购物车物品
-(void)requestDelCartGoods:(UNIShopCarModel*)model{
     __weak UNIShopCarController* myself = self;
    NSString *goodsKeys = [NSString stringWithFormat:@"%d_%d_%d",model.goodId,model.goodsType,model.shopId];
    UNIShopCarRequest* rq = [[UNIShopCarRequest alloc]init];
    [rq postWithSerCode:@[API_URL_DelCartGoods] params:@{@"isAll":@"0",@"goodsKeys":goodsKeys}];
    rq.delCartGoods=^(int code,NSString* tips,NSError* err){
        if (err) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
        
        [YIToast showText:tips];
        if (code == 0){
            [myself startRequest];
            [myself requestBottomInfo];
        }

    };
}

#pragma mark 是否全选
-(void)requestChangeCartGoodsIsCheck:(BOOL)allSelect{
    __weak UNIShopCarController* myself = self;
    UNIShopCarRequest* rq = [[UNIShopCarRequest alloc]init];
    [rq postWithSerCode:@[API_URL_ChangeCartGoodsIsCheck] params:@{@"isAll":@(allSelect)}];
    rq.changeCartGoodsIsCheck=^(int code,NSString* tips,NSError* err){
        if (err) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
        
        [YIToast showText:tips];
        if (code == 0){
            [myself startRequest];
            [myself requestBottomInfo];
        }
    };
}
#pragma mark 修改某个商品是否选中
-(void)requestCartIsCheck:(UNIShopCarModel*)model{
     __weak UNIShopCarController* myself = self;
    
    UNIShopCarRequest* rq = [[UNIShopCarRequest alloc]init];
    [rq postWithSerCode:@[API_URL_CartIsCheck] params:@{@"goodId":@(model.goodId),@"goodType":@(model.goodsType),@"isCheck":@(model.isCheck)}];
    rq.cartIsCheck=^(int code,NSString* tips,NSError* err){
        if (err) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
        [YIToast showText:tips];
        if (code == 0)
            [myself requestBottomInfo];
    };
}


#pragma mark 支付按钮事件
- (IBAction)payBtnAction:(UIButton *)sender {
    if (_selectNum<1)
        return;
    
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Guide" bundle:nil];
    UIViewController* vc = [st instantiateViewControllerWithIdentifier:@"UNIVerifyController"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 全选按钮事件
- (IBAction)allSelectBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self requestChangeCartGoodsIsCheck:sender.selected];
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
    return _myData.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* name = @"cell";
    UNIShopCarCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"UNIShopCarCell" owner:self options:nil].lastObject;
        cell.selectionStyle = 0;
        
        BTKeyboardTool* tool = [BTKeyboardTool keyboardTool];
        tool.toolDelegate = self;
        [tool dismissTwoBtn];
        cell.numField.inputAccessoryView = tool;
        cell.numField.delegate = self;
    }
    UNIShopCarModel* model = _myData[indexPath.row];
    cell.selectBtn.selected = model.isCheck;
    cell.label1.text = model.goodName;
    if (model.specifications)
        cell.label3.text = [NSString stringWithFormat:@"规格: %@",model.specifications];
    cell.label2.text = [NSString stringWithFormat:@"￥%.2f",model.price];
    cell.numField.text = [NSString stringWithFormat:@"%d",model.num];
    NSArray* arr = [model.goodLogoUrl componentsSeparatedByString:@","];
    NSString* imgUel = arr.count>0?arr[0]:model.goodLogoUrl;
    [cell.mainimg sd_setImageWithURL:[NSURL URLWithString:imgUel] placeholderImage:[UIImage imageNamed:@"main_img_cellbg"]];
    
    cell.selectBtn.tag = indexPath.row+1;
    cell.delectBtn.tag = indexPath.row+1;
    cell.addBtn.tag = indexPath.row+1;
    cell.cutBtn.tag = indexPath.row+1;
    cell.numField.tag = indexPath.row+1;
    
    __weak UNIShopCarController* myself = self;
    [[cell.selectBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(UIButton* x) {
        x.selected = !x.selected;
        UNIShopCarModel* model =myself.myData[x.tag-1];
        model.isCheck = x.selected;
        [myself requestCartIsCheck:model];
    }];
    [[cell.delectBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         [UIAlertView showWithTitle:@"提示" message:@"是否确定删除该商品?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"删除"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
             if (buttonIndex>0) {
                 UNIShopCarModel* model =myself.myData[x.tag-1];
                 [myself requestDelCartGoods:model];
             }
         }];
     }];
    [[cell.addBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         UNIShopCarModel* model =myself.myData[x.tag-1];
         model.num++;
         NSIndexPath *index = [NSIndexPath indexPathForRow:x.tag-1 inSection:0];
         UNIShopCarCell* cell=[myself.tableView cellForRowAtIndexPath:index];
         cell.numField.text = [NSString stringWithFormat:@"%d",model.num];
         [myself requestChangeNumOfShopCar:model];
     }];
    [[cell.cutBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         UNIShopCarModel* model =myself.myData[x.tag-1];
         if (model.num>1){
             model.num--;
             NSIndexPath *index = [NSIndexPath indexPathForRow:x.tag-1 inSection:0];
             UNIShopCarCell* cell=[myself.tableView cellForRowAtIndexPath:index];
             cell.numField.text = [NSString stringWithFormat:@"%d",model.num];
             [myself requestChangeNumOfShopCar:model];
         }
     }];
    
//    [cell.numField.rac_textSignal subscribeNext:^(NSString* x) {
//      
//    }];
    
    
    return cell;
}
-(void)keyboardTool:(BTKeyboardTool *)tool buttonClick:(KeyBoardToolButtonType)type{
    [self.view endEditing:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    int num = textField.text.intValue;
    if(num<1)num =1;
    
    UNIShopCarModel* model =self.myData[textField.tag-1];
    model.num = num;
    NSIndexPath *index = [NSIndexPath indexPathForRow:textField.tag-1 inSection:0];
    UNIShopCarCell* cell=[self.tableView cellForRowAtIndexPath:index];
    cell.numField.text = [NSString stringWithFormat:@"%d",model.num];
    [self requestChangeNumOfShopCar:model];
}
- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    CGRect tab =_tableView.frame;
    tab.size.height -=keyboardSize.height;
    _tableView.frame = tab;
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
    _tableView.frame = tabRect;
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
