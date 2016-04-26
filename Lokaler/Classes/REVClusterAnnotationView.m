//
//  
//    ___  _____   ______  __ _   _________ 
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_| 
//
//  Created by Bart Claessens. bart (at) revolver . be
//

#import "REVClusterAnnotationView.h"


@implementation REVClusterAnnotationView

@synthesize coordinate,idTxt;

- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if ( self )
    {
		UIDevice* thisDevice = [UIDevice currentDevice];
		if(thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
			label = [[UILabel alloc] initWithFrame:CGRectMake(10, 23, 60, 36)];
			label.font = [UIFont boldSystemFontOfSize:32];

		}
		else {
            
            
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0)) {
                // Retina display
                label = [[UILabel alloc] initWithFrame:CGRectMake(3, 15, 43, 26)];
                label.font = [UIFont boldSystemFontOfSize:21];

            } else {
                // non-Retina display
                label = [[UILabel alloc] initWithFrame:CGRectMake(7, 20, 43, 26)];
                label.font = [UIFont boldSystemFontOfSize:22];
            }

			
		}

		
		
        [self addSubview:label];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        
        label.textAlignment = UITextAlignmentCenter;
        label.shadowColor = [UIColor blackColor];
        label.shadowOffset = CGSizeMake(0,-1);		
		
    }
    return self;
}

- (void) setClusterText:(NSString *)text//:(NSString*)idTxt1
{
    label.text = text;
	//self.idTxt =idTxt1;
}


- (void) dealloc
{
    [label release], label = nil;
    [super dealloc];
}

@end
