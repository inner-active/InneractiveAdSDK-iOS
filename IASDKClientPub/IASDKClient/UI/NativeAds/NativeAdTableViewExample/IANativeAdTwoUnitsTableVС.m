//
//  IANativeAdTwoUnitsTableVС.m
//  IASDKClient
//
//  Created by Inneractive on 09/03/2017.
//  Copyright (c) 2017 Inneractive. All rights reserved.
//

#import "IANativeAdTwoUnitsTableVС.h"

#import <IASDKCore/IASDKCore.h>
#import <IASDKVideo/IASDKVideo.h>
#import <IASDKNative/IASDKNative.h>

#import "IAFeedDataProvider.h"
#import "IAFeedTableCell.h"
#import "IANativeAdTableCell.h"
#import "IAColors.h"

typedef NS_ENUM(NSInteger, IADebugAdUnitType) {
	IADebugAdUnitTypeNative = 0,
	IADebugAdUnitTypeRectangle = 1,
	IADebugAdUnitTypeSquare = 2,
	IADebugAdUnitTypeLandscape = 3,
};

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
IANativeUnitControllerDelegate,
IANativeContentDelegate,
IAVideoContentDelegate,
UIGestureRecognizerDelegate,
UIPickerViewDelegate,
UIPickerViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *table;

@property (nonatomic, strong) NSMutableArray *initialFeedDataArray;
@property (nonatomic, strong) NSMutableArray *actualFeedDataArray;

@property (nonatomic, strong) IAAdSpot *adSpot1;
@property (nonatomic, strong) IAUnitController *unit1;
@property (nonatomic, strong) IAContentController *content1;

@property (nonatomic, strong) IAAdSpot *adSpot2;
@property (nonatomic, strong) IAUnitController *unit2;
@property (nonatomic, strong) IAContentController *content2;

@property (nonatomic) IADebugAdUnitType unitType;
@property (nonatomic, strong) UIPickerView *pickerView;

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
        [self initNativeAds];
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

- (void)initNativeAds {
    IANativeAdDescription *nativeAdDescription = [IANativeAdDescription build:^(id<IANativeAdDescriptionBuilder>  _Nonnull builder) {
        builder.assetsDescription.titleAssetPriority = IANativeAdAssetPriorityRequired;
        builder.nativeAdMainAssetMinWidth = 100;
        builder.nativeAdMainAssetMinHeight = 100;
        builder.maxBitrate = 8192;
    }];
    IAAdRequest *request1 = [IAAdRequest build:^(id<IAAdRequestBuilder>  _Nonnull builder) {
        builder.useSecureConnections = NO;
        builder.spotID = @"150950"; // native video;
        builder.timeout = 20;
        builder.subtypeDescription = nativeAdDescription;
        builder.autoLocationUpdateEnabled = YES;
    }];
    
    _content1 = [IANativeContentController build:^(id<IANativeContentControllerBuilder>  _Nonnull builder) {
        builder.nativeContentDelegate = self;
        builder.videoContentDelegate = self;
    }];
    
    _unit1 = [IANativeUnitController build:^(id<IANativeUnitControllerBuilder>  _Nonnull builder) {
        builder.unitDelegate = self;
        [builder addSupportedContentController:self.content1];
    }];
    
    _adSpot1 = [IAAdSpot build:^(id<IAAdSpotBuilder>  _Nonnull builder) {
        builder.adRequest = request1;
        [builder addSupportedUnitController:self.unit1];
    }];
    
    IAAdRequest *request2 = [request1 copy]; // will perform deep copy;
    
    _content2 = [IANativeContentController build:^(id<IANativeContentControllerBuilder>  _Nonnull builder) {
        builder.nativeContentDelegate = self;
        builder.videoContentDelegate = self;
    }];
    
    _unit2 = [IANativeUnitController build:^(id<IANativeUnitControllerBuilder>  _Nonnull builder) {
        builder.unitDelegate = self;
        [builder addSupportedContentController:self.content2];
    }];
    
    _adSpot2 = [IAAdSpot build:^(id<IAAdSpotBuilder>  _Nonnull builder) {
        builder.adRequest = request2;
        [builder addSupportedUnitController:self.unit2];
    }];
}

- (void)initVideoAds {
	NSString *spotID = @"";
    
	if (self.unitType == IADebugAdUnitTypeRectangle) {
		spotID = @"150945"; // rect video;
	} else if (self.unitType == IADebugAdUnitTypeSquare) {
		spotID = @"150948"; // square video;
	} else if (self.unitType == IADebugAdUnitTypeLandscape) {
		spotID = @"150947"; // landscape video;
	}
	
    IAAdRequest *request1 = [IAAdRequest build:^(id<IAAdRequestBuilder>  _Nonnull builder) {
        builder.useSecureConnections = NO;
        builder.spotID = spotID;
        builder.timeout = 20;
        builder.autoLocationUpdateEnabled = YES;
    }];
    
    _content1 = [IAVideoContentController build:^(id<IAVideoContentControllerBuilder>  _Nonnull builder) {
        builder.videoContentDelegate = self;
    }];
    
    _unit1 = [IAViewUnitController build:^(id<IAViewUnitControllerBuilder>  _Nonnull builder) {
        builder.unitDelegate = self;
        [builder addSupportedContentController:self.content1];
    }];
    
    _adSpot1 = [IAAdSpot build:^(id<IAAdSpotBuilder>  _Nonnull builder) {
        builder.adRequest = request1;
        [builder addSupportedUnitController:self.unit1];
    }];
    
    IAAdRequest *request2 = [request1 copy]; // will perform deep copy;
    
    _content2 = [IAVideoContentController build:^(id<IAVideoContentControllerBuilder>  _Nonnull builder) {
        builder.videoContentDelegate = self;
    }];
    
    _unit2 = [IAViewUnitController build:^(id<IAViewUnitControllerBuilder>  _Nonnull builder) {
        builder.unitDelegate = self;
        [builder addSupportedContentController:self.content2];
    }];
    
    _adSpot2 = [IAAdSpot build:^(id<IAAdSpotBuilder>  _Nonnull builder) {
        builder.adRequest = request2;
        [builder addSupportedUnitController:self.unit2];
    }];
}

- (void)addUnitTypeButton {
    UIBarButtonItem *unitTypeButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Choose unit...", @"Button title") style:UIBarButtonItemStylePlain target:self action:@selector(unitTypeButtonWasPressed:)];
    NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:kIAColorsButtonsText forKey:NSForegroundColorAttributeName];
    
    [unitTypeButton setTitleTextAttributes:titleAttributes forState:UIControlStateNormal];
    unitTypeButton.tintColor = UIColor.whiteColor;
    
    self.navigationItem.rightBarButtonItem = unitTypeButton;
}

#pragma mark - Service

- (void)unitTypeButtonWasPressed:(UIButton *)button {
	if (_pickerView == nil) {
		_pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
		self.pickerView.backgroundColor = UIColor.whiteColor;
		self.pickerView.delegate = self;
		self.pickerView.dataSource = self;
		self.pickerView.alpha = 0.0;
		[self.pickerView selectRow:0 inComponent:0 animated:NO];
	}
    
	self.pickerView.frame = CGRectMake(0.0, CGRectGetHeight(self.view.frame) - 144.0, CGRectGetWidth(self.view.frame), 144.0);
	[self.view addSubview:self.pickerView];
	
	[UIView animateWithDuration:1.0 animations:^{ self.pickerView.alpha = 1.0; } completion:nil];
}

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
            if ((idx % (kFirstAdUnitStartIndex + kRepeatingInterval)) == 0) {
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
	[self addUnitTypeButton];
	
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
		if (self.unitType == IADebugAdUnitTypeNative) {
			IANativeAdTableCell *nativeAdCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(IANativeAdTableCell.class) forIndexPath:indexPath];
			IANativeUnitController *currentAdController = (IANativeUnitController *)currentIndexData.data;
			
			[currentAdController showAdInNativeRenderer:nativeAdCell];
			cell = nativeAdCell;
		} else {
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
		}
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
		if (self.unitType == IADebugAdUnitTypeNative) {
			height = IANativeAdTableCell.sizeForNativeAdCell.height;
		} else {
			IAViewUnitController *adController = (IAViewUnitController *)currentIndexData.data;
			height = CGRectGetHeight(adController.adView.frame) + 1;
        }
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

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return 4;
}

#pragma mark - UIPickerViewDelegate

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSString *title = @"";
    
	switch (row) {
		case 0:
			title = NSLocalizedString(@"Native", @"");
			break;
		case 1:
			title = NSLocalizedString(@"Rectangle", @"");
			break;
		case 2:
			title = NSLocalizedString(@"Square", @"");
			break;
		case 3:
			title = NSLocalizedString(@"Landscape", @"");
			break;
		default:
			break;
	}
    
	NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : kIAColorsAquamarine}];
	
	return attributedTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // remove ad objects retained in data array:
    [self.actualFeedDataArray removeAllObjects];
    
    // set initial data array:
    [self.actualFeedDataArray addObjectsFromArray:self.initialFeedDataArray];
    
    // remove ad objects as members (in addition, after content+unit controller are deallocated, their players/adviews will be removed as well):
    self.adSpot1 = nil;
    self.unit1 = nil;
    self.content1 = nil;
    self.adSpot2 = nil;
    self.unit2 = nil;
    self.content2 = nil;
    
    // reload table for 2 reasons: 1. to be consistent with initial data array; 2. to remove adView(s) or native ads UI elelemts, added as subviews;
    [self.table reloadData];
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // remove picker:
            [UIView animateWithDuration:1.0 animations:^{
                pickerView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [pickerView removeFromSuperview];
            }];
            
            weakSelf.unitType = row;
            
            // fetch new set of ads:
            if (weakSelf.unitType == IADebugAdUnitTypeNative) {
                [weakSelf initNativeAds];
            } else {
                [weakSelf initVideoAds];
            }

            [weakSelf fetchAds];
        });
    });
}

#pragma mark - Dispose

- (void)dealloc {
    NSLog(@"%@ deallocated", NSStringFromClass(self.class));
}

@end
