//
//  IARegularAdVC.m
//  IASDKClient
//
//  Created by Inneractive on 15/02/2017.
//  Copyright © 2017 Inneractive. All rights reserved.
//

#import "IARegularAdVC.h"
#import <IASDKCore/IASDKCore.h>
#import <IASDKVideo/IASDKVideo.h>
#import <IASDKMRAID/IASDKMRAID.h>

@interface IARegularAdVC () <IAUnitDelegate, IAVideoContentDelegate, IAMRAIDContentDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIButton *loadAdButton;
@property (nonatomic, weak) IBOutlet UIButton *showAdButton;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, strong, nonnull) IAViewUnitController *viewUnitController;

@property (nonatomic, strong, nonnull) IAFullscreenUnitController *fullscreenUnitController;

@property (nonatomic, strong, nonnull) IAMRAIDContentController *MRAIDContentController;
@property (nonatomic, strong, nonnull) IAVideoContentController *videoContentController;

@property (nonatomic, strong, nonnull) NSLayoutConstraint *adViewWidthConstraint;
@property (nonatomic, strong, nonnull) NSLayoutConstraint *adViewHeightConstraint;

@property (nonatomic, strong) IAAdSpot *adSpot;
@property (nonatomic, weak) IAAdView *adView;

@end

@implementation IARegularAdVC {}

#pragma mark - Inneractive SDK usecases examples

- (void)loadAd {
    [self.adView removeFromSuperview]; // in case 'load' button was pressed after ad is already presented;
    self.adView = nil;

    IAUserData *userData = [IAUserData build:^(id<IAUserDataBuilder>  _Nonnull builder) {
        builder.age = 34;
        builder.gender = IAUserGenderTypeMale;
        builder.zipCode = @"90210";
    }];

    NSString *spotID = nil; // is mandatory;

    if (self.requestedAdType == SampleAdTypeBanner) {
        spotID = @"150942"; // banner;
    } else if (self.requestedAdType == SampleAdTypeRectangle) {
        spotID = @"150943"; // mrect: 150943 for HTML/MRAID, 150945 for video/VPAID;
    } else if (self.requestedAdType == SampleAdTypeSquare) {
        spotID = @"150948"; // square;
    } else if (self.requestedAdType == SampleAdTypeLandscape) {
        spotID = @"150947"; // landscape;
    } else if (self.requestedAdType == SampleAdTypeInterstitial) {
        spotID = @"150946"; // interstitial;
    } else if (self.requestedAdType == SampleAdTypeVertical) {
        spotID = @"150951"; // video;
    }

    IAAdRequest *request = [IAAdRequest build:^(id<IAAdRequestBuilder>  _Nonnull builder) {
        builder.useSecureConnections = NO;
        builder.spotID = spotID;
        builder.timeout = 25;
        builder.userData = userData;
        builder.keywords = @"hell & brimstone + earthly/delight, diving,programming";
        builder.location = nil;
    }];

    _videoContentController = [IAVideoContentController build:^(id<IAVideoContentControllerBuilder>  _Nonnull builder) {
        builder.videoContentDelegate = self;
    }];

    _MRAIDContentController = [IAMRAIDContentController build:^(id<IAMRAIDContentControllerBuilder>  _Nonnull builder) {
        builder.MRAIDContentDelegate = self;
    }];

    _viewUnitController = [IAViewUnitController build:^(id<IAViewUnitControllerBuilder>  _Nonnull builder) {
        builder.unitDelegate = self;

        [builder addSupportedContentController:self.videoContentController];
        [builder addSupportedContentController:self.MRAIDContentController];
    }];

    _fullscreenUnitController = [IAFullscreenUnitController build:^(id<IAFullscreenUnitControllerBuilder>  _Nonnull builder) {
        builder.unitDelegate = self;

        [builder addSupportedContentController:self.videoContentController];
        [builder addSupportedContentController:self.MRAIDContentController];
    }];

    _adSpot = [IAAdSpot build:^(id<IAAdSpotBuilder>  _Nonnull builder) {
        builder.adRequest = request;
        [builder addSupportedUnitController:self.viewUnitController]; // 'self' can be used in builder block, this block is not retained; the concept is similar to iOS method 'enumerateObjectsUsingBlock:';
		[builder addSupportedUnitController:self.fullscreenUnitController];
    }];

    __weak typeof(self) weakSelf = self;

    [self.adSpot fetchAdWithCompletion:^(IAAdSpot * _Nullable adSpot, IAAdModel * _Nullable adModel, NSError * _Nullable error) { // 'self' should not be used in this block;
        [weakSelf renderAdWithSpot:adSpot model:adModel error:error];
    }];

    [self.adSpot setAdRefreshCompletion:^(IAAdSpot * _Nullable adSpot, IAAdModel * _Nullable adModel, NSError * _Nullable error) {
        [weakSelf renderAdWithSpot:adSpot model:adModel error:error];
    }];
}

- (void)renderAdWithSpot:(IAAdSpot * _Nullable)adSpot model:(IAAdModel * _Nullable)model error:(NSError * _Nullable)error {
    [self.spinner stopAnimating];
    self.spinner.hidden = YES;

    if (error) {
        NSLog(@"ad failed with error: %@", error.localizedDescription);
    } else {
        NSLog(@"ad succeeded");

        if (adSpot.activeUnitController == self.viewUnitController) {

            // the invocation of 'showAdInParentView:' is not needed on refresh, but will not make no trouble;
            // on refresh, IA SDK will use provided superview in order to add the ad to view hierarchy;
            [self.viewUnitController showAdInParentView:self.view];
            self.adView = self.viewUnitController.adView; // update the adView, it will change on each refresh; note: refresh is supported only in "view" unit and only with HTML/MRAID content;

            if (self.adView) {
                // *** here is a frame positioning example:
                //const CGFloat x = (self.view.bounds.size.width - self.adView.bounds.size.width) / 2.0;
                //self.adView.frame = CGRectMake(x, 0, self.adView.bounds.size.width, self.adView.bounds.size.height);

                // *** here is a constraints positioning example:
                self.adView.translatesAutoresizingMaskIntoConstraints = NO;

                // adding centerX constraint
                [self.view addConstraint:
                 [NSLayoutConstraint constraintWithItem:self.adView
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1
                                               constant:0]];

                // adding top constraint
                [self.view addConstraint:
                 [NSLayoutConstraint constraintWithItem:self.adView
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeTop
                                             multiplier:1
                                               constant:0]];
                       self.adViewWidthConstraint =
         [NSLayoutConstraint constraintWithItem:self.adView
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:nil
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:1
                                       constant:CGRectGetWidth(self.adView.frame)];
		self.adViewWidthConstraint.active = YES;

        self.adViewHeightConstraint =
         [NSLayoutConstraint constraintWithItem:self.adView
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:nil
                                      attribute:NSLayoutAttributeHeight
                                     multiplier:1
                                       constant:CGRectGetHeight(self.adView.frame)];
		self.adViewHeightConstraint.active = YES;

                // note: that adView is a new object after each refresh;
            }

        } else if (adSpot.activeUnitController == self.fullscreenUnitController) {
            self.showAdButton.hidden = NO;
        }

        if ([adSpot.activeUnitController.activeContentController isKindOfClass:IAVideoContentController.class]) { // 'is video ad' check;
            IAVideoContentController *videoContentController = (IAVideoContentController *)adSpot.activeUnitController.activeContentController;

            videoContentController.videoContentDelegate = self;
            videoContentController.muted = YES;
        }
    }
}

- (void)showInterstitial {
	self.showAdButton.hidden = YES;
	[self.fullscreenUnitController showAdAnimated:YES completion:nil];
}

#pragma mark - IAUnitDelegate

- (UIViewController * _Nonnull)IAParentViewControllerForUnitController:(IAUnitController * _Nullable)unitController {
    return self;
}

- (void)IAAdDidReceiveClick:(IAUnitController * _Nullable)unitController {
    NSLog(@"ad clicked;");
}

- (void)IAAdWillLogImpression:(IAUnitController * _Nullable)unitController {
    NSLog(@"ad ipmression;");
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

// TODO: ensure in interstitial is not being called several times, e.g: in-app browser dismissed -> interstitial itself dismissed;
- (void)IAUnitControllerDidDismissFullscreen:(IAUnitController * _Nullable)unitController {
    NSLog(@"IAUnitControllerDidDismissFullscreen");
    self.showAdButton.hidden = YES;
}

- (void)IAUnitControllerWillOpenExternalApp:(IAUnitController * _Nullable)unitController {
    NSLog(@"IA will open external app;");
}

#pragma mark - IAVideoContentDelegate

- (void)IAVideoCompleted:(IAVideoContentController * _Nullable)contentController {
    NSLog(@"IAVideoCompleted");
}

- (void)IAVideoContentController:(IAVideoContentController * _Nullable)contentController videoInterruptedWithError:(NSError *)error {
    NSLog(@"videoInterruptedWithError");
}

- (void)IAVideoContentController:(IAVideoContentController * _Nullable)contentController videoDurationUpdated:(NSTimeInterval)videoDuration {
    NSLog(@"videoDurationUpdated");
}

- (void)IAVideoContentController:(IAVideoContentController * _Nullable)contentController videoProgressUpdatedWithCurrentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
	//NSLog(@"videoProgressUpdatedWithCurrentTime: %.2f totalTime: %.2f", currentTime, totalTime);
}

#pragma mark - IAMRAIDContentDelegate

- (void)IAMRAIDContentController:(IAMRAIDContentController * _Nullable)contentController MRAIDAdWillResizeToFrame:(CGRect)frame {
    NSLog(@"MRAIDAdWillResizeToFrame");
}

- (void)IAMRAIDContentController:(IAMRAIDContentController * _Nullable)contentController MRAIDAdDidResizeToFrame:(CGRect)frame {
    NSLog(@"MRAIDAdDidResizeToFrame");
}

- (void)IAMRAIDContentController:(IAMRAIDContentController * _Nullable)contentController MRAIDAdWillExpandToFrame:(CGRect)frame {
    NSLog(@"MRAIDAdWillExpandToFrame");
}

- (void)IAMRAIDContentController:(IAMRAIDContentController * _Nullable)contentController MRAIDAdDidExpandToFrame:(CGRect)frame {
    NSLog(@"MRAIDAdDidExpandToFrame");
}

- (void)IAMRAIDContentControllerMRAIDAdWillCollapse:(IAMRAIDContentController * _Nullable)contentController {
    NSLog(@"IAMRAIDContentControllerMRAIDAdWillCollapse");
}

- (void)IAMRAIDContentControllerMRAIDAdDidCollapse:(IAMRAIDContentController * _Nullable)contentController {
    NSLog(@"IAMRAIDContentControllerMRAIDAdDidCollapse");
}

- (void)IAMRAIDContentController:(IAMRAIDContentController * _Nullable)contentController videoInterruptedWithError:(NSError * _Nonnull)error {
    NSLog(@"IAMRAIDContentController:videoInterruptedWithError: %@", error);
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;


    self.spinner.hidden = YES;
    self.showAdButton.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - IB

- (IBAction)loadAdPressed:(UIButton *)sender {
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    self.showAdButton.hidden = YES;

    [self loadAd];
}

- (IBAction)showAdPressed:(UIButton *)sender {
    if ((self.requestedAdType == SampleAdTypeInterstitial) || (self.requestedAdType == SampleAdTypeVertical)) {
        [self showInterstitial];
    }
}

#pragma mark - Dispose

- (void)dealloc {
    NSLog(@"%@ deallocated", NSStringFromClass(self.class));
}

@end
