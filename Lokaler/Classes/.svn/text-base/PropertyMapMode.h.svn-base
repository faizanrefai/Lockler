//
//  PropertyMapMode.h
//  EstateLokaler
//
//  Created by apple on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "REVClusterMapView.h"
#import "REVClusterPin.h"
#import "REVClusterAnnotationView.h"
#import "REVClusterMap.h"


@class EstateLokalerAppDelegate;
@class DisplayMap;
@class RootViewController;
 
@interface PropertyMapMode : UIViewController<MKMapViewDelegate> {
	IBOutlet MKMapView *MapView;
	IBOutlet UIView *viewMonthProperties;

	EstateLokalerAppDelegate *appdel;
	NSDictionary *t_dic;
	NSDictionary *_dict;
	
	NSMutableArray *arrLat;
	NSMutableArray *arrLong;
	NSMutableArray *arrTitle;
	
	NSMutableArray *arrLat1;
	NSMutableArray *arrLong1;
	NSMutableArray *arrTitle1;
	
	int cnt;
	int cnt1;
	NSString *strSearch;
	NSString *strSecImg;
	NSMutableArray *searchArray;
	NSMutableArray *arrPOM;
	NSMutableDictionary *dictPOM;
	
	
	IBOutlet UILabel *lblkms;
	IBOutlet UILabel *lblHouseNo;
	IBOutlet UILabel *lblArea;
	IBOutlet UILabel *lbltown;
	IBOutlet UILabel *lblDept;
	IBOutlet UILabel *lblCompName;
	IBOutlet UILabel *lblAddress;
	NSMutableDictionary *d;
	NSURL *imgURL;
	NSString *strAddress;
	REVClusterMapView *_mapView;
	
	


	
}
@property (nonatomic,retain) NSString *strSearch;

-(void)GDATAPropertyOfMon;
-(void)GDATASearch;
-(void)GDATA;
-(void)GDATASearch;
-(void)clickBack;
-(void)ButtonPressed:(id)sender;
-(void)setToolBarFrames;
-(void)ButtonPressed:(id)sender;
-(void)clickSokeFilter;
-(void)setMapViewPoint;


-(IBAction)clickBack;
-(IBAction)clickListe;
-(IBAction)clickSokeFilter;
-(IBAction)clickClose;
-(void)setMapViewPoint;

@end
