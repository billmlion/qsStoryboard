//
//  CommentsViewController.m
//  qsStoryboard
//
//  Created by bill lion on 13-12-19.
//  Copyright (c) 2013年 bill. All rights reserved.
//

#import "CommentsViewController.h"
#import "ContentCell.h"
#import "Comments.h"
#import "CommentsCell.h"
#import "JSON.h"
#import "SHSShareViewController.h"
#import "SHKActivityIndicator.h"
#define FShareBtn       101
#define FBackBtn        102
#define FAddComments    103

#import "CommentsViewController.h"

@interface CommentsViewController ()
-(void)BackForm;
@end

@implementation CommentsViewController


@synthesize tableView,commentView;
@synthesize qs;
@synthesize list,asiRequestqs;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
   
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:
                                   [UIImage imageNamed:@"main_background.png"]]];
    list=[[NSMutableArray alloc] init];
    //添加headbar
    UIImage *headimage=[UIImage imageNamed:@"head_background.png"];
    UIImageView *headview=[[UIImageView alloc]initWithImage:headimage];
    [headview setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:headview];
    [headview release];
    //添加UILabel
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 6, 180, 32)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont: [UIFont fontWithName:@"Arial" size:18]];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:[NSString stringWithFormat:@"糗事#%@",qs.qiushiID]];
    [self.view addSubview:label];
    [label release];
    
    //返回按钮
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbtn setFrame:CGRectMake(10,6,32,32)];
    [backbtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(BackClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backbtn setTag:FBackBtn];
    [self.view addSubview:backbtn];
    
    //分享按钮
    UIButton *sharebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sharebtn setFrame:CGRectMake(280,6,32,32)];
    [sharebtn setImage:[UIImage imageNamed:@"icon_share.png"] forState:UIControlStateNormal];
    [sharebtn addTarget:self action:@selector(BackClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sharebtn setTag:FShareBtn];
    [self.view addSubview:sharebtn];
    //糗事列表
    CGRect CGRect=CGRectMake(0, 0, kDeviceWidth, [self getTheHeight]-60);
    tableView = [[UITableView alloc]  initWithFrame:CGRect];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.scrollEnabled = NO;
    [commentView addSubview:tableView];
    //评论列表
    commentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-60)];
    commentView.backgroundColor = [UIColor clearColor];
    commentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    commentView.dataSource = self;
    commentView.delegate = self;
    commentView.scrollEnabled = YES;
    [self.view addSubview:commentView];
    commentView.tableHeaderView = tableView;
    
    //给当前的view添加一个向右的手势swip。当向右滑动的时候返回之前的主页面
    UISwipeGestureRecognizer *swip=[[[UISwipeGestureRecognizer alloc]
                                     initWithTarget:self action:@selector(BackFormswip:)]autorelease];
    swip.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swip];
    [self loadData];
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView=nil;
    self.commentView=nil;
    self.qs=nil;
    self.list=nil;
    // self.asiRequest=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)BackClicked:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    switch (btn.tag) {
        case FBackBtn:
            [self BackForm];
            break;
        case FAddComments://追加评论
        {
            NSLog(@"logging comment.");
        }
            break;
            
        case FShareBtn://分享
        {
            SHSShareViewController *shareView = [[SHSShareViewController alloc]initWithRootViewController:self];
            [shareView.view setFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
            [self.view addSubview:shareView.view];
            shareView.sharedtitle = @"糗事百科-生活百态尽在Qiushibaike...";
            shareView.sharedText = qs.content;
            shareView.sharedURL =@"http://www.qiushibaike.com";
            shareView.sharedImageURL = qs.imageURL;
            [shareView showShareKitView];
            
        }
            break;
        default:
            break;
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)BackForm
{
    [self dismissModalViewControllerAnimated:YES];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - Your actions

- (void)loadData{
    [list removeAllObjects];
    NSURL *url = [NSURL URLWithString:CommentsURLString(qs.qiushiID)];
    asiRequestqs = [ASIHTTPRequest requestWithURL:url];
    [asiRequestqs setDelegate:self];
    [asiRequestqs setDidFinishSelector:@selector(GetResultQS:)];
    [asiRequestqs setDidFailSelector:@selector(GetErrQS:)];
    [asiRequestqs startAsynchronous];
    [[SHKActivityIndicator currentIndicator] displayActivity:@"正在加载评论..." inView:self.view];
    
}

-(void) GetErrQS:(ASIHTTPRequest *)request
{
    NSLog(@"获取评论GetErr");
    [[SHKActivityIndicator currentIndicator]hide];
}

-(void) GetResultQS:(ASIHTTPRequest *)request
{
    [[SHKActivityIndicator currentIndicator]hide];
    NSData *data =[request responseData];
    NSString *outString  = [[NSString alloc] initWithData:data encoding:  NSUTF8StringEncoding];
	//NSLog(@"接口返回数据  %@", outString);
    //返回的借口信息保存到字典中
    NSDictionary *dictionary = [outString JSONValue];
    if ([dictionary objectForKey:@"items"]) {
		NSArray *array = [NSArray arrayWithArray:[dictionary objectForKey:@"items"]];
        for (NSDictionary *qiushi in array) {
            Comments *cm = [[[Comments alloc]initwithDictionary:qiushi]autorelease];
            [list addObject:cm];
        }
    }
    [commentView reloadData];
}

#pragma mark - TableView*

- (NSInteger)tableView:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section{
    if (tableview == tableView) {
        return 1;
    }else {
        return [list count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableview == tableView) {
        
        static NSString *identifier = @"_QiShiCELL";
        ContentCell *cell =(ContentCell *) [tableview dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil){
            //设置cell 样式
            cell = [[[ContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.txtContent.NumberOfLines = 0;
        }
        
        //设置内容
        cell.txtContent.text = qs.content;
        //设置图片
        if (qs.imageURL!=nil && qs.imageURL!= @"") {
            cell.imgUrl = qs.imageURL;
            cell.imgMidUrl = qs.imageMidURL;
            //  cell.imgPhoto.hidden = NO;
        }else
        {
            cell.imgUrl = @"";
            cell.imgMidUrl = @"";
            //  cell.imgPhoto.hidden = YES;
        }
        //设置用户名
        if (qs.anchor!=nil && qs.anchor!= @"")
        {
            cell.txtAnchor.text = qs.anchor;
        }else
        {
            cell.txtAnchor.text = @"匿名";
        }
        //设置标签
        if (qs.tag!=nil && qs.tag!= @"")
        {
            cell.txtTag.text = qs.tag;
        }else
        {
            cell.txtTag.text = @"";
        }
        //设置up ，down and commits
        [cell.goodbtn setTitle:[NSString stringWithFormat:@"%d",qs.upCount] forState:UIControlStateNormal];
        //[cell.goodbtn setEnabled:Ye];
        [cell.badbtn setTitle:[NSString stringWithFormat:@"%d",qs.downCount] forState:UIControlStateNormal];
        //[cell.badbtn setEnabled:NO];
        [cell.commentsbtn setTitle:[NSString stringWithFormat:@"%d",qs.commentsCount] forState:UIControlStateNormal];
        //[cell.commentsbtn setEnabled:NO];
        //自适应函数
        [cell resizeTheHeight];
        return cell;
    }else {
        static NSString *identifier1=@"_CommentCell";
        CommentsCell *cell=(CommentsCell *)[tableview dequeueReusableCellWithIdentifier:identifier1];
        if (cell ==nil) {
            //设置cell样式
            cell = [[[CommentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.txtContent.NumberOfLines = 0;
        }
        Comments *cm=[list objectAtIndex:indexPath.row];
        //设置内容
        cell.txtContent.text=cm.content;
        cell.txtfloor.text=[NSString stringWithFormat:@"%d",cm.floor];
        //设置用户名
        if (cm.anchor!=nil && cm.anchor!=@"") {
            cell.txtAnchor.text=cm.anchor;
        }else {
            cell.txtAnchor.text=@"匿名";
        }
        //自定义高度
        [cell resizeTheHeight];
        return cell;
        
        
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableview heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableview) {
        CGFloat height = [self getTheHeight];
        [tableView setFrame:CGRectMake(0, 0, kDeviceWidth, height)];
        return  height;
    }else {
        return [self getTheCellHeight:indexPath.row];
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


-(CGFloat) getTheHeight
{
    CGFloat contentWidth = 280;
    // 设置字体
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    // 显示的内容
    NSString *content = qs.content;
    // 计算出长宽  3000是为了能更多的显示，220 文字内容会显示不全
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 3000) lineBreakMode:UILineBreakModeTailTruncation];
    CGFloat height;
    if (qs.imageURL==nil) {
        height = size.height+214;
    }else
    {
        height = size.height+294;
    }
    // 返回需要的高度
    return height;
}
-(CGFloat) getTheCellHeight:(int) row
{
    CGFloat contentWidth = 280;
    // 设置字体
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    
    Comments *cm = [self.list objectAtIndex:row];
    // 显示的内容
    NSString *content = cm.content;
    // 计算出长宽
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 400) lineBreakMode:UILineBreakModeTailTruncation];
    CGFloat height = size.height+30;
    // 返回需要的高度
    return height;
}

@end
