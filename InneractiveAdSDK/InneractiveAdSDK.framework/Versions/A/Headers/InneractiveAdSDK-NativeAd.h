//
//  InneractiveAdSDK-NativeAd.h
//  InneractiveAdSDK
//
//  Created by Inneractive.
//  Copyright (c) 2015 Inneractive. All rights reserved.
//

#import "InneractiveAdSDK-Ad.h"
#import "InneractiveAdSDK-AdConfig.h"

#pragma mark - Native Ad Interface

/**
 *  @class IaNativeAd
 *  @brief The IaNativeAd is a Native Ads class. It can be used for In-Feed ads stack.
 *  @discussion The IaNativeAd class instance should not be used as a visual object and is only a part of a Native Ads system.
 *
 * The IaNativeAdRenderingDelegate or the IaNativeAdCellRenderingDelegate (for In-Feed) protocols must be implemented in order to successfully render a Native Ad.
 *
 * The compatible ad types are: IaAdType_NativeAd, IaAdType_InFeedNativeAd.
 *
 *  @code self.nativeAd = [[IaNativeAd alloc] initWithAppId:@"some app id" adType:IaAdType_InFeedNativeAd delegate:self];
 */
@interface IaNativeAd : IaAd {}

/**
 *  @brief Is used to initialize the IaNativeAd class instance.
 *
 *  @param appId      The App Id as a string, registered on Inneractive's console (e.g., @"MyCompany_MyApp").
 *  @param adType     The type of ad (IaAdType_NativeAd, IaAdType_InFeedNativeAd).
 *  @param adDelegate The Delegate parameter is a class implementing the <InneractiveAdDelegate> protocol.
 *
 *  @return IaNativeAd instance.
 */
- (instancetype)initWithAppId:(NSString *)appId adType:(IaAdType)adType delegate:(id<InneractiveAdDelegate>)adDelegate;

- (instancetype)init __attribute__((unavailable("please use 'initWithAppId:adType:delegate:' instead")));
- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable("please use 'initWithAppId:adType:delegate:' instead; the instance of this class should not be used as a visual object")));
- (instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable("please use 'initWithAppId:adType:delegate:' instead; the instance of this class should not be used as a visual object")));
+ (instancetype)new __attribute__((unavailable("please use 'initWithAppId:adType:delegate:' instead")));

/**
 *  @brief Is used to control sound of a video ad in non-fullscreen mode.
 */
@property (nonatomic) BOOL isMuted;

/**
 *  @brief Plays a pre-loaded video ad.
 */
- (void)playVideo;

/**
 *  @brief Pauses a playing video ad.
 */
- (void)pauseVideo;

/**
 *  @brief Sends request for a new ad.
 */
- (void)reloadAd;

@end

#pragma mark - Native Ad Rendering Delegate Protocol Methods

/**
 *  @protocol IaNativeAdRenderingDelegate
 *  @brief IaNativeAdRenderingDelegate Protocol.
 *  @discussion Should be implemented in order to render a native ad.
 */
@protocol IaNativeAdRenderingDelegate <NSObject>

@required

/**
 *  @brief Should be implemented in order to render a native ad.
 *
 *  @param adObject IaNativeAd instance.
 */
- (void)layoutAdAssets:(IaNativeAd *)adObject;

@end

/**
 *  @protocol IaNativeAdCellRenderingDelegate
 *  @brief IaNativeAdCellRenderingDelegate Protocol.
 *  @discussion Should be implemented in order to render the in-feed native ad, while working with table adapter.
 */
@protocol IaNativeAdCellRenderingDelegate <IaNativeAdRenderingDelegate>

@required

/**
 *  @brief Defines size for a native ad cell.
 *  @discussion When working with table adapter, implementation of this method is required.
 *
 *  @return Size of a native ad cell.
 */
+ (CGSize)sizeForNativeAdCell;

@end

#pragma mark - Native Ad Table Adapter

/**
 *  @class IaNativeAdTableAdapter
 *  @classdesign Adapter
 *  @brief Autamatic indexes manager for a table view.
 */
@interface IaNativeAdTableAdapter : NSObject

/**
 *  @brief A UITableView instance, that is passed to and managed by IaNativeTableAdapter.
 */
@property (nonatomic, strong, readonly) UITableView *table;

/**
 *  @brief Class specification for ads cells.
 */
@property (nonatomic, strong, readonly) Class adCellRegisteringClass;

/**
 *  @brief A designated initializer.
 *  Will throw an exception if one or more of the input parameters are invalid.
 *
 *  @param nativeAd               IaNativeAd instance of IaAdType_InFeedNativeAd type.
 *  @param table                  UITableView instance.
 *  @param adCellRegisteringClass UITableViewCell subclass, that conforms to IaNativeAdCellRenderingDelegate protocol
 * and implements it's all required methods. It will be used for rendering ads.
 *
 *  @return                       IaNativeAdTableAdapter instance.
 */
- (id)initWithNativeAd:(IaNativeAd *)nativeAd table:(UITableView *)table adCellRegisteringClass:(Class)adCellRegisteringClass;

/**
 *  @brief Use this method before releasing the IaNativeAdTableAdapter instance.
 *  @discussion It will detach the IaNativeAdTableAdapter instance from UITableView instance in order to destroy the IaNativeAdTableAdapter instance in a safe way.
 * Using this method is not needed in case the connected UITableView instance is going to be released also.
 */
- (void)detachFromTable;

// The alloc, init and new methods should not be used to initialize and use the IaNativeAdTableAdapter class.
// initWithNativeAd:table:adCellRegisteringClass: should be used instead.
- (instancetype)init __attribute__((unavailable("init not available, call initWithNativeAd:table:adCellRegisteringClass: instead")));
+ (instancetype)new __attribute__((unavailable("new not available, call initWithNativeAd:table:adCellRegisteringClass: instead")));

@end

#pragma mark - UITableView IaNativeAdTableAdapter Category

/**
 *  @category IaNativeAdTableAdapter
 *  @brief UITableView category methods to work with adapter.
 *  @discussion When working with adapter, all the UITableView methods calls should be substituted with "ia_" prefix methods.
 */
@interface UITableView (IaNativeAdTableAdapter)

/**
 *  @brief Sets the table view's data source.
 *  @discussion If your application needs to change a table view's data source after it has instantiated an ad
 * placer using, that table view, use this method rather than [UITableView setDataSource:].
 *  @param dataSource The new table view data source.
 */
- (void)ia_setDataSource:(id<UITableViewDataSource>)dataSource;

/**
 *  @brief Returns the original data source of the table view.
 *  @discussion When you instantiate a table adapater using a table view, the table adapter replaces the table view's
 * original data source object. If your application needs to access the original data source, use
 * this method instead of [UITableView dataSource].
 *
 *  @return The original table view data source.
 */
- (id<UITableViewDataSource>)ia_dataSource;

/**
 *  @brief Sets the table view's delegate.
 *  @discussion If your application needs to change a table view's delegate after it has instantiated an ad
 * placer using that table view, use this method rather than -[UITableView setDelegate:].
 *
 *  @param delegate The new table view delegate.
 */
- (void)ia_setDelegate:(id<UITableViewDelegate>)delegate;

/**
 *  @brief Returns the original delegate of the table view.
 *  @discussion When you instantiate a table adapter using a table view, the table adapter replaces the table view's
 * original delegate object. If your application needs to access the original delegate, use this
 * method instead of [UITableView delegate].
 *
 *  @return The original table view delegate.
 */
- (id<UITableViewDelegate>)ia_delegate;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (void)ia_reloadData;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (void)ia_reloadSectionIndexTitles NS_AVAILABLE_IOS(3_0);

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (NSInteger)ia_numberOfSections;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (NSInteger)ia_numberOfRowsInSection:(NSInteger)section;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (CGRect)ia_rectForSection:(NSInteger)section;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (CGRect)ia_rectForHeaderInSection:(NSInteger)section;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (CGRect)ia_rectForFooterInSection:(NSInteger)section;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (CGRect)ia_rectForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 *
 *  @return NSIndexPath instance. Returns nil if point is outside of any row in the table.
 */
- (NSIndexPath *)ia_indexPathForRowAtPoint:(CGPoint)point;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 *
 *  @return Nil if the cell is not visible.
 */
- (NSIndexPath *)ia_indexPathForCell:(UITableViewCell *)cell;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 *
 *  @return Nil if the rect is not valid.
 */
- (NSArray *)ia_indexPathsForRowsInRect:(CGRect)rect;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 *
 *  @return Nil if the cell is not visible or index path is out of range.
 */
- (UITableViewCell *)ia_cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (NSArray *)ia_visibleCells;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (NSArray *)ia_indexPathsForVisibleRows;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (UITableViewHeaderFooterView *)ia_headerViewForSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (UITableViewHeaderFooterView *)ia_footerViewForSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (void)ia_scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (void)ia_scrollToNearestSelectedRowAtScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 *
 *  @discussion Use insert/delete/reload or change the editing state only inside an update block. Otherwise things like row count, index, etc. may become invalid.
 */
- (void)ia_beginUpdates;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 *
 *  @discussion Use insert/delete/reload or change the editing state only inside an update block. Otherwise things like row count, index, etc. may become invalid.
 */
- (void)ia_endUpdates;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (void)ia_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (void)ia_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (void)ia_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation NS_AVAILABLE_IOS(3_0);

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (void)ia_moveSection:(NSInteger)section toSection:(NSInteger)newSection NS_AVAILABLE_IOS(5_0);

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (void)ia_insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (void)ia_deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (void)ia_reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation NS_AVAILABLE_IOS(3_0);

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (void)ia_moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath NS_AVAILABLE_IOS(5_0);

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 *
 *  @return Nil or index path representing section and row of selection.
 */
- (NSIndexPath *)ia_indexPathForSelectedRow;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 *
 *  @return Nil or a set of index paths representing the sections and rows of the selection.
 */
- (NSArray *)ia_indexPathsForSelectedRows NS_AVAILABLE_IOS(5_0);

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (void)ia_selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (void)ia_deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (id)ia_dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

/**
 *  @brief IA replacement for the original UITableView method. Use this method when working with table adapter.
 */
- (id)ia_dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier NS_AVAILABLE_IOS(6_0);

@end
