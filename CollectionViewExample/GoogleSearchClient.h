//
//  GoogleSearchClient.h
//  CollectionViewExample
//
//  Created by Ankit Nitin Shah on 2/3/14.
//  Copyright (c) 2014 yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoogleSearchClient: NSObject

- (void) search:(NSString*)query start:(int)start success:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, id data))success failure:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id data))failure;

@end
