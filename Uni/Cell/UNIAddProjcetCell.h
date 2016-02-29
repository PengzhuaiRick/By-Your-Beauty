//
//  UNIAddProjcetCell.h
//  Uni
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNIBaseCell.h"
#import "UNIMyProjectModel.h"
@interface UNIAddProjcetCell : UNIBaseCell
@property (strong, nonatomic)  UIImageView *mainImage;
@property (strong, nonatomic)  UILabel *mainLab;
@property (strong, nonatomic)  UILabel *subLab;
@property (strong, nonatomic)  UIButton *handleBtn;
@property (strong, nonatomic)  UIImageView *handleImag;

-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier;

-(void)setupCellWithData:(id)model;
@end
