//
//  InneractiveFeedDataProvider.m
//  InneractiveAdSample
//
//  Created by Alexey Karzov on 6/10/15.
//  Copyright (c) 2015 Inneractive. All rights reserved.
//

#import "InneractiveFeedDataProvider.h"

@interface InneractiveFeedDataProvider ()

@property (nonatomic, strong) NSMutableArray *profileImagesArray;
@property (nonatomic, strong) NSArray *namesArray;
@property (nonatomic, strong) NSMutableArray *imagesArray;

@end

@implementation InneractiveFeedDataProvider{
    int _feedObjectsCount;
}

#pragma mark - Singleton methods

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    static InneractiveFeedDataProvider *_sharedInstance = nil;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[InneractiveFeedDataProvider alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark - Inits

- (id)init {
    self = [super init];
    
    if (self) {
        _feedObjectsCount = 18;
        
        _namesArray = @[
                        @"Joshua Harris",
                        @"Terry Weaver",
                        @"Fred Richardson",
                        @"Zachary James",
                        @"Kerry Porter",
                        @"Armando Schwartz",
                        @"April Frazier",
                        @"Jesus Poole",
                        @"Patrick Bryant",
                        @"Bonnie Neal",
                        @"Charles Lawson",
                        @"Sheri Reed",
                        @"Ashley Carter",
                        @"Katie Goodwin",
                        @"David Morgan",
                        @"Jasmine Casey",
                        @"Dan Houston",
                        @"Drew Jackson"];
        
        _profileImagesArray = [NSMutableArray arrayWithCapacity:_feedObjectsCount];
        _imagesArray = [NSMutableArray arrayWithCapacity:_feedObjectsCount];
        
        for (int i = 0; i < _feedObjectsCount; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%02d@2x", i];
            NSString *profileImageName = [NSString stringWithFormat:@"%02dp@2x", i];
            NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
            NSString *profileImagePath = [[NSBundle mainBundle] pathForResource:profileImageName ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            UIImage *profileImage = [UIImage imageWithContentsOfFile:profileImagePath];
            
            [_imagesArray addObject:image];
            [_profileImagesArray addObject:profileImage];
        }
    }
    
    return self;
}

- (int)feedObjectsCount {
    return _feedObjectsCount;
}

- (UIImage *)profileImageAtIndex:(NSInteger)index {
    index = [self normalizeIndex:index];
    
    return self.profileImagesArray[index];
}

- (NSString *)nameAtIndex:(NSInteger)index {
    index = [self normalizeIndex:index];
    
    return self.namesArray[index];
}

- (UIImage *)imageAtIndex:(NSInteger)index {
    index = [self normalizeIndex:index];
    
    return self.imagesArray[index];
}

- (int)randomCount {
    return [self randomWithLowerBound:10 upperBound:99];
}

- (NSString *)randomTime {
    int hour = [self randomWithLowerBound:10 upperBound:23];
    int minute = [self randomWithLowerBound:10 upperBound:59];
    NSString *timeString = [NSString stringWithFormat:@"%d:%d", hour, minute];
    
    return timeString;
}

#pragma mark - Service

- (int)randomWithLowerBound:(int)lowerBound upperBound:(int)upperBound {
    return lowerBound + arc4random() % (upperBound - lowerBound);
}

- (NSInteger)normalizeIndex:(NSInteger)index {
    if (index < 0) {
        index = 0;
    }
    
    if (index >= _feedObjectsCount) {
        index %= _feedObjectsCount;
    }
    
    return index;
}

@end
