//
//  ViewControllerCell.h
//  Uni
//
//  Created by apple on 15/12/24.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerCell : UITableViewCell{
    float cellHight;
}
@property (strong, nonatomic)  UIImageView *mainImg;
@property (strong, nonatomic)  UILabel *mainLab;
@property (strong, nonatomic)  UILabel *numLab;

-(id)initWithCellH:(float)cellH reuseIdentifier:(NSString *)reuseIdentifier;

@end
