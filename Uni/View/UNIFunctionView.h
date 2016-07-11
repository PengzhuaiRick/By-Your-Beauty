//
//  UNIFunctionView.h
//  Uni
//
//  Created by apple on 16/7/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIFunctionView : UIView<UITableViewDelegate,UITableViewDataSource>{
    NSArray* titleArray;
    NSArray* imgArray;
    NSArray* imgSArray;
    
}
@property (strong, nonatomic) UITableView *myTableView;
@end
