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
@class UNIMyProjectModel;
@interface UNIAppointTop : UIView<UIScrollViewDelegate,KeyboardToolDelegate>{
    int selectBtnNum;
    int topScrollerNum;
    NSArray* freeTimes;
    NSMutableArray* midBtns;//中间预约时间按钮组
    UIImageView* arrowImg;
    float midBtnH;
    BOOL midNight; //如果当前时间在下班时间到上班时间之间 需要添加两天时间
    UILabel* noDate;
    
    NSArray* projectArr;
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
//@property (assign ,nonatomic) int projectId;
//@property (assign ,nonatomic) int costTime;
@property (copy ,nonatomic) NSString* projBeginDate;
@property (assign ,nonatomic) int shopId;

@property(strong,nonatomic)NSDate* finalTime;//最后可以选择的时间
@property(strong,nonatomic)NSDate* startTime;//预约服务的时间
@property(copy,nonatomic)NSString* lockupTime;//店铺下班时间
@property(copy,nonatomic)NSString* workupTime;//店铺上班时间
//-(id)initWithFrame:(CGRect)frame andProjectId:(int)proectId andCostime:(int)Cos andShopId:(int)shopIp;
-(id)initWithFrame:(CGRect)frame andModel:(UNIMyProjectModel*)mod andShopId:(int)shopIp;
-(void)beforeRequest;

#pragma mark 改变shopid 重新请求数据
-(void)changeShopId:(int)shopid;

#pragma mark 改变projects 重新请求数据
-(void)changeProjectIds:(NSArray*)projects;
@end
