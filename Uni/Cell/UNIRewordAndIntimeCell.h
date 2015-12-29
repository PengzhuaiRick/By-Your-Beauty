//
//  UNIRewordAndIntimeCell.h
//  Uni
//
//  Created by apple on 15/12/29.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyRewardView.h"
@interface UNIRewordAndIntimeCell : UITableViewCell
@property(nonatomic,strong)MyRewardView* RewordAndIntimeView;

-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier andNum:(int)num andType:(int)ty;

-(void)setupCell:(NSArray*)arr;
@end
