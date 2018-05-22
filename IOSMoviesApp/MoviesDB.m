//
//  MoviesDB.m
//  IOSMoviesApp
//
//  Created by EslamWaheed on 5/8/18.
//  Copyright © 2018 EslamWaheed. All rights reserved.
//

#import "MoviesDB.h"

@implementation MoviesDB

- (NSMutableArray<Movie *> *) getAllMovies{
    
    DatabaseManager *databaseManager = [DatabaseManager sharedInstance];
    
    NSMutableArray<Movie*> *moviesList = [NSMutableArray new];
    
    const char *dbPath = [databaseManager.databasePath UTF8String];
    
    sqlite3 *contacDB = databaseManager.contacDB;
    
    sqlite3_stmt *stmt;
    
    if (sqlite3_open(dbPath, &contacDB) == SQLITE_OK) {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM Movies"];
        const char *sql_stmt = [querySQL UTF8String];
        
        if(sqlite3_prepare_v2(contacDB, sql_stmt, -1, &stmt, NULL) == SQLITE_OK){
            while(sqlite3_step(stmt) == SQLITE_ROW){
                
                Movie *movie = [Movie new];
                
                movie.movieID = sqlite3_column_int(stmt, 0);
                movie.vote_average = sqlite3_column_double(stmt, 1);
                movie.title = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(stmt, 2)];
                movie.poster_path = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(stmt, 3)];
                movie.overview = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(stmt, 4)];
                movie.release_date = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(stmt, 5)];
                
                [moviesList addObject:movie];
            }
            sqlite3_finalize(stmt);
        }
        sqlite3_close(contacDB);
    }
    
    return moviesList;
}

- (void) insertMovie: (Movie*) movie{
    
    DatabaseManager *databaseManager = [DatabaseManager sharedInstance];
    
    const char *dbPath = [databaseManager.databasePath UTF8String];
    
    sqlite3 *contacDB = databaseManager.contacDB;
    
    sqlite3_stmt *stmt;
    
    if(sqlite3_open(dbPath, &contacDB) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO Movies (movieID, vote_average, title, poster_path, overview, release_date) VALUES (\"%i\", \"%f\", \"%@\", \"%@\", \"%@\", \"%@\") ", movie.movieID, movie.vote_average, movie.title, movie.poster_path, movie.overview, movie.release_date];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(contacDB, insert_stmt, -1, &stmt, NULL);
        
        if(sqlite3_step(stmt) == SQLITE_DONE){
            printf("%s", "Movie Add\n");
            
        }else{
            printf("%s", "Failed to Add\n");
        }
        sqlite3_finalize(stmt);
        sqlite3_close(contacDB);
    }
}

- (void) deleteMovie: (int) movieID{
    
    DatabaseManager *databaseManager = [DatabaseManager sharedInstance];
    
    const char *dbPath = [databaseManager.databasePath UTF8String];
    
    sqlite3 *contacDB = databaseManager.contacDB;

    sqlite3_stmt *stmt;
    
    if (sqlite3_open(dbPath, &contacDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Movies WHERE movieID = \"%d\" ", movieID];
        
        const char *sql_stmt = [querySQL UTF8String];
        
        if(sqlite3_prepare_v2(contacDB, sql_stmt, -1, &stmt, NULL) == SQLITE_OK){
            if(sqlite3_step(stmt) == SQLITE_DONE){
                sqlite3_reset(stmt);
            }else{
                NSLog(@"%s", sqlite3_errmsg(contacDB));
            }
            sqlite3_finalize(stmt);
        }
        sqlite3_close(contacDB);
    }
}

@end
