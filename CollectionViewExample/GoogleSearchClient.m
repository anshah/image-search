//
//  GoogleSearchClient.m
//  CollectionViewExample
//
//  Created by Ankit Nitin Shah on 2/3/14.
//  Copyright (c) 2014 yahoo. All rights reserved.
//

#import "GoogleSearchClient.h"
#import "AFNetworking.h"

@implementation GoogleSearchClient


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSArray*) search:(NSString*)query{
    return [[NSArray alloc]init];
}

- (void) search:(NSString*)query start:(int)start success:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, id data))success failure:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id data))failure{

    for(int i = start ; i < start+4 ; i++){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=8&q=%@&start=%d", [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],i]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];
        
        [operation start];
    }
}

@end
