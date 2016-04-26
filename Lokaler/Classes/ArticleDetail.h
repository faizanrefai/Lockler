//
//  ArticleDetail.h
//  EstateLokaler
//
//  Created by apple1 on 10/10/11.
//  Copyright 2011 openxcek. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GdataParser;
@class EstateLokalerAppDelegate;
@class EGOImageView;
@interface ArticleDetail : UIViewController<UIScrollViewDelegate> {

	
	IBOutlet UIButton *btnBack;
	NSMutableArray *arrArtList;
	IBOutlet UIImageView *imgView;
	NSMutableDictionary *dict;
	IBOutlet UIScrollView *scroll;
	EstateLokalerAppDelegate *appdel;
	
	IBOutlet UILabel *lblTitle;
	IBOutlet UILabel *lblIntro;
	IBOutlet UILabel *lblName;
	IBOutlet UILabel *lblEmail;
	IBOutlet UILabel *lblDate;
	
	NSString *strTitle;
	NSString *strIntro;
	NSString *strName;
	NSString *strEmail;
	NSString *strDate;
	IBOutlet UIWebView *webView;
	IBOutlet UIScrollView *scrl;
	
}
-(void)GDATA;
-(IBAction)onBack;

@end
