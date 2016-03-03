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
#import "CalloutMapAnnotation.h"
#import "CallOutAnnotationVifew.h"
#import "YILocationManager.h"
#import "UIActionSheet+Blocks.h"
#import "UNIMapAddressView.h"
#import "MainViewRequest.h"

@interface UNIAppointDetail ()<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate>{
    float topCellH;
    float midCellH;
    float bottomCellH;
    
    MKMapView* _mapView;
    
    CalloutMapAnnotation *_calloutAnnotation;
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
     self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(leftBarButtonEvent:)];
    
    [self startRequest];
//    [self setupData];
//    [self setupMyTableView];
   
}

-(void)leftBarButtonEvent:(UIBarButtonItem*)item{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)startRequest{
     [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
    UNIMyAppointInfoRequest* rquest = [[UNIMyAppointInfoRequest alloc]init];
    [rquest postWithSerCode:@[API_PARAM_UNI,API_URL_GetAppointInfo]
                     params:@{@"order":self.order}];
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
                [self requestShopInfo];
            }
        });
    };
}
-(void)requestShopInfo{
    MainViewRequest* rq = [[MainViewRequest alloc]init];
    rq.reshopInfoBlock = ^(UNIShopManage* manager,NSString*tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            if (manager){
                NSIndexPath *index = [NSIndexPath indexPathForRow:(int)self.modelArr.count+1 inSection:0];
                UNIAppointDetail2Cell* cell = [self.myTableView cellForRowAtIndexPath:index];
                cell.label1.text = manager.shortName;
                cell.label2.text = manager.address;
                
                if (self.orderState<2) {
                    CLLocationCoordinate2D td =CLLocationCoordinate2DMake(manager.x.doubleValue,manager.y.doubleValue);
                    self->_mapView.centerCoordinate = td;
                    
                    CalloutMapAnnotation * end =[[CalloutMapAnnotation alloc]initWithLatitude:manager.x.doubleValue andLongitude:manager.y.doubleValue];
                    [self->_mapView addAnnotation:end];
                    
                    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(td,2000, 2000);//以td为中心，显示2000米
                    MKCoordinateRegion adjustedRegion = [self->_mapView regionThatFits:viewRegion];//适配map view的尺寸
                    [self->_mapView setRegion:adjustedRegion animated:YES];
                }
               
            }
        });
    };
    [rq postWithSerCode:@[API_PARAM_UNI,API_URL_ShopInfo] params:@{@"shopId":@(_shopId)}];
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
     self.myTableView.tableFooterView = view;
   if (self.orderState == 2){
       CALayer* lay = [CALayer layer];
       lay.frame = CGRectMake(16, 0, view.frame.size.width, 1);
       lay.backgroundColor = [UIColor colorWithHexString:@"E6E6E6"].CGColor;
       [view.layer addSublayer:lay];
       
    float btnWH =KMainScreenWidth*70/414;
    float btnX = (KMainScreenWidth - btnWH)/2;
    float btnY = 30;
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = btnWH/2;
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.lineBreakMode = 0;
       button.layer.borderWidth = 0.5;
       button.layer.borderColor = [UIColor colorWithHexString:kMainThemeColor].CGColor;
    button.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth>400?17:14];
    [button setTitle:@"服务\n评价" forState:UIControlStateNormal];
       [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       [button setTitleColor:[UIColor colorWithHexString:kMainThemeColor] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:kMainThemeColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
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
    }
     if (self.orderState < 2){
         float mapX = KMainScreenWidth*16/320;
         float mapWH = self.myTableView.frame.size.width - mapX*2;
         MKMapView* mapView = [[MKMapView alloc]initWithFrame:CGRectMake(mapX, 0, mapWH, mapWH)];
         mapView.mapType = MKMapTypeStandard;//标准模式
         mapView.delegate = self;
         mapView.showsUserLocation = YES;//显示自己
         mapView.zoomEnabled = YES;//支持缩放
         [view addSubview:mapView];
         _mapView = mapView;
    }
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
        model =self.modelArr[indexPath.row];
        if (_ifMyDetail) {
            [cell setupCellContentWith1:model];
        }else
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

#pragma mark 颜色转图片
-(UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
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
