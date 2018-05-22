//
//  MoviesDB.h
//  IOSMoviesApp
//
//  Created by EslamWaheed on 5/8/18.
//  Copyright © 2018 EslamWaheed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"
#import "DatabaseManager.h"
#import <sqlite3.h>

@interface MoviesDB : NSObject

- (NSMutableArray<Movie *> *) getAllMovies;

- (void) insertMovie: (Movie*) movie;

- (void) deleteMovie: (int) movieID;

@end
