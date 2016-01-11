//
//  MainViewCell.h
//  Uni
//
//  Created by apple on 15/12/24.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *mainImage;
@property (strong, nonatomic)  UILabel *mainLab;
@property (strong, nonatomic)  UILabel *subLab;
@property (strong, nonatomic)  UILabel *numLab;
@property (strong, nonatomic)  UIButton *handleBtn;

-(void)setupCellWithData:(NSArray*)data type:(int)type;
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier;
@end
