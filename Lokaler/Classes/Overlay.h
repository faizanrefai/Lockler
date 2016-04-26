//
//  Overlay.h
//  EstateLokaler
//
//  Created by apple  on 10/10/11.
//  Copyright 2011 hjbvb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RootViewController;

@interface Overlay : UIViewController {

	RootViewController *rvController;
	
}
@property (nonatomic, retain) RootViewController *rvController;

@end
