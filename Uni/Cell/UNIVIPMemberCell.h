//
//  UNIVIPMemberCell.h
//  Uni
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIVIPMemberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UILabel *mainLab;
@property (weak, nonatomic) IBOutlet UILabel *subLab;
@property (weak, nonatomic) IBOutlet UIButton *handleBtn;
@property (weak, nonatomic) IBOutlet UIImageView *handleImg;
@end
