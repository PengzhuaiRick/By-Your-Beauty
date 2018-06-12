//
//  UNIImageAndTextController.h
//  Uni
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseViewController.h"
@interface UNIImageAndTextController : baseViewController

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property(copy,nonatomic)NSString* projectId;
@end
