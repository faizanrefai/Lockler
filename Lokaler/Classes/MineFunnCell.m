//
//  MineFunnCell.m
//  EstateLokaler
//
//  Created by apple on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MineFunnCell.h"
#import "MineFunnVC.h"
#import "EstateLokalerAppDelegate.h"

@implementation MineFunnCell
@synthesize imgView,lblAvstand;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

-(void)setData:(NSMutableDictionary*)dt{
	EstateLokalerAppDelegate *appdel=(EstateLokalerAppDelegate *)[[UIApplication sharedApplication] delegate];

	
	strFromTo=[NSString stringWithFormat:@"%@-%@ kvm, %@", [dt valueForKey:@"fromarea"],[dt valueForKey:@"toarea"],[dt valueForKey:@"departmentname"]];
	lblToFrom.text=strFromTo;
	strAreaTown=[NSString stringWithFormat:@"%@", [dt valueForKey:@"title"]];
	
	
	CGSize actualSize = [strAreaTown sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12]
								constrainedToSize:CGSizeMake(186, 30) lineBreakMode:UILineBreakModeWordWrap];	
	CGSize textLabelSize = {actualSize.width, actualSize.height};
	if(textLabelSize.height <= 15){
		CGRect frm = lblAreaTown.frame;
		frm.size.height =15;
		lblAreaTown.frame =frm;
	
	}
	lblAreaTown.text=strAreaTown;	
	imgView.frame= CGRectMake(4,7,87,82);
	if([[dt valueForKey:@"houseno"] isEqualToString:@""]){
	strTitle=[NSString stringWithFormat:@"%@%@, %@",[dt valueForKey:@"adress"],[dt valueForKey:@"houseno"],[dt valueForKey:@"townname"] ];
	}
	else {
		strTitle=[NSString stringWithFormat:@"%@ %@, %@",[dt valueForKey:@"adress"],[dt valueForKey:@"houseno"],[dt valueForKey:@"townname"] ];

	}

	lblTitle.text=strTitle;
	CLLocation *locA = [[CLLocation alloc]initWithLatitude:[[dt valueForKey:@"latitude"] doubleValue] longitude:[[dt valueForKey:@"longitude"]doubleValue]];
	CLLocation *locB = [[CLLocation alloc] initWithLatitude:[appdel.strAppLat doubleValue] longitude:[appdel.strAppLong doubleValue]];
	CLLocationDistance distance = [locA distanceFromLocation:locB];	
	
	
	
	
	
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
	
	
	
	
	
	
	
	//float R = 6468500.0; // in meters
//    
//    float lat1 = locA.coordinate.latitude*M_PI/180.0;
//    float lon1 = locA.coordinate.longitude*M_PI/180.0;
//    float lat2 = locB.coordinate.latitude*M_PI/180.0;
//    float lon2 = locB.coordinate.longitude*M_PI/180.0;
//    
//    float d = acosf(sinf(lat1) * sinf(lat2) + 
//					cosf(lat1) * cosf(lat2) *
//					cosf(lon2 - lon1)) * R;
//	
//	// NSLog(@"%@"[NSString stringWithFormat:@"Avstand: %.2f KM",distance/1000.0]);
//    
//	
//	
//	[locA release];	
//	[locB release];
//	if(distance>1000){
//		lblAvstand.text =[NSString stringWithFormat:@"Avstand: %.2f KM",d/1000.0];
//	}
//	else{
//		lblAvstand.text =[NSString stringWithFormat:@"Avstand:%.2f meters",d];
//	}	
//	
}	


- (void)dealloc {
    [super dealloc];
	[lblTitle release];
	[lblToFrom release];
	[lblAreaTown release];
	[lblAvstand release];
	[imgView release];
}



@end
