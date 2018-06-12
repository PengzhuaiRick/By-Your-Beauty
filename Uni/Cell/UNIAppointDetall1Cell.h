//
//  UNIAppointDetall1Cell.h
//  Uni
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNIBaseCell.h"
@interface UNIAppointDetall1Cell : UNIBaseCell
@property (strong, nonatomic) UILabel *label1;
@property (strong, nonatomic) UILabel *label2;
@property (strong, nonatomic) UILabel *label3;

-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setupCellContentWith:(NSArray*)model;
@end
