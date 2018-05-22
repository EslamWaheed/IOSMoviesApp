//
//  MainCollectionViewController.h
//  IOSMoviesApp
//
//  Created by EslamWaheed on 5/16/18.
//  Copyright © 2018 EslamWaheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "Movie.h"
#import "MoviesDB.h"
#import "DetailsViewController.h"

@interface MainCollectionViewController : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource, NSURLConnectionDelegate,  NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *collectionImage;

@end
