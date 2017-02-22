//
//  BaseViewController.m
//  InneractiveAdSample
//
//  Created by Nikita Fedorenko on 10/28/14.
//  Copyright (c) 2014 Inneractive. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController {}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - Service

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
