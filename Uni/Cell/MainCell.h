//
//  MainCell.h
//  Uni
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UILabel *mainLab;
@property (weak, nonatomic) IBOutlet UILabel *subLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIButton *handleBtn;
@property (weak, nonatomic) IBOutlet UIImageView *handleImg;

#pragma mark 设置 第一次个Cell 预约详情
-(void)setupFirstCell:(id)data andTotal:(int)total;

#pragma mark 设置 预约项目的cell
-(void)setupOtherCell:(id)data;

#pragma mark 最后一个cell  自定义预约内容
-(void)setupCustomCell;
@end
