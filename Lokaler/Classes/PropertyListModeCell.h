//
//  PropertyListModeCell.h
//  EstateLokaler
//
//  Created by apple on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PropertyListMode;
@class EstateLokalerAppDelegate;
@interface PropertyListModeCell : UITableViewCell {
	IBOutlet UILabel *lblHouseNo;
	IBOutlet UILabel *lblTitle;
	IBOutlet UILabel *lblAddress;
	IBOutlet UILabel *lblAreaName;
	IBOutlet UILabel *lblTownName;
	IBOutlet UILabel *lblAvstand;
	EstateLokalerAppDelegate *appdel;
	PropertyListMode *instance;
	
	NSString *strHouseNo;
	NSString *strTitle;
	NSString *strAddress;
	NSString *strAreaName;
	NSString *strImage;
	NSString *strTownName;
	
	NSString *fnm;
	NSString *fsize;
	
	NSMutableDictionary *tmpdic;
	
	CGFloat AddHeight;
	
	BOOL insert;
	
	
	
}

//@property(nonatomic,retain)NSMutableDictionary *tmpdic;
//@property(nonatomic) CGFloat AddHeight;
//@property(nonatomic,retain) NSString *fnm;
@property(nonatomic,retain) IBOutlet UIImageView *imgView;
@property(nonatomic,retain)IBOutlet UILabel *lblAvstand;
//@property(nonatomic,retain) NSString *fsize;

-(void)setData:(NSMutableDictionary*)dt;
@end
