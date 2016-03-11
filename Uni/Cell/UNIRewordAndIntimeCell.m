//
//  UNIRewordAndIntimeCell.m
//  Uni
//
//  Created by apple on 15/12/29.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIRewordAndIntimeCell.h"

@implementation UNIRewordAndIntimeCell

-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier andNum:(int)num andType:(int)ty{
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI:cellSize andNum:num andType:ty];
    }
    return self;
}

-(void)setupUI:(CGSize)size andNum:(int)num andType:(int)ty{
    float tabY =KMainScreenWidth*10/320;
    MyRewardView * view = [[MyRewardView alloc]initWithFrame:CGRectMake(16, tabY, size.width - 32, size.height-tabY) andNum:num andType:ty];
    [self addSubview:view];
    self.RewordAndIntimeView = view;
    view=nil;

}
-(void)setupCell:(NSArray*)arr{
    [self.RewordAndIntimeView startReflashTableView:arr];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
