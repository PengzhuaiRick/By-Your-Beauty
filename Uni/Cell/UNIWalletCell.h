//
//  UNIWalletCell.h
//  Uni
//
//  Created by apple on 16/1/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNIBaseCell.h"
@interface UNIWalletCell : UNIBaseCell
@property (strong, nonatomic) UIImageView* mainImg;
@property (strong, nonatomic) UIImageView* overDusImg;//过期
@property (strong, nonatomic)  UILabel *lab1;
@property (strong, nonatomic)  UILabel *lab2;
@property (strong, nonatomic)  UILabel *lab3;
@property (strong, nonatomic)  UILabel *lab4;
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setupCellContent:(id)model;
@end
