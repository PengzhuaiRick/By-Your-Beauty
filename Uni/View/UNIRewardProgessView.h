//
//  UNIRewardProgessView.h
//  Uni
//
//  Created by apple on 16/1/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIRewardProgessView : UIView
@property(nonatomic,assign)int num;
@property(nonatomic,assign)int total;
-(void)setNum:(int)num andTotal:(int)total;
@end
