//
//  UNIShopCarCell.h
//  Uni
//
//  Created by apple on 16/8/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIShopCarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *mainimg;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIView *numView;
@property (weak, nonatomic) IBOutlet UIButton *cutBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITextField *numField;
@property (weak, nonatomic) IBOutlet UIButton *delectBtn;

@end
