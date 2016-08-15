//
//  UNIAddProjectsCell.m
//  Uni
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIAddProjectsCell.h"

@implementation UNIAddProjectsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _mainLab.font = kWTFont(14);
    _subLab.font = kWTFont(14);
}
-(void)setupCellWithData:(id)model{
    UNIMyProjectModel* info = model;
    NSString* imgUrl = info.logoUrl;
    NSArray* arr = [info.logoUrl componentsSeparatedByString:@","];
    if (arr.count>0)
        imgUrl = arr[0];
    //  NSString* str = [NSString stringWithFormat:@"%@%@",API_IMG_URL,imgUrl];
    [self.mainImage sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                      placeholderImage:[UIImage imageNamed:@"main_img_cellbg"]];
    self.mainLab.text = info.projectName;
    self.subLab .text = [NSString stringWithFormat:@"剩余%d次",info.num];
   

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
