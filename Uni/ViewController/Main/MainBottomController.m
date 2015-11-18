//
//  MainBottomController.m
//  Uni
//  首页底部 我未预约项目
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainBottomController.h"
#import "MainMidMoveBackTransition.h"
#import "MainMidCell.h"
#import "MainViewRequest.h"
@interface MainBottomController ()<UINavigationControllerDelegate>

@end

@implementation MainBottomController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _num = (int)_myData.count;
    [self setupNavigation];
    //[self setupTableviewHeader:@"我的项目"];
    [self setupTableviewFootView];
     [self startRequestInfo];
}
-(void)setupNavigation{
    self.tableView.layer.masksToBounds=YES;
    self.tableView.layer.cornerRadius = 5;
    self.tableView.backgroundColor = [UIColor whiteColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTableviewHeader:(NSString*)string{
    UIImageView* view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, KMainScreenWidth*0.06)];
    view.image =[UIImage imageNamed:@"mian_img_cellH"];
    UILabel* lab = [[UILabel alloc]initWithFrame:
                    CGRectMake(10, 5,  self.tableView.frame.size.width-10, KMainScreenWidth*0.05)];
    lab.text=string;
    lab.textColor = [UIColor colorWithHexString:@"575757"];
    lab.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*0.043];
    [view addSubview:lab];
    self.tableView.tableHeaderView = view;
}

-(void)setupTableviewFootView{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  self.tableView.frame.size.width, 5)];
   // view.image =[UIImage imageNamed:@"main_img_cellF"];
    self.tableView.tableFooterView = view;
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _num;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KMainScreenWidth*70/320;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* name = @"CellName";
    MainMidCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell)
        cell = [[NSBundle mainBundle]loadNibNamed:@"MainMidCell" owner:self options:nil].lastObject;
    
    [cell setupCellContent:_myData[0] andType:2];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)reflashTabel:(int)Num{
    _num = Num;
    [self.tableView reloadData];
}

-(void)insertTableViewData{
    _num = 10;
    [self.tableView reloadData];
    
}
-(void)deleteTableViewData:(int)Num{
    _num = Num;
    [self.tableView reloadData];
}


#pragma mark <UINavigationControllerDelegate>
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    
    MainMidMoveBackTransition *inverseTransition = [[MainMidMoveBackTransition alloc]init];
    return inverseTransition;
    
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
                if (!err) {
                    if (myProjectArr){
                        self.myData =[NSMutableArray arrayWithArray:myProjectArr];
                        [self reflashTabel:2];
                    }
                    else
                        [YIToast showText:tips];
                }else
                    [YIToast showText:tips];
            });
        };
        
        
    });
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
