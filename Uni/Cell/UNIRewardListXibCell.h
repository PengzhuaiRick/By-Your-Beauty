//
//  UNIRewardListXibCell.h
//  Uni
//
//  Created by apple on 16/8/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIRewardListXibCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImg;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIImageView *stateImg;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;

-(void)setupCellContentWith:(id)model;
@end
