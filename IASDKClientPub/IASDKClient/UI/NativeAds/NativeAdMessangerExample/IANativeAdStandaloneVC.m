//
//  IANativeAdStandaloneVC.m
//  IASDKClient
//
//  Created by Inneractive on 09/03/2017.
//  Copyright (c) 2017 Inneractive. All rights reserved.
//

#import "IANativeAdStandaloneVC.h"

#import <IASDKCore/IASDKCore.h>
#import <IASDKVideo/IASDKVideo.h>
#import <IASDKNative/IASDKNative.h>

#import "IAContainerViewForNativeAd.h"

@interface IANativeAdStandaloneVC () <IANativeUnitControllerDelegate, IAVideoContentDelegate, IANativeContentDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet IAMessageTextField *messageTextField;
@property (nonatomic, weak) IBOutlet UITableView *messagesTableView;
@property (nonatomic, strong) NSMutableArray *messagesArray;

@property (nonatomic, strong) IAContainerViewForNativeAd *adContainerView;

@property (nonatomic, strong) IAAdSpot *adSpot;
@property (nonatomic, strong) IANativeUnitController *nativeUnitController;
@property (nonatomic, strong) IANativeContentController *nativeContentController;

@property (nonatomic) BOOL adLoaded;
@property (nonatomic) BOOL adPresented;
@property (nonatomic) BOOL isVideoCompleted;
@property (nonatomic) BOOL isImpressionFired;

@property (nonatomic) BOOL keyboardIsUp;
@property (nonatomic) NSTimeInterval keyboardTransitionDuration;
@property (nonatomic) CGFloat keyboardHeight;
@property (nonatomic, weak, nullable) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation IANativeAdStandaloneVC {}

#pragma mark - Inits

- (void)initAdContainerView {
    self.adContainerView = [[IAContainerViewForNativeAd alloc] init];
    self.adContainerView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.adContainerView.translatesAutoresizingMaskIntoConstraints = YES;
    [self.adContainerView.closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.adContainerView.hidden = YES;
    [self.view addSubview:self.adContainerView];
}

- (void)customizeMessagesTableView {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapped)];

    [self.messagesTableView addGestureRecognizer:tapGestureRecognizer];
    
    self.messagesArray = [NSMutableArray arrayWithObject:NSLocalizedString(@"Type something in the edit box below and click \"Send\"", @"")];
}

- (void)initMessageTextField {
    self.messageTextField.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)initAndLoadNativeAd {
    // TODO: ?clean if reloading
    
    // we need to be notified on this event, since the playback mangement is manual in this scenario:
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    IAUserData *userData = [IAUserData build:^(id<IAUserDataBuilder>  _Nonnull builder) {
        builder.age = 34;
        builder.gender = IAUserGenderTypeMale;
        builder.zipCode = @"90210";
    }];

    IANativeAdDescription *nativeAdDescription = [IANativeAdDescription build:^(id<IANativeAdDescriptionBuilder>  _Nonnull builder) {
        builder.assetsDescription.titleAssetPriority = IANativeAdAssetPriorityRequired;
        builder.nativeAdMainAssetMinWidth = 100;
        builder.nativeAdMainAssetMinHeight = 100;
        builder.maxBitrate = 8192;
    }];
    
    IAAdRequest *request = [IAAdRequest build:^(id<IAAdRequestBuilder>  _Nonnull builder) {
        builder.useSecureConnections = NO;
        builder.spotID = @"150950"; // native video;
        builder.timeout = 35;
        builder.userData = userData;
        builder.subtypeDescription = nativeAdDescription;
        builder.keywords = @"diving, programming";
        builder.location = nil;
        builder.autoLocationUpdateEnabled = YES;
    }];
    
    _nativeContentController = [IANativeContentController build:^(id<IANativeContentControllerBuilder>  _Nonnull builder) {
        builder.videoContentDelegate = self;
        builder.nativeContentDelegate = self;
    }];
    
    _nativeUnitController = [IANativeUnitController build:^(id<IANativeUnitControllerBuilder>  _Nonnull builder) {
        builder.unitDelegate = self;
        
        [builder addSupportedContentController:self.nativeContentController];
    }];

    _adSpot = [IAAdSpot build:^(id<IAAdSpotBuilder>  _Nonnull builder) {
        builder.adRequest = request;
        [builder addSupportedUnitController:self.nativeUnitController]; // 'self' can be used in builder block, this block is not retained; the concept is similar to iOS method 'enumerateObjectsUsingBlock:';
    }];
	
	self.isImpressionFired = NO;
	
    __weak typeof(self) weakSelf = self;
    
    [self.adSpot fetchAdWithCompletion:^(IAAdSpot * _Nullable adSpot, IAAdModel * _Nullable adModel, NSError * _Nullable error) { // 'self' should not be used in this block;
        if (error) {
            NSLog(@"ad failed with error: %@", error.localizedDescription);
            
            if (!weakSelf.adLoaded){
                [weakSelf.adContainerView switchToTempMode];
            }
        } else {
            NSLog(@"ad succeeded");
            
            weakSelf.adLoaded = YES;
            weakSelf.isVideoCompleted = NO;
            
            if (adSpot.activeUnitController == weakSelf.nativeUnitController) {
                [weakSelf.nativeUnitController showAdInNativeRenderer:weakSelf.adContainerView];
            }
            
            if ([adSpot.activeUnitController.activeContentController isKindOfClass:IANativeContentController.class]) { // 'is native ad' check;
                // Here is an example, how to determine content controller responsible for received ad;
                
                // IANativeContentController *nativeContentController = (IANativeContentController *)adSpot.activeUnitController.activeContentController;
            }
            
            [weakSelf.adContainerView switchToAdMode];
        }
    }];
}

#pragma mark - IANativeUnitControllerDelegate

- (UIViewController * _Nonnull)IAParentViewControllerForUnitController:(IAUnitController * _Nullable)unitController {
    return self;
}

- (void)IAAdDidReceiveClick:(IAUnitController * _Nullable)unitController {
    NSLog(@"ad clicked;");
}

- (void)IAAdWillLogImpression:(IAUnitController * _Nullable)unitController {
	self.isImpressionFired = YES;
}

- (void)IAUnitControllerDidDismissFullscreen:(IAUnitController * _Nullable)unitController {
	NSLog(@"IAUnitControllerDidDismissFullscreen");
	if (!self.adPresented) {
		[self showAd];
	} else {
		// Invoke 'play' manualy, since in this scenario we are showing a manual management:
		[self.nativeContentController play];
	}

}

#pragma mark - IAVideoContentDelegate

- (void)IAVideoCompleted:(IAVideoContentController * _Nullable)contentController {
    self.isVideoCompleted = YES;
}

- (void)IAVideoContentController:(IAVideoContentController * _Nullable)contentController videoInterruptedWithError:(NSError * _Nonnull)error {
    NSLog(@"video interrupted");
}

- (void)IAVideoContentController:(IAVideoContentController * _Nullable)contentController videoDurationUpdated:(NSTimeInterval)videoDuration {
    NSLog(@"video duration updated: %.2lf", videoDuration);
}

- (void)IAVideoContentController:(IAVideoContentController * _Nullable)contentController videoProgressUpdatedWithCurrentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    self.isVideoCompleted = NO;
    
    NSLog(@"video progress: %d%%", (int)((currentTime / totalTime) * 100.0));
}

#pragma mark - App lifecycle

- (void)appDidBecomeActive:(NSNotification *)notification {
    if (!self.adPresented) {
        [self showAd];
    } else {
        // App did become active; invoke 'play' manualy, since in this scenario we are showing a manual management:
        [self.nativeContentController play];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// we need to be notified on this event, since the playback mangement is manual in this scenario:
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];

    self.navigationController.interactivePopGestureRecognizer.delegate = self;
	
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self initAdContainerView];
    [self customizeMessagesTableView];
    [self initMessageTextField];
    [self initAndLoadNativeAd];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    
    NSString *message = self.messagesArray[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    cell.textLabel.text = message;
    
    return cell;
}

#pragma mark - IAMessageTextFieldDelegate

- (void)sendPressedWithMessage:(NSString *)message {
    [self.messagesArray addObject:message];
    [self.messagesTableView reloadData];
    [self showAd];
}

- (void)textFieldDidBeginEditing {
    [self hideAd];
}

#pragma mark - Service

- (void)tableViewTapped {
    [self.messageTextField resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [self hideAd];
    
    NSDictionary *info = [notification userInfo];
    CGRect keyboardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    keyboardFrame = [self.view convertRect:keyboardFrame fromView:self.view.window];
    
    CGFloat newKeyboardSize = keyboardFrame.size.height;
    CGFloat keyboardSizeOffset = self.keyboardHeight - newKeyboardSize;
    
    self.keyboardHeight = newKeyboardSize;
    
    // keyboard size did change; iOS 9 has different flow;
    if (self.keyboardIsUp && ((keyboardSizeOffset != 0) || ([UIDevice currentDevice].systemVersion.floatValue >= 9))) {
        self.bottomConstraint.constant -= keyboardSizeOffset;
    } else { // keyboard was hidden
        self.keyboardIsUp = YES;
        self.keyboardTransitionDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        __weak typeof(self) weakSelf = self;
        
        [UIView animateWithDuration:self.keyboardTransitionDuration animations:^{
            weakSelf.bottomConstraint.constant += weakSelf.keyboardHeight;
            weakSelf.messageTextField.frame = CGRectMake(
                                                         weakSelf.messageTextField.frame.origin.x,
                                                         weakSelf.messageTextField.frame.origin.y - weakSelf.keyboardHeight,
                                                         weakSelf.messageTextField.bounds.size.width,
                                                         weakSelf.messageTextField.bounds.size.height);
        } completion:^(BOOL finished) {
            [weakSelf.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.messagesArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardIsUp = NO;
    
    NSDictionary *info = [notification userInfo];
    __weak typeof(self) weakSelf = self;
    
    self.keyboardTransitionDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:self.keyboardTransitionDuration animations:^{
        weakSelf.bottomConstraint.constant = 0;
        weakSelf.messageTextField.frame = CGRectMake(
                                                     weakSelf.messageTextField.frame.origin.x,
                                                     weakSelf.messageTextField.frame.origin.y + weakSelf.keyboardHeight,
                                                     weakSelf.messageTextField.bounds.size.width,
                                                     weakSelf.messageTextField.bounds.size.height);
    }];
}

- (void)showAd {
    if (!self.adPresented) {
        self.adPresented = YES;
        
        // for some reason Xcode 10 shows warning on `frame` availability, hence suppressing it;
        #pragma GCC diagnostic push
        #pragma GCC diagnostic ignored "-Wunguarded-availability"
        self.adContainerView.frame = CGRectMake(
                                                self.adContainerView.frame.origin.x,
                                                -self.adContainerView.bounds.size.height,
                                                self.adContainerView.bounds.size.width,
                                                self.adContainerView.bounds.size.height);
        #pragma GCC diagnostic pop
        self.adContainerView.hidden = NO;
        [self.view bringSubviewToFront:self.adContainerView];
        
        __weak typeof(self) weakSelf = self;
        
        [UIView animateWithDuration:self.keyboardTransitionDuration animations:^{
            #pragma GCC diagnostic push
            #pragma GCC diagnostic ignored "-Wunguarded-availability"
            weakSelf.adContainerView.frame = CGRectMake(
                                                    weakSelf.adContainerView.frame.origin.x,
                                                    0.0f,
                                                    weakSelf.adContainerView.bounds.size.width,
                                                    weakSelf.adContainerView.bounds.size.height);
            #pragma GCC diagnostic pop
        } completion:^(BOOL finished) {
            if ([weakSelf.nativeContentController isVideoContent] && !weakSelf.isVideoCompleted) {
                [weakSelf.nativeContentController play];
            }
        }];
    }
    
    //check whether the ad has been loaded
    if (self.adLoaded) {//if yes, show it in "normal" mode
        [self.adContainerView switchToAdMode];
    } else {//if no, show temporary view just for test purpose
        [self.adContainerView switchToTempMode];
    }
}

- (void)hideAd {
    if (self.adPresented) {
        self.adPresented = NO;
		
		if ([self.nativeContentController isVideoContent] && self.isVideoCompleted) {
			// request new ad
			[self initAndLoadNativeAd];
		}
		else if (![self.nativeContentController isVideoContent] && self.isImpressionFired) {
			// request new ad
			[self initAndLoadNativeAd];
		}
		else {
        	[self.nativeContentController pause];
		}
		
        __weak typeof(self) weakSelf = self;
        
        [UIView animateWithDuration:self.keyboardTransitionDuration animations:^{
            // for some reason Xcode 10 shows warning on `frame` availability, hence suppressing it;
            #pragma GCC diagnostic push
            #pragma GCC diagnostic ignored "-Wunguarded-availability"
            weakSelf.adContainerView.frame = CGRectMake(
                                                        weakSelf.adContainerView.frame.origin.x,
                                                        -weakSelf.adContainerView.bounds.size.height,
                                                        weakSelf.adContainerView.bounds.size.width,
                                                        weakSelf.adContainerView.bounds.size.height);
            #pragma GCC diagnostic pop
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)closeButtonPressed:(UIButton *)button {
    [self hideAd];
}

#pragma mark - Memory management

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
