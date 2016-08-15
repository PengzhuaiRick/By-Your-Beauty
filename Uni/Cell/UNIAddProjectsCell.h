//
//  UNIAddProjectsCell.h
//  Uni
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNIMyProjectModel.h"
@interface UNIAddProjectsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UILabel *mainLab;
@property (weak, nonatomic) IBOutlet UILabel *subLab;
@property (weak, nonatomic) IBOutlet UIImageView *handleImag;

-(void)setupCellWithData:(id)model;
@end
