//
//  DRBooksThumbnailer.h
//  DjvuViewer
//
//  Created by Alex Martynov on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DRBooksThumbnailerDelegate;

@interface DRBooksThumbnailer : NSObject {
	
	@private
	NSOperationQueue *tasks;
	
}

@property (nonatomic, assign) id<DRBooksThumbnailerDelegate> delegate;

- (void) enqeueTaskForFileAtPath:(NSString*)path thumbnailSize:(CGSize)size;

@end
