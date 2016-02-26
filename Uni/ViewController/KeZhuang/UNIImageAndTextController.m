//
//  UNIImageAndTextController.m
//  Uni
//  客妆 商品图文详情
//  Created by apple on 15/12/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIImageAndTextController.h"

@interface UNIImageAndTextController ()<UIScrollViewDelegate>

@end

@implementation UNIImageAndTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图文详情";
    NSString* urlString =[NSString stringWithFormat:@"%@/%@",API_IMG_URL,_projectId];;
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    _myWebView.scrollView.delegate = self;
    [_myWebView loadRequest:request];
   
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(leftBarButtonEvent:)];
}

-(void)leftBarButtonEvent:(UIBarButtonItem*)item{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y>60) {
        
    }
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
