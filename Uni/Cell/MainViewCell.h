//
//  MainViewCell.h
//  Uni
//
//  Created by apple on 15/12/24.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNIBaseCell.h"
@interface MainViewCell : UNIBaseCell{
    float cellH;
}
@property (strong, nonatomic)  UIImageView *mainImage;
@property (strong, nonatomic)  UILabel *mainLab;
@property (strong, nonatomic)  UILabel *subLab;
@property (strong, nonatomic)  UILabel *numLab;
@property (strong, nonatomic)  UIButton *handleBtn;

-(void)setupCellWithData:(id)data type:(int)type andTotal:(int)total;
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier;
@end
