//
//  UNIAppointTop.m
//  Uni
//
//  Created by apple on 15/11/24.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppointTop.h"
//#import "UNIAppontMid.h"

@implementation UNIAppointTop
-(id)initWithFrame:(CGRect)frame andModel:(UNIMyProjectModel*)model{
    self = [super initWithFrame:frame];
    if (self) {
        self.model = model;
        [self setupTopScrollerContent];
        [self initSecondView];
        [self setupMidScroller];
        [self setupUI:frame];
    }
    return self;
}

-(void)setupUI:(CGRect)frace{
    self.member =1;
    topScrollerNum = 0;
    _maxNum = 1;
    midBtns = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self startRequest];
    });
    
  

}

-(void)startRequest{
    
    NSString* string = self.selectDay;
    UNIMypointRequest* request = [[UNIMypointRequest alloc]init];
    [request postWithSerCode:@[API_PARAM_UNI,API_URL_GetFreeTime]
                      params:@{@"projectId":@(self.model.projectId),
                               @"date":string,
                               @"costTime":@(self.model.costTime)
                                                                           }];
    request.regetFreeTime=^(NSArray* array,NSString* tips,NSError* err){
        //筛选已经过去了的时间点
        NSDateFormatter* dateF = [[NSDateFormatter alloc]init];
        [dateF setDateFormat:@"yyyy-M-d"];
        NSString  * title = [dateF stringFromDate:[NSDate date]];
        
        NSMutableArray* data = [NSMutableArray array];
        if ([title isEqualToString: string]) {
            NSString* title1 = [[NSDate date].description substringWithRange:NSMakeRange(11, 5)];
            NSArray* now = [title1 componentsSeparatedByString:@":"];
            int xs = [now[0] intValue]+8;
            int m = [now[1] intValue];
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
        }else{
            [data addObjectsFromArray:array];
        }
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [LLARingSpinnerView RingSpinnerViewStop];
            self.userInteractionEnabled = YES;
            if (err) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            //if (data.count>0) {
                self->freeTimes = data;
                [self setupMidScroller];
           // }
//            else
//                [YIToast showText:@"请求预约时间点失败"];
        });
    };
}

#pragma mark 加载scroller里面的内容
-(void)setupTopScrollerContent{
    float topH =KMainScreenWidth*45/320;
    UIScrollView* view = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, topH)];
    view.showsHorizontalScrollIndicator=NO;
    view.delegate = self;
    [self addSubview:view];
    _topScroller = view;
    
    
    _topBtns = [NSMutableArray arrayWithCapacity:8];
    
    float btnW =KMainScreenWidth/5;
    float btnH = _topScroller.frame.size.height;
    _topScroller.contentSize = CGSizeMake(btnW*8,btnH);
    _topScroller.delegate = self;
    for (int i =0 ; i<8; i++) {
        NSDate *now = nil;
        if (i>0)
            now =[NSDate dateWithTimeIntervalSinceNow:(24*60*60)*(i-1)];
        else
            now= [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
        
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
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[self createImageWithColor:[UIColor blackColor]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:kMainThemeColor]] forState:UIControlStateSelected];
        [btn setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:kMainThemeColor]] forState:UIControlStateHighlighted];
        if (i==1){
            btn.selected = YES;
            self.selectYear =year;
            self.selectDay =[NSString stringWithFormat:@"%d-%d-%d",year,month,day];
            }
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_topScroller addSubview:btn];
        [_topBtns addObject:btn];
        
        if (i==0) {
            [btn setTitleColor:[UIColor colorWithHexString:@"c2c1c0"] forState:UIControlStateNormal];
            continue;
        }
        
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(UIButton* x){
             self.numDay = (int)x.tag;
             
             x.selected=YES;
             for (UIButton* b in self.topBtns) {
                 if (b!=x)
                     b.selected=NO;
             }
             
             CGPoint point = CGPointMake(0, 0);
             [self.midScroller setContentOffset:point animated:YES];
             
             self.member=1;//重置人数
             NSString* str = [x titleForState:UIControlStateNormal];
             NSString* monthAndDay =[str componentsSeparatedByString:@"\n"][1];
             self.selectDay=[NSString stringWithFormat:@"%d-%@",self.selectYear,monthAndDay];
            
             CGPoint pot = CGPointMake(x.center.x, self->arrowImg.center.y);
             [UIView animateWithDuration:0.2 animations:^{
                 self->arrowImg.center = pot;
             }];
             
             [LLARingSpinnerView RingSpinnerViewStart];
             self.userInteractionEnabled = NO;
             dispatch_async(dispatch_get_global_queue(0, 0), ^{
                 [NSThread sleepForTimeInterval:1.0];
                 [self startRequest];
             });
             
        }];
    }

    
    
    float arrowW =KMainScreenWidth*5/320;
    float arrowH = KMainScreenWidth*4/320;
    float arrowX = btnW+(btnW-arrowW)/2;
    float arrowY = _topScroller.frame.size.height - arrowH;
    UIImageView* arrow = [[UIImageView alloc]initWithFrame:CGRectMake(arrowX, arrowY, arrowW, arrowH)];
    arrow.image = [UIImage imageNamed:@"appoint_img_arrows"];
    [_topScroller addSubview:arrow];
    arrowImg = arrow;

    }


-(void)initSecondView{
    float viewX = 10;
    float viewY = CGRectGetMaxY(_topScroller.frame)+10;
    float viewH = self.frame.size.height - viewY;
    float viewW = self.frame.size.width - 2*viewX;
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    float labX = 16;
    float labY = 10;
    float labH = KMainScreenWidth* 25/414;
    float labW =  KMainScreenWidth* 100/320;
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(labX, labY, labW, labH)];
    lab.text = @"开始时间";
    lab.font = [UIFont systemFontOfSize:KMainScreenWidth>320?18:15];
    [view addSubview:lab];

    float topY = CGRectGetMaxY(lab.frame)+5;
    float topH =view.frame.size.height - topY- KMainScreenWidth*40/320;
    float topX = 10;
    float topW =view.frame.size.width -2*topX;
    UIScrollView* secondV = [[UIScrollView alloc]initWithFrame:CGRectMake(topX, topY,topW, topH)];
    secondV.delegate = self;
    [view addSubview:secondV];
    _midScroller = secondV;
    
//    CALayer* lay = [CALayer layer];
//    lay.frame = CGRectMake(topX, CGRectGetMaxY(secondV.frame), topW, 0.5);
//    lay.backgroundColor = kMainGrayBackColor.CGColor;
//    [view.layer addSublayer:lay];

    float btnW = KMainScreenWidth*180/414;
    float btnH = KMainScreenWidth*30/414;
    float btnY = CGRectGetMaxY(secondV.frame)+10;
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(labX, btnY, btnW, btnH);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@" 如需取消请提前致电商家" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth>320?14:9];
    [btn setImage:[UIImage imageNamed:@"appoint_btn_xunwen"] forState:UIControlStateNormal];
    [view addSubview:btn];
    
    float lab1X = view.frame.size.width/2+20;
    float lab1Y = btnY;
    float lab1H = btnH;
    float lab1W =  KMainScreenWidth* 40/320;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(lab1X, lab1Y, lab1W, lab1H)];
    lab1.text = @"人数:";
    lab1.font = [UIFont systemFontOfSize:KMainScreenWidth>320?18:15];
    [view addSubview:lab1];
    
    
    float btn1WH = btnH;
    float btn1Y = btnY;
    float btn1X = CGRectGetMaxX(lab1.frame);
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(btn1X, btn1Y, btn1WH, btn1WH);
    [btn1 setImage:[UIImage imageNamed:@"appoint_btn_jian"] forState:UIControlStateNormal];
    [view addSubview:btn1];
    [[btn1 rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         if (self.member >1)
             self.member--;
     }];
    
    float teX = CGRectGetMaxX(btn1.frame);
    float teW = KMainScreenWidth* 25/320;
    UITextField* text = [[UITextField alloc]initWithFrame:CGRectMake(teX, btn1Y, teW, btn1WH)];
    text.keyboardType = UIKeyboardTypeNumberPad;
    text.textAlignment = NSTextAlignmentCenter;
    text.text=@"1";
    [view addSubview:text];
    _nunField = text;
    
    BTKeyboardTool* tool = [BTKeyboardTool keyboardTool];
    tool.toolDelegate=self;
    [tool dismissTwoBtn];
    self.nunField.inputAccessoryView = tool;
    
    [RACObserve(self, member)subscribeNext:^(id x) {
        self.nunField.text = [NSString stringWithFormat:@"%d",self.member];
    }];
    
    [self.nunField.rac_textSignal subscribeNext:^(NSString* value) {
        if (value.length>0) {
            char r = [value characterAtIndex:value.length-1];
            if (r<48||r>57){
                NSString *str=[NSString stringWithCString:&r  encoding:NSUTF8StringEncoding];
                value = [value stringByReplacingOccurrencesOfString:str withString:@""];
            }
        }
        int num = value.intValue;
        if (num>self.maxNum) {
            num =self.maxNum;
            [YIToast showText:@"已到达可预约最大人数"];
        }else if(num<1)
            num = 1;
        self.member = num;
        // botton.nunField.text = [NSString stringWithFormat:@"%d",num];
    }];

    
    
    
    float btn2X = CGRectGetMaxX(text.frame);
    UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(btn2X, btn1Y, btn1WH, btn1WH);
    [btn2 setImage:[UIImage imageNamed:@"appoint_btn_jia"] forState:UIControlStateNormal];
    [view addSubview:btn2];
    [[btn2 rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         if (self.member<self.maxNum) {
             self.member++;
         }else
             [YIToast showText:@"已达到预约时间点的最大人数"];
     }];

//    float btn3WH = KMainScreenWidth*20/320;
//    float btn3Y = (view.frame.size.height- btn3WH)/2;
//    UIButton* btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn3.frame = CGRectMake(0, btn3Y, btn3WH, btn3WH);
//    [btn3 setImage:[UIImage imageNamed:@"appoint_btn_leftTop"] forState:UIControlStateNormal];
//    [view addSubview:btn3];
//    _midLeftBtn = btn3;
//    [[btn3 rac_signalForControlEvents:UIControlEventTouchUpInside]
//    subscribeNext:^(id x) {
//        
//    }];
//
//    float btn4X = view.frame.size.width - btn3WH;
//    UIButton* btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn4.frame = CGRectMake(btn4X, btn3Y, btn3WH, btn3WH);
//    [btn4 setImage:[UIImage imageNamed:@"appoint_btn_rightTop"] forState:UIControlStateNormal];
//    [view addSubview:btn4];
//    _midRightBtn = btn4;
//    [[btn4 rac_signalForControlEvents:UIControlEventTouchUpInside]
//     subscribeNext:^(id x) {
//         
//     }];
    
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
    
    float btnW = (_midScroller.frame.size.width - 20)/3; //按钮的宽和高
    float btnH = _midScroller.frame.size.height*0.4;
        _midScroller.contentSize = CGSizeMake(_midScroller.frame.size.width ,
                                              btnH*f);
    _midScroller.pagingEnabled=YES;
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
    for (UIView* view in self.midScroller.subviews) {
        [view removeFromSuperview];
    }
    
    
    for (int i = 0; i<cout; i++) {
        NSDictionary* dic = freeTimes[i];
        float btnX =10+ i%3 * btnW;
        float btnY =i/3*btnH;
        UIButton* but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame=CGRectMake(btnX, btnY, btnW, btnH);
        if(i == 0){
            but.selected=YES;
            self.selectTime =[dic valueForKey:@"time"];
        }
        [but setTitle:[dic valueForKey:@"time"] forState:UIControlStateNormal];
        but.tag = 10+i;
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor colorWithHexString:kMainThemeColor] forState:UIControlStateHighlighted];
        [but setTitleColor:[UIColor colorWithHexString:kMainThemeColor] forState:UIControlStateSelected];
        [_midScroller addSubview:but];
        [self->midBtns addObject:but];
        if (i%3 == 0) {
            CALayer* lay = [CALayer layer ];
            lay.frame = CGRectMake(10, 0, self.midScroller.frame.size.width - 20, 0.5);
            lay.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
            [but.layer addSublayer:lay];
        }
        if (i%3<2) {
            CALayer* lay1 = [CALayer layer ];
            float layH = btnH*0.6;
            float layY = (btnH - layH)/2;
            lay1.frame = CGRectMake(btnW, layY, 0.5, layH);
            lay1.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
            [but.layer addSublayer:lay1];
        }
        
        [[but rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(UIButton* x) {
             self.member=1;//重置人数
             x.selected = YES;
             NSDictionary* dic = self->freeTimes[x.tag-10];
             self.maxNum = [[dic objectForKey:@"num"] intValue];
             self.selectTime = [x titleForState:UIControlStateNormal];
             for (UIButton* k in self->midBtns) {
                 if (k!=x)
                     k.selected=NO;
             }
        }];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == self.midScroller) {
         float xx = scrollView.contentOffset.x;
        if (xx<50) {
            self.midLeftBtn.enabled=NO;
            self.midRightBtn.enabled = YES;
        }else if (xx >= scrollView.contentSize.width- scrollView.frame.size.width-50){
            self.midLeftBtn.enabled=YES;
            self.midRightBtn.enabled = NO;
        }else{
            self.midLeftBtn.enabled=YES;
            self.midRightBtn.enabled = YES;
        }

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


@end
