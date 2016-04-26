//
//  HeadlinesCellController.m
//  UPI
//
//  Created by Vivek on 08/12/10.
//  Copyright 2010 VivekSharma. All rights reserved.
//
#import	"PropertiesDetailVC.h"
#import "HeadlinesCellController.h"
#import	"ArticleVC.h"

 
@implementation HeadlinesCellController
@synthesize lblCompName,PriAgent,secAgent,btnCall,btnEmail,myLogoImg;
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

- (void)dealloc {
    [super dealloc];
}
@end