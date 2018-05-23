//
//  IAFeedDataProvider.m
//  IASDKClient
//
//  Created by Inneractive on 09/03/2017.
//  Copyright (c) 2017 Inneractive. All rights reserved.
//

#import "IAFeedDataProvider.h"

@interface IAFeedDataProvider ()

@property (nonatomic, strong) NSMutableArray *profileImagesArray;
@property (nonatomic, strong) NSArray *namesArray;
@property (nonatomic, strong) NSMutableArray *imagesArray;

@end

@implementation IAFeedDataProvider{
    NSInteger _feedObjectsCount;
}

#pragma mark - Singleton methods

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    static IAFeedDataProvider *_sharedInstance = nil;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[IAFeedDataProvider alloc] init];
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
        
        for (NSInteger i = 0; i < _feedObjectsCount; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%02ld@2x", (long)i];
            NSString *profileImageName = [NSString stringWithFormat:@"%02ldp@2x", (long)i];
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

- (NSInteger)feedObjectsCount {
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

- (NSInteger)randomCount {
    return [self randomWithLowerBound:10 upperBound:99];
}

- (NSString *)randomTime {
    NSInteger hour = [self randomWithLowerBound:10 upperBound:23];
    NSInteger minute = [self randomWithLowerBound:10 upperBound:59];
    NSString *timeString = [NSString stringWithFormat:@"%ld:%ld", (long)hour, (long)minute];
    
    return timeString;
}

#pragma mark - Service

- (NSInteger)randomWithLowerBound:(NSInteger)lowerBound upperBound:(NSInteger)upperBound {
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
