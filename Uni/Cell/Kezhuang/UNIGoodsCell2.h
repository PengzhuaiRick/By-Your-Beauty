//
//  UNIGoodsCell2.h
//  Uni
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIGoodsCell2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label1; //
@property (weak, nonatomic) IBOutlet UILabel *label2; //
@property (weak, nonatomic) IBOutlet UILabel *label3; //
@property (weak, nonatomic) IBOutlet UILabel *label4; //
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UILabel *title3;
@property (weak, nonatomic) IBOutlet UILabel *title4;

-(void)setupCellContentWith:(id)model;
@end
