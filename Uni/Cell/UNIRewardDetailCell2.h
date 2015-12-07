//
//  UNIRewardDetailCell2.h
//  Uni
//
//  Created by apple on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIRewardDetailCell2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImg;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3; //￥188
@property (weak, nonatomic) IBOutlet UILabel *label4; //已返
@property (weak, nonatomic) IBOutlet UILabel *label5; //￥25
@property (weak, nonatomic) IBOutlet UILabel *label6; //x1


-(void)setupCellContentWith:(id)model;
@end
