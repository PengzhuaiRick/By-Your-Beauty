//
//  MainViewCell.m
//  Uni
//
//  Created by apple on 15/12/24.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainViewCell.h"

@implementation MainViewCell

-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI:cellSize];
    }
    return self;
}
-(void)setupUI:(CGSize)size{
    MainMidView* view= [[MainMidView alloc]initWithFrame:CGRectMake(0, 8, size.width, size.height-8) headerTitle:nil];
    [self addSubview:view];
    self.mainView = view;
}
-(void)setupCellWithData:(NSArray*)data type:(int)type{
    [self.mainView startReloadData:data andType:type];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
