//
//  UNIOrderListCell.h
//  Uni
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNIOrderRequest.h"
@interface UNIOrderListCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *mainImg;
@property (strong, nonatomic)  UILabel *label1;
@property (strong, nonatomic)  UILabel *label2;
@property (strong, nonatomic)  UILabel *label3;
@property (strong, nonatomic)  UILabel *stateBtn;

-(void)setupCellContentWith:(id)model;
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier;
@end
