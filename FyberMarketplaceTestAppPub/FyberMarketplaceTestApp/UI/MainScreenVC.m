//
//  MainScreenVC.m
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 15/02/2017.
//  Copyright © 2017 Fyber. All rights reserved.
//

#import "MainScreenVC.h"
#import "IARegularAdVC.h"
#import "IAColors.h"

@interface MainScreenVC ()

@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation MainScreenVC {}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UITableViewHeaderFooterView.appearance setTintColor:UIColor.systemPinkColor];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[self customizeBackButtonForNavigationItem:[segue.destinationViewController navigationItem]];
	
	if (![segue.identifier isEqualToString:@"ShowNativeAdWithManualManagement"] &&
		![segue.identifier isEqualToString:@"ShowMediationsSegue"]) {
	
		// Get the new view controller using [segue destinationViewController].
		// Pass the selected object to the new view controller.
		IARegularAdVC *VC = [segue destinationViewController];
		
		VC.requestedAdType = [[self.table indexPathForSelectedRow] row];
	}
}

- (void)customizeBackButtonForNavigationItem:(UINavigationItem *)navItem{	
	UIImage *buttonImage = [[UIImage imageNamed:@"Back-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:buttonImage style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    
	navItem.leftBarButtonItem = barButtonItem;
}

- (void)backPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sectionsCount = 2;
    
    return sectionsCount;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.textLabel.textColor = kIAColorsAquamarine;
    cell.textLabel.font = [UIFont systemFontOfSize:18];
}

@end
