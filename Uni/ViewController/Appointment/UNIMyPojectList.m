//
//  UNIMyPojectList.m
//  Uni
//  添加项目列表
//  Created by apple on 15/11/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIMyPojectList.h"
#import "MainViewRequest.h"
#import <MJRefresh/MJRefresh.h>
#import "UNIHttpUrlManager.h"
#import "UNIAddProjectsCell.h"
#define CELLH KMainScreenWidth*85/414
#define MAXTABLEH KMainScreenHeight-74-60  //tableview最大高度
@interface UNIMyPojectList ()<UITableViewDataSource,UITableViewDelegate>{
    CGRect tableRect;//
    CGRect btnRect;
    int pageNum;
    int pageSize;
    
    int seletNum;
    UILabel* numLab;
    __weak IBOutlet UIButton *needKnowBtn;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableview;
@end


@implementation UNIMyPojectList
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"预约我的项目列表"];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"预约我的项目列表"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupTableView];
   // [self startRequestInfo];
    [self.myTableview.header beginRefreshing];
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(leftBarButtonEvent:)];
}

-(void)leftBarButtonEvent:(UIBarButtonItem*)item{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupData{
    self.title = @"我的项目";
    seletNum = 0;
    pageNum = 0;
    pageSize = 20;
    _myData = [NSMutableArray array];
     self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    
    float btnWH = KMainScreenWidth*20/320;
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, btnWH, btnWH)];
    lab.text=@"0";
    lab.font = [UIFont systemFontOfSize:KMainScreenWidth*11/320];
    lab.backgroundColor = [UIColor colorWithHexString:kMainPinkColor];
    lab.layer.masksToBounds=YES;
    lab.layer.cornerRadius = btnWH/2;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:lab];
    numLab = lab;
}
-(void)setupTableView{

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

    needKnowBtn.titleLabel.font = kWTFont(18);
}
-(void)setupNodata{
    if (_myData.count>0) {
        return;
    }
    UIView* view = [[UIView alloc]initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [self.view addSubview:view];
    
    UIImageView* img =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    img.center = CGPointMake(KMainScreenWidth/2-60, KMainScreenHeight/2);
    img.image = [UIImage imageNamed:@"main_img_nodata2"];
    [view addSubview:img];
    
    UNIHttpUrlManager *manager = [UNIHttpUrlManager sharedInstance];
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(KMainScreenWidth/2, KMainScreenHeight/2-30,KMainScreenWidth/2, 20)];
    lab.text = @"马上购买去！";
    lab.textColor = [UIColor colorWithHexString:@"1b1b1b"];
    lab.font = kWTFont(18);
    [view addSubview:lab];
    
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(KMainScreenWidth/2, KMainScreenHeight/2,KMainScreenWidth/2, 40)];
    lab1.text = manager.GOTOBUY_DESC;
    lab1.textColor = [UIColor colorWithHexString:@"b5b4b4"];
    lab1.font = kWTFont(16);
    lab1.numberOfLines = 0;
    lab1.lineBreakMode = 0;
    [view addSubview:lab1];
}

#pragma mark 选择 按钮事件
- (IBAction)selectBtnAcvtion:(id)sender {
    NSMutableArray* arr = [NSMutableArray array];
    for (UNIMyProjectModel* model in self.myData) {
        if (model.select) {
            [arr addObject:model];
        }
    }
    [self.delegate UNIMyPojectListDelegateMethod:arr];
    [[BaiduMobStat defaultStat]logEvent:@"btn_select_projects" eventLabel:@"项目列表选择项目按钮"];
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 15)];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELLH;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _myData.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* name = @"cell";
    UNIAddProjectsCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell =[[NSBundle mainBundle]loadNibNamed:@"UNIAddProjectsCell" owner:self options:nil].lastObject;
    }
    UNIMyProjectModel* model = _myData[indexPath.section];
    [cell setupCellWithData:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UNIMyProjectModel* model = _myData[indexPath.section];
    UNIAddProjectsCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (model.select){
        
        _restTime +=(model.costTime* 60);
        model.select = NO;
        seletNum -- ;
        cell.handleImag.image= [UIImage imageNamed:@"addpro_btn_selelct1"];
    }
    else{
        if (self.restTime >= (model.costTime* 60)) {
            _restTime -=(model.costTime* 60);
        }else{
            [UIAlertView showWithTitle:@"提示" message:@"您添加的项目已经超出服务时间" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
            return;
        }
        model.select = YES;
        seletNum++;
        cell.handleImag.image= [UIImage imageNamed:@"addpro_btn_selelct2"];
    }
    numLab.text = [NSString stringWithFormat:@"%d",seletNum];

    
}

#pragma mark 开始请求我未预约项目
-(void)startRequestInfo{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        MainViewRequest* request1 = [[MainViewRequest alloc]init];
        [request1 postWithSerCode:@[API_URL_MyProjectInfo]
                           params:@{@"page":@(self->pageNum),@"size":@(20)}];
        request1.remyProjectBlock =^(NSArray* myProjectArr,int count,NSString* tips,NSError* err){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.myTableview.header endRefreshing];
                [self.myTableview.footer endRefreshing];
                if (err==nil) {
                    if (self->pageNum == 0)//下拉刷新
                        [self.myData removeAllObjects];
                    
                    if (myProjectArr.count<20)
                        [self.myTableview.footer endRefreshingWithNoMoreData];
                    
                  //  if (myProjectArr.count>0){
                        NSMutableArray* data = [NSMutableArray arrayWithArray:myProjectArr];
                        NSMutableArray* data1 = [NSMutableArray arrayWithArray:myProjectArr];
                        for (UNIMyProjectModel* info in self.projectIdArr) {
                            for (UNIMyProjectModel* model in data) {
                                if (model.projectId == info.projectId)
                                    [data1 removeObject:model];
                            }
                        }
                        [self.myData addObjectsFromArray:data1];
                        [self.myTableview reloadData];
                        [self setupNodata];
                   // }
                }else
                    [YIToast showText:NETWORKINGPEOBLEM];
            });
        };
        
        
    });
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
