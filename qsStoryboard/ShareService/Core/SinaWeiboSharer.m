//
//  SinaWeiboSharer.m
//  ShareDemo
//
//  Created by mini2 on 2/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SinaWeiboSharer.h"
#import "NSMutableURLRequest+FormData.h"
#import "SHSAPIKeys.h"
#define url @"https://api.weibo.com/2/statuses/update.json"
#define TEXT_IMAGE_URL @"https://api.weibo.com/2/statuses/upload.json"

@implementation SinaWeiboSharer
@synthesize connection = _connection;
- (id)init
{
    if(self=[super init])
    {
        self.appKey=SINAWEIBO_APP_KEY;
        self.secretKey=SINAWEIBO_SECRET_KEY;
    }
    
    return self;
}

- (void)shareText:(NSString *)text andImage:(UIImage *)image;
{
    self.sharedText=text;
    self.sharedImage=image;
    
    if([self isVerified])
    {
//        if([self.delegate respondsToSelector:@selector(OAuthSharerDidBeginShare:)])
//            [self.delegate OAuthSharerDidBeginShare:self];
//        
//        OAConsumer *comsumer=[[[OAConsumer alloc] initWithKey:_appKey secret:_secretKey] autorelease];
//        OAMutableURLRequest *request=[[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:TEXT_IMAGE_URL] consumer:comsumer token:_accessToken realm:nil signatureProvider:_signatureProvider];
//        request.shareType=ShareTypeTextAndImage;
//        [request setHTTPMethod:@"POST"];
//        [request setOAuthParameterName:@"status" withValue:[text URLEncodedString]];
//        
//        NSDictionary *textField=[NSDictionary dictionaryWithObject:[text URLEncodedString] forKey:@"status"];
//        NSDictionary *fileField=[NSDictionary dictionaryWithObject:UIImageJPEGRepresentation(image, 0.5) forKey:@"pic"];
//        [request setFormDataWithTextField:textField withFileField:fileField];
//        
//        [comsumer release];
//        
//        OAAsynchronousDataFetcher *fetcher=[[OAAsynchronousDataFetcher alloc] initWithRequest:request delegate:self didFinishSelector:@selector(shareRequestTicket:didFinishWithData:) didFailSelector:@selector(shareRequestTicket:didFailWithError:)];
//        [fetcher start];
//        [fetcher release];
        
    }
    else
    {
        self.pendingShare=ShareTypeTextAndImage;
        [self beginOAuthVerification];
    }

}
-(int)textLength:(NSString *)dataString
{
    float sum = 0.0;
    for(int i=0;i<[dataString length];i++)
    {
        NSString *character = [dataString substringWithRange:NSMakeRange(i, 1)];
        if([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            sum++;
        }
        else
            sum += 0.5;
    }
    
    return ceil(sum);
}
- (void)shareText:(NSString *)text
{
    self.sharedText=text;

    if([self isVerified])
    {
        if([self textLength:self.sharedText] > 140)
        {
            UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"错误" message:@"文字内容超过 140个字!" delegate:nil cancelButtonTitle:@"YES" otherButtonTitles:nil];
            [alert2 show];
            return ;
        }
        if([self.delegate respondsToSelector:@selector(OAuthSharerDidBeginShare:)])
            [self.delegate OAuthSharerDidBeginShare:self];
       //@"2.00xmiDbC03Gs7Zd2c59ba190eGIVcD"
        OAConsumer *comsumer=[[[OAConsumer alloc] initWithKey:_appKey secret:_secretKey] autorelease];
        NSString *params = [[NSString alloc] initWithFormat:@"access_token=%@&status=%@",comsumer.key,self.sharedText];
        NSMutableData *postData = [[NSMutableData alloc] init];
        [postData appendData:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3.0];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
        
//        OAMutableURLRequest *request=[[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] consumer:comsumer token:_accessToken realm:nil signatureProvider:_signatureProvider];
//        [request setHTTPMethod:@"POST"];
//        [request setOAuthParameterName:@"status" withValue:[text URLEncodedString]];
//        request.shareType=ShareTypeText;
//        [comsumer release];
//        
//        OAAsynchronousDataFetcher *fetcher=[[OAAsynchronousDataFetcher alloc] initWithRequest:request delegate:self didFinishSelector:@selector(shareRequestTicket:didFinishWithData:) didFailSelector:@selector(shareRequestTicket:didFailWithError:)];
//        [fetcher start];
//        [fetcher release];
        
    }
    else
    {
        self.pendingShare=ShareTypeText;
        [self beginOAuthVerification];
    }
}
#pragma mark - NSURLConnection delegate Methods

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"111");
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"222");
    DataStatistic *stat = [[DataStatistic alloc] init];
    [stat sendStatistic:self.sharedUrl site:@"sinaminiblog"];
    [stat release];
    
    NSString *responseStr=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@" %@",responseStr);
    [responseStr release];
    self.sharedText=nil;
    self.sharedImage=nil;
    if([self.delegate respondsToSelector:@selector(OAuthSharerDidFinishShare:)])
        [self.delegate OAuthSharerDidFinishShare:self];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)theconnection
{
     NSLog(@"333");

}
- (void)shareRequestTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    DataStatistic *stat = [[DataStatistic alloc] init];
    [stat sendStatistic:self.sharedUrl site:@"sinaminiblog"];
    [stat release];
    
    NSString *responseStr=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [responseStr release];
    self.sharedText=nil;
    self.sharedImage=nil;
    if([self.delegate respondsToSelector:@selector(OAuthSharerDidFinishShare:)])
        [self.delegate OAuthSharerDidFinishShare:self];
}

- (void)shareRequestTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error
{
    if([self.delegate respondsToSelector:@selector(OAuthSharerDidFailShare:)])
        [self.delegate OAuthSharerDidFailShare:self];
}

@end
