//
//  UNIPurChaseView.m
//  Uni
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIPurChaseView.h"
#import "UNIPurStyleCell.h"
#import "UIActionSheet+Blocks.h"
#import "UNIShopManage.h"
#import "YILocationManager.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
@implementation UNIPurChaseView
-(id)initWithFrame:(CGRect)frame andPrice:(CGFloat)price{
    self = [super initWithFrame:frame];
    if (self) {
        gPrice = price;
        self.payStyle = 1;
        [self setupTableView];
    }
    return self;
}

-(void)setupTableView{
    float btnWH =KMainScreenWidth*70/320;;
    cell1 = KMainScreenWidth*40/320;
    cell2 = 60;
    float tabH = 4*cell1 +2*cell2;
    UITableView* tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, tabH) style:UITableViewStylePlain];
    tab.scrollEnabled = NO;
    tab.layer.masksToBounds=YES;
    tab.layer.cornerRadius = 10;
    tab.delegate = self;
    tab.dataSource = self;
    [self addSubview:tab];
    _myTableview = tab;
    
    
    float btnX = (self.frame.size.width-btnWH)/2;
    float btnY = CGRectGetMaxY(tab.frame)+15;
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(btnX, btnY, btnWH, btnWH);
    [btn setBackgroundImage:[UIImage imageNamed:@"appoint_btn_sure"] forState:UIControlStateNormal];
    btn.titleLabel.numberOfLines = 0;
    btn.titleLabel.lineBreakMode = 0;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*17/320];
    [btn setTitle:@"确定\n支付" forState:UIControlStateNormal];
    [self addSubview:btn];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        if (self.payStyle == 1)
            [self jumpToBizPay];
        else
            [self payWithZFB];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float cellH = cell1;
    if (indexPath.row==3 ||indexPath.row == 4) {
        cellH = cell2;
    }
    return cellH;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6 ;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        if (indexPath.row == 3) {
                 UNIPurStyleCell* cell = [[NSBundle mainBundle]loadNibNamed:@"UNIPurStyleCell" owner:self options:nil].lastObject;
                cell.label1.text = @"微信支付";
                cell.label2.text = @"使用微信支付";
                cell.mainImg.image = [UIImage imageNamed:@"KZ_img_weixin"];
                cell.stateImg.image = [UIImage imageNamed:@"KZ_btn_payStyle2"];
                wcCell = cell ;
                return cell;
            }
        if (indexPath.row == 4){
                 UNIPurStyleCell* cell = [[NSBundle mainBundle]loadNibNamed:@"UNIPurStyleCell" owner:self options:nil].lastObject;
                cell.label1.text = @"支付宝";
                cell.label2.text = @"使用支付宝";
                cell.mainImg.image = [UIImage imageNamed:@"KZ_img_zhifubao"];
                cell.stateImg.image= [UIImage imageNamed:@"KZ_btn_payStyle1"];
                zfCell = cell;
                return cell;
            }
    
    
        static NSString* name = @"cell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
        }
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"  请您到XX美容院领取您的宝贝";
                cell.textLabel.textColor = [UIColor colorWithHexString:kMainThemeColor];
                cell.textLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*13/320];
                break;
            case 1:
                cell.textLabel.text = @"广州某街道20号";
                cell.textLabel.textColor = [UIColor blackColor];
                cell.textLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*13/320];
                cell.imageView.image = [UIImage imageNamed:@"function_img_cell2"];
                cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 2:
                cell.textLabel.text = @"020-88888888";
                cell.textLabel.textColor = [UIColor blackColor];
                cell.textLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*13/320];
                cell.imageView.image = [UIImage imageNamed:@"function_img_cell3"];
                cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 5:{
                NSString* string = [NSString stringWithFormat:@"￥%.2f",gPrice];
                UIFont* font =[UIFont boldSystemFontOfSize:KMainScreenWidth* 15/320];
                float labW =string.length*(KMainScreenWidth* 15/320); 
                float labX =tableView.frame.size.width -8 - labW;
                UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labX, 10, labW, 20)];
                lab1.text =string;
                lab1.textColor = [UIColor colorWithHexString:kMainThemeColor];
                lab1.font =font;
                [cell addSubview:lab1];
                
                
                float lab2W =KMainScreenWidth* 50/320;
                float lab2X = labX - lab2W;
                UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(lab2X,10,lab2W, 20)];
                lab2.text = @"合计";
                lab2.textAlignment = NSTextAlignmentRight;
                lab2.font = [UIFont boldSystemFontOfSize:KMainScreenWidth* 15/320];
                [cell addSubview:lab2];
            }
                break;
    }
    return cell;
                return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 1://导航到店
            [self callOtherMapApp];
            break;
        case 2://致电商家
            [self callPhoneToShop];
            break;
        case 3:
            wcCell.stateImg.image= [UIImage imageNamed:@"KZ_btn_payStyle2"];
            zfCell.stateImg.image= [UIImage imageNamed:@"KZ_btn_payStyle1"];
            self.payStyle = 1;
            break;
        case 4:
            wcCell.stateImg.image= [UIImage imageNamed:@"KZ_btn_payStyle1"];
            zfCell.stateImg.image= [UIImage imageNamed:@"KZ_btn_payStyle2"];
             self.payStyle = 2;
            break;
    }
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
    
    [UIActionSheet showInView:self withTitle:@"本机地图" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:mapsArray tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
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

#pragma mark 调用电话功能
-(void)callPhoneToShop{
    UNIShopManage* manager = [UNIShopManage getShopData];
    NSString* tel = [NSString stringWithFormat:@"tel://%@",manager.telphone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
}

-(void)payWithZFB{
    /*
     *点击获取prodcut实例并初始化订单信息
     */

    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = ZFBPID;
    NSString *seller = ZFBACCOUNT;
    NSString *privateKey =ZFBRSAPrivateKey;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
//    if ([partner length] == 0 ||
//        [seller length] == 0 ||
//        [privateKey length] == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"缺少partner或者seller或者私钥。"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = @"4412831990091123"; //订单ID（由商家自行制定）
    order.productName = @""; //商品标题
    order.productDescription =@""; //商品描述
    order.amount = [NSString stringWithFormat:@"%d",234]; //商品价格
    order.notifyURL =  @"http://www.baidu.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"UniZFBPay";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
        
    }

}
- (NSString *)jumpToBizPay {
    
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                return @"";
            }else{
                return [dict objectForKey:@"retmsg"];
            }
        }else{
            return @"服务器返回错误，未获取到json对象";
        }
    }else{
        return @"服务器返回错误";
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
