//
//  UNIMyAppointCell.h
//  Uni
//
//  Created by apple on 15/11/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <SWTableViewCell.h>

@interface UNIAddMyAppointCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *mainImg;
@property (strong, nonatomic)  UILabel *mainLab;
@property (strong, nonatomic)  UILabel *subLab;


//-(void)setupCellWithData:(NSArray*)data type:(int)type andTotal:(int)total;
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier;

@end
