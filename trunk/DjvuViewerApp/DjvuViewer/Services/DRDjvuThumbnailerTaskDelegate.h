//
//  DRDjvuThumbnailerTaskDelegate.h
//  DjvuViewer
//
//  Created by Alex Martynov on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DRDjvuThumbnailerTask;

@protocol DRDjvuThumbnailerTaskDelegate <NSObject>

- (void) thumbnailerTask:(DRDjvuThumbnailerTask*)task didFinishedWithThumbnail:(UIImage*)image;

@end
