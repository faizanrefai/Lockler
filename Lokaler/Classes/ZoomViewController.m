//
//  ZoomViewController.m
//  Zoom
//
//  Created by Fernando Bunn on 10/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ZoomViewController.h"
#import "PropertiesDetailVC.h"

@implementation ZoomViewController
@synthesize image,myImage,orirntation,img_arr,pageNo;

- (void)loadView {
	appdel=(EstateLokalerAppDelegate *)[[UIApplication sharedApplication] delegate];
	//pagingScrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
//	pagingScrollView.backgroundColor = [UIColor blackColor];
//	pagingScrollView.delegate = self;
//	image = [[UIImageView alloc] initWithImage:myImage];
//	
//	pagingScrollView.contentSize = image.frame.size;
//	//[pagingScrollView addSubview:image];	
//	pagingScrollView.minimumZoomScale = pagingScrollView.frame.size.width / image.frame.size.width;
//	pagingScrollView.maximumZoomScale = 2.0;
//	[pagingScrollView setZoomScale:pagingScrollView.minimumZoomScale];
//	cnt=0;
//	self.view = pagingScrollView;
//	[pagingScrollView release];

	
	
	CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
	main_view = [[UIView alloc]initWithFrame:pagingScrollViewFrame];
	self.view  = main_view;
	
    pagingScrollView = [[UIScrollView alloc] initWithFrame:main_view.bounds];
    pagingScrollView.pagingEnabled = YES;
    pagingScrollView.backgroundColor = [UIColor blackColor];
    pagingScrollView.showsVerticalScrollIndicator = NO;
    pagingScrollView.showsHorizontalScrollIndicator = NO;
    pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    pagingScrollView.delegate = self;
	[main_view addSubview:pagingScrollView];
	
    // Step 2: prepare to tile content
    recycledPages = [[NSMutableSet alloc] init];
    visiblePages  = [[NSMutableSet alloc] init];
	
	
}

-(void)setView
{
	
		[pagingScrollView scrollRectToVisible:CGRectMake(480*pageNo,0,480,320) animated:NO];
	
}


- (void)viewDidLoad {
    [super viewDidLoad];
	[self performSelector:@selector(setView) withObject:nil afterDelay:0.1];
	
	[[UIDevice currentDevice] setOrientation:orirntation];
	
	[self tilePages];
	
	
	//self.view.frame=CGRectMake(0, 0, 320, 460);	
}


- (void)viewDidUnload {
	[image release], image = nil; 	
}


- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView {
	CGSize boundsSize = scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
		}
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
	return frameToCenter;
}

#pragma mark -
#pragma mark UIScrollViewDelegate

//- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//   image.frame = [self centeredFrameForScrollView:scrollView andUIView:image];;
//	
//	cnt++;
//	if(cnt>1){
//		//if(image.frame.size.width<=320 ){//&& image.frame.size.height<=480){
//		if(image.frame.size.width<=310 && image.frame.size.height <=470){
//			[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];
//			appdel.addcnt =0;
//			[self.navigationController popViewControllerAnimated:NO];		
//		}
//	}
//}

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//	return image;
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if(interfaceOrientation ==UIInterfaceOrientationLandscapeLeft||interfaceOrientation ==UIInterfaceOrientationLandscapeRight){
		
		self.view.frame =CGRectMake(0, 0, 480, 320);
        
	}
	else {
        [self.navigationController popViewControllerAnimated:NO];
      
	}
	
	//image.frame = [self centeredFrameForScrollView:self.view andUIView:image];
	return YES;
}




#pragma mark -
#pragma mark Tiling and page configuration

- (void)tilePages 
{
    CGRect visibleBounds = pagingScrollView.bounds;	
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, [self imageCount] - 1);
    
    for (ImageScrollView_inspire *page in visiblePages) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [recycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
    [visiblePages minusSet:recycledPages];
    
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            ImageScrollView_inspire *page = [self dequeueRecycledPage];
            if (page == nil) {
                page = [[[ImageScrollView_inspire alloc] init] autorelease];
            }
            [self configurePage:page forIndex:index];
            [pagingScrollView addSubview:page];
            [visiblePages addObject:page];
        }
    }    
}

- (ImageScrollView_inspire *)dequeueRecycledPage
{
    ImageScrollView_inspire *page = [recycledPages anyObject];
    if (page) {
        [[page retain] autorelease];
        [recycledPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (ImageScrollView_inspire *page in visiblePages) {
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (void)configurePage:(ImageScrollView_inspire *)page forIndex:(NSUInteger)index
{
    page.index = index;
    page.frame = [self frameForPageAtIndex:index];
	[page displayImageEgo:[self imageAtIndex:index]];
}


#pragma mark -
#pragma mark ScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tilePages];
	
}



#pragma mark -
#pragma mark View controller rotation methods

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//	//return (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || 
//	//            interfaceOrientation==UIInterfaceOrientationLandscapeRight) ? YES : NO;
//	
//	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
//    
//    
//}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	// CGFloat offset = pagingScrollView.contentOffset.x;
	//    CGFloat pageWidth = pagingScrollView.bounds.size.width;
	//    
	//    if (offset >= 0) {
	//        firstVisiblePageIndexBeforeRotation = floorf(offset / pageWidth);
	//        percentScrolledIntoFirstVisiblePage = (offset - (firstVisiblePageIndexBeforeRotation * pageWidth)) / pageWidth;
	//    } else {
	//        firstVisiblePageIndexBeforeRotation = 0;
	//        percentScrolledIntoFirstVisiblePage = offset / pageWidth;
	//    }    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    for (ImageScrollView_inspire *page in visiblePages) {
        CGPoint restorePoint = [page pointToCenterAfterRotation];
        CGFloat restoreScale = [page scaleToRestoreAfterRotation];
        page.frame = [self frameForPageAtIndex:page.index];
        [page setMaxMinZoomScalesForCurrentBounds];
        [page restoreCenterPoint:restorePoint scale:restoreScale];
        
    }
    CGFloat pageWidth = pagingScrollView.bounds.size.width;
    CGFloat newOffset = (firstVisiblePageIndexBeforeRotation * pageWidth) + (percentScrolledIntoFirstVisiblePage * pageWidth);
    pagingScrollView.contentOffset = CGPointMake(newOffset, 0);
}

#pragma mark -
#pragma mark  Frame calculations
#define PADDING  10

- (CGRect)frameForPagingScrollView {
	CGRect frame; 
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		frame = CGRectMake(0, 0, 1024, 768);
	}
	else {
		frame = CGRectMake(0, 0, 480, 320);
	}
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    CGRect bounds = pagingScrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
}

- (CGSize)contentSizeForPagingScrollView {
    CGRect bounds = pagingScrollView.bounds;
    return CGSizeMake(bounds.size.width * [self imageCount], bounds.size.height);
}

- (NSString *)imageAtIndex:(NSUInteger)index {
    NSString *imageName = [self imageNameAtIndex:index];
    //return [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",imageName]];
    return imageName;
}

- (NSString *)imageNameAtIndex:(NSUInteger)index {
    NSString *name = nil;
	name = [img_arr objectAtIndex:index];
    return name;
}

- (CGSize)imageSizeAtIndex:(NSUInteger)index {
	CGSize size;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		size = CGSizeMake(1024, 768);
	}
	else {
		size = CGSizeMake(460, 320);
	}
    return size;
}

- (NSUInteger)imageCount {
    return [img_arr count];
}



- (void)dealloc {
    [super dealloc];
}

@end
