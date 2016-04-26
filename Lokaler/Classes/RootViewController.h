//
//  RootViewController.h
//  EstateLokaler
//
//  Created by apple on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "AlertHandler.h"


@class GdataParser;
@class EstateLokalerAppDelegate;
@class MineSokVC;
@class MineFunnVC;
@class PropertyListMode;
@class ContactUs;
@class EstateMedia;

@interface RootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,CLLocationManagerDelegate>{
	
	
	MineFunnVC *minefunnViewController;	
	PropertyListMode *objPropertyList;
	MineSokVC *detailViewController;
	EstateLokalerAppDelegate *appdel;
	
	IBOutlet UIView *viewSokAlert;
	IBOutlet UIView *matchNotFound;	
	IBOutlet UITextField *txtSearch;
	IBOutlet UILabel *lblTime;
	IBOutlet UILabel *lblCountText;
	IBOutlet UILabel *lblcnt;
	IBOutlet UIButton *btnContactUs;
    IBOutlet UIButton *newPropertyofmnthBtn;
    IBOutlet UIImageView *newPropertyofmnthIMG;
	IBOutlet UILabel *myError_msgLbl;	    
	
	NSString *strSokSearch;
	NSMutableArray *pastUrls;			
	UITableView *autocompleteTableView;	
    CLLocationManager *locationManager;
}

-(IBAction)clickNewAddedProperty:(id)sender;
-(IBAction)clickMineSok;
-(IBAction)clickMineFunn;
-(IBAction)clickSokBtn;
-(IBAction)clickLokalerNaerheten;
-(IBAction)clickLukk;
-(IBAction)clickContactUs;
-(IBAction)clickEstateMedia;
-(void)GDATACount;
-(void)GDATAPremises;
-(void)GDATASearch;
-(void)GDATAMineSok;
-(void)GDATAMinefunn;
-(void)GDATAAutoSugested;
- (void) searchTableView;
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring;

@end
