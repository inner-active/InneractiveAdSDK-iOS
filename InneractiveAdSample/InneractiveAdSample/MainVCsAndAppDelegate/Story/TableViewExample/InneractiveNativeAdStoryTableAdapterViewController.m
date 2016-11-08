//
//  InneractiveNativeAdStoryTableAdapterViewController.m
//  InneractiveAdSample
//
//  Created by Nikita Fedorenko on 11/18/14.
//  Copyright (c) 2014 Inneractive. All rights reserved.
//

#import "InneractiveNativeAdStoryTableAdapterViewController.h"

#import "InneractiveFeedDataProvider.h"

#import "InneractiveFeed2TableCell.h"
#import "InneractiveNativeAd2TableCell.h"
#import "InneractivePositioningPicker.h"
#import "iToast.h"

@interface InneractiveNativeAdStoryTableAdapterViewController () <InneractivePositioningPickerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, assign) NSUInteger feedItemsCount;

@property (nonatomic, strong) IaNativeAdTableAdapter *tableAdapter;
@property (nonatomic, strong) IaNativeAd *nativeAd;
@property (nonatomic, strong) InneractivePositioningPicker *positioningPicker;

@end

@implementation InneractiveNativeAdStoryTableAdapterViewController

#pragma mark - Inits

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _feedItemsCount = 100;
    }
    
    return self;
}

- (void)initPositioningButtonIfNeeded {
    if (!self.navigationItem.rightBarButtonItem) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"Positioning"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(positioningPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 30, 30);
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        self.navigationItem.rightBarButtonItem = barButtonItem;
    }
}

- (void)initTable {
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds
                                                      style:UITableViewStylePlain];
    
    table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    table.translatesAutoresizingMaskIntoConstraints = YES;
    table.allowsSelection = NO;
    
    table.dataSource = self;
    table.delegate = self;
    [table registerClass:InneractiveFeed2TableCell.class forCellReuseIdentifier:NSStringFromClass(InneractiveFeed2TableCell.class)];
    
    self.table = table;
    [self.view addSubview:table];
}

- (void)initNativeAd {
    NSString *const sampleAppIdString = @"MyCompany_MyApp";
    
    self.nativeAd = [[IaNativeAd alloc] initWithAppId:sampleAppIdString adType:IaAdType_InFeedNativeAd delegate:self];
    
    // optional settings:
    self.nativeAd.adConfig.nativeAdAssetsDescription.mainAssetMinSize = IaAdAssetSizeMake(100, 100);
    self.nativeAd.adConfig.nativeAdAssetsDescription.titleAssetPriority = IaNativeAdAssetPriorityRequired;
    self.nativeAd.adConfig.nativeAdAssetsDescription.imageIconAssetPriority = IaNativeAdAssetPriorityRequired;
    self.nativeAd.adConfig.nativeAdAssetsDescription.imageIconAssetMinSize = IaAdAssetSizeMake(20, 20);
    self.nativeAd.adConfig.nativeAdAssetsDescription.callToActionTextAssetPriority = IaNativeAdAssetPriorityOptional;
    self.nativeAd.adConfig.nativeAdAssetsDescription.descriptionTextAssetPriority = IaNativeAdAssetPriorityNone;

    self.nativeAd.adConfig.nativeAdStartPosition = 0;
    self.nativeAd.adConfig.nativeAdRepeatingInterval = 5;
    
    self.nativeAd.adConfig.videoLayout.progressBarIsVisibleInFeed = YES;
    self.nativeAd.adConfig.videoLayout.controlsInsideVideoRect = YES;
    
    self.nativeAd.videoProgressObserver = ^(NSTimeInterval currentTime, NSTimeInterval totalTime) {
        NSLog(@"[Current video time: %.2lfs total time: %.2lfs progress: %.0lf%%]", currentTime, totalTime, (currentTime / totalTime) * 100.0);
    };
    // end of optional settings;
    
    self.tableAdapter = [[IaNativeAdTableAdapter alloc] initWithNativeAd:self.nativeAd table:self.table adCellRegisteringClass:InneractiveNativeAd2TableCell.class]; // automatic indexes management;
    
    
    [[InneractiveAdSDK sharedInstance] loadAd:self.nativeAd];
}

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    
    [self initPositioningButtonIfNeeded];
    [self initTable];
    [self initNativeAd];
}

#pragma mark - Service

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)positioningPressed:(UIButton *)sender {
    if (!self.positioningPicker) {
        InneractivePositioningPicker *picker = [[InneractivePositioningPicker alloc] initWithMaxPositions:self.feedItemsCount delegate:self nativeAd:self.nativeAd];
        
        self.positioningPicker = picker;
        [picker showFromView:self.view];
    }
}

- (void)removePositioningPicker {
    [self.positioningPicker dismiss];
    self.positioningPicker = nil;
}

#pragma mark - UITableviewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feedItemsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /* if using dequeueReusableCellWithIdentifier: (without index) will work
       using dequeueReusableCellWithIdentifier:forIndexPath: probably will have NSIndexPath inconsistency,
       therefore, Ia_dequeueReusableCellWithIdentifier:forIndexPath: is needed to use */
    InneractiveFeed2TableCell *cell = [tableView ia_dequeueReusableCellWithIdentifier:NSStringFromClass(InneractiveFeed2TableCell.class)
                                                                         forIndexPath:indexPath];
    
    cell.feedImageView.image = [[InneractiveFeedDataProvider sharedInstance] imageAtIndex:indexPath.row];
    cell.avatarImageView.image = [[InneractiveFeedDataProvider sharedInstance] profileImageAtIndex:indexPath.row];
    cell.authorNameLabel.text = [[InneractiveFeedDataProvider sharedInstance] nameAtIndex:indexPath.row];
    cell.timeLabel.text = [[InneractiveFeedDataProvider sharedInstance] randomTime];
    
    return cell;
}

#pragma mark - UITableviewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [InneractiveFeed2TableCell preferredHeight];
}

#pragma mark - InneractiveAdDelegate

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (void)InneractiveAdLoaded:(IaAd *)ad {
    NSLog(@"NativeAdStoryTableAdapterView - InneractiveAdLoaded: %@", ad);
    
    if (ad.isVideoAd) {
        NSLog(@"Video duration is %.2lfs", ad.videoDuration);
    }
    
    IaNativeAd *nativeAd = (IaNativeAd *)ad;
    
    if (nativeAd.responseModel.titleText.length) {
        NSLog(@"Native ad response contains: Title");
    }
    
    if (nativeAd.responseModel.iconImageURLString.length) {
        NSLog(@"Native ad response contains: Icon");
    }
    
    if (nativeAd.responseModel.VASTXMLData.length) {
        NSLog(@"Native ad response contains: Video");
    }
    
    if (nativeAd.responseModel.largeImageURLString.length) {
        NSLog(@"Native ad response contains: Image");
    }
    
    if (nativeAd.responseModel.descriptionString.length) {
        NSLog(@"Native ad response contains: Description text");
    }
    
    if (nativeAd.responseModel.CTAText.length) {
        NSLog(@"Native ad response contains: CTA text");
    }
}

- (void)InneractiveAdFailedWithError:(NSError *)error withAdView:(IaAd *)ad {
    NSLog(@"NativeAdStoryTableAdapterView - InneractiveAdFailedWithError: %@.", error);
    [[iToast makeText:[NSString stringWithFormat:@"InneractiveAdFailed Event Received\n%@", [error localizedDescription]]] show];
}

- (void)InneractiveAdAppShouldResume:(IaAd *)ad {
    NSLog(@"NativeAdStoryTableAdapterView - InneractiveAdAppShouldResume");
}

- (void)InneractiveAdAppShouldSuspend:(IaAd *)ad {
    NSLog(@"NativeAdStoryTableAdapterView - InneractiveAdAppShouldSuspend");
}

- (void)InneractiveAdClicked:(IaAd *)ad {
    NSLog(@"InneractiveAdClicked - %@", ad.adConfig.appId);
}

- (void)InneractiveAdWillOpenExternalApp:(IaAd *)ad {
    NSLog(@"InneractiveAdWillOpenExternalApp - %@", ad.adConfig.appId);
}

#pragma mark - InneractivePositioningPickerDelegate

- (void)positioningPickerSelected:(InneractivePositioningPicker *)picker {
    [self removePositioningPicker];
    [self.table ia_reloadData];
    [self.table ia_scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (void)positioningPickerCancelled:(InneractivePositioningPicker *)picker {
    [self removePositioningPicker];
}

@end
