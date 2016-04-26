//
//  CurrentLocationMap.h
//  EstateLokaler
//
//  Created by apple  on 10/8/11.
//  Copyright 2011 hjbvb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class PropertiesDetailVC;
@class DisplayMap;
@class REVClusterPin;
@class REVClusterAnnotationView;
@class iCodeBlogAnnotation;
@class iCodeBlogAnnotationView;

@interface AddressAnnotation : NSObject <MKAnnotation> 
{

}

@end



@interface CurrentLocationMap : UIViewController <MKMapViewDelegate>{
	
	IBOutlet MKMapView	*mapView;
	IBOutlet UILabel *lblAddress;
	AddressAnnotation *addAnnotation;
	//NSMutableDictionary *dic;
	NSString *strLat;
	NSString *strLong;
	NSString *strTitle;
	NSString *strAddress;
	
	NSURL *imgURL;
	NSMutableDictionary *d;
	
	REVClusterAnnotationView *annView;
}

-(IBAction)back;
-(void)setMapViewPoint;
@property(nonatomic,retain) NSString *strLat;
@property(nonatomic,retain) NSString *strLong;
@property(nonatomic,retain) NSString *strTitle;
@property(nonatomic,retain) NSString *strAddress;

@end
