//
//  UNILocateNotifiDetail.m
//  Uni
//  本地通知预约详情
//  Created by apple on 15/12/17.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNILocateNotifiDetail.h"
#import "UNIAppointDetall1Cell.h"
#import "UNIAppointDetailCell.h"
#import "UNIAppointDetail2Cell.h"
#import "UNIMyAppointInfoRequest.h"
@interface UNILocateNotifiDetail ()<UITableViewDataSource,UITableViewDelegate>{
    float topCellH;
    float midCellH;
    float bottomCellH;
}
@property(nonatomic,strong)NSArray* modelArr;
@property(nonatomic,assign)int orderState;

@end

@implementation UNILocateNotifiDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"预约详情";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    [self setupNavigation];
     [self startRequest];
//    [self setupData];
//    [self setupMyTableView];
}
-(void)setupNavigation{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kMainThemeColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"<返回" style:0 target:self action:@selector(backBarButtonAction:)];
}
-(void)backBarButtonAction:(UIBarButtonItem*)item{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)startRequest{
    [LLARingSpinnerView RingSpinnerViewStart];
    UNIMyAppointInfoRequest* rquest = [[UNIMyAppointInfoRequest alloc]init];
    [rquest postWithSerCode:@[API_PARAM_UNI,API_URL_GetAppointInfo]
                     params:@{@"order":_order}];
    rquest.reqMyAppointInfo = ^(NSArray* models,NSString* tips ,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            [LLARingSpinnerView RingSpinnerViewStop];
            if (er) {
                [YIToast showText:er.localizedDescription];
                return ;
            }
            if (models && models.count>0) {
                self.modelArr = models;
                [self setupData];
                [self setupMyTableView];
            }else
                [YIToast showText:tips];
        });
    };
}
-(void)setupData{
    UNIMyAppointInfoModel* model = self.modelArr.lastObject;
    self.orderState = model.status;
    
    topCellH =KMainScreenWidth * 65 /320;
    midCellH =KMainScreenWidth * 90 /320;
    bottomCellH = KMainScreenWidth * 220 /320;
    
    if (self.orderState != 3) //取消
        topCellH -=KMainScreenWidth * 18 /320;
    
    if (self.orderState >1)
        bottomCellH =KMainScreenWidth*18/320 +10;
    
}
-(void)setupMyTableView{
    
    float tableH = topCellH+ midCellH*self.modelArr.count + bottomCellH;
    float jg = KMainScreenHeight - 64 - 16;
    if (self.orderState == 2)
        jg -= KMainScreenWidth*50/320;
    
    if (tableH>jg )
        tableH = jg;
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(16, 64+8, KMainScreenWidth-32, tableH) style:UITableViewStylePlain];
    self.myTableView.delegate= self;
    self.myTableView.dataSource =self;
    self.myTableView.layer.masksToBounds = YES;
    self.myTableView.layer.cornerRadius = 5;
    self.myTableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    [self.view addSubview:self.myTableView];
    [self setupTabelViewFootView];
}

-(void)setupTabelViewFootView{
    self.myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KMainScreenWidth-32, 1)];
 
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float cellH = 0;
    if (indexPath.row == 0){
        cellH =topCellH;
    }
    else if (indexPath.row == indexPath.row+1)//最后一个Cell
        cellH =bottomCellH;
    else
        cellH = midCellH;
    
    
    return cellH;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UNIMyAppointInfoModel* model=nil;
    if (indexPath.row == 0) {
        model = self.modelArr.lastObject;
        UNIAppointDetall1Cell* cell =[[NSBundle mainBundle]loadNibNamed:@"UNIAppointDetall1Cell" owner:self options:nil].lastObject;
        [cell setupCellContentWith:@[@(self.orderState),self.order,model.createTime,model.lastModifiedDate]];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == self.modelArr.count+1)//最后一个Cell
    {
        model = self.modelArr.lastObject;
        UNIAppointDetail2Cell* cell =[[NSBundle mainBundle]loadNibNamed:@"UNIAppointDetail2Cell" owner:self options:nil].lastObject;
        [cell setupCellContentWith:model.status];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString* name = @"cell";
        UNIAppointDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
        if (!cell)
            cell=[[NSBundle mainBundle]loadNibNamed:@"UNIAppointDetailCell" owner:self options:nil].lastObject;
        model =self.modelArr.lastObject;
        [cell setupCellContentWith:model];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
    return nil;
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
