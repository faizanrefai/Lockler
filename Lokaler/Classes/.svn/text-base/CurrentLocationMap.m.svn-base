//
//  CurrentLocationMap.m
//  EstateLokaler
//
//  Created by apple  on 10/8/11.
//  Copyright 2011 hjbvb. All rights reserved.
//

#import "CurrentLocationMap.h"
#import "PropertiesDetailVC.h"
#import "DisplayMap.h"
#import "iCodeBlogAnnotation.h"
#import "iCodeBlogAnnotationView.h"

@implementation AddressAnnotation

#pragma mark -
#pragma mark View lifecycle
@synthesize coordinate;
//
//- (NSString *)subtitle
//{
//	//return @"Sub Title";
//}
//- (NSString *)title
//{
//	//return @"Title";
//}
//
//-(id)initWithCoordinate:(CLLocationCoordinate2D) c
//{ 
//	//coordinate=c;
////	NSLog(@"%f,%f",c.latitude,c.longitude);
////	return self;
//}

@end

@implementation CurrentLocationMap
@synthesize strLat,strLong,strTitle;
@synthesize strAddress;

- (void)viewDidLoad {
    [super viewDidLoad];

	lblAddress.textAlignment= UITextAlignmentCenter;
	lblAddress.text=strAddress;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	//NSLog(@"Lati::%@  Longi::%@ strTitle::%@",strLat,strLong,strTitle);
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=0.2;
	span.longitudeDelta=0.2;
	
	CLLocationCoordinate2D location = mapView.userLocation.coordinate;
	
	location.latitude = [strLat floatValue];
	location.longitude = [strLong floatValue];
	region.span=span;
	region.center=location;
	
	if(addAnnotation != nil) {
		[mapView removeAnnotation:addAnnotation];
		[addAnnotation release];
		addAnnotation = nil;
	}
	
	//addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location];
	//[mapView addAnnotation:addAnnotation];
	[mapView setRegion:region animated:TRUE];
	[mapView regionThatFits:region];
	
	[self setMapViewPoint];
}

-(void)setMapViewPoint
{	
		MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
		NSString *tempLat,*tempLong;
		tempLat=strLat;
		tempLong=strLong;
		
		region.center.latitude=[tempLat floatValue];
		region.center.longitude =[tempLong floatValue];
		
		region.span.longitudeDelta = 0.01f;
		region.span.latitudeDelta = 0.01f;
		
		[mapView setRegion:region animated:YES]; 
		
		[mapView setDelegate:self];
		DisplayMap *ann = [[DisplayMap alloc] init]; 
		ann.title =strTitle;
		ann.coordinate = region.center; 
	
	CLLocationCoordinate2D workingCoordinate;
	
	workingCoordinate.latitude = [tempLat floatValue];
	workingCoordinate.longitude = [tempLong floatValue];
	iCodeBlogAnnotation *school4 = [[iCodeBlogAnnotation alloc] initWithCoordinate:workingCoordinate];
	[school4 setAnnotationType:iCodeBlogAnnotationTypeEDU];	
	[mapView addAnnotation:school4];

}

- (iCodeBlogAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
	iCodeBlogAnnotationView *annotationView = nil;
	
	iCodeBlogAnnotation* myAnnotation = (iCodeBlogAnnotation *)annotation;
	
			NSString* identifier = @"Taco";
		
		iCodeBlogAnnotationView *newAnnotationView = (iCodeBlogAnnotationView *)[mV dequeueReusableAnnotationViewWithIdentifier:identifier];
		
		if(nil == newAnnotationView)
		{
			newAnnotationView = [[[iCodeBlogAnnotationView alloc] initWithAnnotation:myAnnotation reuseIdentifier:identifier] autorelease];
		}
		
		annotationView = newAnnotationView;	
	[annotationView setEnabled:YES];
	[annotationView setCanShowCallout:YES];	
	return annotationView;
	
}

- (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(UIView *)view
{
    CLLocationCoordinate2D location;
    
    location.latitude = point.x;
    location.longitude = point.y;
	
    return location;
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
	CGPoint a  = [gestureRecognizer locationInView:mapView];
	
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    region.center = [mapView convertPoint:a toCoordinateFromView:mapView];
    span.latitudeDelta=mapView.region.span.latitudeDelta/6;
    span.longitudeDelta=mapView.region.span.longitudeDelta/6;
    region.span=span;
    
    [mapView setRegion:region animated:TRUE];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(IBAction)back{
	[self.navigationController popViewControllerAnimated:YES];	
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	if (strLat!=nil) {
		strLat=nil;
		[strLat release];
	}
	if (strLong!=nil) {
		strLong=nil;
		[strLong release];
	}
	if (strTitle!=nil) {
		strTitle=nil;
		[strTitle release];
	}
	if (mapView!=nil) {
		mapView=nil;
		[mapView release];
	}
	
	[mapView release];
	[lblAddress release];
}


@end

