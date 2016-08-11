//
//  UNIAppointCell.m
//  Uni
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIAppointCell.h"
#import "UNIMyProjectModel.h"
@implementation UNIAppointCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _mainLab.font = kWTFont(15);
    _subLab.font = kWTFont(14);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setupCellContent:(id)model1{
    UNIMyProjectModel* model = model1;
    NSString* imgUrl = model.logoUrl;
    NSArray* arr = [model.logoUrl componentsSeparatedByString:@","];
    if (arr.count>0)
        imgUrl = arr[0];
    
    // NSString* str = [NSString stringWithFormat:@"%@%@",API_IMG_URL,imgUrl];
    [self.mainImg sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                    placeholderImage:[UIImage imageNamed:@"main_img_cellbg"]];
    
    self.mainLab.text = model.projectName;
    self.subLab.text = [NSString stringWithFormat:@"服务时长%d分钟",model.costTime];

}
@end
