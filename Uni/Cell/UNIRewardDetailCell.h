//
//  UNIRewardDetailCell.h
//  Uni
//
//  Created by apple on 16/1/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNIMyRewardModel.h"
#import "UNIRewardProgessView.h"
@interface UNIRewardDetailCell : UITableViewCell
@property (strong, nonatomic)  UILabel *mainLab;
@property (strong, nonatomic)  UILabel *subLab;
@property (strong, nonatomic)  UILabel *stateLab;
@property (strong, nonatomic)UNIRewardProgessView* progessView;
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier andTpye:(int)tp;

-(void)setupCellContent:(id)model andType:(int)type andTotal:(int)total;
@end
