//
//  UNIAppointTop.m
//  Uni
//
//  Created by apple on 15/11/24.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppointTop.h"
//#import "UNIShopManage.h"
#import "UNIMyProjectModel.h"
#import "BaiduMobStat.h"
#import "UNIShopView.h"
@implementation UNIAppointTop

-(id)initWithFrame:(CGRect)frame andModel:(UNIMyProjectModel*)mod andShopId:(int)shopIp{
    self = [super initWithFrame:frame];
    if (self) {
        if (mod) {
              projectArr = @[mod];
             _projBeginDate = mod.projectBeginDate;
        }
      
        _shopId =shopIp;
       
//        [self setupData];
//        [self judgeBeforeDawn];
        [self setupTopScrollerContent];
        [self initSecondView];
        [self setupMidScroller];
        [self setupUI:frame];
    }
    return self;
}
-(void)setupData{
//    UNIShopManage* shop = [UNIShopManage getShopData];
//    _lockupTime= shop.end_time;
//    _workupTime = shop.begin_time;
    _lockupTime= nil;
    _workupTime =nil;

}

#pragma mark 判断是否凌晨
-(void)judgeBeforeDawn{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    int hour =[localeDate.description substringWithRange:NSMakeRange(11, 2)].intValue; //当前时间的中的小时
    
    NSArray* beginArr = [_workupTime componentsSeparatedByString:@":"];
    int workH = [beginArr[0] intValue]; //上班时间中的小时
    
    NSArray* endArr = [_lockupTime componentsSeparatedByString:@":"];
    int endH = [endArr[0] intValue]; //下班时间中的小时
    
    midNight = NO;
    //判断当前时间在店铺上班时间前 都被认为现在是凌晨 //判断当前时间超过或等于下班时间 都认为是凌晨
    if (hour <= workH || hour >= endH) {
        midNight=YES;
   }
    
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer*)gesture{
    
    CGRect midScR = _midScroller.frame;
    CGRect newX =midScR;
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        if (self->selectBtnNum>1) {
            --self->selectBtnNum;
            newX.origin.x = midScR.size.width;
            for (UIButton* b in self.topBtns) {
                if (b.tag == self->selectBtnNum) {
                    [self dateBtnAction:b];
                    break ;
                }
            }
            if (self->selectBtnNum<5) {
                [self.topScroller setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        }
        [[BaiduMobStat defaultStat]logEvent:@"arrow_right_appoint" eventLabel:@"预约右边翻页"];
    }
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self->selectBtnNum<7) {
            ++self->selectBtnNum;
             newX.origin.x = -midScR.size.width;
            for (UIButton* b in self.topBtns) {
                if (b.tag == self->selectBtnNum) {
                    [self dateBtnAction:b];
                    break;
                }
            }
            if (self->selectBtnNum>4) {
                [self.topScroller setContentOffset:CGPointMake(self.frame.size.width/5*3, 0) animated:YES];
            }
        }
        [[BaiduMobStat defaultStat]logEvent:@"arrow_left_appoint" eventLabel:@"预约左边翻页"];
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.midScroller.frame =newX;
    } completion:^(BOOL finished) {
        self.midScroller.frame =midScR;
    }];
    
}

-(void)setupUI:(CGRect)frace{
    //self.member =1;
    topScrollerNum = 0;
   // _maxNum = 1;
    midBtns = [NSMutableArray array];
    self.backgroundColor = [UIColor clearColor];
    [self beforeRequest];
}

-(void)beforeRequest{
    
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
    self.midScroller.alpha = 0.5;
    [self startRequest];

}

-(void)startRequest{
   // self.selectTime = @"";
    NSString* string = self.selectDay;
    
    NSMutableString* projectIds = [NSMutableString string];
    int allCostTime =0;
    if (projectArr.count < 1) {
        [projectIds appendString: @"0"];
    }else{
        for (int i=0; i<projectArr.count; i++) {
            UNIMyProjectModel* model = projectArr[i];
            allCostTime+=model.costTime;
            if (i != projectArr.count-1)
                [projectIds appendFormat:@"%d,",model.projectId];
            else
                [projectIds appendFormat:@"%d",model.projectId];
        }
    }
    UNIMypointRequest* request = [[UNIMypointRequest alloc]init];
    [request postWithSerCode:@[API_URL_GetFreeTime]
                      params:@{@"projectId":projectIds,
                               @"date":string,
                               @"costTime":@(allCostTime),
                               @"shopId":@(_shopId)}];
    request.regetFreeTime=^(NSArray* array,NSString* tips,NSError* err){
        [LLARingSpinnerView RingSpinnerViewStop1];
        if (err) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
        //筛选已经过去了的时间点
        NSDateFormatter* dateF = [[NSDateFormatter alloc]init];
        [dateF setDateFormat:@"yyyy-M-d"];
        NSString  * title = [dateF stringFromDate:[NSDate date]];
        
        NSMutableArray* data = [NSMutableArray array];
        if ([title isEqualToString: string]) {
            NSString* title1 = [[NSDate date].description substringWithRange:NSMakeRange(11, 5)];
            NSArray* now = [title1 componentsSeparatedByString:@":"];
            int xs = [now[0] intValue]+8;  //+8小时为北京时间
            int m = [now[1] intValue];     //分钟
            for (NSDictionary* dic in array) {
                NSString* time = [dic objectForKey:@"time"];
                NSArray* st = [time componentsSeparatedByString:@":"];
                int selexs = [st[0] intValue];
                int selem = [st[1] intValue];
                if (selexs>xs){
                    [data addObject:dic];
                    continue;
                }
                else if (selexs == xs){
                    if (selem>m) {
                        [data addObject:dic];
                        continue;
                    }
                }
            }
        }else
            [data addObjectsFromArray:array];
        
        
        if (self.selectTime) {
            BOOL cuizai = NO;
            for (int i = 0;i<data.count;i++) {
                NSDictionary* dic = data[i];
                if ([self.selectTime isEqualToString:dic[@"time"]])
                    cuizai = YES;
                
                if (i == data.count - 1 && cuizai==NO)
                    self.selectTime = nil;
            }
        }
        if (!self.selectTime){
            if (data.count>0) {
                NSDictionary* dic = data[0];
                self.selectTime = dic[@"time"];
            }
        }
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.midScroller.alpha = 1;
            
            self.userInteractionEnabled = YES;\
                self->freeTimes = data;
                self->noDate.hidden= data.count>0;
            [self setupMidScroller];
        });
    };
}

#pragma mark 加载scroller里面的内容
-(void)setupTopScrollerContent{
    float topH =KMainScreenWidth*46/320;
    UIScrollView* view = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, topH)];
    view.backgroundColor = [UIColor blackColor];
    view.showsHorizontalScrollIndicator=NO;
    view.delegate = self;
    [self addSubview:view];
    _topScroller = view;
    
    float btnW =self.frame.size.width/5;
    float btnH = _topScroller.frame.size.height+1;
    
    UIImageView* backMove = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"appoint_img_top"]];
    backMove.frame = CGRectMake(btnW, 0, btnW, btnH);
    [view addSubview:backMove];
    arrowImg = backMove;
    
    _topBtns = [NSMutableArray arrayWithCapacity:8];
   
    _topScroller.contentSize = CGSizeMake(btnW*8,topH);
    
    NSDateFormatter* forma = [[NSDateFormatter alloc]init];
    [forma setDateFormat:@"yyyy-MM-dd"];
    NSDate *beginDate =[forma dateFromString:_projBeginDate];
    NSString* nowString = [forma stringFromDate:[NSDate date]];
    NSDate* today = [forma dateFromString:nowString];
    
    if (!_projBeginDate ||[_projBeginDate isEqualToString:@""])
        beginDate = [forma dateFromString:nowString];
    
    if ([today timeIntervalSinceDate:beginDate] >= 0) {
        beginDate = [today dateByAddingTimeInterval:(24*60*60)];
    }
    for (int i =0 ; i<8; i++) {
        NSDate *now = nil;
        
        if (i<1)
            now =[beginDate dateByAddingTimeInterval:-(24*60*60)];
        if (i == 1)
            now = beginDate;
        if (i>1)
            now = [beginDate dateByAddingTimeInterval:(24*60*60)*(i-1)];
        
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = kCFCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        int year = (int)[dateComponent year];
        int month =  (int)[dateComponent month];
        int day = (int) [dateComponent day];
        int weekday = (int) [dateComponent weekday];
        NSString* wenke = weekday==1?@"星期天":weekday==2?@"星期一":weekday==3?@"星期二":weekday==4?@"星期三":weekday==5?@"星期四":weekday==6?@"星期五":weekday==7?@"星期六":@"";
        NSString* str = [NSString stringWithFormat:@"%@\n%d-%d",wenke,month,day];
      //  NSLog(@"month,day,weekday,year  %d, %d, %d, %d",month,day,weekday,year);
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake(btnW*i, 0, btnW, btnH);
        [btn setTitle:str forState:UIControlStateNormal];
        btn.titleLabel.lineBreakMode =0;
        btn.titleLabel.numberOfLines = 0;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor clearColor]];
        
        if (i == 0)btn.enabled=NO;
        
        if (i==1){
            self->selectBtnNum = 1;
            self.selectYear =year;
            self.selectDay =[NSString stringWithFormat:@"%d-%d-%d",year,month,day];
            }
        btn.titleLabel.font = kWTFont(15);
        [_topScroller addSubview:btn];
        [_topBtns addObject:btn];
       
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(UIButton* x){
             [self dateBtnAction:x];
        }];
        btn=nil;
    }
}
-(void)dateBtnAction:(UIButton*)x{
    self.numDay = (int)x.tag;
    selectBtnNum =(int)x.tag;
    x.selected=YES;
    for (UIButton* b in self.topBtns) {
        if (b!=x)
            b.selected=NO;
    }
    
   // self.member=1;//重置人数
    NSString* str = [x titleForState:UIControlStateNormal];
    NSString* monthAndDay =[str componentsSeparatedByString:@"\n"][1];
    self.selectDay=[NSString stringWithFormat:@"%d-%@",self.selectYear,monthAndDay];
    
    CGPoint pot = CGPointMake(x.center.x, self->arrowImg.center.y);
    [UIView animateWithDuration:0.2 animations:^{
        self->arrowImg.center = pot;
    }];
    
    self.userInteractionEnabled = NO;
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
    self.midScroller.alpha = 0.5;
    noDate.hidden=YES;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:1.0];
        [self startRequest];
    });

}

-(void)initSecondView{
    float viewX = 0;
    float viewY = CGRectGetMaxY(_topScroller.frame)+10;
    float viewH = self.frame.size.height - viewY;
    float viewW = self.frame.size.width - 2*viewX;
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(viewX, viewY, viewW , viewH)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    float labX = 16;
    float labY = 0;
    float labH = KMainScreenWidth* 40/414;
    float labW =  KMainScreenWidth* 100/320;
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(labX, labY, labW, labH)];
    lab.text = @"开始时间";
    lab.font = kWTFont(15);
    [view addSubview:lab];

    float btn3WH = KMainScreenWidth*30/414;
    
    float topH =viewH - CGRectGetMaxY(lab.frame)-10;
    float topY = CGRectGetMaxY(lab.frame);
    float topX = btn3WH;
    float topW =view.frame.size.width - 2* btn3WH;
    UIScrollView* secondV = [[UIScrollView alloc]initWithFrame:CGRectMake(topX, topY,topW, topH)];
    secondV.delegate = self;
    secondV.pagingEnabled=NO;
    [view addSubview:secondV];
    _midScroller = secondV;
    
    UILabel* nodate = nil;
    nodate = [[UILabel alloc]init];
    nodate.text = @"没有可以预约的时间哦！";
    nodate.font = kWTFont(15);;
    nodate.hidden = YES;
    nodate.textColor = [UIColor colorWithHexString:kMainTitleColor];
    [nodate sizeToFit];
    nodate.frame = CGRectMake((self.midScroller.frame.size.width - nodate.frame.size.width)/2, topH/2, nodate.frame.size.width, nodate.frame.size.height);
    [self.midScroller addSubview:nodate];
    noDate = nodate; nodate = nil;
    
    
    UISwipeGestureRecognizer* recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [_midScroller addGestureRecognizer:recognizer];
    
    
    UISwipeGestureRecognizer*  recognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer1 setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    [_midScroller addGestureRecognizer:recognizer1];


    //float btn3Y = (view.frame.size.height- btn3WH)/2;
    UIButton* btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(0, 0, btn3WH, viewH);
    [btn3 setImage:[UIImage imageNamed:@"appoint_btn_leftTop"] forState:UIControlStateNormal];
    [view addSubview:btn3];
    _midLeftBtn = btn3;
    [[btn3 rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        if (self->selectBtnNum>1) {
            --self->selectBtnNum;
            for (UIButton* b in self.topBtns) {
                if (b.tag == self->selectBtnNum) {
                    [self dateBtnAction:b];
                    break ;
                }
            }
            if (self->selectBtnNum<5) {
                [self.topScroller setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        }
    }];

    float btn4X = view.frame.size.width - btn3WH;
    UIButton* btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(btn4X, 0, btn3WH, viewH);
    [btn4 setImage:[UIImage imageNamed:@"appoint_btn_rightTop"] forState:UIControlStateNormal];
    [view addSubview:btn4];
    _midRightBtn = btn4;
    [[btn4 rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         if (self->selectBtnNum<7) {
             ++self->selectBtnNum;
             for (UIButton* b in self.topBtns) {
                 if (b.tag == self->selectBtnNum) {
                     [self dateBtnAction:b];
                     break;
                 }
             }
             
             if (self->selectBtnNum>4) {
                 [self.topScroller setContentOffset:CGPointMake(KMainScreenWidth/5*3, 0) animated:YES];
             }
         }
     }];
    btn4=nil;  btn3=nil; recognizer1=nil;recognizer=nil;secondV=nil; lab=nil; view=nil;
}

-(void)setupMidScroller{
    int cout= (int)freeTimes.count;
    //int cout = 15;
    int f = 1;//能翻的页数
    if (cout>3){
        f = cout/3;
        if (cout%3 > 0)
            f++;
    }
    
    float KK =0;
    float btnW = (_midScroller.frame.size.width - KK)/3;
    float btnH = KMainScreenWidth*70/414;
    _midScroller.contentSize = CGSizeMake(_midScroller.frame.size.width ,
                                              btnH*f);

        [[self.midRightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {
                 CGPoint point = CGPointMake(0, 0);
                 [self.midScroller setContentOffset:point animated:YES];

        }];
        
        [[self.midLeftBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {
                 CGPoint point = CGPointMake(0, 0);
                 [self.midScroller setContentOffset:point animated:YES];
            
         }];

    
    //移除数组里面的按钮对象
    [midBtns removeAllObjects];
    //移除self.midScroller里面的按钮
    //NSArray* arr =self.midScroller.subviews;
    for (UIView* view in self.midScroller.subviews) {
        if ([view isKindOfClass:[UILabel class]])
            continue;
        [view removeFromSuperview];
    }
    
    for (int i = 0; i<cout; i++) {
        NSDictionary* dic = freeTimes[i];
        float btnX =KK/2+ i%3 * btnW;
        float btnY =i/3*btnH;
        UIButton* but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame=CGRectMake(btnX+1, btnY+1, btnW-2, btnH-2);
        
//        NSString* btnString =[dic valueForKey:@"time"];
//        if ([self.selectTime isEqualToString:btnString])
//            but.selected=YES;
        
       
        if(i == 0){
            
            self.startTime = nil;
            NSString* str = [NSString stringWithFormat:@"%@ %@",self.selectDay,self.selectTime];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            self.startTime = [dateFormatter dateFromString:str];
            dateFormatter = nil; str=nil;
        }
        
        if (i == cout-1) {
            self.finalTime=nil;
            NSString* str = [NSString stringWithFormat:@"%@ %@",_selectDay,[dic valueForKey:@"time"]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            self.finalTime = [dateFormatter dateFromString:str];
            dateFormatter = nil; str=nil;
        }
        [but setTitle:[dic valueForKey:@"time"] forState:UIControlStateNormal];
        but.tag = 10+i;
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor colorWithHexString:kMainPinkColor] forState:UIControlStateHighlighted];
        [but setTitleColor:[UIColor colorWithHexString:kMainPinkColor] forState:UIControlStateSelected];
        but.titleLabel.font = [UIFont systemFontOfSize:(KMainScreenWidth*15/414)];
        but.layer.borderColor =[UIColor colorWithHexString:kMainPinkColor].CGColor;
        if (i == 0){
            but.selected=YES;
            but.layer.borderWidth = 1;
        }
        
        
        [_midScroller addSubview:but];
        [self->midBtns addObject:but];
       
            CALayer* lay = [CALayer layer ];
            lay.frame = CGRectMake(0, 0, btnW, 0.5);
            lay.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
            [but.layer addSublayer:lay];
            lay=nil;
        
        if (i%3<2) {
            CALayer* lay1 = [CALayer layer ];
            float layH = btnH*0.6;
            float layY = (btnH - layH)/2;
            lay1.frame = CGRectMake(btnW-1, layY, 0.5, layH);
            lay1.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
            [but.layer addSublayer:lay1];
            lay1=nil;
        }
        
        [[but rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(UIButton* x) {
             x.selected = YES;
             x.layer.borderWidth =1;
             self.selectTime = [x titleForState:UIControlStateNormal];
             for (UIButton* k in self->midBtns) {
                 if (k!=x){
                     k.selected=NO;
                     k.layer.borderWidth =0;}
             }
             self.startTime = nil;
             NSString* str = [NSString stringWithFormat:@"%@ %@",self.selectDay,self.selectTime];
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
             self.startTime = [dateFormatter dateFromString:str];
             dateFormatter = nil; str=nil;
            
        }];
        but = nil;
    }
}

-(void)keyboardTool:(BTKeyboardTool *)tool buttonClick:(KeyBoardToolButtonType)type{
    if (type ==kKeyboardToolButtonTypeDone ) {
        [self endEditing:YES];
    }
}
/**
 *颜色值转换成图片
 */

- (UIImage*)createImageWithColor:(UIColor*) color
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

#pragma mark 改变shopid 重新请求数据
-(void)changeShopId:(int)shopid{
    _shopId = shopid;
    [self beforeRequest];
}

-(void)changeProjectIds:(NSArray*)projects{
    projectArr = projects;
    [self beforeRequest];
}

@end
