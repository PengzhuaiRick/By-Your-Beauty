//
//  MainMidCell.h
//  Uni
//
//  Created by apple on 15/11/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNIBaseCell.h"
#import "UNIMyAppintModel.h"
#import "UNIMyProjectModel.h"
//#import "UNIMyRewardModel.h"
#define CELLW self.superview.frame.size.width
#define CELLH KMainScreenWidth*70/375
@interface MainMidCell : UNIBaseCell
@property (strong, nonatomic)  UIImageView *mainImage;
@property (strong, nonatomic)  UILabel *mainLab;
@property (strong, nonatomic)  UILabel *subLab;
@property (strong, nonatomic)  UILabel *stateLab;

-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier;

-(void)setupCellContent:(id)model andType:(int)type;

//-(void)setAppointCell:(id)model and:(int)num and:(int)type;
@end
