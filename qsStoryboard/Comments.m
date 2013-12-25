//
//  Comments.m
//  糗百
//
//  Created by Apple on 12-10-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Comments.h"

@implementation Comments

@synthesize content;
@synthesize commentsID;
@synthesize floor;
@synthesize anchor;

- (void)dealloc
{
    [anchor release];
    [commentsID release];
    [content release];
    [super dealloc];
}
-(id)initwithDictionary:(NSDictionary *)dictionary;
{
    if (self=[super init]) {
        self.content=[dictionary objectForKey:@"content"];
        self.commentsID=[dictionary objectForKey:@"id"];
        self.floor=[[dictionary objectForKey:@"floor"] intValue];
        id  user=[dictionary objectForKey:@"user"];
        if ((NSNull *)user !=[NSNull null]) {
            NSDictionary *user=[NSDictionary dictionaryWithDictionary:[dictionary objectForKey:@"user"]];
            self.anchor=[user objectForKey:@"login"];                    
        }
    }
    return  self;
}

@end
