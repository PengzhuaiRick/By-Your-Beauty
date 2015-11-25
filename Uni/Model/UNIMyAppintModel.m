//
//  UNIMyAppintModel.m
//  Uni
//  我已预约的Model
//  Created by apple on 15/11/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIMyAppintModel.h"
#define TABLENAME @"myappint"
#define TABLENAMEPATH @"myappint.sqlite"
@implementation UNIMyAppintModel
-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        
        [self analyDic:dic];
        
    }
    return self;
}


-(void)creatTheDataBaseTable:(NSString *)path{
    self.db = [[FMDatabase alloc]initWithPath:path];
    if ([self.db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:
                                     @"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,myorder TEXT,projectName TEXT,logoUrl TEXT,time TEXT,createTime TEXT,costTime INTEGER,status INTEGER)",TABLENAME];
        BOOL res = [self.db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
           [self insertNewData:self];
        }
        
        [self.db close];
    }
}
-(void)analyDic:(NSDictionary*)dic{
    self.myorder = [self safeObject:dic ForKey:@"order"];
    self.projectName = [self safeObject:dic ForKey:@"projectName"];
    self.logoUrl = [self safeObject:dic ForKey:@"logoUrl"];
    self.time = [self safeObject:dic ForKey:@"time"];
    self.createTime = [self safeObject:dic ForKey:@"createTime"];
    self.costTime = [[self safeObject:dic ForKey:@"costTime"]intValue];
    self.status = [[self safeObject:dic ForKey:@"status"]intValue];
    //[self creatTheDataBaseTable:[self creatDataBasePath:TABLENAMEPATH]];
}

-(void)insertNewData:(id)model{
    if (![self.db open]){
        return;}
    //查询数据库是否存在这个数据
    FMResultSet* set = [self.db executeQuery:[NSString stringWithFormat:@"select * from %@ where myorder = '%@'",TABLENAME,self.myorder]];
    
    //如果不存在就加入数据
    if (![set next]) {
        NSString *insertSql= [NSString stringWithFormat:
                           @"INSERT INTO %@ (myorder,projectName,logoUrl,time,createTime,costTime ,status) VALUES ('%@', '%@', '%@', '%@', '%@', '%d', '%d')",
                           TABLENAME,self.myorder, self.projectName, self.logoUrl,self.time,self.createTime,self.costTime,self.status];
        NSLog(@"insertSql %@",insertSql);
        BOOL res = [self.db executeUpdate:insertSql];
        
        
        res?NSLog(@"插入成功"):NSLog(@"插入失败");
    }else{
        //存在就修改数据
        NSString*projectName = [set stringForColumn:@"projectName"];
        NSString*logoUrl = [set stringForColumn:@"logoUrl"];
        NSString*time = [set stringForColumn:@"time"];
        NSString*createTime = [set stringForColumn:@"createTime"];
        int costTime = [set intForColumn:@"costTime"];
        int status = [set intForColumn:@"status"];
        
        NSString *updateSql = [NSString stringWithFormat:
                               @"UPDATE %@ SET projectName = '%@',logoUrl = '%@',time = '%@',createTime = '%@',costTime = '%d', status = '%d' WHERE projectName = '%@' AND logoUrl = '%@' AND time = '%@' AND createTime = '%@' AND costTime = '%d' AND status = '%d'",
                               TABLENAME,  self.projectName,self.logoUrl,self.time,self.createTime,self.costTime,self.status, projectName,logoUrl,time,createTime,costTime,status];
        BOOL res = [self.db executeUpdate:updateSql];
        res?NSLog(@"插入成功111"):NSLog(@"插入失败111");
    }
}
@end
