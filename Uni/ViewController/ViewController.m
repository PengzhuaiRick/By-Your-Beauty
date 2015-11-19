//
//  ViewController.m
//  Uni
//  功能界面
//  Created by apple on 15/10/27.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"
#import "UIActionSheet+Blocks.h"
@interface ViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CGPoint startPoint;
    CGPoint currentPoint;
    
    NSArray* titleArray;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupParams];
    [self setupSelf];
    [self setupTableViewFootview];
}

-(void)setupSelf{
  //  MainViewController* vv = _tv.viewControllers.lastObject;
    [self.view addSubview:_tv.view];
    self.view.multipleTouchEnabled=YES;
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan1:)];
    //pan.delegate = self;
    [self.view addGestureRecognizer:pan];
   }

-(void)setupParams{
    titleArray = [NSArray arrayWithObjects:@"首页",@"导航到家",@"致电商家",@"我的奖励",@"我的钱包",@"修改密码", nil];
}


-(void)setupTableViewFootview{
    _myTableView.tableFooterView = [UIView new];
}
-(void)viewWillAppear:(BOOL)animated{
     self.navigationController.navigationBarHidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* name = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:name];
    }
    cell.textLabel.text = titleArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            [self callOtherMapApp];
            break;
        case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://15017579092"]];
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
    }
}

-(void)handlePan1:(UIPanGestureRecognizer*)pan{
     CGPoint point = [pan translationInView:[self view]];
    //UIViewController* vv = _tv.viewControllers.lastObject;
     UIViewController* vv = _tv;
    if (pan.state == UIGestureRecognizerStateBegan) {
        startPoint = point;
        currentPoint = point;
    }
    else if (pan.state == UIGestureRecognizerStateChanged) {
        float offX =vv.view.frame.origin.x+(point.x-currentPoint.x);
        if (offX>-1 && offX<KMainScreenWidth-101){
            vv.view.frame = CGRectMake(offX,
                                     0,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height);
            currentPoint = point;
        }
    }
    else if(pan.state == UIGestureRecognizerStateEnded){
        float offset = currentPoint.x - startPoint.x;
        if (offset>0) {
            if (offset>80)
            [UIView animateWithDuration:0.2 animations:^{
                vv.view.userInteractionEnabled=NO;
                vv.view.frame = CGRectMake(KMainScreenWidth-100, 0, self.view.frame.size.width,self.view.frame.size.height);
            }];
            else
                [UIView animateWithDuration:0.2 animations:^{
                   vv.view.userInteractionEnabled=YES;
                    vv.view.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
                }];
        }else if (offset<0 ){
            if (offset < -80)
                [UIView animateWithDuration:0.2 animations:^{
                  vv.view.userInteractionEnabled=YES;
                    vv.view.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
                    
                }];
            else
                [UIView animateWithDuration:0.2 animations:^{
                   vv.view.userInteractionEnabled=NO;
                   vv.view.frame = CGRectMake(KMainScreenWidth-100, 0, self.view.frame.size.width,self.view.frame.size.height);
                }];

            
        }
    }
}

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
    CLLocationCoordinate2D pt = CLLocationCoordinate2DMake(32, 44);
    CLLocationCoordinate2D startCoor = pt;
    CLLocationCoordinate2D endCoor = CLLocationCoordinate2DMake(33, 45);
    NSString *toName = @"";
    
    
    if ([tag isEqualToString:@"苹果地图"])//苹果地图
    {
        MKMapItem *currentAction = [MKMapItem mapItemForCurrentLocation];
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:endCoor addressDictionary:nil];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:placemark];
        toLocation.name =toName;
        
        [MKMapItem openMapsWithItems:@[currentAction, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        
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


//-(void)handleSwipe:(UISwipeGestureRecognizer*)swipe{
//    NSLog(@"谁打我  %lu",(unsigned long)swipe.direction);
//}
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}
@end
