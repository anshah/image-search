//
//  Image.m
//  CollectionViewExample
//
//  Created by Ankit Nitin Shah on 2/3/14.
//  Copyright (c) 2014 yahoo. All rights reserved.
//

#import "Image.h"

//#define MAX_HEIGHT  100;
@interface Image()

@property (nonatomic, strong) NSString* url;
@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger height;
@property (nonatomic, strong) NSString* title;

@end
@implementation Image

-(id) initWithDictionary: (NSDictionary*) dict{
    self = [super init];
    if(self){
        self.url = [dict valueForKeyPath:@"tbUrl"];
        self.width = [[dict valueForKeyPath:@"width"] integerValue];
        self.height = [[dict valueForKeyPath:@"height"] integerValue];
        self.title = [dict valueForKeyPath:@"title"];
    }
    return self;
}

-(NSInteger) scaledWidth{
    return (self.width*100)/self.height;
}

@end
