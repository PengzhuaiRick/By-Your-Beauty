//
//  UNIGoodsCell1.h
//  Uni
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNIBaseCell.h"
@interface UNIGoodsCell1 : UNIBaseCell<UIScrollViewDelegate>
@property (strong, nonatomic)  UIScrollView *mainImage;
@property (strong, nonatomic)  UILabel *label1;
@property (strong, nonatomic)  UILabel *label2;
@property (strong, nonatomic)  UILabel *label3;
@property (strong, nonatomic)  UIButton *prideBtn;


-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setupCellContentWith:(id)model;
@end
