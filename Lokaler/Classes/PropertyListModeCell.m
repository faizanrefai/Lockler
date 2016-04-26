//
//  PropertyListModeCell.m
//  EstateLokaler
//
//  Created by apple on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PropertyListModeCell.h"
#import "PropertyListMode.h"
#import "EstateLokalerAppDelegate.h"

//#define FONT_SIZE 12.0f
//#define CELL_CONTENT_WIDTH 220.0f
//#define CELL_CONTENT_MARGIN 10.0f
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
 
@implementation PropertyListModeCell
@synthesize imgView,lblAvstand;

//@synthesize fnm,fsize,AddHeight;
//@synthesize tmpdic;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
    if (self) {
        // Initialization code.
    }
    return self;
}


-(void)setData:(NSMutableDictionary*)dt{
	appdel=(EstateLokalerAppDelegate *)[[UIApplication sharedApplication] delegate];
	if([[dt valueForKey:@"houseno"] isEqualToString:@""]){
		strTitle=[NSString stringWithFormat:@"%@%@, %@", [dt valueForKey:@"adress"],[dt valueForKey:@"houseno"],[dt valueForKey:@"townname"]];

	}
	else {
		strTitle=[NSString stringWithFormat:@"%@ %@, %@", [dt valueForKey:@"adress"],[dt valueForKey:@"houseno"],[dt valueForKey:@"townname"]];

	}

	strAddress=[NSString stringWithFormat:@"%@-%@ kvm, %@", [dt valueForKey:@"fromarea"],[dt valueForKey:@"toarea"],[dt valueForKey:@"departmentname"]];
	strTownName=[dt valueForKey:@"title"];
	
	CGSize actualSize = [strTownName sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12]
								constrainedToSize:CGSizeMake(186, 30) lineBreakMode:UILineBreakModeWordWrap];	
	CGSize textLabelSize = {actualSize.width, actualSize.height};
	if(textLabelSize.height <= 15){
		CGRect frm = lblTownName.frame;
		frm.size.height =15;
		lblTownName.frame =frm;
		
	}
	lblTitle.text=strTitle;
	lblAddress.text=strAddress;
	lblTownName.text=strTownName;
	
	
	
	CLLocation *locA = [[CLLocation alloc]initWithLatitude:[[dt valueForKey:@"latitude"] doubleValue] longitude:[[dt valueForKey:@"longitude"]doubleValue]];
	CLLocation *locB = [[CLLocation alloc] initWithLatitude:[appdel.strAppLat doubleValue] longitude:[appdel.strAppLong doubleValue]];
	CLLocationDistance distance = [locA distanceFromLocation:locB];	
	
    
//    float R = 6368500.00;
//    
//    float dLat =DEGREES_TO_RADIANS( abs(locA.coordinate.latitude -locB.coordinate.latitude));
//     float dLon = DEGREES_TO_RADIANS( abs(locA.coordinate.longitude -locB.coordinate.longitude));
//    
//    float lat1 = DEGREES_TO_RADIANS(locA.coordinate.latitude);
//    float lat2 = DEGREES_TO_RADIANS(locB.coordinate.latitude);
//    
//    float a = (sinf(dLat/2.0) * sinf(dLat/2.0)) +sinf(dLon/2.0) * sinf(dLon/2.0) * cosf(lat1) * cosf(lat2); 
//    float c = 2 * atan2f(sqrtf(a), sqrtf(1-a)); 
//    float d = R * c ;
    
    
    double R = 6468500.0; // in meters
    
    double lat1 = locA.coordinate.latitude*(M_PI/180.0);
    double lon1 = locA.coordinate.longitude*(M_PI/180.0);
    double lat2 = locB.coordinate.latitude*(M_PI/180.0);
    double lon2 = locB.coordinate.longitude*(M_PI/180.0);
    
    double d = acos(sin(lat1) * sin(lat2) + 
                cos(lat1) * cos(lat2) *
                cos(lon2 - lon1)) * R;

   // NSLog(@"%@"[NSString stringWithFormat:@"Avstand: %.2f KM",distance/1000.0]);
    
	if(d>1000.0){
		lblAvstand.text =[NSString stringWithFormat:@"Avstand: %.2f KM",d/1000.0];
         NSLog(@"%@",[NSString stringWithFormat:@"Avstand: %.2f KM",d/1000.0]);
	}
	else{
		lblAvstand.text =[NSString stringWithFormat:@"Avstand:%.2f meters",d];
         NSLog(@"%@",[NSString stringWithFormat:@"Avstand: %.2f KM",d/1000.0]);
	}	
    NSLog(@"%@ , %@,",locA,locB);
    [locA release];	
	[locB release];
}

/*-(void)setData1:(NSMutableDictionary*)dt{
	
	strHouseNo=[dt valueForKey:@"houseno"];
	strTitle=[dt valueForKey:@"title"];
	strAddress=[dt valueForKey:@"adress"];
	strAreaName=[dt valueForKey:@"areaname"];
	strTownName=[dt valueForKey:@"townname"];

}	*/

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

- (void)dealloc {
    [super dealloc];
	[lblHouseNo release];
	[lblTitle release];
	[lblAddress release];
	[lblAreaName release];
	[lblAvstand release];

	[lblTownName release];
	
}


@end
