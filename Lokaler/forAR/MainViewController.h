//
//  MainViewController.h
//  Yorient
//
//  Created by P. Mark Anderson on 11/10/09.
//  Copyright Spot Metrix, Inc 2009. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "SM3DAR.h" 
#import "AudioToolbox/AudioServices.h"
#import "YahooLocalSearch.h"
#import <MapKit/MapKit.h>
#import <SimpleGeo/SimpleGeo.h>
#import "BirdseyeView.h"
#import "ThumbnailCalloutFocusView.h"
#import "EstateLokalerAppDelegate.h"

@interface MainViewController : UIViewController <MKMapViewDelegate, SM3DARDelegate, CLLocationManagerDelegate, SearchDelegate> 
{
	SystemSoundID focusSound;
	NSString *searchQuery;
    YahooLocalSearch *search;
    BOOL sm3darInitialized;
    UIView *focusedMarker;
    NSArray *searchStrings;
    NSInteger currentSearchIndex;
    EstateLokalerAppDelegate *appdel;

    IBOutlet SM3DARMapView *mapView;
    IBOutlet UIView *hudView;
    IBOutlet ThumbnailCalloutFocusView *focusView;    
    IBOutlet UIActivityIndicatorView *spinner;
    NSMutableArray *myfechedplaces;
    NSMutableArray *placesArr;
	NSString *strLat;
	NSString *strLong;
    
    SimpleGeo *simplegeo;
    BirdseyeView *birdseyeView;
    
    IBOutlet UIButton *toggleMapButton;
    SM3DARPointOfInterest *northStar;

    CLLocationAccuracy desiredLocationAccuracy;
    NSInteger desiredLocationAccuracyAttempts;
    BOOL acceptableLocationAccuracyAchieved;
    CLLocationManager *locationManager;
	BOOL isBetween;
	int PrpId;
	double minLat ;
	double minLon;
	IBOutlet UIButton *info_bar;
	//IBOutlet UIView *myAlert;
	
}

@property (nonatomic)int PrpId;
@property (nonatomic, retain) NSString *searchQuery;
@property (nonatomic, retain) NSString *strLat;
@property (nonatomic, retain) NSString *strLong;
@property (nonatomic, retain) YahooLocalSearch *search;
@property (nonatomic, retain) IBOutlet SM3DARMapView *mapView;
@property (nonatomic, retain) SimpleGeo *simplegeo;

-(IBAction)onClose:(id)sender;
-(IBAction)onInbetween:(id)sender;
- (void)plotSimpleGeoPlaces:(NSArray*)fetchedPlaces;
- (void)initSound;
- (void)playFocusSound;
- (void)runLocalSearch:(NSString*)query;
//- (void)addDirectionBillboardsWithFixtures;
- (void) fetchSimpleGeoPlaces:(NSString*)searchString;
- (IBAction) refreshButtonTapped;
- (IBAction) infoButtonTapped;

- (IBAction) toggleMapButtonTapped:(UIButton *)sender;
- (void) addNorthStar;
- (void) loadPoints;
- (void) lookBusy;
- (void) relax;
-(IBAction)obCloseAlert;

@end
