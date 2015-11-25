//
//  UNIAppontMid.h
//  Uni
//
//  Created by apple on 15/11/25.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIAppontMid : UIView<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *topLab;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;


-(void)setupUI;
@end
