//
//  EstateLokalerAppDelegate.m
//  EstateLokaler
//
//  Created by apple on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EstateLokalerAppDelegate.h"
#import "RootViewController.h"
#import "GdataParser.h"
#import "AlertHandler.h"


@implementation EstateLokalerAppDelegate
   
@synthesize window,floatTEMP,signSok,isAlert,strDistance;
@synthesize navigationController,sokCnt;
@synthesize arrList,arrList1;
@synthesize strArtID;
@synthesize appdelStrSearch,aVar;
@synthesize appdelStrSortID;
@synthesize flag,appdelStrLokaleID,buttonClick;
@synthesize flagOfTwelve;
@synthesize appdel_ArrayFilterBack,appdel_dicFilterBack;
@synthesize flagFilter;
@synthesize strTypeLokaleID;
@synthesize strFylkeID,isDetail;
@synthesize strAreaID,addcnt;
@synthesize strSizeID,strAppLat,strAppLong;
@synthesize appdel_ArrayFilterSave,appdel_dicFilterSave,appdel_strSize;
@synthesize arrayForPoopFrags,arrayForPoopTypes;
@synthesize flagsokSearch,currentArray,currentElement;
@synthesize currentDict,propCount,arrayPremises,dicPremises,flagOfPremises;
@synthesize lat,lon,distance,pickerTag,pickerTagArea,strTitleMap,fbTitle,isNearBy,tagMethere;

@synthesize myCurrentData_arr,udID,appdelStrID,Currentsorted,urlPropertylist,mineSok_arr,frmSok;
//Ipad
@synthesize PropertyArray,NewPropCnt,isAllSel,sortId,strAppSearchId,isNew_add,autosuggested_arr;

#pragma mark -
#pragma mark Application lifecycle



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.distanceFilter = kCLDistanceFilterNone; 
	locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
	[locationManager startUpdatingLocation];
	
	isAlert =TRUE;
	frmSok =FALSE;
	isNearBy =FALSE;
	udID=@"";
	appdelStrID=@"";
	strAppSearchId =@"";
	isNew_add =FALSE;
	Currentsorted =2;
	
	udID=[[[UIDevice currentDevice] uniqueIdentifier]retain];
	NSLog(@"udid is %@",udID);
	sokCnt=1;
	urlPropertylist = @"";
	
	myCurrentData_arr =[[NSMutableArray alloc] init];
	autosuggested_arr =[[NSMutableDictionary alloc]init];
	mineSok_arr =[[NSMutableArray alloc] init];
	
	
	
	appdel_ArrayFilterBack=[[NSMutableArray alloc]init];
	distance=[[NSMutableArray alloc]init];

	appdel_dicFilterBack=[[NSMutableDictionary alloc]init];	
	application.statusBarOrientation = UIInterfaceOrientationPortrait;
	[self.window addSubview:navigationController.view];
  
    [self.window makeKeyAndVisible];
	
    return YES;
	
}

- (BOOL)isIpad{
	UIDevice* thisDevice = [UIDevice currentDevice];
	if(thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		return YES;
	}
	else {
		return NO;
	}
}



- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

   strAppLat= [[NSString alloc]initWithFormat:@"%g",newLocation.coordinate.latitude];
    strAppLong = [[NSString alloc]initWithFormat:@"%g",newLocation.coordinate.longitude];
	lat = newLocation.coordinate.latitude;
    lon = newLocation.coordinate.longitude;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[navigationController release];
	[window release];
	
	
	if (appdel_ArrayFilterBack!=nil) {
				[appdel_ArrayFilterBack removeAllObjects];
				[appdel_ArrayFilterBack release];
				appdel_ArrayFilterBack=nil;
			}
		
	if (appdel_dicFilterBack!=nil) {
		[appdel_dicFilterBack removeAllObjects];
		[appdel_dicFilterBack release];
		appdel_dicFilterBack=nil;
	}
	
	[arrayPremises release];
	[dicPremises release];
	
	[arrList release];
	[arrList1 release];	
	[appdel_ArrayFilterBack release];	
	[appdel_ArrayFilterSave release];
	[arrList release];
	[arrayForPoopFrags release];
	[arrayForPoopTypes release];
	[strTypeLokaleID release];
	[strFylkeID release];
	[strAreaID release];
	[strSizeID release];
	[appdel_strSize release];
	[aVar release];
	[strTypeLokaleID release];
	
	[strAppLat release];
	[strAppLong release];
	[strArtID release];
	[udID release];
	[appdelStrSearch release];
	[appdelStrSortID release];
	[appdelStrLokaleID release];

	
	[super dealloc];
}


@end

