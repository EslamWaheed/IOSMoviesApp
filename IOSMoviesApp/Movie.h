//
//  Movie.h
//  IOSMoviesApp
//
//  Created by EslamWaheed on 5/7/18.
//  Copyright © 2018 EslamWaheed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Videos.h"
#import "Reviews.h"

@interface Movie : NSObject

@property int  movieID;
@property double vote_average;
@property NSString *title;
@property NSString *poster_path;
@property NSString *overview;
@property NSString *release_date;

@end
