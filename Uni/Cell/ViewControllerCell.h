//
//  ViewControllerCell.h
//  Uni
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImg;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@end
