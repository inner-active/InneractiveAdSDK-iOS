//
//  InneractiveNativeAdStoryCollectionViewController.m
//  InneractiveAdSample
//
//  Created by Nikita Fedorenko on 24/3/15.
//  Copyright (c) 2015 Inneractive. All rights reserved.
//

#import "InneractiveNativeAdStoryCollectionViewController.h"

#import "InneractiveFeedDataProvider.h"
#import "InneractiveFeedCollectionCell.h"
#import "InneractiveNativeAdCollectionCell.h"
#import "iToast.h"

@interface InneractiveNativeAdStoryCollectionViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) IaNativeAd *nativeAd;
@property (nonatomic, strong) NSMutableDictionary *adsIndexesDictionary;

@end

@implementation InneractiveNativeAdStoryCollectionViewController {
    int _adStartPosition;
    int _adRepeatingInterval;
    int _initialFeedCount;
    CGSize _generalItemSize;
    BOOL _isPhoneIdiom;
}

#pragma mark - Inits

- (void)initCollectionView; {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumInteritemSpacing = 4.0;
    layout.minimumLineSpacing = 4.0;
    layout.sectionInset = UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                          collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    collectionView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    collectionView.translatesAutoresizingMaskIntoConstraints = YES;
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(InneractiveFeedCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(InneractiveFeedCollectionCell.class)];
    [collectionView registerClass:InneractiveNativeAdCollectionCell.class forCellWithReuseIdentifier:NSStringFromClass(InneractiveNativeAdCollectionCell.class)];
    
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
}

- (void)initAd {
    NSString *const kSampleAppIdString = @"MyCompany_MyApp";
    
    self.nativeAd = [[IaNativeAd alloc] initWithAppId:kSampleAppIdString adType:IaAdType_InFeedNativeAd delegate:self];
    
    // Setting requirements for ads
    self.nativeAd.adConfig.nativeAdAssetsDescription.titleAssetPriority = IaNativeAdAssetPriorityRequired;
    self.nativeAd.adConfig.nativeAdAssetsDescription.imageIconAssetPriority = IaNativeAdAssetPriorityNone;
    self.nativeAd.adConfig.nativeAdAssetsDescription.callToActionTextAssetPriority = IaNativeAdAssetPriorityOptional;
    self.nativeAd.adConfig.nativeAdAssetsDescription.descriptionTextAssetPriority = IaNativeAdAssetPriorityNone;
     
    [[InneractiveAdSDK sharedInstance] loadAd:self.nativeAd];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isPhoneIdiom = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initCollectionView];
    [self initAd];
    [self manageIndexes];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self recalculateItemSize];
    [self.collectionView.collectionViewLayout invalidateLayout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationDidChange:(NSNotification *)notification {
    [self recalculateItemSize];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - Ads management

- (void)manageIndexes {
    if (self.nativeAd) {
        //this is just example; those are just random indexes and management for the ads; it is possible to manage ads / feed indexes in a different way;
        _adStartPosition = 3;
        _adRepeatingInterval = _isPhoneIdiom ? 17 : 35;
        _initialFeedCount = 300;//can be any count, the source will be generated, always
        self.adsIndexesDictionary = [NSMutableDictionary dictionary];
        
        int overallCellsCount = _initialFeedCount + [self adsCountForIndex:_initialFeedCount - 1];
        
        for (int i = _adStartPosition; i < overallCellsCount; i += _adRepeatingInterval) {
            [self.adsIndexesDictionary setObject:self.nativeAd forKey:@(i)];
        }
    }
}

- (int)adsCountForIndex:(int)index {
    int result = 0;
    
    if (index > _adStartPosition) {
        result = ((index - _adStartPosition) / _adRepeatingInterval) + 1;
    }
    
    return result;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _initialFeedCount + self.adsIndexesDictionary.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *returnCell = nil;
    IaNativeAd *currentAd = [self.adsIndexesDictionary objectForKey:@(indexPath.row)];
    
    if (currentAd) {
        InneractiveNativeAdCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(InneractiveNativeAdCollectionCell.class) forIndexPath:indexPath];
        
        [[InneractiveAdSDK sharedInstance] showNativeAd:currentAd atCell:(InneractiveNativeAdCollectionCell *)cell];
        
        returnCell = cell;
    } else {
        int actualIndex = (int)indexPath.row - [self adsCountForIndex:(int)indexPath.row];
        InneractiveFeedCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(InneractiveFeedCollectionCell.class) forIndexPath:indexPath];
        
        cell.titleLabel.text = [[InneractiveFeedDataProvider sharedInstance] nameAtIndex:actualIndex];
        cell.feedImageView.image = [[InneractiveFeedDataProvider sharedInstance] imageAtIndex:actualIndex];
        cell.timeLabel.text = [[InneractiveFeedDataProvider sharedInstance] randomTime];
        cell.likesCountLabel.text = [NSString stringWithFormat:@"%d",[[InneractiveFeedDataProvider sharedInstance] randomCount]];
        cell.commentsCountLabel.text = [NSString stringWithFormat:@"%d",[[InneractiveFeedDataProvider sharedInstance] randomCount]];
        
        returnCell = cell;
    }
    
    return returnCell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_generalItemSize.width == 0.0f) {
        [self recalculateItemSize];
    }
    
    return _generalItemSize;
}

#pragma mark - InneractiveAdDelegate

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (void)InneractiveAdLoaded:(IaAd *)ad {
    NSLog(@"NativeAdStoryCollectionView - InneractiveAdLoaded: %@", ad);
}

- (void)InneractiveAdFailedWithError:(NSError*)error withAdView:(IaAdView *)ad {
    NSLog(@"NativeAdStoryCollectionView - InneractiveAdFailedWithError: %@.", error);
    [[iToast makeText:[NSString stringWithFormat:@"InneractiveAdFailed Event Received\n%@", [error localizedDescription]]] show];
}

- (void)InneractiveAdClicked:(IaAdView *)adView {
    NSLog(@"NativeAdStoryCollectionView - InneractiveAdClicked");
}

- (void)InneractiveAdAppShouldResume:(IaAdView *)adView {
    NSLog(@"NativeAdStoryCollectionView - InneractiveAdAppShouldResume");
}

- (void)InneractiveAdAppShouldSuspend:(IaAd *)adView {
    NSLog(@"NativeAdStoryCollectionView - InneractiveAdAppShouldSuspend");
}

#pragma mark - Service

- (void)recalculateItemSize {
    NSInteger itemsCount = _isPhoneIdiom ? 2 : 3;
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        itemsCount = 4;
    }
    
    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    CGFloat emptySpaceBetweenItems = layout.minimumInteritemSpacing * (itemsCount - 1) + layout.sectionInset.left + layout.sectionInset.right;
    CGFloat width = (self.collectionView.bounds.size.width - emptySpaceBetweenItems) / (CGFloat)itemsCount;
    width = floor(width);
    CGFloat height = (width * 4.0f) / 3.0f;
    
    _generalItemSize = CGSizeMake(width, height);
    
    //we need to update this, because UICollectionViewCell / UITableViewCell class, that conforms to protocol 'IaNativeAdCellRenderingDelegate'
    //must implement static method 'sizeForNativeAdCell', and because an item size in this specific example changes due to interface orientation
    [InneractiveNativeAdCollectionCell setSize:_generalItemSize];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
