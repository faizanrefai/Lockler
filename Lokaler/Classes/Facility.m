//
//  Facility.m
//  EstateLokaler
//
//  Created by apple1 on 10/15/11.
//  Copyright 2011 openxcek. All rights reserved.
//

#import "Facility.h"


@implementation Facility
@synthesize lblFaci;

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
