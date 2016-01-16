//
//  UNIAppointTop.h
//  Uni
//
//  Created by apple on 15/11/24.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNIMyProjectModel.h"
#import "UNIMypointRequest.h"
#import "BTKeyboardTool.h"
@interface UNIAppointTop : UIView<UIScrollViewDelegate,KeyboardToolDelegate>{
    int topScrollerNum;
    NSArray* freeTimes;
    NSMutableArray* midBtns;//中间预约时间按钮组
    UIImageView* arrowImg;
}
@property (assign, nonatomic) int member;//人数
@property (strong ,nonatomic) UNIMyProjectModel* model;
@property (assign ,nonatomic) int selectYear;   //年份
@property (copy, nonatomic) NSString* selectDay; //选择的日期
@property (copy, nonatomic) NSString* selectTime; //选择的时间段
@property (assign ,nonatomic)int maxNum; //最大人数
@property (assign ,nonatomic)int numDay; //用来计算本地通知的触发时间
@property (strong, nonatomic) UITextField *nunField;

@property (strong, nonatomic)NSMutableArray* topBtns;
@property (strong, nonatomic)  UIScrollView *topScroller;
@property (strong, nonatomic)  UIButton *midLeftBtn;
@property (strong, nonatomic)  UIButton *midRightBtn;
@property (strong, nonatomic)  UIScrollView *midScroller;


-(id)initWithFrame:(CGRect)frame andModel:(UNIMyProjectModel*)model;
@end
