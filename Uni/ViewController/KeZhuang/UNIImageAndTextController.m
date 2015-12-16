//
//  UNIImageAndTextController.m
//  Uni
//  客妆 商品图文详情
//  Created by apple on 15/12/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIImageAndTextController.h"

@interface UNIImageAndTextController ()

@end

@implementation UNIImageAndTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图文详情";
    NSString* urlString = [NSString stringWithFormat:@"%@/shopadmin/Public/Home/Detail/goods?id=%d",API_URL,self.projectId];
    NSLog(@"urlString %@",urlString);
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [_myWebView loadRequest:request];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
