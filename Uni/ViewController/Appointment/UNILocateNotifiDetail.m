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
#import "CalloutMapAnnotation.h"
#import "CallOutAnnotationVifew.h"
#import "YILocationManager.h"
#import "UIActionSheet+Blocks.h"
#import "UNIMapAddressView.h"
#import "MainViewRequest.h"
@interface UNILocateNotifiDetail ()<UITableViewDataSource,UITableViewDelegate>{
    float topCellH;
    float midCellH;
    float bottomCellH;
    
    CalloutMapAnnotation *_calloutAnnotation;
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
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
    UNIMyAppointInfoRequest* rquest = [[UNIMyAppointInfoRequest alloc]init];
    [rquest postWithSerCode:@[API_PARAM_UNI,API_URL_GetAppointInfo]
                     params:@{@"order":_order}];
    rquest.reqMyAppointInfo = ^(NSArray* models,NSString* tips ,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            [LLARingSpinnerView RingSpinnerViewStop1];
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            if (models && models.count>0) {
                self.modelArr = models;
                [self setupData];
                [self setupMyTableView];
            }
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
    self.myTableView.tableFooterView = view;
    
    if (self.orderState < 2){
        MainViewRequest* rq = [[MainViewRequest alloc]init];
        rq.reshopInfoBlock = ^(UNIShopManage* manager,NSString*tips,NSError* er){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (er) {
                    [YIToast showText:NETWORKINGPEOBLEM];
                    return ;
                }
                if (manager){
                    float mapX = KMainScreenWidth*16/320;
                    float mapWH = self.myTableView.frame.size.width - mapX*2;
                    MKMapView* mapView = [[MKMapView alloc]initWithFrame:CGRectMake(mapX, 0, mapWH, mapWH)];
                    mapView.mapType = MKMapTypeStandard;//标准模式
                    mapView.showsUserLocation = YES;//显示自己
                    mapView.zoomEnabled = YES;//支持缩放
                    [view addSubview:mapView];
                    CLLocationCoordinate2D td =CLLocationCoordinate2DMake(manager.x.doubleValue,manager.y.doubleValue);
                    mapView.centerCoordinate = td;
        
                    UNIMapAnnotation * end =[[UNIMapAnnotation alloc]initWithTitle:manager.shopName andCoordinate:td];
                    [mapView addAnnotation:end];
        
                    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(td,2000, 2000);//以td为中心，显示2000米
                    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];//适配map view的尺寸
                    [mapView setRegion:adjustedRegion animated:YES];
                }
            });
        };
        [rq postWithSerCode:@[API_PARAM_UNI,API_URL_ShopInfo] params:@{@"shopId":@(_shopId)}];

        
    }
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2)
        [self callOtherMapApp];
    
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[UNIMapAnnotation class]]) {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        if (_calloutAnnotation) {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
        _calloutAnnotation = [[CalloutMapAnnotation alloc]
                              initWithLatitude:view.annotation.coordinate.latitude
                              andLongitude:view.annotation.coordinate.longitude];
        [mapView addAnnotation:_calloutAnnotation];
        
        [mapView setCenterCoordinate:_calloutAnnotation.coordinate animated:YES];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[CalloutMapAnnotation class]]) {
        CallOutAnnotationVifew *annotationView =(CallOutAnnotationVifew*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView) {
            annotationView = [[CallOutAnnotationVifew alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:@"CustomAnnotation"];
            [[annotationView.navBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
             subscribeNext:^(id x) {
                 NSLog(@"导航");
                 [self callOtherMapApp];
             }];
        }
        return annotationView;
    }
    return nil;
}

#pragma mark 调用其他地图APP
-(void)callOtherMapApp{
    NSMutableArray* mapsArray = [NSMutableArray arrayWithObjects:@"苹果地图", nil];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]])
        [mapsArray addObject:@"百度地图"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
        [mapsArray addObject:@"高德地图"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
        [mapsArray addObject:@"Google地图"];
    
    [UIActionSheet showInView:self.view withTitle:@"本机地图" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:mapsArray tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        NSString* mapName = [actionSheet buttonTitleAtIndex:buttonIndex];
        [self selectLocateAppMap:mapName];
    }];
    
    
}
-(void)selectLocateAppMap:(NSString*)tag{
    YILocationManager* locaMan = [YILocationManager sharedInstance];
    float myLat = [locaMan.userLocInfo.latitude floatValue];
    float myLong = [locaMan.userLocInfo.longitude floatValue];
    CLLocationCoordinate2D pt = CLLocationCoordinate2DMake(myLat, myLong);
    CLLocationCoordinate2D startCoor = pt;
    
    UNIShopManage* shopMan = [UNIShopManage getShopData];
    float endLat = [shopMan.x floatValue];
    float endLong = [shopMan.y floatValue];
    CLLocationCoordinate2D endCoor = CLLocationCoordinate2DMake(endLat, endLong);
    NSString *toName =shopMan.shopName;
    
    
    if ([tag isEqualToString:@"苹果地图"])//苹果地图
    {
        MKMapItem *currentAction = [MKMapItem mapItemForCurrentLocation];
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:endCoor addressDictionary:nil];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:placemark];
        toLocation.name =toName;
        
        [MKMapItem openMapsWithItems:@[currentAction, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                       MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        
    }
    if ([tag isEqualToString:@"百度地图"]){
        //百度地图
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:%@&mode=transit",
                                startCoor.latitude, startCoor.longitude, endCoor.latitude, endCoor.longitude, toName]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    }
    if ([tag isEqualToString:@"高德地图"]){
        //高德地图
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=applicationScheme&poiname=fangheng&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=3",
                                toName, endCoor.latitude, endCoor.longitude]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    }
    if ([tag isEqualToString:@"Google地图"]){
        //Google地图
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%f,%f¢er=%f,%f&directionsmode=transit", endCoor.latitude, endCoor.longitude, startCoor.latitude, startCoor.longitude]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    }
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
