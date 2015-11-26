//
//  UNIAppointTop.m
//  Uni
//
//  Created by apple on 15/11/24.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppointTop.h"
#import "UNIAppontMid.h"
#import "AccountManager.h"

@implementation UNIAppointTop


-(void)setupUI:(CGRect)frace{
    topScrollerNum = 0;
    midBtns = [NSMutableArray array];
   // [self startRequest];
    [self setupTopScrollerContent];
    [self setuptopLeftBtn];
    [self setuptopRightBtn];
}

-(void)startRequest{
    //AccountManager* account = [AccountManager shared];
   // NSString* string = self.selectDay;
    NSString* string = @"2015-11-24";
    UNIMypointRequest* request = [[UNIMypointRequest alloc]init];
    [request postWithSerCode:@[API_PARAM_UNI,API_URL_GetFreeTime] params:@{@"userId":@(1),
                                                                           @"token":@"abcdxxa",
                                                                           @"shopId":@(1),
                                                                           @"projectId":@(self.model.projectId),
                                                                           @"date":string,
                                                                           @"costTime":@(50)
                                                                           }];
    request.regetFreeTime=^(NSArray* array,NSString* tips,NSError* err){
        if (err) {
            [YIToast showText:[err localizedDescription]];
            return ;
        }
        if (array) {
            self->freeTimes = array;
            [self setupMidScroller];
        }else
            [YIToast showText:tips];
    };
}

#pragma mark 加载scroller里面的内容
-(void)setupTopScrollerContent{
    _topBtns = [NSMutableArray arrayWithCapacity:8];
    float btnW = (KMainScreenWidth - 70)/3;
    float btnH = _topScroller.frame.size.height;
    _topScroller.contentSize = CGSizeMake(btnW*8,btnH);
    for (int i =0 ; i<8; i++) {
        NSDate *now = nil;
        if (i>0)
            now =[NSDate dateWithTimeIntervalSinceNow:(24*60*60)*i-1];
        else
            now= [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitDay;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
       // int year = (int)[dateComponent year];
        int month =  (int)[dateComponent month];
        int day = (int) [dateComponent day];
        int weekday = (int) [dateComponent weekday];
        NSString* wenke = weekday==1?@"星期一":weekday==2?@"星期二":weekday==3?@"星期三":weekday==4?@"星期四":weekday==5?@"星期五":weekday==6?@"星期六":weekday==7?@"星期天":@"";
        NSString* str = [NSString stringWithFormat:@"%d-%d %@",month,day,wenke];
        //NSLog(@"str  %@",str);
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnW*i, 0, btnW, btnH);
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"e23469"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithHexString:@"e23469"] forState:UIControlStateHighlighted];
        if (i==1){
            btn.selected = YES;
            self.selectDay =[NSString stringWithFormat:@"%d-%d",month,day];
        }
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*11/320];
        [_topScroller addSubview:btn];
        [_topBtns addObject:btn];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(UIButton* x){
             NSString* str = [x titleForState:UIControlStateNormal];
             self.selectDay=[str componentsSeparatedByString:@" "][0];
             for (UIButton* b in self.topBtns) {
                 if (b==x)
                     b.selected=YES;
                 else
                     b.selected=NO;
             }
              [self startRequest];
        }];
    }
    [self startRequest];
}

#pragma mark topLeftBtn
-(void)setuptopLeftBtn{
    [self.topLeftBtn setImage:[UIImage imageNamed:@"appoint_btn_leftTop"] forState:UIControlStateNormal];
    [self.topLeftBtn setImage:[UIImage imageNamed:@"appoint_btn_leftTop1"] forState:UIControlStateSelected];
    [self.topLeftBtn setImage:[UIImage imageNamed:@"appoint_btn_leftTop1"] forState:UIControlStateHighlighted];
    self.topLeftBtn.highlighted=NO;
   // UIScrollView* scroller = self.topScroller;
    [[self.topLeftBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         x.highlighted=YES;
         self.topRightBtn.highlighted=YES;
         float xx = self.topScroller.contentOffset.x;
         float wy = xx-self.topScroller.frame.size.width;
         if(wy<0){
             wy = 0;
             x.highlighted=NO;
         }
         CGPoint position = CGPointMake(wy,0);
         [self.topScroller setContentOffset:position animated:YES];

    }];
}

-(void)setuptopRightBtn{
    [self.topRightBtn setImage:[UIImage imageNamed:@"appoint_btn_rightTop1"] forState:UIControlStateNormal];
    [self.topRightBtn setImage:[UIImage imageNamed:@"appoint_btn_rightTop"] forState:UIControlStateSelected];
    [self.topRightBtn setImage:[UIImage imageNamed:@"appoint_btn_rightTop"] forState:UIControlStateHighlighted];
    self.topRightBtn.highlighted=YES;

    [[self.topRightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         x.highlighted=YES;
         self.topLeftBtn.highlighted=YES;
         float xx = self.topScroller.contentOffset.x;
        // NSLog(@"xx %f",xx);
         float wy = xx+self.topScroller.frame.size.width;
         
         if(wy>self.topScroller.contentSize.width-self.topScroller.frame.size.width){
             wy = self.topScroller.contentSize.width-self.topScroller.frame.size.width;
             x.highlighted=NO;
         }

         CGPoint position = CGPointMake(wy, 0);
         [self.topScroller setContentOffset:position animated:YES];

     }];
}


-(void)setupMidScroller{
    
    if (freeTimes.count>6) {
        int f = (int)freeTimes.count/6;
        _midScroller.contentSize = CGSizeMake(_midScroller.frame.size.width*f ,
                                              _midScroller.frame.size.height);
        [[self.midRightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {
             int b =(int)self.midScroller.contentOffset.x/self.midScroller.frame.size.width;
             if (b<f-1) {
                 CGPoint point = CGPointMake(self.midScroller.frame.size.width*++b, self.midScroller.frame.size.height);
                 [self.midScroller setContentOffset:point animated:YES];
             }
        }];
        
        [[self.midRightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {
             int b =(int)self.midScroller.contentOffset.x/self.midScroller.frame.size.width;
             if (b>0) {
                 CGPoint point = CGPointMake(self.midScroller.frame.size.width*--b, self.midScroller.frame.size.height);
                 [self.midScroller setContentOffset:point animated:YES];
             }
         }];

    }
    
    [midBtns removeAllObjects];
    
    juw = 0;
    juh = 0;
    
    float ww =self.midScroller.frame.size.width/3;
    float btnW = KMainScreenWidth*50/320;
    float jj = (ww-btnW)/2;
    NSLog(@"%f",jj);
    for (int i = 0; i<freeTimes.count; i++) {
        NSDictionary* dic = freeTimes[i];
        float zuo  = ww*juw+jj+(i/6*self.midScroller.frame.size.width);
        if (i%3==0)
            zuo = jj;
        
        float xia =0;
        if (juh==1) {
            xia = btnW+jj;
        }
        UIButton* but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame=CGRectMake(zuo, xia, btnW, btnW);
        if(i == 0)
            self.selectTime =[dic valueForKey:@"time"];
        [but setTitle:[dic valueForKey:@"time"] forState:UIControlStateNormal];
        but.tag = 10+i;
        but.layer.masksToBounds=YES;
        but.layer.cornerRadius = 25;
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
