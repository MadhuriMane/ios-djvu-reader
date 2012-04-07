//
//  DRBookScrollViewDataSource.h
//  DjvuViewer
//
//  Created by Alex Martynov on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRBookScrollViewDataSource : NSObject {
	
@private
	NSMutableSet* visiblePages;
	NSMutableSet* reusablePages;
	UIView* currentView;
	
}

@property(nonatomic,assign) CGSize pageSize;

@end
