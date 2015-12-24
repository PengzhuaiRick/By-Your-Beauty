//
//  MainViewCell.h
//  Uni
//
//  Created by apple on 15/12/24.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMidView.h"
@interface MainViewCell : UITableViewCell
@property(nonatomic,strong)MainMidView* mainView;

-(void)setupCellWithData:(NSArray*)data type:(int)type;
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier;
@end
