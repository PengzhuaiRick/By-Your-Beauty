//
//  MainMidView.h
//  Uni
//
//  Created by apple on 15/11/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMidView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView* midTableview;


-(id)initWithFrame:(CGRect)frame headerTitle:(NSString*)string;
@end
