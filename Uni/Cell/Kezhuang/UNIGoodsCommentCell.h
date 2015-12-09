//
//  UNIGoodsCommentCell.h
//  Uni
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIGoodsCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImg;
@property (weak, nonatomic) IBOutlet UILabel *label1; //名字
@property (weak, nonatomic) IBOutlet UILabel *label2; //日期
@property (weak, nonatomic) IBOutlet UILabel *label3; //评论内容
@property (weak, nonatomic) IBOutlet UIImageView *xing1;
@property (weak, nonatomic) IBOutlet UIImageView *xing2;
@property (weak, nonatomic) IBOutlet UIImageView *xing3;
@property (weak, nonatomic) IBOutlet UIImageView *xing4;
@property (weak, nonatomic) IBOutlet UIImageView *xing5;

-(void)setupCellContentWith:(id)model;
@end
