//
//  GoogleSearchClient.h
//  CollectionViewExample
//
//  Created by Ankit Nitin Shah on 2/3/14.
//  Copyright (c) 2014 yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoogleSearchClient : UICollectionViewCell

- (void) search:(NSString*)query success:(void (^)(NSURLRequest*, NSHTTPURLResponse*, id))success failure:(void (^)(NSURLRequest*, NSHTTPURLResponse*, NSError*))failure;

@end
