//
//  UNIOrderDetailCell.h
//  Uni
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIOrderDetailCell1 : UITableViewCell
@property (strong, nonatomic) UIImageView* mainImg;
@property (strong, nonatomic)  UILabel *lab1;
@property (strong, nonatomic)  UILabel *lab2;
@property (strong, nonatomic)  UILabel *lab3;
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setupCellContent:(id)model;

@end
