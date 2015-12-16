//
//  UNIGoodsDeatilController.m
//  Uni
//  客妆商品详情
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIGoodsDeatilController.h"
#import "UNIGoodsCell1.h"
#import "UNIGoodsCell2.h"
#import "UNIGoodsCell3.h"
#import "UNIGoodsCell4.h"
#import "UNIGoodsComment.h"
#import "UNIPurchaseController.h"
#import <MJRefresh/MJRefresh.h>
#import "UNIGoodsDetailRequest.h"
#import "UNIImageAndTextController.h"
@interface UNIGoodsDeatilController ()<UITableViewDataSource,UITableViewDelegate>{
    UIView* midView;
   // float tableH;
    float cell1H;
    float cell2H;
    float cell3H;
    float cell4H;
    UNIGoodsModel* model;
}
@property(nonatomic,strong)UIScrollView* myScroller;
@property(nonatomic,strong)UITableView* myTable;
@property(nonatomic,strong)NSMutableArray* allArray;

@end

@implementation UNIGoodsDeatilController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    
    [self startRequestReward];
   
}
#pragma mark 开始请求 我的奖励
-(void)startRequestReward{
    UNIGoodsDetailRequest* requet = [[UNIGoodsDetailRequest alloc]init];
    [requet postWithSerCode:@[API_PARAM_UNI,API_URL_GetSellInfo] params:nil];
    requet.kzgoodsInfoBlock =^(NSArray* array,NSString* tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (er) {
                [YIToast showText:@"请求发生错误"];
                return ;
            }
            if(array){
                self->model = array.lastObject;
                [self setupMyScroller];
                 [self setupData];
                [self setupTableView];
            }else
                [YIToast showText:tips];
        });
    };
}

-(void)setupNavigation{
    self.title = @"客妆";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
}
-(void)setupData{
    float size1 =[self suanziti:model.projectName andFont:17 andWidth:200].height;
    float size2 =[self suanziti:model.effect andFont:12 andWidth:200].height;
    cell1H =255 + size1 -20;
    cell2H =110 + size2 -35;
    cell3H =44;
    cell4H =KMainScreenWidth* 125/320;
    //tableH = KMainScreenWidth* 100/320 + cell1H +cell2H +cell3H+ cell4H + 30;
    self.allArray = [NSMutableArray array];
}

-(void)startRequest{
    
}
-(void)setupMyScroller{
    float scX = 10;
    float scY = 64+8;
    float scW = KMainScreenWidth - scX*2;
    float scH = KMainScreenHeight - 64 - scX*2;
//    if (IOS_VERSION<9.0){
//        scY = 8;
//        scH = KMainScreenHeight - scX*2;
//    }
    self.myScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(scX, scY, scW, scH)];
    self.myScroller.delegate = self;
    self.myScroller.contentSize = CGSizeMake(scW, scH);
    self.myScroller.backgroundColor = [UIColor clearColor];
    self.myScroller.pagingEnabled =YES;
    [self.view addSubview:self.myScroller];
}
-(void)setupTableView{
    float tabW = self.myScroller.frame.size.width;
    UITableView* tabview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, tabW,_myScroller.frame.size.height) style:UITableViewStylePlain];
    tabview.delegate = self;
    tabview.dataSource = self;
    tabview.backgroundColor = [UIColor clearColor];
    tabview.showsVerticalScrollIndicator=NO;
    [self.myScroller addSubview:tabview];
    self.myTable =tabview;
    [self setupHeaderview];
    
    self.myTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.myScroller.contentSize = CGSizeMake(self.myScroller.frame.size.width, self.myScroller.frame.size.height*2);
        [self.myScroller setContentOffset:CGPointMake(0,self.myScroller.frame.size.height) animated:YES];
        self.myTable.footer = nil;
        [self setupWebView];

    }];
}

#pragma mark 设置头部View
-(void)setupHeaderview{
    
    float topW = KMainScreenWidth - 10*2;
    float topH = KMainScreenWidth* 120/320;
    UIView* top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, topW, topH)];
    self.myTable.tableHeaderView = top;
    
    UIImage* img = [UIImage imageNamed:@"mian_img_cellH"];
    float imgH = KMainScreenWidth* 16/320;
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, topW, imgH)];
    imgView.image =img;
    [top addSubview:imgView];
    
    float labX = KMainScreenWidth*5/320;
    float labY = 0;
    float labW = topW- labX*2;
    UILabel* lab =[[UILabel alloc]initWithFrame:CGRectMake(labX, labY, labW, imgH)];
    lab.text = @"团购满";
    lab.font = [UIFont boldSystemFontOfSize:KMainScreenWidth* 12/320];
    [top addSubview:lab];
    
    UIImage* img2 = [UIImage imageNamed:@"main_img_cellF"];
    float img2H = KMainScreenWidth*8/320;
    float img2Y = topH - img2H-10;
    UIImageView* imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, img2Y, topW, img2H)];
    imgView2.image = img2;
    [top addSubview:imgView2];
    
    UIView* button = [[UIView alloc]initWithFrame:CGRectMake(0, img2Y+img2H, topW, 10)];
    [top addSubview:button];
    
    float midH = topH - imgH - img2H - 10;
    UIView * midview = [[UIView alloc]initWithFrame:CGRectMake(0, imgH, topW, midH)];
    midview.backgroundColor = [UIColor whiteColor];
    [top addSubview:midview];
    midView = midview;
    
    [self setupMidview];
}

-(void)setupMidview{
    CALayer* line = [CALayer layer];
     float lineX =10;
    float lineW = midView.frame.size.width - 2*lineX;
    float lineH = KMainScreenWidth*3/320;
    float lineY = (midView.frame.size.height - lineH)/2;
    line.frame = CGRectMake(lineX, lineY, lineW, lineH);
    line.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor].CGColor;
    line.masksToBounds=YES;
    line.cornerRadius = 3;
    [midView.layer addSublayer:line];
    
    NSArray* colors = @[@"KZ_img_red",@"KZ_img_orange",@"KZ_img_green",@"KZ_img_red",@"KZ_img_orange"];
    NSArray* imgNames = @[@"KZ_img_good",@"KZ_img_bofang",@"KZ_img_aixin",@"KZ_img_xing",@"KZ_img_zuanshi"];
    NSArray* stringS = @[@"5人返￥5",@"10人返￥15",@"20人返￥25",@"25人返￥30",@"30人返￥35"];
    float jg = midView.frame.size.width/6;
    for (int i =0; i<colors.count; i++) {
        UIImage* img = [UIImage imageNamed:colors[i]];
        float imgWH =KMainScreenWidth*12/320;
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imgWH, imgWH)];
        //imgView.contentMode=UIViewContentModeScaleAspectFit;
        imgView.center = CGPointMake( (i+1)*jg,midView.frame.size.height/2);
        imgView.image = img;
        [midView addSubview:imgView];
        
        UIImage* img1 = [UIImage imageNamed:imgNames[i]];
        float img2WH =KMainScreenWidth*22/320;
        UIImageView* imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img2WH, img2WH+4)];
        //imgView1.contentMode=UIViewContentModeScaleAspectFit;
        imgView1.image = img1;
        
        float centerX = 0;
        float labCenterY = 0;
        if ((i+1)%2==0){
            centerX = CGRectGetMaxY(imgView.frame)+imgView.frame.size.height/2+8;
            labCenterY = imgView.frame.origin.y - imgView.frame.size.height/2-8;
        }else{
            centerX = imgView.frame.origin.y - imgView.frame.size.height/2-8;
            labCenterY =  CGRectGetMaxY(imgView.frame)+imgView.frame.size.height/2+8;
        }
        imgView1.center = CGPointMake((i+1)*jg, centerX);
       
        [midView addSubview:imgView1];
        
        UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 15)];
        lab.text = stringS[i];
        lab.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*9/320];
        [lab sizeToFit];
        lab.center = CGPointMake((i+1)*jg, labCenterY);
        [midView addSubview:lab];
    }
   
}

#pragma mark 加载webView
-(void)setupWebView{
    UIWebView* web = [[UIWebView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_myTable.frame), _myTable.frame.size.width, _myScroller.frame.size.height)];
    NSString* urlString = [NSString stringWithFormat:@"%@/shopadmin/Public/Home/Detail/goods?id=%d",API_URL,model.projectId];
    NSLog(@"urlString %@",urlString);
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [web loadRequest:request];
    [_myScroller addSubview:web];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float cell = 0;
    switch (indexPath.row) {
        case 0:
            cell = cell1H;
            break;
        case 1:
            cell = cell2H;
            break;
        case 2:
            cell = cell3H;
            break;
        case 3:
            cell = cell4H;
            break;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            UNIGoodsCell1* cell =[[NSBundle mainBundle]loadNibNamed:@"UNIGoodsCell1" owner:self options:nil].lastObject;
            [cell setupCellContentWith:model];
            return cell;
        }
            break;
        case 1:{
            UNIGoodsCell2* cell =[[NSBundle mainBundle]loadNibNamed:@"UNIGoodsCell2" owner:self options:nil].lastObject;
            [cell setupCellContentWith:model];
            return cell;
        }
            break;
        case 2:{
            UNIGoodsCell3* cell =[[NSBundle mainBundle]loadNibNamed:@"UNIGoodsCell3" owner:self options:nil].lastObject;
            return cell;
        }
            break;
        case 3:{
            UNIGoodsCell4* cell =[[NSBundle mainBundle]loadNibNamed:@"UNIGoodsCell4" owner:self options:nil].lastObject;
            [cell setupCellContentWith:model];
            [[cell.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
            subscribeNext:^(UIButton* x) {
                UIStoryboard* st = [UIStoryboard storyboardWithName:@"KeZhuang" bundle:nil];
                UNIPurchaseController* comment = [st instantiateViewControllerWithIdentifier:@"UNIPurchaseController"];
                [self.navigationController pushViewController:comment animated:YES];
            }];
            
            [[cell.stateBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
             subscribeNext:^(UIButton* x) {
                 UIStoryboard* st = [UIStoryboard storyboardWithName:@"KeZhuang" bundle:nil];
                 UNIGoodsComment* comment = [st instantiateViewControllerWithIdentifier:@"UNIGoodsComment"];
                 [self.navigationController pushViewController:comment animated:YES];
            }];
            return cell;
        }
            break;
    }

    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:{
            UIStoryboard* st = [UIStoryboard storyboardWithName:@"KeZhuang" bundle:nil];
            UNIImageAndTextController* imgAndText = [st instantiateViewControllerWithIdentifier:@"UNIImageAndTextController"];
            imgAndText.projectId = model.projectId;
            [self.navigationController pushViewController:imgAndText animated:YES];
        }
            break;
        case 3:{
            
        }
            break;
    }
}

-(CGSize)suanziti:(NSString*)text andFont:(float)font andWidth:(float)width{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font]}//传人的字体字典
                                       context:nil];
    
    return rect.size;
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
