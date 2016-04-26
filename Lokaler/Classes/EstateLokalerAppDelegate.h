//
//  EstateLokalerAppDelegate.h
//  EstateLokaler
//
//  Created by apple on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CLLocationManager.h"
#import <MapKit/MapKit.h>
//#import "RootViewController_ipad.h"
//#import "ZoomViewController_Ipad.h"
//#import "MineFunnPopVw.h"
@class GdataParser;

@interface EstateLokalerAppDelegate : NSObject <UIApplicationDelegate,CLLocationManagerDelegate> {

    UIWindow *window;
    UINavigationController *navigationController;
	
	CLLocationManager *locationManager;
	double lat;
	double lon; 
	
	NSMutableArray *arrList;
	NSMutableArray *arrList1;
	NSMutableArray *appdel_ArrayFilterBack;
	NSMutableArray *appdel_ArrayFilterSave;
	NSMutableArray *currentArray;
	NSArray *arrayForPoopFrags;
	NSArray *arrayForPoopTypes;
	NSArray *arrayPremises;
	NSMutableArray *distance;
	
	NSMutableDictionary *appdel_dicFilterBack;
	NSMutableDictionary *appdel_dicFilterSave;
	NSMutableDictionary *currentDict;
	NSMutableDictionary *dicPremises;
	  
	NSString *strTypeLokaleID;
	
	NSMutableArray *strFylkeID;
	NSMutableArray *strAreaID;
	NSMutableArray *appdel_strSize;
	
	
	NSString *strSizeID;
	NSString *aVar;
	NSString *strAppLat;
	NSString *strAppLong;
	NSString *strArtID;
	
	NSString *appdelStrSortID;
	NSString *appdelStrLokaleID;
	NSString *strDistance;
	NSString *strTitleMap;
	
	int flag;
	int flagOfPremises;
	int flagOfTwelve;
	int flagFilter;
	int buttonClick;
	int signSok;
	int flagsokSearch;
	int currentElement;
	float floatTEMP;
	int addcnt;
	int sokCnt;
	int propCount;
	
	int pickerTag;
	int pickerTagArea;
	BOOL isAlert;
	BOOL isDetail;
		NSString *appdelStrSearch;

	
	NSString *fbTitle;
	
	//for ipad
    NSMutableArray *PropertyArray;
    int NewPropCnt;
    BOOL isAllSel;
	int sortId;
	
	//for meera
	
	NSMutableArray *myCurrentData_arr;
	NSMutableArray *autosuggested_arr;
	NSMutableArray *mineSok_arr;
	BOOL isNew_add;
	NSString *udID;
	NSString *appdelStrID;

	NSString *strAppSearchId;
	int Currentsorted;
	NSString *urlPropertylist;
	BOOL frmSok;
	BOOL isNearBy;
	BOOL tagMethere;
	
}

@property (nonatomic)BOOL tagMethere;
@property int pickerTagArea;
@property (nonatomic)BOOL frmSok;
@property (nonatomic)BOOL isNearBy;

@property(nonatomic)int Currentsorted;;
@property (nonatomic)BOOL isNew_add;
@property(nonatomic,retain)NSString *urlPropertylist;;
@property(nonatomic,retain) NSMutableArray *mineSok_arr;

//Ipad
@property (nonatomic)  int sortId;
@property (nonatomic) int NewPropCnt;
@property (nonatomic, retain) NSMutableArray *PropertyArray;
@property (nonatomic) BOOL isAllSel;

@property(nonatomic,readwrite) int addcnt;
@property(nonatomic)	BOOL isAlert;
@property(nonatomic)	BOOL isDetail;;
@property int flag;
@property int signSok;
@property int flagOfTwelve;
@property int flagsokSearch;
@property int buttonClick;
@property int flagFilter;
@property int currentElement;
@property int propCount;
@property int flagOfPremises;

@property int sokCnt;
@property int pickerTag;

@property(nonatomic,readwrite) float floatTEMP;
@property(nonatomic,retain)NSMutableArray *myCurrentData_arr;
@property(nonatomic,retain)NSString *strAppLat;
@property(nonatomic,retain)NSString *strArtID;
@property(nonatomic,retain)NSString *strAppLong;
@property(nonatomic,retain)NSString *strTitleMap;
@property(nonatomic,retain)	NSArray *arrayPremises;
@property(nonatomic,retain)	NSArray *arrayForPoopFrags;
@property(nonatomic,retain)	NSArray *arrayForPoopTypes;
@property(nonatomic,retain) NSMutableArray *arrList;
@property(nonatomic,retain) NSMutableArray *arrList1;
@property(nonatomic,retain) NSMutableArray *currentArray;
@property(nonatomic,retain) NSMutableArray *appdel_ArrayFilterBack;
@property(nonatomic,retain) NSMutableArray *appdel_ArrayFilterSave;
@property(nonatomic,retain) NSMutableArray *distance;
@property(nonatomic,retain) NSMutableArray *appdel_strSize;
@property(nonatomic,retain) NSString *strAppSearchId;
@property(nonatomic,retain) NSString *udID;
@property(nonatomic,retain) NSString *appdelStrLokaleID;
@property(nonatomic,retain) NSString *appdelStrSortID;
@property(nonatomic,retain) NSString *aVar;
@property(nonatomic,retain) NSString *appdelStrSearch;
@property(nonatomic,retain) NSString *appdelStrID;
@property(nonatomic,retain) NSString	*strTypeLokaleID;
@property(nonatomic,retain) NSMutableArray	*strFylkeID;
@property(nonatomic,retain) NSMutableArray	*strAreaID;
@property(nonatomic,retain) NSString	*strSizeID;
@property(nonatomic,retain) NSString	*strDistance;
@property(nonatomic,retain)NSMutableDictionary *dictTown;
@property(nonatomic,retain)NSMutableDictionary *dictArea;
@property(nonatomic,retain)NSMutableDictionary *dictDept;
@property(nonatomic,retain)NSMutableDictionary *appdel_dicFilterBack;
@property(nonatomic,retain)NSMutableDictionary *appdel_dicFilterSave;
@property(nonatomic,retain)NSMutableDictionary *currentDict;
@property(nonatomic,retain)NSMutableDictionary *dicPremises;
@property(nonatomic,retain)NSString *fbTitle;


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property double lat;
@property double lon; 
@property (nonatomic, retain)NSMutableArray *autosuggested_arr;




-(void)GDATAAutoSugested;
- (BOOL)isIpad;
@end

