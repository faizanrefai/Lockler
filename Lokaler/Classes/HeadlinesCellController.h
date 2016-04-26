//
//  HeadlinesCellController.h
//  UPI
//
//  Created by Vivek on 08/12/10.
//  Copyright 2010 VivekSharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "EGOImageView.h"
@class ArticleVC;

@interface HeadlinesCellController : UITableViewCell <MFMailComposeViewControllerDelegate>{
	
	IBOutlet UILabel *lblCompName;
	IBOutlet UILabel *PriAgent;
	IBOutlet UILabel *secAgent;	
	IBOutlet UIButton *btnCall;
	IBOutlet UIButton *btnEmail;
	IBOutlet EGOImageView *myLogoImg;
	
}

@property(nonatomic,retain)UILabel *lblCompName;
@property(nonatomic,retain)UILabel *PriAgent;
@property(nonatomic,retain)UILabel *secAgent;	
@property(nonatomic,retain)UIButton *btnCall;
@property(nonatomic,retain)UIButton *btnEmail;
@property(nonatomic,retain)EGOImageView *myLogoImg;

@end 
