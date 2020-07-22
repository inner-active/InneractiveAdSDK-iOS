//
//  CustomAdsViewController.h
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 05/07/2020.
//  Copyright © 2020 Fyber. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CustomAdsViewControllerDelegate <NSObject>

@required
- (void)updateServer:(NSString *)server database:(NSString *)database mockResponse:(NSString *)mockResponse;

@end

@interface CustomAdsViewController : UITableViewController

@property (weak, nonatomic) id <CustomAdsViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
