//
//  UNIRewardListCell.h
//  Uni
//
//  Created by apple on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNIBaseCell.h"
@interface UNIRewardListCell : UNIBaseCell
@property (strong, nonatomic)  UIImageView *mainImg;
@property (strong, nonatomic)  UILabel *label1;
@property (strong, nonatomic)  UILabel *label2;
@property (strong, nonatomic)  UILabel *label3;
@property (strong, nonatomic)  UIButton *stateBtn;

-(void)setupCellContentWith:(id)model;
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier;
@end
