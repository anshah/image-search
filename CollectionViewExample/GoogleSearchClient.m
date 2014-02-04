//
//  GoogleSearchClient.m
//  CollectionViewExample
//
//  Created by Ankit Nitin Shah on 2/3/14.
//  Copyright (c) 2014 yahoo. All rights reserved.
//

#import "GoogleSearchClient.h"

@implementation GoogleSearchClient

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

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

- (void) search:(NSString*)query success:(void (^)(NSURLRequest*, NSHTTPURLResponse*, id))success failure:(void (^)(NSURLRequest*, NSHTTPURLResponse*, NSError*))failure{

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%@", [@"Katrina" stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        id results = [JSON valueForKeyPath:@"responseData.results"];
        if ([results isKindOfClass:[NSArray class]]) {
            [self.imageResults removeAllObjects];
            [self.imageResults addObjectsFromArray:results];
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    } failure:nil];
    
    [operation start];
    
}

@end
