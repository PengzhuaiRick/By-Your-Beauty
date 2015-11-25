//
//  UNIBaseModel.h
//  Uni
//
//  Created by apple on 15/11/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface UNIBaseModel : NSObject

@property(nonatomic,strong)FMDatabase* db;

#pragma mark 创建表
-(void)creatTheDataBaseTable:(NSString*)path;

#pragma mark 插入数据
-(void)insertNewData:(id)model;

#pragma mark 删除数据
-(void)delectOldData:(id)model;

#pragma mark 修改数据
-(void)modiicateData:(id)model;

#pragma mark 查询数据
-(id)queryData:(id)model;


#pragma mark 创建数据库路径
-(NSString* )creatDataBasePath:(NSString*)path;

- (id)safeObject:(NSDictionary*)dic ForKey:(id)aKey;
@end
