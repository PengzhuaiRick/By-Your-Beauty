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

#import "UNIMapAnnotation.h"
#import <MapKit/MapKit.h>
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
   
    [self setupNavigation];
     [self startRequest];
//    [self setupData];
//    [self setupMyTableView];
}
-(void)setupNavigation{
    self.title=@"预约详情";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(backBarButtonAction:)];
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
    
    topCellH =KMainScreenWidth * 100 /320;
    midCellH =KMainScreenWidth * 65 /320;
    bottomCellH = KMainScreenWidth * 60 /320;
    
    if (self.orderState != 3) //取消
        midCellH -=KMainScreenWidth * 18 /320;
}
-(void)setupMyTableView{
    
    float tableY =0;
    float tableH = KMainScreenHeight - tableY;
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tableY, KMainScreenWidth, tableH) style:UITableViewStylePlain];
    self.myTableView.delegate= self;
    self.myTableView.dataSource =self;
    self.myTableView.layer.masksToBounds = YES;
    self.myTableView.layer.cornerRadius = 5;
    // self.myTableView.scrollEnabled=NO;
    
    [self.view addSubview:self.myTableView];
    [self setupTabelViewFootView];
}

-(void)setupTabelViewFootView{
    UIView* view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight/2)];
    
    if (self.orderState < 2){
        
        float mapX = KMainScreenWidth*16/320;
        float mapWH = self.myTableView.frame.size.width - mapX*2;
        MKMapView* mapView = [[MKMapView alloc]initWithFrame:CGRectMake(mapX, 0, mapWH, mapWH)];
        mapView.mapType = MKMapTypeStandard;//标准模式
        mapView.showsUserLocation = YES;//显示自己
        mapView.zoomEnabled = YES;//支持缩放
        [view addSubview:mapView];
        UNIShopManage* manager = [UNIShopManage getShopData];
        CLLocationCoordinate2D td =CLLocationCoordinate2DMake(manager.x.doubleValue,manager.y.doubleValue);
        mapView.centerCoordinate = td;
        
        UNIMapAnnotation * end =[[UNIMapAnnotation alloc]initWithTitle:manager.shopName andCoordinate:td];
        [mapView addAnnotation:end];
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(td,2000, 2000);//以td为中心，显示2000米
        MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];//适配map view的尺寸
        [mapView setRegion:adjustedRegion animated:YES];
        
        
    }
    self.myTableView.tableFooterView = view;

 
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.modelArr.count+2;
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
