//
//  CommentsViewController.h
//  qsStoryboard
//
//  Created by bill lion on 13-12-19.
//  Copyright (c) 2013年 bill. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIHTTPRequest.h"
#import "QiuShi.h"


@interface CommentsViewController : UIViewController<ASIHTTPRequestDelegate,
UITableViewDataSource,UITableViewDelegate>
{
    //糗事内容的TableView
    UITableView *tableView;
    //评论的TableView
    UITableView *commentView;
    //糗事的对象
    QiuShi *qs;
    //记录评论的数组
    NSMutableArray *list;
    //http请求
    ASIHTTPRequest *asiRequestqs;
    
}
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) UITableView *commentView;
@property (nonatomic,retain) QiuShi *qs;
@property (nonatomic,retain) NSMutableArray *list;
@property (nonatomic,retain) ASIHTTPRequest *asiRequestqs;

-(CGFloat) getTheHeight;
-(CGFloat) getTheCellHeight:(int) row;
-(void) GetErrQS:(ASIHTTPRequest *)request;
-(void) GetResultQS:(ASIHTTPRequest *)request;

- (void)loadData;

@end
