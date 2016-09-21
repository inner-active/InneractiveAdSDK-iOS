//
//  InneractivePositioningPicker.h
//  InneractiveAdSample
//
//  Created by Nikita Fedorenko on 11/19/14.
//  Copyright (c) 2014 Inneractive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InneractiveAdSDK.h"

@class InneractivePositioningPicker;

@protocol InneractivePositioningPickerDelegate <NSObject>

@required
- (void)positioningPickerSelected:(InneractivePositioningPicker *)picker;
- (void)positioningPickerCancelled:(InneractivePositioningPicker *)picker;

@end

@interface InneractivePositioningPicker : NSObject

@property (nonatomic, weak) id<InneractivePositioningPickerDelegate> delegate;

- (id)initWithMaxPositions:(NSUInteger)maxPositions delegate:(id<InneractivePositioningPickerDelegate>)delegate nativeAd:(IaNativeAd *)nativeAd;

- (void)showFromView:(UIView *)view;
- (void)dismiss;

@end
