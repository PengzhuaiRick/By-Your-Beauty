//
//  UNIPurchaseCell.h
//  Uni
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UNIPurchaseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImg;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UITextField *countField;
@property (weak, nonatomic) IBOutlet UIButton *jiabtn;
@property (weak, nonatomic) IBOutlet UIButton *jianbtn;

+(float)CellHight;
-(void)setupCellContentWith:(id)model;
@end
