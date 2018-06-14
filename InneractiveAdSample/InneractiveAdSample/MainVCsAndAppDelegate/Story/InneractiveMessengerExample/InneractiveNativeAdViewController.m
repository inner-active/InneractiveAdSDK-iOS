//
//  InneractiveNativeAdViewController.m
//  InneractiveAdSample
//
//  Created by Nikita Fedorenko on 24/11/14.
//  Copyright (c) 2014 Inneractive. All rights reserved.
//

#import "InneractiveNativeAdViewController.h"

#import "InneractiveViewForNativeAd.h"
#import "iToast.h"

@interface InneractiveNativeAdViewController ()

@property (nonatomic, strong) InneractiveMessageTextField *messageTextField;
@property (nonatomic, strong) UITableView *messagesTableView;
@property (nonatomic, strong) NSMutableArray *messagesArray;

@property (nonatomic, strong) IaNativeAd *nativeAd;
@property (nonatomic, strong) InneractiveViewForNativeAd *adContainerView;

@end

@implementation InneractiveNativeAdViewController {
    BOOL _keyboardIsUp;
    NSTimeInterval _keyboardTransitionDuration;
    CGFloat _keyboardHeight;
    BOOL _adLoaded;
    BOOL _adPresented;
    BOOL _initialAutoFetchFlag;
    BOOL _isVideoCompleted;
}

#pragma mark - Inits

- (void)initAdContainerView {
    self.adContainerView = [[InneractiveViewForNativeAd alloc] init];
    self.adContainerView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.adContainerView.translatesAutoresizingMaskIntoConstraints = YES;
    [self.adContainerView.closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.adContainerView.hidden = YES;
    [self.view addSubview:self.adContainerView];
}

- (void)initMessageTextField {
    InneractiveMessageTextField *messengerTextField = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(InneractiveMessageTextField.class) owner:nil options:nil] objectAtIndex:0];
    
    messengerTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    messengerTextField.translatesAutoresizingMaskIntoConstraints = YES;
    
    messengerTextField.frame = CGRectMake(
                                         0.0f,
                                         self.view.frame.size.height - messengerTextField.frame.size.height,
                                         self.view.frame.size.width,
                                         messengerTextField.frame.size.height);
    
    messengerTextField.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.messageTextField = messengerTextField;
    [self.view addSubview:messengerTextField];
}

- (void)initMessagesTableView {
    CGRect frame = CGRectMake(
                              0.0f,
                              0.0f,
                              self.view.frame.size.width,
                              self.view.frame.size.height - self.messageTextField.frame.size.height);
    UITableView *table = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    
    table.autoresizingMask =  UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    table.translatesAutoresizingMaskIntoConstraints = YES;
    table.clipsToBounds = YES;
    
    table.dataSource = self;
    table.delegate = self;
    table.rowHeight = 28.0f;
    table.tableFooterView = [[UIView alloc] init];
    [table registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapped)];

    [table addGestureRecognizer:tapGestureRecognizer];
    
    self.messagesArray = [NSMutableArray arrayWithObject:NSLocalizedString(@"Type something in the edit box below and click \"Send\"", @"")];
    self.messagesTableView = table;
    [self.view addSubview:table];
}

- (void)initAndLoadNativeAd {
    NSString *const sampleAppIdString = @"MyCompany_MyApp";
    
    self.nativeAd = [[IaNativeAd alloc] initWithAppId:sampleAppIdString adType:IaAdType_NativeAd delegate:self];
    
    // Setting requirements for ads
    self.nativeAd.adConfig.nativeAdAssetsDescription.titleAssetPriority = IaNativeAdAssetPriorityRequired;
    self.nativeAd.adConfig.nativeAdAssetsDescription.imageIconAssetPriority = IaNativeAdAssetPriorityNone;
    self.nativeAd.adConfig.nativeAdAssetsDescription.callToActionTextAssetPriority = IaNativeAdAssetPriorityOptional;
    self.nativeAd.adConfig.nativeAdAssetsDescription.descriptionTextAssetPriority = IaNativeAdAssetPriorityRequired;
    
    self.nativeAd.isMuted = NO;
    
    [[InneractiveAdSDK sharedInstance] loadAd:self.nativeAd];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _initialAutoFetchFlag = [InneractiveAdSDK sharedInstance].sdkConfig.disableAutoFetch;
    [InneractiveAdSDK sharedInstance].sdkConfig.disableAutoFetch = YES; // Disable ads autorefreshing so they would be refreshed only after reloadAd call
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initAdContainerView];
    [self initMessageTextField];
    [self initMessagesTableView];
    
    [self initAndLoadNativeAd];
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

#pragma mark - InneractiveMessageTextFieldDelegate

- (void)sendPressedWithMessage:(NSString *)message {
    [self.messagesArray addObject:message];
    [self.messagesTableView reloadData];
    [self showAd];
}

- (void)textFieldDidBeginEditing {
    [self hideAd];
}

#pragma mark - InneractiveAdDelegate

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (void)InneractiveAdLoaded:(IaNativeAd *)nativeAd {
    _adLoaded = YES;
    
    _isVideoCompleted = NO;
    
    if (_adPresented) {
        [self.adContainerView switchToAdMode];//in case there was test mode
        if([self.nativeAd isVideoAd]) {
            [self.nativeAd playVideo];// Play video ad when it appears on the screen. Otherwise it will be paused waiting for user interaction.
        }
    }
    
    NSLog(@"NativeAdViewController - InneractiveAdLoaded: %@", nativeAd);
}

- (void)InneractiveAdFailedWithError:(NSError *)error withAdView:(IaNativeAd *)nativeAd {
    if(!_adLoaded){
        [self.adContainerView switchToTempMode];
    }
    
    NSLog(@"NativeAdViewController - InneractiveAdFailedWithError: %@.", error);
    [[iToast makeText:[NSString stringWithFormat:@"InneractiveAdFailed Event Received\n%@", [error localizedDescription]]] show];
}

- (void)InneractiveVideoCompleted:(IaAd *)ad {
    _isVideoCompleted = YES;
}

- (void)InneractiveAdAppShouldResume:(IaAdView*)adView {
    NSLog(@"NativeAdViewController - InneractiveAdAppShouldResume");
}

- (void)InneractiveAdAppShouldSuspend:(IaAd *)adView {
    NSLog(@"NativeAdViewController - InneractiveAdAppShouldSuspend");
}

#pragma mark - Service

- (void)tableViewTapped {
    [self.messageTextField resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    keyboardFrame = [self.view convertRect:keyboardFrame fromView:self.view.window];
    CGFloat newKeyboardSize = keyboardFrame.size.height;
    CGFloat keyboardSizeOffset = _keyboardHeight - newKeyboardSize;
    
    _keyboardHeight = newKeyboardSize;
    
    //keyboard size did change; iOS 9 has different flow
    if (_keyboardIsUp && ((keyboardSizeOffset != 0.0f) || ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f))) {
        self.messageTextField.frame = CGRectMake(
                                                 self.messageTextField.frame.origin.x,
                                                 self.messageTextField.frame.origin.y + keyboardSizeOffset,
                                                 self.messageTextField.bounds.size.width,
                                                 self.messageTextField.bounds.size.height);
        
        self.messagesTableView.frame = CGRectMake(
                                                  self.messagesTableView.frame.origin.x,
                                                  self.messagesTableView.frame.origin.y,
                                                  self.messagesTableView.bounds.size.width,
                                                  self.messagesTableView.bounds.size.height + keyboardSizeOffset);
    } else {//keyboard was hidden
        _keyboardIsUp = YES;
        _keyboardTransitionDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        [UIView animateWithDuration:_keyboardTransitionDuration animations:^{
            self.messageTextField.frame = CGRectMake(
                                                     self.messageTextField.frame.origin.x,
                                                     self.messageTextField.frame.origin.y - self->_keyboardHeight,
                                                     self.messageTextField.bounds.size.width,
                                                     self.messageTextField.bounds.size.height);
            
            self.messagesTableView.frame = CGRectMake(
                                                      self.messagesTableView.frame.origin.x,
                                                      self.messagesTableView.frame.origin.y,
                                                      self.messagesTableView.bounds.size.width,
                                                      self.messagesTableView.bounds.size.height - self->_keyboardHeight);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _keyboardIsUp = NO;
    
    NSDictionary *info = [notification userInfo];
    
    _keyboardTransitionDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:_keyboardTransitionDuration animations:^{
        self.messageTextField.frame = CGRectMake(
                                                 self.messageTextField.frame.origin.x,
                                                 self.messageTextField.frame.origin.y + self->_keyboardHeight,
                                                 self.messageTextField.bounds.size.width,
                                                 self.messageTextField.bounds.size.height);
        
        self.messagesTableView.frame = CGRectMake(
                                                  self.messagesTableView.frame.origin.x,
                                                  self.messagesTableView.frame.origin.y,
                                                  self.messagesTableView.bounds.size.width,
                                                  self.messagesTableView.bounds.size.height + self->_keyboardHeight);
    }];
}

- (void)showAd {
    if (!_adPresented) {
        _adPresented = YES;
        [[InneractiveAdSDK sharedInstance] showNativeAd:self.nativeAd atView:self.adContainerView];
        
        self.adContainerView.frame = CGRectMake(
                                                self.adContainerView.frame.origin.x,
                                                -self.adContainerView.bounds.size.height,
                                                self.adContainerView.bounds.size.width,
                                                self.adContainerView.bounds.size.height);
        self.adContainerView.hidden = NO;
        [self.view bringSubviewToFront:self.adContainerView];
        
        [UIView animateWithDuration:_keyboardTransitionDuration animations:^{
            self.adContainerView.frame = CGRectMake(
                                                    self.adContainerView.frame.origin.x,
                                                    0.0f,
                                                    self.adContainerView.bounds.size.width,
                                                    self.adContainerView.bounds.size.height);
        } completion:^(BOOL finished) {
            if([self.nativeAd isVideoAd]) {
                [self.nativeAd playVideo]; // Play video ad when it appears on the screen. Otherwise it will be paused waiting for user interaction.
            }
        }];
    }
    
    //check whether the ad has been loaded
    if (_adLoaded) {//if yes, show it in "normal" mode
        [self.adContainerView switchToAdMode];
    } else {//if no, show temporary view just for test purpose
        [self.adContainerView switchToTempMode];
    }
}

- (void)hideAd{
    if(_adPresented){
        _adPresented = NO;
        
        if (_isVideoCompleted || ![self.nativeAd isVideoAd]) {
            [self.nativeAd reloadAd];
        }
        
        if([self.nativeAd isVideoAd]) {
            [self.nativeAd pauseVideo]; // Pause video when it moves off the screen
        }
    
        [UIView animateWithDuration:_keyboardTransitionDuration animations:^{
            self.adContainerView.frame = CGRectMake(
                                                    self.adContainerView.frame.origin.x,
                                                    -self.adContainerView.bounds.size.height,
                                                    self.adContainerView.bounds.size.width,
                                                    self.adContainerView.bounds.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)closeButtonPressed:(UIButton *)button {
    [self hideAd];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Memory management

- (void)dealloc {
    [InneractiveAdSDK sharedInstance].sdkConfig.disableAutoFetch = _initialAutoFetchFlag;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
