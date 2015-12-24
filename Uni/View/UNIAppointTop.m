//
//  UNIAppointTop.m
//  Uni
//
//  Created by apple on 15/11/24.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppointTop.h"
#import "UNIAppontMid.h"

@implementation UNIAppointTop


-(void)setupUI:(CGRect)frace{
    self.member =1;
    topScrollerNum = 0;
    _maxNum = 1;
    midBtns = [NSMutableArray array];
//    NSString* day =[[NSDate date] description];
//    NSLog(@" dat\y  %@",day);
//    self.selectDay = [day substringWithRange:NSMakeRange(0, 9)];
   // [self startRequest];
    [self setupTopScrollerContent];
    [self setuptopLeftBtn];
    [self setuptopRightBtn];
}

-(void)startRequest{
    
    NSString* string = self.selectDay;
    UNIMypointRequest* request = [[UNIMypointRequest alloc]init];
    [request postWithSerCode:@[API_PARAM_UNI,API_URL_GetFreeTime] params:@{@"projectId":@(self.model.projectId),
                                                                           @"date":string,
                                                                           @"costTime":@(self.model.costTime)
                                                                           }];
    request.regetFreeTime=^(NSArray* array,NSString* tips,NSError* err){
        //筛选已经过去了的时间点
        NSMutableArray* data = [NSMutableArray array];
        if (array.count>0) {
            NSString* title1 = [[NSDate date].description substringWithRange:NSMakeRange(11, 5)];
            NSArray* now = [title1 componentsSeparatedByString:@":"];
            int xs = [now[0] intValue];
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
        }
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [LLARingSpinnerView RingSpinnerViewStop];
            self.userInteractionEnabled = YES;
            if (err) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            if (data.count>0) {
                self->freeTimes = data;
                [self setupMidScroller];
            }else
                [YIToast showText:@"请求预约时间点失败"];
        });
    };
}

#pragma mark 加载scroller里面的内容
-(void)setupTopScrollerContent{
    _topBtns = [NSMutableArray arrayWithCapacity:8];
    float btnW = (KMainScreenWidth - 70)/3;
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
        NSString* str = [NSString stringWithFormat:@"%d-%d %@",month,day,wenke];
      //  NSLog(@"month,day,weekday,year  %d, %d, %d, %d",month,day,weekday,year);
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake(btnW*i, 0, btnW, btnH);
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"e23469"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithHexString:@"e23469"] forState:UIControlStateHighlighted];
        if (i==1){
            btn.selected = YES;
            self.selectYear =year;
            self.selectDay =[NSString stringWithFormat:@"%d-%d-%d",year,month,day];
        }
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*11/320];
        [_topScroller addSubview:btn];
        [_topBtns addObject:btn];
        
        if (i==0) {
            [btn setTitleColor:[UIColor colorWithHexString:@"c2c1c0"] forState:UIControlStateNormal];
            [btn setTitleColor:nil forState:UIControlStateSelected];
            [btn setTitleColor:nil forState:UIControlStateHighlighted];
            continue;
        }
        
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(UIButton* x){
             self.numDay = (int)x.tag;
             [self.topScroller setContentOffset:CGPointMake(x.frame.origin.x-x.frame.size.width, 0) animated:YES];
             
             CGPoint point = CGPointMake(0, 0);
             [self.midScroller setContentOffset:point animated:YES];
             
             self.member=1;//重置人数
             NSString* str = [x titleForState:UIControlStateNormal];
             NSString* monthAndDay =[str componentsSeparatedByString:@" "][0];
             self.selectDay=[NSString stringWithFormat:@"%d-%@",self.selectYear,monthAndDay];
             for (UIButton* b in self.topBtns) {
                 if (b==x)
                     b.selected=YES;
                 else
                     b.selected=NO;
             }
             [LLARingSpinnerView RingSpinnerViewStart];
             self.userInteractionEnabled = NO;
             dispatch_async(dispatch_get_global_queue(0, 0), ^{
                 [NSThread sleepForTimeInterval:1.0];
                 [self startRequest];
             });
             
        }];
    }
    [LLARingSpinnerView RingSpinnerViewStart];
    self.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self startRequest];
    });
}

#pragma mark topLeftBtn
-(void)setuptopLeftBtn{
    [self.topLeftBtn setImage:[UIImage imageNamed:@"appoint_btn_leftTop"] forState:UIControlStateNormal];
    [self.topLeftBtn setImage:[UIImage imageNamed:@"appoint_btn_leftTop1"] forState:UIControlStateSelected];
    [self.topLeftBtn setImage:[UIImage imageNamed:@"appoint_btn_leftTop1"] forState:UIControlStateHighlighted];
    self.topLeftBtn.selected=NO;
   // UIScrollView* scroller = self.topScroller;
    [[self.topLeftBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         float xx = self.topScroller.contentOffset.x;
         float wy = xx-self.topScroller.frame.size.width;
         if(wy<0)
             wy = 0;
         
         CGPoint position = CGPointMake(wy,0);
         [self.topScroller setContentOffset:position animated:YES];

    }];
}

-(void)setuptopRightBtn{
    [self.topRightBtn setImage:[UIImage imageNamed:@"appoint_btn_rightTop1"] forState:UIControlStateNormal];
    [self.topRightBtn setImage:[UIImage imageNamed:@"appoint_btn_rightTop"] forState:UIControlStateSelected];
    [self.topRightBtn setImage:[UIImage imageNamed:@"appoint_btn_rightTop"] forState:UIControlStateHighlighted];
    self.topRightBtn.selected=YES;

    [[self.topRightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         float xx = self.topScroller.contentOffset.x;
         float wy = xx+self.topScroller.frame.size.width;
         
         if(wy>self.topScroller.contentSize.width-self.topScroller.frame.size.width)
             wy = self.topScroller.contentSize.width-self.topScroller.frame.size.width;
         CGPoint position = CGPointMake(wy, 0);
         [self.topScroller setContentOffset:position animated:YES];

     }];
}


-(void)setupMidScroller{
    int cout= (int)freeTimes.count;
    int f = 1;//能翻的页数
    if (cout>6){
        f = cout/6;
        if (cout%6 > 0)
            f++;
    }
        _midScroller.contentSize = CGSizeMake(_midScroller.frame.size.width*f ,
                                              _midScroller.frame.size.height);
    _midScroller.pagingEnabled=YES;
        [[self.midRightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {
             int b =(int)self.midScroller.contentOffset.x/self.midScroller.frame.size.width;
             ++b;
             if (b<f) {
                 CGPoint point = CGPointMake(self.midScroller.frame.size.width*b, 0);
                 [self.midScroller setContentOffset:point animated:YES];
             }
        }];
        
        [[self.midLeftBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {
             int b =(int)self.midScroller.contentOffset.x/self.midScroller.frame.size.width;
             if (b>0) {
                 CGPoint point = CGPointMake(self.midScroller.frame.size.width*--b, 0);
                 [self.midScroller setContentOffset:point animated:YES];
             }
         }];

    
    //移除数组里面的按钮对象
    [midBtns removeAllObjects];
    //移除self.midScroller里面的按钮
    for (UIView* view in self.midScroller.subviews) {
        [view removeFromSuperview];
    }
    
    juw = 0;//判断时候满三个
    juh = 0;//判断当前是第一行还是第二行
    
    float ww =self.midScroller.frame.size.width/3; //间隔+按钮的宽+间隔 =完整的间距
    float btnW = KMainScreenWidth*50/320; //按钮的宽和高
    float jj = (ww-btnW)/2; //按钮的间距
    for (int i = 0; i<cout; i++) {
        NSDictionary* dic = freeTimes[i];
        float zuo  = ww*juw+jj+(i/6*self.midScroller.frame.size.width); //按钮的X坐标
        if (i%3==0)
            zuo = jj+(i/6*self.midScroller.frame.size.width);
        float xia =0;//按钮的Y坐标
        if (juh==1) {
            xia = btnW+jj;
        }
        UIButton* but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame=CGRectMake(zuo, xia, btnW, btnW);
        if(i == 0){
            but.selected=YES;
            self.selectTime =[dic valueForKey:@"time"];
        }
        [but setTitle:[dic valueForKey:@"time"] forState:UIControlStateNormal];
        but.tag = 10+i;
        but.layer.masksToBounds=YES;
        but.layer.cornerRadius = KMainScreenWidth*25/320;
        [but setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"c2c1c0"]] forState:UIControlStateNormal];
        [but setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"25C4AA"]] forState:UIControlStateHighlighted];
        [but setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"25C4AA"]] forState:UIControlStateSelected];
        [_midScroller addSubview:but];
        [self->midBtns addObject:but];
        if (juw>1) {
            juw = 0;
            if (juh==1) {
                juh=0;
            }else
                juh=1;
        }else
            juw++;
        
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
    if (scrollView == self.topScroller) {
        float xx = scrollView.contentOffset.x;
        if (xx<50) {
            self.topLeftBtn.selected=NO;
            self.topRightBtn.selected = YES;
        }else if (xx >=scrollView.contentSize.width/2){
            self.topLeftBtn.selected=YES;
            self.topRightBtn.selected = NO;
        }else{
            self.topLeftBtn.selected=YES;
            self.topRightBtn.selected = YES;
        }
    }
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

#pragma mark 用颜色转成图片
-(UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
