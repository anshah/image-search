//
//  Image.h
//  CollectionViewExample
//
//  Created by Ankit Nitin Shah on 2/3/14.
//  Copyright (c) 2014 yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Image : NSObject

@property (nonatomic, strong, readonly) NSString* url;
@property (nonatomic, readonly) NSInteger width;
@property (nonatomic, readonly) NSInteger height;
@property (nonatomic, strong, readonly) NSString* title;

@property (nonatomic) NSInteger displayWidth;

-(NSInteger) scaledWidth;

-(id) initWithDictionary: (NSDictionary*) dict;

@end
