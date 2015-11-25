//
//  UNIAppointTop.h
//  Uni
//
//  Created by apple on 15/11/24.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIAppointTop : UIView{
    int topScrollerNum;
}
@property (copy, nonatomic) NSString* selectDay; //选择的日期
@property (strong, nonatomic)NSMutableArray* topBtns;
@property (weak, nonatomic) IBOutlet UIButton *topLeftBtn;
@property (weak, nonatomic) IBOutlet UIButton *topRightBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *topScroller;
@property (weak, nonatomic) IBOutlet UIButton *midLeftBtn;
@property (weak, nonatomic) IBOutlet UIButton *midRightBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *midScroller;

-(void)setupUI:(CGRect)frace;
@end
