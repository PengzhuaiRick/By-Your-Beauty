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
    topScrollerNum = 0;
    [self setupTopScrollerContent];
    [self setuptopLeftBtn];
    [self setuptopRightBtn];
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
        
        self.selectDay =[NSString stringWithFormat:@"%d-%d",month,day];
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnW*i, 0, btnW, btnH);
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"e23469"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithHexString:@"e23469"] forState:UIControlStateHighlighted];
        if (i==1)
            btn.selected = YES;
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
        }];
    }
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
         NSLog(@"xx %f",xx);
         float wy = xx+self.topScroller.frame.size.width;
         
         if(wy>self.topScroller.contentSize.width-self.topScroller.frame.size.width){
             wy = self.topScroller.contentSize.width-self.topScroller.frame.size.width;
             x.highlighted=NO;
         }

         CGPoint position = CGPointMake(wy, 0);
         [self.topScroller setContentOffset:position animated:YES];

     }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
