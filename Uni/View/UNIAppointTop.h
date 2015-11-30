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
@interface UNIAppointTop : UIView<UIScrollViewDelegate>{
    int topScrollerNum;
    NSArray* freeTimes;
    int juw;//记录行数
    int juh;//记录列数
    NSMutableArray* midBtns;//中间预约时间按钮组
}
@property (assign, nonatomic) int member;//人数
@property (strong ,nonatomic) UNIMyProjectModel* model;
@property (assign ,nonatomic) int selectYear;   //年份
@property (copy, nonatomic) NSString* selectDay; //选择的日期
@property (copy, nonatomic) NSString* selectTime; //选择的时间段
@property (assign ,nonatomic)int maxNum; //最大人数

@property (strong, nonatomic)NSMutableArray* topBtns;
@property (weak, nonatomic) IBOutlet UIButton *topLeftBtn;
@property (weak, nonatomic) IBOutlet UIButton *topRightBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *topScroller;
@property (weak, nonatomic) IBOutlet UIButton *midLeftBtn;
@property (weak, nonatomic) IBOutlet UIButton *midRightBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *midScroller;



-(void)setupUI:(CGRect)frace;
@end
