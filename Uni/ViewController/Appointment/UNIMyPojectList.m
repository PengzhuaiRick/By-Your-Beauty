//
//  UNIMyPojectList.m
//  Uni
//  添加项目列表
//  Created by apple on 15/11/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIMyPojectList.h"
#import "UNIMyAppointCell.h"
#import "MainViewRequest.h"
@interface UNIMyPojectList ()<UITableViewDataSource,UITableViewDelegate>

@end


@implementation UNIMyPojectList

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupTableView];
    [self startRequestInfo];
}
-(void)setupData{
    self.title = @"我的项目";
    _myData = [NSMutableArray array];
     self.view.backgroundColor = [UIColor colorWithHexString:@"e4e5e9"];
}
-(void)setupTableView{
    _myTableview = [[UITableView alloc]initWithFrame: CGRectMake(8, 64+8, KMainScreenWidth-16, KMainScreenHeight-64-16)
                                               style:UITableViewStylePlain];
    _myTableview.layer.masksToBounds = YES;
    _myTableview.layer.cornerRadius = 5;
    _myTableview.delegate =self;
    _myTableview.dataSource = self;
    
    [self.view addSubview:_myTableview];
    
    _myTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _myTableview.frame.size.width, 30)];
    
    NSString* btnT = @"项目根据美容院预约安排,如果您的项目不能连续预约,请选择其他时间进行预约";
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor clearColor]];
    btn.frame = CGRectMake(8, KMainScreenHeight-30, _myTableview.frame.size.width, 30);
    [btn setImage:[UIImage imageNamed:@"appoint_btn_xunwen"] forState:UIControlStateNormal];
    [btn setTitle:btnT forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:8];
    btn.titleLabel.numberOfLines = 0;
    btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:btn];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* name = @"cell";
    UNIMyAppointCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell =[[NSBundle mainBundle]loadNibNamed:@"UNIMyAppointCell" owner:self options:nil].lastObject;
    }
    cell.mainImg.image = [UIImage imageNamed:@"main_img_cell1"];
    //  cell.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    cell.mainLab.text = @"WODASD";
    cell.mainLab.textColor = [UIColor colorWithHexString:@"ee4b7c"];
    cell.mainLab.font = [UIFont boldSystemFontOfSize:13];
    
    cell.subLab.text = @"NANANA";
    cell.subLab.textColor = [UIColor colorWithHexString:@"c2c1c0"];
    cell.subLab.font = [UIFont boldSystemFontOfSize:13];

    cell.functionBtn.tag = indexPath.row+10;
    [[cell.functionBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(UIButton* x) {
//        id model = self.myData[x.tag-10];
//        [self.delegate UNIMyPojectListDelegateMethod:model];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark 开始请求我未预约项目
-(void)startRequestInfo{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        MainViewRequest* request1 = [[MainViewRequest alloc]init];
        [request1 postWithSerCode:@[API_PARAM_UNI,API_URL_MyProjectInfo]
                           params:@{@"userId":@(1),
                                    @"token":@"abcdxxa",
                                    @"shopId":@(1),
                                    @"page":@(0),@"size":@(20)}];
        request1.remyProjectBlock =^(NSArray* myProjectArr,NSString* tips,NSError* err){
            dispatch_async(dispatch_get_main_queue(), ^{
//                self.tableView.footer.hidden = YES;
//                [self.tableView.header endRefreshing];
//                [self.tableView.footer endRefreshing];
                if (err==nil) {
                    if (myProjectArr.count>0){
//                        if (self->pageNum == 0)//下拉刷新
//                            [self.myData removeAllObjects];
//                        
                       [self.myData addObjectsFromArray:myProjectArr];
                        [self.myTableview reloadData];
                    }
                    else
                        [YIToast showText:tips];
                }else
                    [YIToast showText:tips];
            });
        };
        
        
    });
}

-(void)modificationUI{
    
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
