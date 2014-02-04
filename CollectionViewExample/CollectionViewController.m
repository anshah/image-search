//
//  MyCollectionViewController.m
//  CollectionViewExample
//
//  Created by Ankit Nitin Shah on 2/3/14.
//  Copyright (c) 2014 yahoo. All rights reserved.
//

#import "CollectionViewController.h"
#import "UIImageView+AFNetworking.h"
#import "GoogleSearchClient.h"
#import "Image.h"


@interface CollectionViewController ()

@property (nonatomic, strong) NSMutableArray* images;
@property (nonatomic, strong) NSMutableArray* imageSets;
@property (nonatomic, strong) UISearchBar* searchBarTop;
@property (nonatomic) NSInteger pageIndexSearchResult;
@property (nonatomic, strong) NSString* searchQuery;
@property (nonatomic) NSInteger searchingMore;

@end

@implementation CollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBarTop = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.searchBarTop setPlaceholder:@"Enter your command here"];
    //self.searchDC = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBarTop contentsController:self];
    self.searchBarTop.delegate = self;
    
    //[[self navigationController] setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar addSubview:self.searchBarTop];
    
    self.pageIndexSearchResult = 0;
    self.searchingMore = 4;
    self.searchQuery = @"Titanic";
    [self moreSearch:YES];
	// Do any additional setup after loading the view.
}


-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if(searchBar.text.length >0){
        NSLog(@"Search bar end");
        [searchBar endEditing:true];
        self.pageIndexSearchResult = 0;
        self.searchingMore = 4;
        self.searchQuery = searchBar.text;
        [self moreSearch: YES];
    };
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *myCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"MyCell"
                                    forIndexPath:indexPath];
    Image* img = [self.images objectAtIndex:indexPath.row];
    //UIImage* loadingImg = [UIImage imageWithContentsOfFile: @"images/loading.gif"];
    UIImageView* imageView = myCell.imageView;
    [imageView setImageWithURL: [NSURL URLWithString:[img url]]];
    for(NSLayoutConstraint* con in imageView.constraints){
        if([con firstAttribute] == NSLayoutAttributeWidth){
            con.constant = [img displayWidth];
        }
    }
    return myCell;
}
/*
-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
}*/


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Image *image = [self.images objectAtIndex:indexPath.row ];
    return CGSizeMake(image.displayWidth, 100);
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float percentScrolled = 1.0*(scrollView.contentOffset.y+scrollView.frame.size.height) / self.collectionView.contentSize.height;
    if(self.searchingMore == 0 && percentScrolled > 0.9){
        self.searchingMore = 4;
        [self moreSearch: NO];
    }
}

- (void) moreSearch:(BOOL) isNew{
    if(isNew){
        self.images = [[NSMutableArray alloc] init];
    }
    GoogleSearchClient* client = [[GoogleSearchClient alloc] init];
    [client search:self.searchQuery start:self.pageIndexSearchResult success:^(NSURLRequest *request, NSHTTPURLResponse *response, id data) {
        
        id results = [data valueForKeyPath:@"responseData.results"];
        if ([results isKindOfClass:[NSArray class]]) {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            for(NSDictionary* dict in results){
                [array addObject: [[Image alloc] initWithDictionary:dict]];
            }
            [self.images addObjectsFromArray:array];
            self.imageSets = [self groupTogether: self.images];
            //= [NSArray arrayWithArray:array];
            //NSLog(@"Count: %d %@",self.imageSets.count, self.images);
            NSLog(@"Img: %@", self.images);
            [self.collectionView reloadData];
        }
        self.searchingMore = self.searchingMore-1;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id data) {
        self.searchingMore = self.searchingMore-1;
        NSLog(@"%@", error);
    }];
    self.pageIndexSearchResult += 4;
}

- (NSMutableArray*) groupTogether: (NSArray*) imgs{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    NSMutableArray* set = nil;
    for (int i= 0; i< imgs.count; i++) {
        if(set == nil){
            set = [[NSMutableArray alloc] initWithObjects:imgs[i], nil];
        }else{
            NSInteger totalExistingWidth = 0;
            for(Image* img in set){
                totalExistingWidth += [img scaledWidth];
            }
            float errorPerImage = ((totalExistingWidth -319)*1.0)/ [set count];
            float errorPerImageAdded = ((totalExistingWidth+[imgs[i] scaledWidth] -319)*1.0)/ ([set count]+1);
            if((errorPerImage > 0 && errorPerImageAdded >0)
               || (abs(errorPerImage) < abs(errorPerImageAdded))
               || (i+1 == imgs.count)){
                [result addObject: set];
                int totalError = (totalExistingWidth -319);
                for(Image* img in set){
                    img.displayWidth = [img scaledWidth] - (([img scaledWidth]*totalError)/totalExistingWidth);
                }
                int missed = 319;
                for(Image* img in set){
                    missed -= [img displayWidth];
                }
                if(missed != 0){
                    ((Image*)[set lastObject]).displayWidth = [[set lastObject] displayWidth] + missed;
                }
                //if((i+1 == imgs.count) && [set count] ==0){
                //  ((Image*)[set lastObject]).displayWidth = ((Image*)[set lastObject]).scaledWidth;
                //}
                set = [[NSMutableArray alloc] initWithObjects:imgs[i], nil];
            }else{
                [set addObject:imgs[i]];
            }
        }
    }
    return result;
}


@end



