//
//  MainViewController.h
//  qsStoryboard
//
//  Created by bill lion on 13-12-19.
//  Copyright (c) 2013年 bill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "ASIHTTPRequest.h"
#import "QiuShi.h"
#import "ContentCell.h"

@interface MainViewController :UIViewController<UITableViewDataSource,
UITableViewDelegate,PullingRefreshTableViewDelegate,ASIHTTPRequestDelegate>

{
    //未登陆显示
    UIImageView *headlogoView; //求是百科的logo
    //test testStoryboard
    //test 1
    
    
    //随机、8小时最糗、7天内最糗、一个月最糗、真相
    QiuShiTime MainQiuTime;
    
    NSMutableArray *list;
    PullingRefreshTableView *tableView;
    BOOL refreshing;
    NSInteger page;
    //随机、8小时最糗、7天内最糗、一个月最糗、真相
    QiuShiTime QiuTime;
    //http 请求
    ASIHTTPRequest *asiRequest;
}
@property (nonatomic,assign)  QiuShiTime MainQiuTime;
@property (nonatomic,retain) UIImageView *headlogoView;
@property (assign,nonatomic) NSInteger page;
@property (nonatomic) BOOL refreshing;
@property (retain,nonatomic) PullingRefreshTableView *tableView;
@property (retain,nonatomic) NSMutableArray *list;
@property (nonatomic,assign) QiuShiTime QiuTime;
@property(nonatomic,retain) ASIHTTPRequest *asiRequest;
-(void) LoadPageOfQiushiType:(QiuShiTime) time;
-(CGFloat) getTheHeight:(NSInteger)row;




@end
