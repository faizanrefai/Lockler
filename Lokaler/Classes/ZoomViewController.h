//
//  ZoomViewController.h
//  Zoom
//
//  Created by Fernando Bunn on 10/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EstateLokalerAppDelegate.h"

#import "ImageScrollView_inspire.h"

@class PropertiesDetailVC;
@interface ZoomViewController : UIViewController <UIScrollViewDelegate> {
	UIImageView *image;
	int cnt ;
	UIImage *myImage;
	PropertiesDetailVC *obj;
	EstateLokalerAppDelegate *appdel;
	UIButton *myButton;
	UIInterfaceOrientation orirntation;
	
	UIScrollView *pagingScrollView;
	
	NSMutableArray *img_arr;
	NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
	int           firstVisiblePageIndexBeforeRotation;
    CGFloat       percentScrolledIntoFirstVisiblePage;
	
	IBOutlet UIView *main_view;
	int pageNo;
	
}


- (void)tilePages;
- (ImageScrollView_inspire *)dequeueRecycledPage;

- (NSUInteger)imageCount;
- (NSString *)imageNameAtIndex:(NSUInteger)index;
- (CGSize)imageSizeAtIndex:(NSUInteger)index;
- (NSString *)imageAtIndex:(NSUInteger)index;

- (void)configurePage:(ImageScrollView_inspire *)page forIndex:(NSUInteger)index;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;

- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (CGSize)contentSizeForPagingScrollView;


@property(nonatomic)int pageNo;
@property(nonatomic,retain)UIImageView *image;
@property(nonatomic)UIInterfaceOrientation orirntation;
@property(nonatomic,retain) UIImage *myImage;
@property(nonatomic,retain) NSMutableArray *img_arr;
@end

