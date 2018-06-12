//
//  UNAlertShowController.m
//  Uni
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNAlertShowController.h"

@interface UNAlertShowController ()

@end

@implementation UNAlertShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
-(void)setupUI{
    _alverView.layer.masksToBounds = YES;
    _alverView.layer.cornerRadius = 15;
    
    _cancleBtn.layer.masksToBounds=YES;
    _cancleBtn.layer.cornerRadius = _cancleBtn.frame.size.width/2;
    _cancleBtn.layer.borderColor = [UIColor colorWithHexString:kMainPinkColor].CGColor;
    _cancleBtn.layer.borderWidth = 1;
    
    _sureBtn.layer.masksToBounds=YES;
    _sureBtn.layer.cornerRadius = _sureBtn.frame.size.width/2;
    _sureBtn.layer.borderColor = [UIColor colorWithHexString:@"362745"].CGColor;
    _sureBtn.layer.borderWidth = 1;
    
    
}
- (IBAction)cancelBtn:(id)sender {
    [self selfDismiss:nil];
}
- (IBAction)sureBtn:(id)sender {
    [self selfDismiss:@selector(sendTheMessageToDelegate)];
   }
-(void)sendTheMessageToDelegate{
    if (self.delegateSignal) {
        [self.delegateSignal sendNext:nil];
    }

}

#pragma mark 让自己消失
-(void)selfDismiss:(SEL)action{
    __weak UNAlertShowController* myself = self;
    [UIView animateWithDuration:0.3 animations:^{
        myself.view.alpha = 0;
    } completion:^(BOOL finished) {
        [myself dismissViewControllerAnimated:NO completion:^{
            if (action)
                [myself performSelectorOnMainThread:action withObject:nil waitUntilDone:NO];
        }];
    }];
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
