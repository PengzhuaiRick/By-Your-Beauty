//
//  UNIAppointDetail.m
//  Uni
//  预约详情界面
//  Created by apple on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppointDetail.h"
#import "UNIAppointDetall1Cell.h"
#import "UNIAppointDetailCell.h"
#import "UNIAppointDetail2Cell.h"
#import "UNIMyAppointInfoRequest.h"
#import "UNIEvaluateController.h"
@interface UNIAppointDetail ()<UITableViewDataSource,UITableViewDelegate>{
    float topCellH;
    float midCellH;
    float bottomCellH;
}
@property(nonatomic,strong)NSArray* modelArr;
@property(nonatomic,assign)int orderState;
@end

@implementation UNIAppointDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"预约详情";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    
    [self startRequest];
//    [self setupData];
//    [self setupMyTableView];
}
-(void)startRequest{
     [LLARingSpinnerView RingSpinnerViewStart];
    UNIMyAppointInfoRequest* rquest = [[UNIMyAppointInfoRequest alloc]init];
    [rquest postWithSerCode:@[API_PARAM_UNI,API_URL_GetAppointInfo]
                     params:@{@"order":self.order}];
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
   // self.myTableView.scrollEnabled=NO;
    if (KMainScreenHeight<568) {
        self.myTableView.scrollEnabled=YES;
    }
    [self.view addSubview:self.myTableView];
    [self setupTabelViewFootView];
}

-(void)setupTabelViewFootView{
    self.myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KMainScreenWidth-32, 1)];
    
    if (self.orderState != 2)
        return;
    
    
    float btnWH =KMainScreenWidth*70/320;
    float btnX = (KMainScreenWidth - btnWH)/2;
    float btnY = CGRectGetMaxY(self.myTableView.frame)+5;
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = btnWH/2;
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.lineBreakMode = 0;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*14/320];
    [button setTitle:@"服务\n评价" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"appoint_btn_sure"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
//         UNIMyAppointInfoModel* info =self.modelArr.lastObject;
//         NSArray* arr= @[self.order,info.projectName,info.createTime];
         UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         UNIEvaluateController* eva = [story instantiateViewControllerWithIdentifier:@"UNIEvaluateController"];
       //  eva.data = arr;
         [self.navigationController pushViewController:eva animated:YES];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelArr.count+2;
    //return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float cellH = 0;
    if (indexPath.row == 0){
        cellH =topCellH;
    }
    else if (indexPath.row == _modelArr.count+1)//最后一个Cell
         cellH =bottomCellH;
    else
         cellH = midCellH;
    

    return cellH;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UNIMyAppointInfoModel* model=nil;
    if (indexPath.row == 0) {
         model = self.modelArr.lastObject;
        static NSString* name1 = @"UNIAppointDetall1Cell";
        UNIAppointDetall1Cell* cell = [tableView dequeueReusableCellWithIdentifier:name1];
        if (!cell){
            cell =[[NSBundle mainBundle]loadNibNamed:@"UNIAppointDetall1Cell" owner:self options:nil].lastObject;
            cell.selectionStyle =UITableViewCellSelectionStyleNone;}
        
        [cell setupCellContentWith:@[@(self.orderState),self.order,model.createTime,model.lastModifiedDate]];
        
        return cell;
    }else if (indexPath.row == self.modelArr.count+1)//最后一个Cell
    {
        model = self.modelArr.lastObject;
        static NSString* name3 = @"UNIAppointDetail2Cell";
        UNIAppointDetail2Cell* cell = [tableView dequeueReusableCellWithIdentifier:name3];
        if (!cell) {
            cell =[[NSBundle mainBundle]loadNibNamed:@"UNIAppointDetail2Cell" owner:self options:nil].lastObject;
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
        }
        
        [cell setupCellContentWith:model.status];
        
        return cell;
    }else{
        static NSString* name2 = @"UNIAppointDetailCell";
        UNIAppointDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:name2];
        if (!cell){
            cell=[[NSBundle mainBundle]loadNibNamed:@"UNIAppointDetailCell" owner:self options:nil].lastObject;
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
        }
        model =self.modelArr.lastObject;
        [cell setupCellContentWith:model];
        
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
