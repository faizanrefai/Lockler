//
//  MineSokCell1.m
//  EstateLokaler
//
//  Created by apple  on 9/29/11.
//  Copyright 2011 hjbvb. All rights reserved.
//

#import "MineSokCell.h"

#import "MineSokVC.h"
#import "PropertyListMode.h"
@implementation MineSokCell
@synthesize lblCntProp;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

-(void)setData:(NSMutableDictionary*)dt{
	
	strDate=[dt valueForKey:@"date_insert"];
	NSMutableArray *splitDate=[[strDate componentsSeparatedByString:@" "]retain];
		
	NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
	
	[dateForm setDateFormat:@"yyyy-MM-dd"];
	
	NSDate *dateSelected = [dateForm dateFromString:[splitDate objectAtIndex:0]];
	NSDateFormatter *dateForm1 = [[NSDateFormatter alloc] init];
	
	[dateForm1 setDateFormat:@"dd. MMMM yyyy."];
	NSString *temp;
	temp=[dateForm1 stringFromDate:dateSelected];
	
	
	NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
	
	[dateFor setDateFormat:@"HH:mm:ss"];
	
	NSDate *dateSelected1 = [dateFor dateFromString:[splitDate objectAtIndex:1]];
	NSDateFormatter *dateFor1 = [[NSDateFormatter alloc] init];
	
	[dateFor1 setDateFormat:@"HH:mm"];
	NSString *temp1;
	temp1=[dateFor1 stringFromDate:dateSelected1];

	NSMutableArray *arrsplit=[[NSMutableArray alloc]init];	
	arrsplit=(NSMutableArray *)[temp componentsSeparatedByString:@" "];
	if([[arrsplit objectAtIndex:1] isEqualToString:@"January"]){
		[arrsplit removeObjectAtIndex:1];
		[arrsplit insertObject:@"januar " atIndex:1];
	}
	
	else if([[arrsplit objectAtIndex:1] isEqualToString:@"February"]){
		[arrsplit removeObjectAtIndex:1];
		[arrsplit insertObject:@"februar " atIndex:1];
		
	}
	else if([[arrsplit objectAtIndex:1] isEqualToString:@"March"]){
		[arrsplit removeObjectAtIndex:1];
		[arrsplit insertObject:@"mars " atIndex:1];
		
	}
	else if([[arrsplit objectAtIndex:1] isEqualToString:@"April"]){
		[arrsplit removeObjectAtIndex:1];
		[arrsplit insertObject:@"april " atIndex:1];
		
	}
	else if([[arrsplit objectAtIndex:1] isEqualToString:@"May"]){
		[arrsplit removeObjectAtIndex:1];
		[arrsplit insertObject:@"mai " atIndex:1];
		
	}
	else if([[arrsplit objectAtIndex:1] isEqualToString:@"June"]){
		[arrsplit removeObjectAtIndex:1];
		[arrsplit insertObject:@"juni " atIndex:1];
		
	}
	else if([[arrsplit objectAtIndex:1] isEqualToString:@"July"]){
		[arrsplit removeObjectAtIndex:1];
		[arrsplit insertObject:@"august " atIndex:1];
		
	}
	else if([[arrsplit objectAtIndex:1] isEqualToString:@"August"]){
		[arrsplit removeObjectAtIndex:1];
		[arrsplit insertObject:@"november " atIndex:1];
		
	}
	else if([[arrsplit objectAtIndex:1] isEqualToString:@"September"]){
		[arrsplit removeObjectAtIndex:1];
		[arrsplit insertObject:@"september " atIndex:1];
		
	}
	else if([[arrsplit objectAtIndex:1] isEqualToString:@"October"]){
		[arrsplit removeObjectAtIndex:1];
		[arrsplit insertObject:@"oktober " atIndex:1];
		
	}
	else if([[arrsplit objectAtIndex:1] isEqualToString:@"November"]){
		[arrsplit removeObjectAtIndex:1];
		[arrsplit insertObject:@"november " atIndex:1];
		
	}
	
	else {
		[arrsplit removeObjectAtIndex:1];
		[arrsplit insertObject:@"desember " atIndex:1];
		
	}
	NSMutableString *str1 = [[NSMutableString alloc] init];
	for(int i=0;i<3;i++)
	{
		NSLog(@"%@",[arrsplit objectAtIndex:i]);

		str1=[str1 stringByAppendingString:[arrsplit objectAtIndex:i]];
		
	}
	NSLog(@"%@",str1);
	
	
	NSString *str=[dt valueForKey:@"from_area"];	
	if([str isEqualToString:@"(null)"])	{
		lblFromTo.text=@"Alle Størrelser";		
	}
	else{
		if([[dt valueForKey:@"from_area"] isEqualToString:@""]){
			lblFromTo.text=@"Alle Størrelser";			
		}
		else{
			if([[dt valueForKey:@"to_area"]isEqualToString:@""]){
				strFromTo=[NSString stringWithFormat:@"%@ kvm ", [dt valueForKey:@"from_area"]];

			}
			else{
				strFromTo=[NSString stringWithFormat:@"%@-%@ kvm ", [dt valueForKey:@"from_area"],[dt valueForKey:@"to_area"]];

			}
			lblFromTo.text=strFromTo;
		}		
	}
	
	
	lblDate.text=[NSString stringWithFormat:@"%@ KI. %@",str1,temp1];
	lblDept.text=[dt valueForKey:@"dept"];
	lblArea.text=[NSString stringWithFormat:@"%@,%@",[dt valueForKey:@"town"],[dt valueForKey:@"area"]];
	NSLog(@"lokaler cnt %@",[dt valueForKey:@"cnt"]);
	if(![[dt valueForKey:@"cnt"] isEqualToString:@""]){
		arrImg.hidden =FALSE;
	lblCntProp.text=[NSString stringWithFormat:@"%@ lokaler", [dt valueForKey:@"cnt"]];	
	}
	else {
		arrImg.hidden =TRUE;
		lblCntProp.text=@"";
	}

	[dateForm release];
	[dateFor release];
}	

- (void)dealloc { 
    [super dealloc];
	[lblTitle release];
	[lblArea release];
	[lblFromTo release];
	[lblDate release];
	[lblTown release];
	
}

@end
