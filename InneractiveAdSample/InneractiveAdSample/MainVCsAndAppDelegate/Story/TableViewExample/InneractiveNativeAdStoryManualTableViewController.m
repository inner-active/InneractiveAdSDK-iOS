//
//  InneractiveNativeAdStoryManualTableViewController.m
//  InneractiveAdSample
//
//  Created by Nikita Fedorenko on 11/18/14.
//  Copyright (c) 2014 Inneractive. All rights reserved.
//

#import "InneractiveNativeAdStoryManualTableViewController.h"

#import "InneractiveFeedDataProvider.h"
#import "InneractiveFeed1TableCell.h"
#import "InneractiveNativeAd1TableCell.h"
#import "iToast.h"

@interface InneractiveFeedPostData : NSObject

@property (nonatomic, strong) NSString *authorName;
@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, strong) UIImage *postImage;
@property (nonatomic, strong) NSString *creationTimeString;

@end

@implementation InneractiveFeedPostData

@end


@interface InneractiveNativeAdStoryManualTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) NSArray *feedWithAdsArray;

@property (nonatomic, strong) IaNativeAd *nativeAd;
@property (nonatomic, strong) IaNativeAd *nativeAd2;

@end

@implementation InneractiveNativeAdStoryManualTableViewController

#pragma mark - Inits

- (void)initTable {
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds
                                                      style:UITableViewStylePlain];
    
    table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    table.translatesAutoresizingMaskIntoConstraints = YES;
    table.allowsSelection = NO;
    
    table.dataSource = self;
    table.delegate = self;
    [table registerClass:InneractiveFeed1TableCell.class forCellReuseIdentifier:NSStringFromClass(InneractiveFeed1TableCell.class)];
    [table registerClass:InneractiveNativeAd1TableCell.class forCellReuseIdentifier:NSStringFromClass(InneractiveNativeAd1TableCell.class)];
    
    self.table = table;
    [self.view addSubview:table];
}

- (void)initTableDataSourceArray {
    if (self.nativeAd && self.nativeAd2) {
        int postsCount = 100;
        NSMutableArray *postsArray = [NSMutableArray arrayWithCapacity:postsCount];
        for (int i = 0; i < postsCount; i++) {
            InneractiveFeedPostData *postData = [InneractiveFeedPostData new];
            postData.authorName = [[InneractiveFeedDataProvider sharedInstance] nameAtIndex:i];
            postData.avatarImage = [[InneractiveFeedDataProvider sharedInstance] profileImageAtIndex:i];
            postData.postImage = [[InneractiveFeedDataProvider sharedInstance] imageAtIndex:i];
            postData.creationTimeString = [[InneractiveFeedDataProvider sharedInstance] randomTime];
            [postsArray addObject:postData];
        }
        
        int i = 0;
        int startPosition = 0;
        int repeatingInterval = 5;
        IaNativeAd *lastAdAdded = nil;
        NSMutableArray *feedWithAdsArray = [NSMutableArray array];
        
        for (InneractiveFeedPostData *postData in postsArray) {
            if ((i == startPosition) || (((i + startPosition) % repeatingInterval) == 0)) {//if is repeating interval -> add ad
                IaNativeAd *adToAdd = lastAdAdded != self.nativeAd ? self.nativeAd : self.nativeAd2;//choose desired spot
                
                [feedWithAdsArray addObject:adToAdd];
                lastAdAdded = adToAdd;
            }
            
            [feedWithAdsArray addObject:postData];//add feed object
            ++i;
        }
        
        self.feedWithAdsArray = [NSArray arrayWithArray:feedWithAdsArray];
    }
}

- (void)initAds {
    NSString *const sampleAppIdString = @"MyCompany_MyApp";
    NSString *const sampleAppId2String = @"MyCompany_MyApp";
    
    self.nativeAd = [[IaNativeAd alloc] initWithAppId:sampleAppIdString adType:IaAdType_InFeedNativeAd delegate:self];
    self.nativeAd2 = [[IaNativeAd alloc] initWithAppId:sampleAppId2String adType:IaAdType_InFeedNativeAd delegate:self];
    
    // Setting requirements for ads
    self.nativeAd.adConfig.nativeAdAssetsDescription.titleAssetPriority = IaNativeAdAssetPriorityRequired;
    self.nativeAd.adConfig.nativeAdAssetsDescription.imageIconAssetPriority = IaNativeAdAssetPriorityRequired;
    self.nativeAd.adConfig.nativeAdAssetsDescription.callToActionTextAssetPriority = IaNativeAdAssetPriorityOptional;
    self.nativeAd.adConfig.nativeAdAssetsDescription.descriptionTextAssetPriority = IaNativeAdAssetPriorityRequired;
    
    self.nativeAd2.adConfig.nativeAdAssetsDescription.titleAssetPriority = IaNativeAdAssetPriorityRequired;
    self.nativeAd2.adConfig.nativeAdAssetsDescription.imageIconAssetPriority = IaNativeAdAssetPriorityRequired;
    self.nativeAd2.adConfig.nativeAdAssetsDescription.callToActionTextAssetPriority = IaNativeAdAssetPriorityOptional;
    self.nativeAd2.adConfig.nativeAdAssetsDescription.descriptionTextAssetPriority = IaNativeAdAssetPriorityRequired;
    
    [[InneractiveAdSDK sharedInstance] loadAd:self.nativeAd];
    [[InneractiveAdSDK sharedInstance] loadAd:self.nativeAd2];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAds];
    [self initTableDataSourceArray];
    [self initTable];
}

#pragma mark - Service

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - UITableviewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feedWithAdsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSObject *feedWithAdsObject = self.feedWithAdsArray[indexPath.row];
    IaNativeAd *currentNativeAd = nil;
    
    if ([feedWithAdsObject isKindOfClass:IaNativeAd.class]) {//is Ad Cell
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(InneractiveNativeAd1TableCell.class) forIndexPath:indexPath];
        currentNativeAd = (IaNativeAd *)feedWithAdsObject;
        
        [[InneractiveAdSDK sharedInstance] showNativeAd:currentNativeAd atCell:(InneractiveNativeAd1TableCell *)cell];
    } else {//is feed cell
        InneractiveFeed1TableCell* feedCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(InneractiveFeed1TableCell.class) forIndexPath:indexPath];
        
        feedCell.authorNameLabel.text = [(InneractiveFeedPostData*)feedWithAdsObject authorName];
        feedCell.avatarImageView.image = [(InneractiveFeedPostData*)feedWithAdsObject avatarImage];
        feedCell.feedImageView.image = [(InneractiveFeedPostData*)feedWithAdsObject postImage];
        
        cell = feedCell;
    }
    
    return cell;
}

#pragma mark - UITableviewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44.0f;
    NSObject *feedWithAdsObject = self.feedWithAdsArray[indexPath.row];
    
    if ([feedWithAdsObject isKindOfClass:IaNativeAd.class]) {//is Ad Cell
        height = [InneractiveNativeAd1TableCell sizeForNativeAdCell].height;
    } else {//is feed cell
        height = [InneractiveFeed1TableCell preferredHeight];
    }
    
    return height;
}

#pragma mark - InneractiveAdDelegate

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (void)InneractiveAdLoaded:(IaAd *)ad {
    DDLogInfo(@"NativeAdStoryAdapterTableView - InneractiveAdLoaded: %@", ad);
}

- (void)InneractiveAdFailedWithError:(NSError*)error withAdView:(IaAd *)ad {
    DDLogWarn(@"NativeAdStoryAdapterTableView - InneractiveAdFailedWithError: %@.", error);
    [[iToast makeText:[NSString stringWithFormat:@"InneractiveAdFailed Event Received\n%@", [error localizedDescription]]] show];
}

- (void)InneractiveAdClicked:(IaAd *)ad {
    DDLogInfo(@"InneractiveAdClicked");
}

- (void)InneractiveAdAppShouldResume:(IaAd *)ad {
    DDLogInfo(@"InneractiveAdAppShouldResume");
}

- (void)InneractiveAdAppShouldSuspend:(IaAd *)ad {
    DDLogInfo(@"InneractiveAdAppShouldSuspend");
}

@end
