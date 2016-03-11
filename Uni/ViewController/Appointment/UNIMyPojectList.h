//
//  UNIMyPojectList.h
//  Uni
//  添加项目列表
//  Created by apple on 15/11/26.
//  Copyright © 2015年 apple. All rights reserved.
//

@protocol UNIMyPojectListDelegate <NSObject>

-(void)UNIMyPojectListDelegateMethod:(NSArray*)arr;
@end

#import <UIKit/UIKit.h>

@interface UNIMyPojectList : UIViewController
@property (assign,nonatomic)id<UNIMyPojectListDelegate> delegate;
@property (strong,nonatomic) NSArray* projectIdArr;
@property (strong, nonatomic) NSMutableArray* myData;
@property (strong, nonatomic) UITableView *myTableview;
@property (assign,nonatomic) int restTime;


@end
