//
//  VideosDB.h
//  IOSMoviesApp
//
//  Created by EslamWaheed on 5/8/18.
//  Copyright © 2018 EslamWaheed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Videos.h"
#import "DatabaseManager.h"
#import <sqlite3.h>

@interface VideosDB : NSObject

- (NSMutableArray<Videos *> *) getAllVideos;

- (void) insertVideos: (Videos*) videos;

- (void) deleteVideos: (int) movieID;

@end
