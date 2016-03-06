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
    int selectBtnNum;
    int topScrollerNum;
    NSArray* freeTimes;
    NSMutableArray* midBtns;//中间预约时间按钮组
    UIImageView* arrowImg;
    float midBtnH;
}
//@property (assign, nonatomic) int member;//人数
@property (assign ,nonatomic) int selectYear;   //年份
@property (copy, nonatomic) NSString* selectDay; //选择的日期
@property (copy, nonatomic) NSString* selectTime; //选择的时间段
//@property (assign ,nonatomic)int maxNum; //最大人数
@property (assign ,nonatomic)int numDay; //用来计算本地通知的触发时间
@property (strong, nonatomic) UITextField *nunField;

@property (strong, nonatomic)NSMutableArray* topBtns;
@property (strong, nonatomic)  UIScrollView *topScroller;
@property (strong, nonatomic)  UIButton *midLeftBtn;
@property (strong, nonatomic)  UIButton *midRightBtn;
@property (strong, nonatomic)  UIScrollView *midScroller;
@property (assign ,nonatomic) int projectId;
@property (assign ,nonatomic) int costTime;
@property (assign ,nonatomic) int shopId;

-(id)initWithFrame:(CGRect)frame andProjectId:(int)proectId andCostime:(int)Cos andShopId:(int)shopIp;

-(void)beforeRequest;

#pragma mark 改变shopid 重新请求数据
-(void)changeShopId:(int)shopid;
@end
