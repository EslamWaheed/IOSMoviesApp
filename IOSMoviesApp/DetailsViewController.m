//
//  DetailsViewController.m
//  IOSMoviesApp
//
//  Created by EslamWaheed on 5/8/18.
//  Copyright © 2018 EslamWaheed. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController (){
    
    NSMutableData *reviewsData;
    NSMutableArray<Reviews*> *reviewsList;
    NSURLConnection *reviewurlConnection;
    
    NSMutableData *videosData;
    NSMutableArray<Videos*> *videosList;
    NSURLConnection *videourlConnection;
}

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     @property NSString *title;
     */
    
    reviewsList = [NSMutableArray new];
    videosList  = [NSMutableArray new];
    
    NSString *reviewurlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%d/reviews?api_key=97d00ec2ce73d12ed605e60ff3bba8cc",   _movie.movieID];
    
    NSURL *reviewurl = [[NSURL alloc] initWithString:reviewurlString];
    NSURLRequest *reviewurlRequest = [NSURLRequest requestWithURL:reviewurl];
    reviewurlConnection = [[NSURLConnection alloc] initWithRequest:reviewurlRequest delegate:self];
    [reviewurlConnection start];
    
    
    NSString *videourlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%d/videos?api_key=97d00ec2ce73d12ed605e60ff3bba8cc",   _movie.movieID];
    
    NSURL *videourl = [[NSURL alloc] initWithString:videourlString];
    NSURLRequest *videourlRequest = [NSURLRequest requestWithURL:videourl];
    videourlConnection = [[NSURLConnection alloc] initWithRequest:videourlRequest delegate:self];
    [reviewurlConnection start];
    
    
    [_dimage sd_setImageWithURL:[NSURL URLWithString:_movie.poster_path] placeholderImage:[UIImage imageNamed:@"avgeneric.png"]];
    
    _dyear.text = _movie.release_date;
    
    _drate.text = [NSString stringWithFormat:@"%f/10", _movie.vote_average];
    
    _doverview.text = _movie.overview;
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if(connection == reviewurlConnection){
        reviewsData = [NSMutableData new];
    }else if(connection == videourlConnection){
        videosData = [NSMutableData new];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if(connection == reviewurlConnection){
        [reviewsData appendData:data];
    }else if(connection == videourlConnection){
        [videosData appendData:data];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if(connection == reviewurlConnection){
        
        NSString *reviewsResultData = [[NSString alloc] initWithData:reviewsData encoding:NSUTF8StringEncoding];
        
        NSDictionary *reviewsDicData = [NSJSONSerialization JSONObjectWithData:reviewsData options:NSJSONReadingAllowFragments error:nil];
        
        NSArray *reviewResultArray = [[NSArray alloc] initWithArray:[reviewsDicData objectForKey:@"results"]];
        
        for (int i = 0; i<[reviewResultArray count]; i++){
            Reviews *reviews = [Reviews new];
            
            NSDictionary *resultDic = [NSDictionary new];
            
            resultDic = [reviewResultArray objectAtIndex:i ];
            
            reviews.movieID = _movie.movieID;
            reviews.reviewAuthor = [[NSString alloc]initWithString:[resultDic objectForKey:@"author"]];
            reviews.reviewContent = [[NSString alloc]initWithString:[resultDic objectForKey:@"content"]];
            
            [reviewsList addObject:reviews];
            
            [self loadReview];
        }
    }else if(connection == videourlConnection){
        NSString *videosResultData = [[NSString alloc] initWithData:videosData encoding:NSUTF8StringEncoding];
        
        NSDictionary *videosDicData = [NSJSONSerialization JSONObjectWithData:videosData options:NSJSONReadingAllowFragments error:nil];
        
        NSArray *videosResultArray = [[NSArray alloc] initWithArray:[videosDicData objectForKey:@"results"]];
        
        for (int i = 0; i<[videosResultArray count]; i++){
            Videos *videos = [Videos new];
            
            NSDictionary *resultDic = [NSDictionary new];
            
            resultDic = [videosResultArray objectAtIndex:i ];
            
            videos.movieID = _movie.movieID;
            videos.videoName = [[NSString alloc]initWithString:[resultDic objectForKey:@"name"]];
            videos.videoKey = [[NSString alloc]initWithString:[resultDic objectForKey:@"key"]];
            
            [videosList addObject:videos];
            
            [self loadVideo];
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)favourit:(id)sender {
    MoviesDB *movieDB = [MoviesDB new];
    
    [movieDB insertMovie:_movie];
    
    ReviewsDB *reviewsDB = [ReviewsDB new];
    
    for(int i = 0; i<[reviewsList count]; i++){
        [reviewsDB insertReview:[reviewsList objectAtIndex:i]];
    }
    
    VideosDB *videosDB = [VideosDB new];
    
    for(int j = 0; j<[videosList count]; j++){
        [videosDB insertVideos:[videosList objectAtIndex:j]];
    }
    
}

- (void) loadReview{
    for (int i = 0; i<[reviewsList count]; i++){
        //add reviews to view
        
        UILabel *reviewAuthorLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+(i*115), 10+(i*115),100, 100)];
        
        UILabel *reviewContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15+(i*115), 15+(i*115),100, 100)];
        
        reviewAuthorLabel.text = [[reviewsList objectAtIndex:i] reviewAuthor];
        
        reviewContentLabel.text = [[reviewsList objectAtIndex:i] reviewContent];
        
        [_reviewView addSubview:reviewAuthorLabel];
        
        [_reviewView addSubview:reviewContentLabel];
    }
}

- (void) loadVideo{
    for (int i = 0; i<[videosList count]; i++){
        //add videos to view
        
        UILabel *videoNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+(i*115), 10+(i*115),100, 100)];
        
        UILabel *videoUrlLabel = [[UILabel alloc]initWithFrame:CGRectMake(15+(i*115), 15+(i*115),100, 100)];
        
        videoNameLabel.text = [[videosList objectAtIndex:i] videoName];
        
        videoUrlLabel.text = [[NSString alloc]initWithFormat:@"https://www.youtube.com/watch?%@", [[videosList objectAtIndex:i] videoKey]];
        
        [_trailerView addSubview:videoNameLabel];
        
        [_trailerView addSubview:videoUrlLabel];
    }
}
@end
