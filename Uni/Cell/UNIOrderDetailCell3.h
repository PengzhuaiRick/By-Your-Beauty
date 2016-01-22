//
//  UNIOrderDetailCell3.h
//  Uni
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIOrderDetailCell3 : UITableViewCell
@property (strong, nonatomic)  UILabel *lab1;
@property (strong, nonatomic)  UILabel *lab2;
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setupCellContent:(id)model;
@end
