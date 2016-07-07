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
#import <MapKit/MapKit.h>
#import "CalloutMapAnnotation.h"
#import "CallOutAnnotationVifew.h"
#import "UIActionSheet+Blocks.h"
#import "UNIShopRequest.h"
#import "UNITransfromX&Y.h"
@interface UNILocateNotifiDetail ()<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate>{
    float topCellH;
    float midCellH;
    float bottomCellH;
    UNIShopModel* shopManage;
    MKMapView* _mapView;
    CalloutMapAnnotation *_calloutAnnotation;
}
@property(nonatomic,strong)NSArray* modelArr;
@property(nonatomic,assign)int orderState;

@end

@implementation UNILocateNotifiDetail
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"本地通知提醒"];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"本地通知提醒"];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)startRequest{
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
    UNIMyAppointInfoRequest* rquest = [[UNIMyAppointInfoRequest alloc]init];
    [rquest postWithSerCode:@[API_URL_GetAppointInfo]
                     params:@{@"order":self.order,@"shopId":@(_shopId)}];
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
            }else
                [YIToast showText:tips];
        });
    };
}
-(void)requestShopInfo{
    UNIShopRequest* rq = [[UNIShopRequest alloc]init];
    rq.rwshopModelBlock = ^(UNIShopModel* manager,NSString*tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            if (manager){
                self->shopManage = manager;
                NSIndexPath *index = [NSIndexPath indexPathForRow:(int)self.modelArr.count+1 inSection:0];
                UNIAppointDetail2Cell* cell = [self.myTableView cellForRowAtIndexPath:index];
                cell.label1.text = manager.shopName;
                cell.label2.text = manager.address;
                
                if (self.orderState<2) {
                    NSArray* arr = [UNITransfromX_Y bd_decrypt:manager.x and:manager.y];
                    CLLocationCoordinate2D td =CLLocationCoordinate2DMake([arr[0] doubleValue],[arr[1] doubleValue]);
                    self->_mapView.centerCoordinate = td;
                    
                    CalloutMapAnnotation * end =[[CalloutMapAnnotation alloc]initWithLatitude:td.latitude andLongitude:td.longitude];
                    [self->_mapView addAnnotation:end];
                    
                    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(td,2000, 2000);//以td为中心，显示2000米
                    MKCoordinateRegion adjustedRegion = [self->_mapView regionThatFits:viewRegion];//适配map view的尺寸
                    [self->_mapView setRegion:adjustedRegion animated:YES];
                }
            }else
                [YIToast showText:tips];
        });
    };
    [rq postWithSerCode:@[API_URL_ShopInfo] params:@{@"shopId":@(_shopId)}];
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
    
    float tableY =15;
    float tableH = KMainScreenHeight - tableY;
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tableY, KMainScreenWidth, tableH) style:UITableViewStylePlain];
    self.myTableView.delegate= self;
    self.myTableView.dataSource =self;
    self.myTableView.separatorStyle = 0;
    [self.view addSubview:self.myTableView];
    [self setupTabelViewFootView];
}

-(void)setupTabelViewFootView{
    UIView* view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight/2)];
    self.myTableView.tableFooterView = view;
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
       // model = self.modelArr.lastObject;
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
    CLLocationCoordinate2D end = CLLocationCoordinate2DMake(shopManage.x, shopManage.y);
    UNITransfromX_Y* xy = [[UNITransfromX_Y alloc]initWithView:self.view withEndCoor:end withAim:shopManage.shopName];
    [xy setupUI];
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
