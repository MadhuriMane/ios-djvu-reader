//
//  DRBooksThumbnailerDelegate.h
//  DjvuViewer
//
//  Created by Alex Martynov on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DRBooksThumbnailer;

@protocol DRBooksThumbnailerDelegate <NSObject>

- (void) djvuThumbnailer:(DRBooksThumbnailer*)thumbnailer didGenerateThumbnail:(UIImage*)thumbnail;

@end
