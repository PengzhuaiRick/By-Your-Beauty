//
//  UNIAppointDetailCell.h
//  Uni
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIAppointDetailCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *mainImage;
@property (strong, nonatomic)  UIImageView *intimeImg;
@property (strong, nonatomic)  UILabel *mainLab;
@property (strong, nonatomic)  UILabel *subLab;
@property (strong, nonatomic)  UILabel *stateLab;
@property (strong, nonatomic)  UILabel *timeLab;

-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setupCellContentWith:(id)model;

@end
