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

#import "UNIMapAnnotation.h"
#import <MapKit/MapKit.h>
@interface UNIAppointDetail ()<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate>{
    float topCellH;
    float midCellH;
    float bottomCellH;
}
@property(nonatomic,strong)NSArray* modelArr;
@property(nonatomic,assign)int orderState;
@end

@implementation UNIAppointDetail
-(void)viewDidDisappear:(BOOL)animated{
    CGRect vRe = self.view.frame;
    vRe.origin.y = 64;
    self.view.frame = vRe;
    
    self.myTableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
}
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

    topCellH =KMainScreenWidth * 100 /320;
    midCellH =KMainScreenWidth * 65 /320;
    bottomCellH = KMainScreenWidth * 60 /320;
    
    if (self.orderState != 3) //取消
        midCellH -=KMainScreenWidth * 18 /320;
    
}
-(void)setupMyTableView{
    
    float tableY =64+15;
    float tableH = KMainScreenHeight - tableY;
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tableY, KMainScreenWidth, tableH) style:UITableViewStylePlain];
    self.myTableView.delegate= self;
    self.myTableView.dataSource =self;
    [self.view addSubview:self.myTableView];
    [self setupTabelViewFootView];
}

-(void)setupTabelViewFootView{
    UIView* view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight/2)];
    
//    if (self.orderState == 2){
    float btnWH =KMainScreenWidth*80/320;
    float btnX = (KMainScreenWidth - btnWH)/2;
    float btnY = 30;
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = btnWH/2;
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.lineBreakMode = 0;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*17/320];
    [button setTitle:@"服务\n评价" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithHexString:kMainThemeColor]];
    [view addSubview:button];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
//         UNIMyAppointInfoModel* info =self.modelArr.lastObject;
//         NSArray* arr= @[self.order,info.projectName,info.createTime];
         UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         UNIEvaluateController* eva = [story instantiateViewControllerWithIdentifier:@"UNIEvaluateController"];
         eva.model =self.modelArr[0];
         eva.order = self.order;
         [self.navigationController pushViewController:eva animated:YES];
     }];
//    }
//     if (self.orderState < 2){
//        
//        float mapX = KMainScreenWidth*16/320;
//        float mapWH = self.myTableView.frame.size.width - mapX*2;
//        MKMapView* mapView = [[MKMapView alloc]initWithFrame:CGRectMake(mapX, 0, mapWH, mapWH)];
//        mapView.mapType = MKMapTypeStandard;//标准模式
//        mapView.showsUserLocation = YES;//显示自己
//        mapView.zoomEnabled = YES;//支持缩放
//        [view addSubview:mapView];
//        UNIShopManage* manager = [UNIShopManage getShopData];
//        CLLocationCoordinate2D td =CLLocationCoordinate2DMake(manager.x.doubleValue,manager.y.doubleValue);
//        mapView.centerCoordinate = td;
//        
//        UNIMapAnnotation * end =[[UNIMapAnnotation alloc]initWithTitle:manager.shopName andCoordinate:td];
//                [mapView addAnnotation:end];
//        
//        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(td,2000, 2000);//以td为中心，显示2000米
//        MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];//适配map view的尺寸
//        [mapView setRegion:adjustedRegion animated:YES];
//    
//
//    }
    self.myTableView.tableFooterView = view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelArr.count+2;
    //return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float cellH = 0;
    if (indexPath.row == _modelArr.count){
        cellH =midCellH;
    }
    else if (indexPath.row == _modelArr.count+1)//最后一个Cell
         cellH =bottomCellH;
    else
         cellH = topCellH;
    

    return cellH;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UNIMyAppointInfoModel* model=nil;
    if (indexPath.row == self.modelArr.count) {
         model = self.modelArr.lastObject;
        static NSString* name1 = @"UNIAppointDetall1Cell";
        UNIAppointDetall1Cell* cell = [tableView dequeueReusableCellWithIdentifier:name1];
        if (!cell){
            cell =[[UNIAppointDetall1Cell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width,midCellH) reuseIdentifier:name1];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;}
        
        [cell setupCellContentWith:@[@(self.orderState),self.order,model.createTime,model.lastModifiedDate]];
        
        return cell;
    }else if (indexPath.row == self.modelArr.count+1)//最后一个Cell
    {
        model = self.modelArr.lastObject;
        static NSString* name3 = @"UNIAppointDetail2Cell";
        UNIAppointDetail2Cell* cell = [tableView dequeueReusableCellWithIdentifier:name3];
        if (!cell) {
            cell =[[UNIAppointDetail2Cell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width,bottomCellH) reuseIdentifier:name3];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    }else{
        static NSString* name2 = @"UNIAppointDetailCell";
        UNIAppointDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:name2];
        if (!cell){
            cell=[[UNIAppointDetailCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width,topCellH) reuseIdentifier:name2];
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
