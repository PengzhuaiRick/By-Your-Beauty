//
//  UNIMyAppointCell.h
//  Uni
//
//  Created by apple on 15/11/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>

@interface UNIAddMyAppointCell : SWTableViewCell
@property (weak, nonatomic)  UIImageView *mainImg;
@property (weak, nonatomic)  UILabel *mainLab;
@property (weak, nonatomic)  UILabel *subLab;


//-(void)setupCellWithData:(NSArray*)data type:(int)type andTotal:(int)total;
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier;

@end
