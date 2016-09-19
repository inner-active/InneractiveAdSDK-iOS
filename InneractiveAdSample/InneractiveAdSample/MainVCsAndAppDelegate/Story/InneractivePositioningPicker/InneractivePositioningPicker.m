//
//  InneractivePositioningPicker.m
//  InneractiveAdSample
//
//  Created by Nikita Fedorenko on 11/19/14.
//  Copyright (c) 2014 Inneractive. All rights reserved.
//

#import "InneractivePositioningPicker.h"

#import "InneractivePositioningPickerView.h"

#define kPickerViewStartPosition 0
#define kPickerViewRepeatingInterval 1

@interface InneractivePositioningPicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) NSUInteger maxPositions;
@property (nonatomic, strong) IaNativeAd *nativeAd;

@property (nonatomic, strong) InneractivePositioningPickerView *pickerView;

@end

@implementation InneractivePositioningPicker {}

#pragma mark - Inits

- (id)initWithMaxPositions:(NSUInteger)maxPositions delegate:(id<InneractivePositioningPickerDelegate>)delegate nativeAd:(IaNativeAd *)nativeAd {
    self = [super init];
    
    if (self) {
        _maxPositions = maxPositions;
        _delegate = delegate;
        _nativeAd = nativeAd;
        [self initPickerView];
    }
    
    return self;
}

- (void)initPickerView {
    _pickerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(InneractivePositioningPickerView.class) owner:nil options:nil] objectAtIndex:0];
    
    _pickerView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    _pickerView.translatesAutoresizingMaskIntoConstraints = YES;
    
    _pickerView.pickerView.delegate = self;
    _pickerView.pickerView.dataSource = self;
    
    [_pickerView.updateButton addTarget:self action:@selector(updatePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_pickerView.cancelButton addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [_pickerView.pickerView selectRow:_nativeAd.adConfig.nativeAdStartPosition inComponent:kPickerViewStartPosition animated:NO];
    [_pickerView.pickerView selectRow:_nativeAd.adConfig.nativeAdRepeatingInterval - 2 inComponent:kPickerViewRepeatingInterval animated:NO];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;//start position and repeating interval
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger count = 0;
    
    if (component == kPickerViewStartPosition) {
        count = self.maxPositions + 1;
    } else if (component == kPickerViewRepeatingInterval) {
        count = self.maxPositions + 1;
    }
    
    return count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = nil;
    
    if (component == kPickerViewStartPosition) {
        title = [NSString stringWithFormat:@"%ld", (long)row];
    } else if (component == kPickerViewRepeatingInterval) {
        title = [NSString stringWithFormat:@"%ld", (long)(row + 2)];
    }
    
    return title;
}

#pragma mark - Service

- (void)updatePressed:(UIButton *)sender {
    self.nativeAd.adConfig.nativeAdStartPosition = [self.pickerView.pickerView selectedRowInComponent:kPickerViewStartPosition];
    self.nativeAd.adConfig.nativeAdRepeatingInterval = [self.pickerView.pickerView selectedRowInComponent:kPickerViewRepeatingInterval] + 2;
    
    [self.delegate positioningPickerSelected:self];
}

- (void)cancelPressed:(UIButton *)sender {
    [self.delegate positioningPickerCancelled:self];
}

#pragma mark - API

- (void)showFromView:(UIView *)view {
    self.pickerView.alpha = 0.0f;
    self.pickerView.center = CGPointMake(CGRectGetWidth(view.bounds) / 2.0f, CGRectGetHeight(view.bounds) / 2.0f);
    [view addSubview:self.pickerView];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.pickerView removeFromSuperview];
    }];
}

@end
