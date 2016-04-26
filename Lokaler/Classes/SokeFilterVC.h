//
//  SokeFilterVC.h
//  EstateLokaler
//
//  Created by apple on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ALPickerView.h"
@class EstateLokalerAppDelegate;
@class PropertyListMode;
@class ALPickerView;

@interface SokeFilterVC : UIViewController <ALPickerViewDelegate> {
	EstateLokalerAppDelegate *appdel;
	ALPickerView *pickerView;
	
	IBOutlet UIToolbar *downPickerToolBar;
	IBOutlet UILabel *lblTypeLokale;
	IBOutlet UILabel *lblTypeLokaleText;	
	IBOutlet UILabel *lblFlyke;
	IBOutlet UILabel *lblArea;
	IBOutlet UILabel *lblSize;
	IBOutlet UILabel *lblOmradeTitle;
	IBOutlet UIView *viewAlert;
	IBOutlet UIButton *btnLokale;
	IBOutlet UIButton *btnFylke;
	IBOutlet UIButton *btnOmrade;
	IBOutlet UIButton *btnSize;
	IBOutlet UIButton *btnFerdig;	
		
	NSMutableArray *entries;
	NSMutableArray *myselectedItemstype;
	NSMutableArray *myselectedItemsflyker;
	NSMutableArray *myselectedItemsarea;
	NSMutableArray *myselectedItemssize;
	NSMutableDictionary *selectionStates;	
	int tagValue;
}

-(void)setToolBarFrames;
-(void)presentPickerView;
-(IBAction)clickBack;
-(IBAction)clickTypeLokale;
-(IBAction)clickFylke;
-(IBAction)clickKommuneOmrade;
-(IBAction)clickStorrelse;
-(IBAction)clickNullStillAlleFilter;
-(IBAction)clickBruk;
-(IBAction)clickFerdig;
-(IBAction)clickYes;
-(IBAction)clickNo;
-(void)GDATA;
-(void)GDATAArea;
-(void)GDATAFylke;
-(void)GDATASize;
-(void)GDATASaveNo;
-(void)GDATAYes;



@end

