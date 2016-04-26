//
//  MineFunnVC.h
//  EstateLokaler
//
//  Created by apple on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class EstateLokalerAppDelegate;
@class PropertiesDetailVC;
@class MineSokCell;
@class EGOImageView;
@class REVClusterMapView;
@class REVClusterPin;
@class REVClusterAnnotationView;


@interface MineFunnVC : UIViewController <UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate>{
	EstateLokalerAppDelegate *appdel;
	PropertiesDetailVC *detailViewController;	
	int Loadmorecnt;
	NSString *selected_pinId;	
	IBOutlet UITableView *tableView;
	IBOutlet UIButton *LoadMore;
	IBOutlet UIImageView *img;
	IBOutlet UIView *mapView;
	IBOutlet UIView *listView;
	IBOutlet MKMapView *mapObj; 
	IBOutlet UIButton *btnBack;
	IBOutlet UIButton *btnDelete;	
	REVClusterMapView *_mapView;	
	//EGOImageView *imageViewc ;
}

- (void)addGestureRecognizersToPiece:(UIView *)piece;
-(IBAction)onLoadMore:(id)Sender;
-(IBAction)clickKart;
-(IBAction)clickList;
-(IBAction)clickBack;
-(IBAction)funnDelete;
-(void)GDATADelete:(NSString*)valId;
-(void)getMapannotation: (NSMutableArray *)arr;
@end
