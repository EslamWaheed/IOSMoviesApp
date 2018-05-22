//
//  ReviewsDB.h
//  IOSMoviesApp
//
//  Created by EslamWaheed on 5/8/18.
//  Copyright © 2018 EslamWaheed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reviews.h"
#import "DatabaseManager.h"
#import <sqlite3.h>

@interface ReviewsDB : NSObject

- (NSMutableArray<Reviews *> *) getAllReviews;

- (void) insertReview: (Reviews*) review;

- (void) deleteReview: (int) movieID;

@end
