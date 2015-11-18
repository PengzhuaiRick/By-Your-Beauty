//
//  MainMidCell.h
//  Uni
//
//  Created by apple on 15/11/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNIMyAppintModel.h"
#import "UNIMyProjectModel.h"
#define CELLW self.superview.frame.size.width
#define CELLH KMainScreenWidth*70/375
@interface MainMidCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UILabel *mainLab;
@property (weak, nonatomic) IBOutlet UILabel *subLab;
@property (weak, nonatomic) IBOutlet UIButton *handleBtn;

-(void)setupCellContent:(id)model andType:(int)type;
@end
