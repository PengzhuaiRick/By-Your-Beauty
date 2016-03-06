//
//  UNIAddAndDelectCell.h
//  Uni
//
//  Created by apple on 16/3/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIAddAndDelectCell : UITableViewCell
@property(nonatomic,strong)UIView* moveView;
@property(nonatomic,strong)UIButton* delectBtn;
@property (strong, nonatomic)  UIImageView *mainImg;
@property (strong, nonatomic)  UILabel *mainLab;
@property (strong, nonatomic)  UILabel *subLab;

-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier;

-(void)setupCellContent:(id)model;
@end
