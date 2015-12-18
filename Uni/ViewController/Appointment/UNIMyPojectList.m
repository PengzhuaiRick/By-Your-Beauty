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
#import <MJRefresh/MJRefresh.h>
#define CELLH KMainScreenWidth*60/320
#define MAXTABLEH KMainScreenHeight-64-30-24  //tableview最大高度
@interface UNIMyPojectList ()<UITableViewDataSource,UITableViewDelegate>{
    UIButton* needKnowBtn;//需知按钮
    CGRect tableRect;//
    CGRect btnRect;
    int pageNum;
    int pageSize;
}
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
    pageNum = 0;
    pageSize = 20;
    _myData = [NSMutableArray array];
     self.view.backgroundColor = [UIColor colorWithHexString:@"e4e5e9"];
}
-(void)setupTableView{
   
        tableRect =CGRectMake(8, 64+8, KMainScreenWidth-16,MAXTABLEH);
    _myTableview = [[UITableView alloc]initWithFrame:tableRect
                                               style:UITableViewStylePlain];
    _myTableview.layer.masksToBounds = YES;
    _myTableview.layer.cornerRadius = 5;
    _myTableview.delegate =self;
    _myTableview.dataSource = self;
    
    if (IOS_VERSION<9.0)
        _myTableview.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    if (IOS_VERSION>9.0)
        _myTableview.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    [self.view addSubview:_myTableview];
    
    self.myTableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->pageNum =0;
        self->pageSize =(int)self.myData.count;
        [self startRequestInfo];
    }];
    self.myTableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            ++self->pageNum;
            self->pageSize =(int)self.myData.count+20;
            [self startRequestInfo];
        }];

    
    _myTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _myTableview.frame.size.width, 30)];
    
    NSString* btnT = @"项目根据美容院预约安排,如果您的项目不能连续预约,请选择其他时间进行预约";
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor clearColor]];
    btnRect =  CGRectMake(8, KMainScreenHeight-38, _myTableview.frame.size.width, 30);
    btn.frame =btnRect;
    [btn setImage:[UIImage imageNamed:@"appoint_btn_xunwen"] forState:UIControlStateNormal];
    [btn setTitle:btnT forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*9/320];
    btn.titleLabel.numberOfLines = 0;
    btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:btn];
    needKnowBtn = btn;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELLH;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* name = @"cell";
    UNIMyAppointCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell =[[NSBundle mainBundle]loadNibNamed:@"UNIMyAppointCell" owner:self options:nil].lastObject;
        cell.mainLab.textColor = [UIColor colorWithHexString:@"ee4b7c"];
        cell.mainLab.font = [UIFont boldSystemFontOfSize:13];
        
        cell.subLab.textColor = [UIColor colorWithHexString:@"c2c1c0"];
        cell.subLab.font = [UIFont boldSystemFontOfSize:13];

    }
    UNIMyProjectModel* model = _myData[indexPath.row];
    cell.mainImg.image = [UIImage imageNamed:@"main_img_cell1"];
    //  cell.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    cell.mainLab.text =model.projectName;
    
    
    cell.subLab.text = [NSString stringWithFormat:@"服务时长%d分钟",model.costTime];
    
    cell.functionBtn.tag = indexPath.row+10;
    [[cell.functionBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(UIButton* x) {
        id model = self.myData[x.tag-10];
        [self.delegate UNIMyPojectListDelegateMethod:model];
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
                                    @"page":@(self->pageNum),@"size":@(20)}];
        request1.remyProjectBlock =^(NSArray* myProjectArr,NSString* tips,NSError* err){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.myTableview.header endRefreshing];
                [self.myTableview.footer endRefreshing];
                if (err==nil) {
                    if (myProjectArr.count>0){
                        if (myProjectArr.count<20)
                            self.myTableview.footer.hidden = YES;
                        else
                             self.myTableview.footer.hidden = NO;
                        if (self->pageNum == 0)//下拉刷新
                            [self.myData removeAllObjects];
                        
                       [self.myData addObjectsFromArray:myProjectArr];
                        [self modificationUI];
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
    float h = _myData.count*CELLH;
    float th = 0;
    if(h>MAXTABLEH)
        th = MAXTABLEH;
    else
        th = h;
    tableRect.size.height = th;
    self.myTableview.frame =tableRect;
    [self.myTableview reloadData];
    
    needKnowBtn.frame =
    CGRectMake(btnRect.origin.x, CGRectGetMaxY(_myTableview.frame), btnRect.size.width, btnRect.size.height);
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
