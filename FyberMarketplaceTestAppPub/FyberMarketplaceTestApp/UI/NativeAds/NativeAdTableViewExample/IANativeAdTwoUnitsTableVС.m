//
//  IANativeAdTwoUnitsTableVС.m
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 09/03/2017.
//  Copyright (c) 2017 Fyber. All rights reserved.
//

#import "IANativeAdTwoUnitsTableVС.h"

#import <IASDKCore/IASDKCore.h>
#import <IASDKCore/IASDKVideo.h>
#import <IASDKCore/IASDKMRAID.h>

#import "IAFeedDataProvider.h"
#import "IAFeedTableCell.h"
#import "IAColors.h"

@interface IAFeedPostData : NSObject
@property (nonatomic, strong) NSString *authorName;
@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, strong) UIImage *postImage;
@property (nonatomic, strong) NSString *creationTimeString; // currently is not used;
@end
@implementation IAFeedPostData {}
@end

@interface IAFeedDataObject : NSObject
@property (nonatomic) BOOL isAd;
@property (nonatomic, strong) NSObject *data;
@end
@implementation IAFeedDataObject {}
@end

@interface IANativeAdTwoUnitsTableVС () <
UITableViewDataSource,
UITableViewDelegate,
UIGestureRecognizerDelegate,
IAUnitDelegate,
IAVideoContentDelegate>

@property (nonatomic, weak) IBOutlet UITableView *table;

@property (nonatomic, strong) NSMutableArray *initialFeedDataArray;
@property (nonatomic, strong) NSMutableArray *actualFeedDataArray;

@property (nonatomic, strong) IAAdSpot *adSpot1;
@property (nonatomic, strong) IAUnitController *unit1;
@property (nonatomic, strong) IAContentController *content1;
@property (nonatomic, strong) IAContentController *mraidContent1;

@property (nonatomic, strong) IAAdSpot *adSpot2;
@property (nonatomic, strong) IAUnitController *unit2;
@property (nonatomic, strong) IAContentController *content2;
@property (nonatomic, strong) IAContentController *mraidContent2;

@end

@implementation IANativeAdTwoUnitsTableVС {}

static const NSInteger kInitialFeedCount = 100;
static const NSInteger kFirstAdUnitStartIndex = 0;
static const NSInteger kRepeatingInterval = 7;

#pragma mark - Inits

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initInitialFeedDataArray];
        [self initAds];
    }
    
    return self;
}

- (void)initInitialFeedDataArray {
    _initialFeedDataArray = [NSMutableArray arrayWithCapacity:kInitialFeedCount];
    
    for (int i = 0; i < kInitialFeedCount; i++) {
        IAFeedPostData *postData = [IAFeedPostData new];
        
        postData.authorName = [[IAFeedDataProvider sharedInstance] nameAtIndex:i];
        postData.avatarImage = [[IAFeedDataProvider sharedInstance] profileImageAtIndex:i];
        postData.postImage = [[IAFeedDataProvider sharedInstance] imageAtIndex:i];
        postData.creationTimeString = [[IAFeedDataProvider sharedInstance] randomTime];
        
        IAFeedDataObject *feedDataObject = [IAFeedDataObject new];
        
        feedDataObject.isAd = NO; // just showing is not an ad;
        feedDataObject.data = postData;
        [_initialFeedDataArray addObject:feedDataObject];
    }
    
    _actualFeedDataArray = [NSMutableArray arrayWithArray:_initialFeedDataArray];
}

- (void)initAds {
	NSString *spotID = @"150943";
	
    IAAdRequest *request1 = [IAAdRequest build:^(id<IAAdRequestBuilder>  _Nonnull builder) {
        builder.spotID = spotID;
        builder.timeout = 20;
#ifdef CERT_BUILD
        builder.debugger = [IADebugger build:^(id<IADebuggerBuilder>  _Nonnull builder) {}];
#endif
    }];
#ifdef DEBUG
    request1.debugger.server = @"ia-cert";
    request1.debugger.database = @"4321";
    //request1.debugger.mockResponsePath = @"";
#endif
//#ifdef CERT_BUILD
//    [[ClientRequestSettingss sharedInstance] updateRequestObjectWithCustomSettings:request1];
//#endif
    
    _content1 = [IAVideoContentController build:^(id<IAVideoContentControllerBuilder>  _Nonnull builder) {
        builder.videoContentDelegate = self;
    }];

    _mraidContent1 = [IAMRAIDContentController build:^(id<IAMRAIDContentControllerBuilder>  _Nonnull builder) {}];

    _unit1 = [IAViewUnitController build:^(id<IAViewUnitControllerBuilder>  _Nonnull builder) {
        builder.unitDelegate = self;
        [builder addSupportedContentController:self.content1];
        [builder addSupportedContentController:self.mraidContent1];
    }];
    
    _adSpot1 = [IAAdSpot build:^(id<IAAdSpotBuilder>  _Nonnull builder) {
        builder.adRequest = request1;
        [builder addSupportedUnitController:self.unit1];
    }];
    
    IAAdRequest *request2 = [IAAdRequest build:^(id<IAAdRequestBuilder>  _Nonnull builder) {
        builder.spotID = spotID;
        builder.timeout = 20;
    }];
    
#ifdef DEBUG
    request2.debugger.server = @"ia-cert";
    request2.debugger.database = @"4321";
    //request2.debugger.mockResponsePath = @"";

#endif
//#ifdef CERT_BUILD
//    [[ClientRequestSettingss sharedInstance] updateRequestObjectWithCustomSettings:request2];
//#endif
    
    _content2 = [IAVideoContentController build:^(id<IAVideoContentControllerBuilder>  _Nonnull builder) {
        builder.videoContentDelegate = self;
    }];
    
    _mraidContent2 = [IAMRAIDContentController build:^(id<IAMRAIDContentControllerBuilder>  _Nonnull builder) {}];
    
    _unit2 = [IAViewUnitController build:^(id<IAViewUnitControllerBuilder>  _Nonnull builder) {
        builder.unitDelegate = self;
        [builder addSupportedContentController:self.content2];
        [builder addSupportedContentController:self.mraidContent2];
    }];
    
    _adSpot2 = [IAAdSpot build:^(id<IAAdSpotBuilder>  _Nonnull builder) {
        builder.adRequest = request2;
        [builder addSupportedUnitController:self.unit2];
    }];
}

#pragma mark - Service

/**
 *  @brief Will fetch ads and update the feed accordingly.
 *
 *  @discussion When one of the ad units succeeds to load, the actual feed data array will be updated with it.
 */
- (void)fetchAds {
    __weak typeof(self) weakSelf = self;
    
    // 'self' should not be used in this block;
    // "returns" on main thread;
    IAAdSpotAdResponseBlock responseBlock = ^(IAAdSpot * _Nullable adSpot, IAAdModel * _Nullable adModel, NSError * _Nullable error) {
        if (error) {
            NSLog(@"ad failed: %@", error);
        } else {
            NSLog(@"ad succeeded");
            [weakSelf extendActualFeedArray:[adSpot activeUnitController]];
        }
    };
    
    [self.adSpot1 fetchAdWithCompletion:[responseBlock copy]];
    [self.adSpot2 fetchAdWithCompletion:[responseBlock copy]];
}

- (void)extendActualFeedArray:(IAUnitController *)adUnitController {
    const BOOL isFirstTimeAdInjection = (self.actualFeedDataArray.count == self.initialFeedDataArray.count); // means no ad has been injected so far;
    NSMutableArray *newFeedArray = [NSMutableArray array];
    
    if (isFirstTimeAdInjection) { // this is first time ad injection, we need to calculate the indices;
        [self.actualFeedDataArray enumerateObjectsUsingBlock:^(IAFeedDataObject * _Nonnull currentFeedObject, NSUInteger idx, BOOL * _Nonnull stop) {
            // we will inject the ad at this index;
            if ((idx != 0 ) && ((idx % (kFirstAdUnitStartIndex + kRepeatingInterval)) == 0)) {
                IAFeedDataObject *adObject = [IAFeedDataObject new];
                
                adObject.isAd = YES;
                adObject.data = adUnitController;
                [newFeedArray addObject:adObject];
            }
            
            [newFeedArray addObject:currentFeedObject];
        }];
        
        self.actualFeedDataArray = newFeedArray; // updating the feed;
    } else { // this is second time ad injection, since the indices are already calculated and the feed already contains the ads, we just only need to swap half of the units to a new one;
        __block BOOL shouldInjectNow = NO;
        
        [self.actualFeedDataArray enumerateObjectsUsingBlock:^(IAFeedDataObject * _Nonnull currentFeedObject, NSUInteger idx, BOOL * _Nonnull stop) {
            if (currentFeedObject.isAd) {
                if (shouldInjectNow) {
                    currentFeedObject.data = adUnitController; // switching to the new ad;
                }
                
                shouldInjectNow = !shouldInjectNow; // setting the flag to inject next time, in case this time was disabled, and vice versa;
            }
        }];
    }
    
    [self.table reloadData];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
	
    __weak typeof(self) weakSelf = self;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.table reloadData]; // show feed without ads, meanwhile;
            [weakSelf fetchAds]; // fetch ads;
        });
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - UITableviewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actualFeedDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    IAFeedDataObject *currentIndexData = self.actualFeedDataArray[indexPath.row];
		
    if (currentIndexData.isAd) {
        IAViewUnitController *currentAdController = (IAViewUnitController *)currentIndexData.data;
        NSString *reuseCellID = (currentAdController == self.unit1) ? @"IAAdTableCell1" : @"IAAdTableCell2";
        UITableViewCell *rectAdCell = [tableView dequeueReusableCellWithIdentifier:reuseCellID forIndexPath:indexPath];
        BOOL adViewWasShown = (currentAdController.adView.superview != nil);
        
        [currentAdController showAdInParentView:rectAdCell.contentView];
        IAAdView *adView = currentAdController.adView;
        
        if (adView && !adViewWasShown) {
            adView.backgroundColor = [UIColor whiteColor];
            
            // *** here is a constraints positioning example:
            adView.translatesAutoresizingMaskIntoConstraints = NO;
            
            // adding centerX constraint
            [rectAdCell.contentView addConstraint:
             [NSLayoutConstraint constraintWithItem:adView
                                          attribute:NSLayoutAttributeCenterX
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:rectAdCell.contentView
                                          attribute:NSLayoutAttributeCenterX
                                         multiplier:1
                                           constant:0]];
            
            // adding centerY constraint
            [rectAdCell.contentView addConstraint:
             [NSLayoutConstraint constraintWithItem:adView
                                          attribute:NSLayoutAttributeCenterY
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:rectAdCell.contentView
                                          attribute:NSLayoutAttributeCenterY
                                         multiplier:1
                                           constant:0]];
        }
        
        cell = rectAdCell;
    } else {
		IAFeedTableCell *feedCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(IAFeedTableCell.class) forIndexPath:indexPath];
        IAFeedPostData *currentFeedData = (IAFeedPostData *)currentIndexData.data;
        
        feedCell.authorNameLabel.text = currentFeedData.authorName;
        feedCell.avatarImageView.image = currentFeedData.avatarImage;
        feedCell.feedImageView.image = currentFeedData.postImage;
		
		cell = feedCell;
	}
	
    return cell;
}

#pragma mark - UITableviewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    IAFeedDataObject *currentIndexData = self.actualFeedDataArray[indexPath.row];
    
	if (currentIndexData.isAd) {
        IAViewUnitController *adController = (IAViewUnitController *)currentIndexData.data;
        
        height = CGRectGetHeight(adController.adView.frame) + 1;
    } else {
        height = IAFeedTableCell.preferredHeight;
    }
    
    return height;
}

#pragma mark - IANativeUnitControllerDelegate

- (UIViewController * _Nonnull)IAParentViewControllerForUnitController:(IAUnitController * _Nullable)unitController {
    return self;
}

- (void)IAAdDidReceiveClick:(IAUnitController * _Nullable)unitController {
    NSLog(@"ad clicked;");
}

- (void)IAUnitControllerWillPresentFullscreen:(IAUnitController * _Nullable)unitController {
    NSLog(@"IAUnitControllerWillPresentFullscreen");
}

- (void)IAUnitControllerDidPresentFullscreen:(IAUnitController * _Nullable)unitController {
    NSLog(@"IAUnitControllerDidPresentFullscreen");
}

- (void)IAUnitControllerWillDismissFullscreen:(IAUnitController * _Nullable)unitController {
    NSLog(@"IAUnitControllerWillDismissFullscreen");
}

- (void)IAUnitControllerDidDismissFullscreen:(IAUnitController * _Nullable)unitController {
    NSLog(@"IAUnitControllerDidDismissFullscreen");
}

- (void)IAUnitControllerWillOpenExternalApp:(IAUnitController * _Nullable)unitController {
    NSLog(@"IA will open external app;");
}

#pragma mark - IAVideoContentDelegate

- (void)IAVideoCompleted:(IAVideoContentController * _Nullable)contentController {
    NSLog(@"video of content controller:%p completed", contentController);
}

- (void)IAVideoContentController:(IAVideoContentController * _Nullable)contentController videoInterruptedWithError:(NSError * _Nonnull)error {
    NSLog(@"video of content controller:%p interrupted with error:%@", contentController, error);
}

- (void)IAVideoContentController:(IAVideoContentController * _Nullable)contentController videoDurationUpdated:(NSTimeInterval)videoDuration {
    NSLog(@"video duration of content controller:%p updated: %.2f", contentController, videoDuration);
}

- (void)IAVideoContentController:(IAVideoContentController * _Nullable)contentController videoProgressUpdatedWithCurrentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    //NSLog(@"video progress of content controller:%p updated with progress %.2f%%", contentController, (currentTime / totalTime) * 100);
}

#pragma mark - Dispose

- (void)dealloc {
    NSLog(@"%@ deallocated", NSStringFromClass(self.class));
}

@end
