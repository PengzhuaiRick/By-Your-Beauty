//
//  UNIOrderDetailCell2.h
//  Uni
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNIBaseCell.h"
@interface UNIOrderDetailCell2 : UNIBaseCell
@property (strong, nonatomic)  UILabel *lab1;
@property (strong, nonatomic)  UILabel *lab2;
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setupCellContent:(id)model;
@end
