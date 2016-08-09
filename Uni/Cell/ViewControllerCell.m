//
//  ViewControllerCell.m
//  Uni
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewControllerCell.h"

@implementation ViewControllerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleName.font =kWTFont(16);
    _numLab.font = kWTFont(13);
    _numLab.layer.masksToBounds = YES;
    _numLab.layer.cornerRadius = _numLab.frame.size.height/2;
}

@end
