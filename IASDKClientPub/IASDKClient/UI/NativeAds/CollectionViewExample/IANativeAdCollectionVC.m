//
//  IANativeAdCollectionVC.m
//  IASDKClient
//
//  Created by Inneractive on 09/03/2017.
//  Copyright (c) 2017 Inneractive. All rights reserved.
//

#import "IANativeAdCollectionVC.h"

#import <IASDKCore/IASDKCore.h>
#import <IASDKVideo/IASDKVideo.h>
#import <IASDKNative/IASDKNative.h>

#import "IAFeedDataProvider.h"
#import "IAFeedCollectionCell.h"
#import "IANativeAdCollectionCell.h"

@interface IANativeAdCollectionVC () <IANativeUnitControllerDelegate, IANativeContentDelegate, IAVideoContentDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) IAAdSpot *adSpot;
@property (nonatomic, strong) IANativeUnitController *adUnitController;
@property (nonatomic, strong) IANativeContentController *adContentController;

@property (nonatomic, strong) NSMutableDictionary *adsIndexesDictionary;

@property (nonatomic, assign) NSInteger adStartPosition;
@property (nonatomic, assign) NSInteger adRepeatingInterval;
@property (nonatomic, assign) NSInteger initialFeedCount;
@property (nonatomic, assign) CGSize generalItemSize;
@property (nonatomic, assign) BOOL isPhoneIdiom;

@property (nonatomic, assign) BOOL isAdReceived;

@end

@implementation IANativeAdCollectionVC {}

#pragma mark - Inits

- (void)initCollectionView; {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 4.0;
    layout.minimumLineSpacing = 4.0;
    layout.sectionInset = UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0);
    
	if (@available(iOS 11, *)) {
    	layout.sectionInsetReference = UICollectionViewFlowLayoutSectionInsetFromSafeArea;
	}
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)initAd {
	IANativeAdDescription *nativeAdDescription = [IANativeAdDescription build:^(id<IANativeAdDescriptionBuilder>  _Nonnull builder) {
		builder.assetsDescription.titleAssetPriority = IANativeAdAssetPriorityRequired;
		builder.nativeAdMainAssetMinWidth = 100;
		builder.nativeAdMainAssetMinHeight = 100;
		builder.maxBitrate = 8192;
	}];
	
	IAAdRequest *request = [IAAdRequest build:^(id<IAAdRequestBuilder>  _Nonnull builder) {
		builder.useSecureConnections = NO;
		builder.spotID = @"150950"; // native video;
		builder.timeout = 20;
		builder.subtypeDescription = nativeAdDescription;
		builder.autoLocationUpdateEnabled = YES;
	}];
    
	_adContentController = [IANativeContentController build:^(id<IANativeContentControllerBuilder>  _Nonnull builder) {
        builder.nativeContentDelegate = self;
        builder.videoContentDelegate = self;
    }];
    
	_adUnitController = [IANativeUnitController build:^(id<IANativeUnitControllerBuilder>  _Nonnull builder) {
		builder.unitDelegate = self;
		[builder addSupportedContentController:self.adContentController];
	}];
	
	_adSpot = [IAAdSpot build:^(id<IAAdSpotBuilder>  _Nonnull builder) {
		builder.adRequest = request;
		[builder addSupportedUnitController:self.adUnitController];
	}];
}

- (void)fetchAd {
	__weak typeof(self) weakSelf = self;
	
	[self.adSpot fetchAdWithCompletion:^(IAAdSpot * _Nullable adSpot, IAAdModel * _Nullable adModel, NSError * _Nullable error) { // 'self' should not be used in this block;
		if (error) {
			NSLog(@"ad failed: %@", error);
		} else {
			NSLog(@"ad succeeded");
			weakSelf.isAdReceived = YES;
			[weakSelf manageIndexes];
			[weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
		}
	}];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];

    self.isPhoneIdiom = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
	self.initialFeedCount = 300;//can be any count, the source will be generated, always
	//this is just example; those are just random indexes and management for the ads; it is possible to manage ads / feed indexes in a different way;
	self.adStartPosition = 3;
	self.adRepeatingInterval = self.isPhoneIdiom ? 17 : 35;

    // seems like is not needed; TODO: check different devices;
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initCollectionView];
    [self initAd];
	[self fetchAd];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self reload];
}

- (void)orientationDidChange:(NSNotification *)notification {
    [self reload];
}

#pragma mark - Ads management

- (void)manageIndexes {
    if (self.adUnitController) {
		
		self.adsIndexesDictionary = [NSMutableDictionary dictionary];
        NSInteger overallCellsCount = self.initialFeedCount + [self adsCountForIndex:self.initialFeedCount - 1];
        
        for (NSInteger i = self.adStartPosition; i < overallCellsCount; i += self.adRepeatingInterval) {
            [self.adsIndexesDictionary setObject:self.adUnitController forKey:@(i)];
        }
    }
}

- (NSInteger)adsCountForIndex:(NSInteger)index {
    NSInteger result = 0;
    
    if (self.isAdReceived && (index > self.adStartPosition)) {
        result = ((index - self.adStartPosition) / self.adRepeatingInterval) + 1;
    }
    
    return result;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.initialFeedCount + self.adsIndexesDictionary.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *returnCell = nil;
    IANativeUnitController *currentUnit = [self.adsIndexesDictionary objectForKey:@(indexPath.item)];
	
    if (currentUnit) {
        IANativeAdCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(IANativeAdCollectionCell.class) forIndexPath:indexPath];
        
		[currentUnit showAdInNativeRenderer:(IANativeAdCollectionCell *)cell];
		returnCell = cell;
    } else {
        NSInteger actualIndex = indexPath.item - [self adsCountForIndex:indexPath.item];
        IAFeedCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(IAFeedCollectionCell.class) forIndexPath:[NSIndexPath indexPathForRow:actualIndex inSection:0]];
		
        cell.titleLabel.text = [[IAFeedDataProvider sharedInstance] nameAtIndex:actualIndex];
        cell.feedImageView.image = [[IAFeedDataProvider sharedInstance] imageAtIndex:actualIndex];
        cell.timeLabel.text = [[IAFeedDataProvider sharedInstance] randomTime];
        cell.likesCountLabel.text = [NSString stringWithFormat:@"%ld",(long)[[IAFeedDataProvider sharedInstance] randomCount]];
        cell.commentsCountLabel.text = [NSString stringWithFormat:@"%ld",(long)[[IAFeedDataProvider sharedInstance] randomCount]];
        
        returnCell = cell;
    }
    
    return returnCell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.generalItemSize.width == 0.0f) {
        [self recalculateItemSize];
    }
    
    return self.generalItemSize;
}

#pragma mark - Service

- (void)reload {
    [self recalculateItemSize];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
}

- (void)recalculateItemSize {
    NSInteger itemsCount = self.isPhoneIdiom ? 2 : 3;
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        itemsCount = 4;
    }
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat emptySpaceBetweenItems = layout.minimumInteritemSpacing * (itemsCount - 1) + layout.sectionInset.left + layout.sectionInset.right;
	CGFloat safeAreaInsets = 0.0f;
    
	if (@available(iOS 11, *)) {
    	safeAreaInsets = self.collectionView.safeAreaInsets.left + self.collectionView.safeAreaInsets.right;
	}
    
    CGFloat width = (self.collectionView.bounds.size.width - safeAreaInsets - emptySpaceBetweenItems) / (CGFloat)itemsCount;
    
    width = floor(width);
    
    CGFloat height = (width * 4.0f) / 3.0f;
    
    self.generalItemSize = CGSizeMake(width, height);
}

#pragma mark - IANativeUnitControllerDelegate

- (UIViewController * _Nonnull)IAParentViewControllerForUnitController:(IAUnitController * _Nullable)unitController {
	return self;
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
	NSLog(@"video progress of content controller:%p updated with progress %.2f%%", contentController, (currentTime / totalTime) * 100);
}

#pragma mark - Dispose

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];

	NSLog(@"%@ deallocated", NSStringFromClass(self.class));
}

@end
