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
#import <MapKit/MapKit.h>
#import "CalloutMapAnnotation.h"
#import "CallOutAnnotationVifew.h"
#import "UIActionSheet+Blocks.h"
#import "UNIShopRequest.h"
#import "UNITransfromX&Y.h"
@interface UNIAppointDetail ()<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate>{
    float topCellH;
    float midCellH;
    float bottomCellH;
    
   // MKMapView* _mapView;
    
    CalloutMapAnnotation *_calloutAnnotation;
}
@property(nonatomic,strong)NSArray* modelArr;
@property(nonatomic,assign)int orderState;
@property(strong ,nonatomic)UNIShopModel* shopManage;
@end

@implementation UNIAppointDetail
-(void)viewWillAppear:(BOOL)animated{
//    self.mappView.delegate = self;
//    self.myTableView.delegate = self;
//    self.myTableView.dataSource = self;
//    self.mappView.showsUserLocation = YES;//显示自己
//    self.mappView.zoomEnabled = YES;//支持缩放
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"预约详情"];
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
//    CGRect vRe = self.view.frame;
//    vRe.origin.y = 64;
//    self.view.frame = vRe;
//    self.mappView.delegate = nil;
//    self.mappView.showsUserLocation = NO;//显示自己
//    self.mappView.zoomEnabled = NO;//支持缩放
//    self.myTableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
//    self.myTableView.delegate = nil;
//    self.myTableView.dataSource = nil;
     [[BaiduMobStat defaultStat] pageviewEndWithName:@"预约详情"];
    [super viewDidDisappear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mappView removeFromSuperview];
    self.mappView = nil;
}
-(void)dealloc{
    _shopManage = nil;
    _myTableView = nil;
    _mappView = nil;
    _order = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"预约详情";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
     self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(leftBarButtonEvent:)];
    [self setupData];
    [self setupMyTableView];
    [self startRequest];
//    [self setupData];
//    [self setupMyTableView];
   
}

-(void)leftBarButtonEvent:(UIBarButtonItem*)item{
    [self.mappView removeFromSuperview];
    self.mappView = nil;
    [self.myTableView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)startRequest{
    __weak UNIAppointDetail* myself= self;
     [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
    UNIMyAppointInfoRequest* rquest = [[UNIMyAppointInfoRequest alloc]init];
    [rquest postWithSerCode:@[API_URL_GetAppointInfo]
                     params:@{@"order":self.order,@"shopId":@(_shopId)}];
    rquest.reqMyAppointInfo = ^(NSArray* models,NSString* tips ,NSError* er){
        [myself requestShopInfo];
        dispatch_async(dispatch_get_main_queue(), ^{
            [LLARingSpinnerView RingSpinnerViewStop1];
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            if (models && models.count>0) {
                myself.modelArr = models;
                [myself setupData];
                [myself setupMyTableView];
                
              //  [self performSelector:@selector(requestShopInfo) withObject:nil afterDelay:1];
               // [myself requestShopInfo];
            }else
                [YIToast showText:tips];
        });
    };
}
-(void)requestShopInfo{
    __weak UNIAppointDetail* mySelf = self;
    UNIShopRequest* rq = [[UNIShopRequest alloc]init];
    rq.rwshopModelBlock = ^(UNIShopModel* manager,NSString*tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            if (manager){
                mySelf.shopManage = manager;
                NSIndexPath *index = [NSIndexPath indexPathForRow:(int)mySelf.modelArr.count+1 inSection:0];
                UNIAppointDetail2Cell* cell = [mySelf.myTableView cellForRowAtIndexPath:index];
                cell.label1.text = manager.shopName;
                cell.label2.text = manager.address;
                
                if (mySelf.orderState<2) {
                    NSArray* arr = [UNITransfromX_Y bd_decrypt:manager.x and:manager.y];
                   CLLocationCoordinate2D td =CLLocationCoordinate2DMake([arr[0] doubleValue],[arr[1] doubleValue]);
                    mySelf.mappView.centerCoordinate = td;
                    
                    CalloutMapAnnotation * end =[[CalloutMapAnnotation alloc]initWithLatitude:td.latitude andLongitude:td.longitude];
                    [mySelf.mappView addAnnotation:end];
                    
                    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(td,1000, 1000);//以td为中心，显示2000米
                    MKCoordinateRegion adjustedRegion = [mySelf.mappView regionThatFits:viewRegion];//适配map view的尺寸
                    [mySelf.mappView setRegion:adjustedRegion animated:NO];
                    
                    arr=nil; end=nil;
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

    topCellH =KMainScreenWidth * 112 /414;
    midCellH =KMainScreenWidth * 100 /414;
    bottomCellH = KMainScreenWidth * 78 /414;
    
    if (self.orderState != 3) //取消
        midCellH =KMainScreenWidth * 76 /414;
    
}
-(void)setupMyTableView{
    if (_myTableView) {
        [_myTableView reloadData];
        return;
    }
    
    //float tableY =64+15;
    float tableY =0;
    float tableH = KMainScreenHeight - tableY;
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tableY, KMainScreenWidth, tableH) style:UITableViewStylePlain];
    self.myTableView.separatorStyle = 0;
    self.myTableView.delegate= self;
    self.myTableView.dataSource =self;
    [self.view addSubview:self.myTableView];
    [self setupTabelViewFootView];
}

-(void)setupTabelViewFootView{
    UIView* view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight/2)];
     self.myTableView.tableFooterView = view;
   if (self.orderState == 2){
       
    float btnWH =KMainScreenWidth*73/414;
    float btnX = (KMainScreenWidth - btnWH)/2;
    float btnY = 30;
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.lineBreakMode = 0;
    button.titleLabel.font =kWTFont(18);
       [button setBackgroundImage:[UIImage imageNamed:@"appoint_btn_remark"] forState:UIControlStateNormal];
    [button setTitle:@"服务\n评价" forState:UIControlStateNormal];
    [view addSubview:button];
       __weak UNIAppointDetail* myself = self;
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         UNIEvaluateController* eva = [story instantiateViewControllerWithIdentifier:@"UNIEvaluateController"];
         eva.model =myself.modelArr[0];
         eva.order = myself.order;
         eva.shopId = myself.shopId;
         [myself.navigationController pushViewController:eva animated:YES];
     }];
    }
     if (self.orderState < 2){
         float mapX = 16;
         float mapWH = self.myTableView.frame.size.width - mapX*2;
         MKMapView* mapView = [[MKMapView alloc]initWithFrame:CGRectMake(mapX, 0, mapWH, mapWH)];
        // mapView.mapType = MKMapTypeStandard;//标准模式
         mapView.delegate = self;
         //mapView.showsUserLocation = YES;//显示自己
        // mapView.zoomEnabled = YES;//支持缩放
         [view addSubview:mapView];
         self.mappView = mapView;
         mapView=nil;
    }
}
#pragma mark 地图移动是会不断请求内存，释放地图内存
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    [self.mappView removeFromSuperview];
    [self.myTableView.tableFooterView addSubview:mapView];
    self.mappView = mapView;
    mapView = nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth,15)];
    view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_modelArr.count<1)
        return 0;
    
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
        if (self.shopManage) {
            cell.label1.text = self.shopManage.shopName;
            cell.label2.text = self.shopManage.address;
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
//        if (_ifMyDetail) {
//            [cell setupCellContentWith1:model];
//        }else
            [cell setupCellContentWith:model];
        
        return cell;
    }
    
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _modelArr.count+1)
        [self callOtherMapApp];
    
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
    CLLocationCoordinate2D end = CLLocationCoordinate2DMake(_shopManage.x, _shopManage.y);
    UNITransfromX_Y* xy = [[UNITransfromX_Y alloc]initWithView:self.view withEndCoor:end withAim:_shopManage.shopName];
    [xy setupUI];
    xy=nil;
    [[BaiduMobStat defaultStat]logEvent:@"btn_gps_appoint_detail" eventLabel:@"预约详情导航按钮"];
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
