//
//  UNIWalletCell.h
//  Uni
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIWalletCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIImageView *mainImag;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;

-(void)setupCellContentWith:(id)model;
@end
