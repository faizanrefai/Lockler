//
//  PropertyListMode.h
//  EstateLokaler
//
//  Created by apple on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "REVClusterMapView.h"
#import "REVClusterPin.h"
#import "REVClusterAnnotationView.h"
#import "REVClusterMap.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "EGOCache.h"

@class GdataParser;
@class EstateLokalerAppDelegate;
@class PropertyListModeCell;
@class PropertiesDetailVC;
@class SokeFilterVC;
@class ALPickerView;

@interface PropertyListMode : UIViewController <MKMapViewDelegate,UIGestureRecognizerDelegate> {

	PropertiesDetailVC *detailViewController;
	MKAnnotationView *annViewf;
	EstateLokalerAppDelegate *appdel;
	PropertiesDetailVC *objPropertyDetailVC;	
	REVClusterMapView *_mapView;
	SokeFilterVC *filterViewController;
	EGOImageView *imageViewL;
	EGOImageView *imageViewPRP;
	
	NSMutableDictionary *mnthPropertyDic;	
	NSMutableArray *arrayTypeLokale;	
	NSString *selected_pinId;
	UITapGestureRecognizer *oneFingerTwoTaps ;
	int Loadmorecnt;
	int selrow;
	
	IBOutlet MKMapView	*MapView;
	IBOutlet UIView		*listView;
	IBOutlet UIView		*mapView;
	IBOutlet UITableView *tblView;
	IBOutlet UIPickerView *typeLokalePicker;		
	IBOutlet UIToolbar	*downPickerToolBar;
	IBOutlet UILabel	*lblTypeLokale;
	IBOutlet UIButton	*btnFerdig;
	IBOutlet UIButton	*btnFilter;	
	IBOutlet UIButton	*seg;
	IBOutlet UILabel	*lblAreal;
	IBOutlet UIButton	*btnAreal;
	IBOutlet UIButton *btnProperty;
	IBOutlet UIButton *LoadMore;
	IBOutlet UILabel	*lblTitleSoq;
	IBOutlet UILabel	*lblSort;
	IBOutlet UIView		*promonthView;
	IBOutlet UIImageView *imgSegKart;
	IBOutlet UIButton *btnBack;
	IBOutlet UIImageView *propImg;	
	IBOutlet UILabel *lblCount;	
	IBOutlet UILabel *lblAddHouseNo;
	IBOutlet UILabel *lblDepartment;
	IBOutlet UILabel *lblTitle;
	IBOutlet UILabel *lblDesc;
	IBOutlet UILabel *lblCompName;
	MKAnnotationView *annViewCurrent;
	BOOL isSearchArea;
	BOOL isPushed;
}

@property(nonatomic)BOOL isSearchArea;

-(void)GDATATwelve;
-(void)GDATAPropertyOfMon;
-(void)GdataUpdate;

-(IBAction)clickList;
-(IBAction)onLoadMore:(id)Sender;
-(IBAction)clickBack;
-(IBAction)clickSortList;
-(IBAction)clickFerdig;
-(IBAction)clickKart;
-(IBAction)clickClose;
-(IBAction)clickProperty;
-(IBAction)clickSokeFilter;

-(void)getMapannotation: (NSMutableArray *)arr;
-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation;
-(void)PickerStatus_hidden:(BOOL)show;
@end
