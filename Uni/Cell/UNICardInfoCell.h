//
//  UNICardInfoCell.h
//  Uni
//
//  Created by apple on 15/12/3.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNIBaseCell.h"
@interface UNICardInfoCell : UNIBaseCell
@property (strong, nonatomic)  UIImageView *mainImage;
@property (strong, nonatomic)  UILabel *mainLab;
@property (strong, nonatomic)  UILabel *subLab;
@property (strong, nonatomic)  UILabel *stateLab;
@property (strong, nonatomic)  UIImageView *img2;//奖励标志
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier;


-(void)setupCellContentWith:(id)model;
@end
