//
//  UNIShopListCell.h
//  Uni
//
//  Created by apple on 16/2/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNIBaseCell.h"
#import "UNIShopModel.h"
@interface UNIShopListCell : UNIBaseCell
@property (strong, nonatomic)  UIImageView *mainImage;
@property (strong, nonatomic)  UILabel *mainLab;
@property (strong, nonatomic)  UILabel *subLab;

-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setupCellContent:(id)model;
@end
