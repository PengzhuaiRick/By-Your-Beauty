//
//  UNIMyPojectList.h
//  Uni
//
//  Created by apple on 15/11/26.
//  Copyright © 2015年 apple. All rights reserved.
//

@protocol UNIMyPojectListDelegate <NSObject>

-(void)UNIMyPojectListDelegateMethod:(id)model;
@end

#import <UIKit/UIKit.h>

@interface UNIMyPojectList : UIViewController
@property (assign,nonatomic)id<UNIMyPojectListDelegate> delegate;
@property (strong, nonatomic) NSMutableArray* myData;
@property (strong, nonatomic) UITableView *myTableview;


@end
