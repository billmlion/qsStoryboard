//
//  Comments.h
//  糗百
//
//  Created by Apple on 12-10-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comments : NSObject
{
    //楼层
    int floor;
    //内容
    NSString *content;
    //作者
    NSString *anchor;
    //糗事id
    NSString *commentsID;
}
@property(nonatomic,assign) int floor;
@property(nonatomic,copy)  NSString *content;
@property(nonatomic,copy)  NSString *anchor;
@property(nonatomic,copy)  NSString *commentsID;

-(id)initwithDictionary:(NSDictionary *)dictionary;
@end
