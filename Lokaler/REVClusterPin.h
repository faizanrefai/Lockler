//
//  
//    ___  _____   ______  __ _   _________ 
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_| 
//
//  Created by Bart Claessens. bart (at) revolver . be
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "EGOImageView.h"

@interface REVClusterPin : NSObject  <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    NSString *pinid;	
	NSString *imgURL;	
    NSArray *nodes;
	EGOImageView *eimgV;
    
}
@property(nonatomic, retain) NSArray *nodes;
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *pinid;
@property(nonatomic, retain) NSString *imgURL;
@property(nonatomic, retain) EGOImageView *eimgV;
@property(nonatomic, copy) NSString *subtitle;

- (NSUInteger) nodeCount;

@end
