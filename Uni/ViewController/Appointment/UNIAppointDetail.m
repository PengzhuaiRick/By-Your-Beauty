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

@interface UNIAppointDetail ()<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate>{
    float topCellH;
    float midCellH;
    float bottomCellH;
    
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
     [LLARingSpinnerView RingSpinnerViewStart];
    UNIMyAppointInfoRequest* rquest = [[UNIMyAppointInfoRequest alloc]init];
    [rquest postWithSerCode:@[API_PARAM_UNI,API_URL_GetAppointInfo]
                     params:@{@"order":self.order}];
    rquest.reqMyAppointInfo = ^(NSArray* models,NSString* tips ,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            [LLARingSpinnerView RingSpinnerViewStop];
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
    
   if (self.orderState == 2){
    float btnWH =KMainScreenWidth*80/320;
    float btnX = (KMainScreenWidth - btnWH)/2;
    float btnY = 30;
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = btnWH/2;
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.lineBreakMode = 0;
    button.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*17/320];
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
    if ([annotation isKindOfClass:[UNIMapAnnotation class]]) {
        MKAnnotationView *annotationView =[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:@"CustomAnnotation"];
//            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"function_img_scell6"];
        }
        return annotationView;
    }
    if ([annotation isKindOfClass:[CalloutMapAnnotation class]]) {
        
        CallOutAnnotationVifew *annotationView = (CallOutAnnotationVifew *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
        if (!annotationView) {
            
            float cellH =KMainScreenWidth*25/320;
            UIView* cell = [[UIView alloc]init];
            
            
            UILabel* lab = [[UILabel alloc]init];
            lab.text = [[UNIShopManage getShopData] address];
            lab.font = [UIFont systemFontOfSize:KMainScreenWidth*12/320];
            [lab sizeToFit];
            float labY = (cellH - lab.frame.size.height)/2;
            lab.frame = CGRectMake(10, labY, lab.frame.size.width, lab.frame.size.height);
            [cell addSubview:lab];
            
            UIButton* but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*12/320];
            [but setTitle:@"地图" forState:UIControlStateNormal];
            [but setBackgroundColor:[UIColor colorWithHexString:kMainThemeColor]];
            float btnX = CGRectGetMaxX(lab.frame)+10;
            but.frame = CGRectMake(btnX, 0, KMainScreenWidth*40/320, cellH);
            [[but rac_signalForControlEvents:UIControlEventTouchUpInside]
            subscribeNext:^(id x) {
                [self callOtherMapApp];
            }];
            [cell addSubview:but];
            
            cell.frame = CGRectMake(0, 0, CGRectGetMaxX(but.frame)+5, cellH);
            
            annotationView = [[CallOutAnnotationVifew alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView" andSize:cell.frame.size] ;
            [annotationView.contentView addSubview:cell];
            
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
