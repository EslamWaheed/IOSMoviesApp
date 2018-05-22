//
//  DetailsViewController.h
//  IOSMoviesApp
//
//  Created by EslamWaheed on 5/8/18.
//  Copyright © 2018 EslamWaheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "Reviews.h"
#import "Videos.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MoviesDB.h"
#import "ReviewsDB.h"
#import "VideosDB.h"

@interface DetailsViewController : UIViewController

@property Movie *movie;

@property (weak, nonatomic) IBOutlet UIImageView *dimage;
@property (weak, nonatomic) IBOutlet UILabel *dyear;
@property (weak, nonatomic) IBOutlet UILabel *dlength;
@property (weak, nonatomic) IBOutlet UILabel *drate;
@property (weak, nonatomic) IBOutlet UILabel *doverview;
- (IBAction)favourit:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *trailerView;
@property (weak, nonatomic) IBOutlet UIView *reviewView;

@end
