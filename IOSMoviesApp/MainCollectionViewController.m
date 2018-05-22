//
//  MainCollectionViewController.m
//  IOSMoviesApp
//
//  Created by EslamWaheed on 5/16/18.
//  Copyright © 2018 EslamWaheed. All rights reserved.
//

#import "MainCollectionViewController.h"

@interface MainCollectionViewController (){
    
    NSMutableData *moviesData;
    NSMutableArray<Movie*> *moviesList;
}

@end

@implementation MainCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    moviesList = [NSMutableArray new];
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/discover/movie?api_key=97d00ec2ce73d12ed605e60ff3bba8cc&language=en-US&sort_by=popularity.desc&include_video=true"];
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [urlConnection start];
    
    NSMutableArray *testDB = [NSMutableArray new];
    MoviesDB *testget = [MoviesDB new];
    
    [testget deleteMovie:354912];
    
    [testget deleteMovie:181808];
    
    [testget deleteMovie:284053];
    
    [testDB addObjectsFromArray:[testget getAllMovies]];

}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    moviesData = [NSMutableData new];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [moviesData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *resultData = [[NSString alloc] initWithData:moviesData encoding:NSUTF8StringEncoding];
    
    NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:moviesData options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *resultArray = [[NSArray alloc] initWithArray:[dicData objectForKey:@"results"]];
    
    for (int i = 0; i<[resultArray count]; i++) {
        Movie *movies = [Movie new];
        NSDictionary *resultDic = [NSDictionary new];
        
        resultDic = [resultArray objectAtIndex:i];
        
        NSString *mid = [[NSString alloc] initWithFormat:@"%@", [resultDic objectForKey:@"id"]];
        
        movies.movieID = [mid intValue];
        
        NSString *mvote_average = [[NSString alloc ] initWithFormat:@"%@", [resultDic objectForKey:@"vote_average"]];
        
        movies.vote_average = [mvote_average doubleValue];
        
        movies.title = [[NSString alloc] initWithString:[resultDic objectForKey:@"title"]];
        movies.poster_path = [[NSString alloc] initWithFormat:@"%@%@",@"http://image.tmdb.org/t/p/w185",[resultDic objectForKey:@"poster_path"]];
        
        movies.overview = [[NSString alloc] initWithString:[resultDic objectForKey:@"overview"]];
        movies.release_date = [[NSString alloc] initWithString:[resultDic objectForKey:@"release_date"]];
        
        [moviesList addObject:movies];
        
//        MoviesDB *movieDB = [MoviesDB new];

//        [movieDB insertMovie:movies];

        [self.collectionView reloadData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [moviesList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImageView *imageView = [cell viewWithTag:1];
    
    if([[moviesList objectAtIndex:indexPath.item ] poster_path] == nil){
        imageView.image = [UIImage imageNamed:@"avgeneric.png"];
    }else{
        [imageView sd_setImageWithURL:[NSURL URLWithString:[[moviesList objectAtIndex:indexPath.item ] poster_path]]                 placeholderImage:[UIImage imageNamed:@"avgeneric.png"]];
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Item at index %d\n", indexPath.item);
    
    DetailsViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    
    details.movie = [moviesList objectAtIndex:indexPath.item];
    
    [self.navigationController pushViewController:details animated:YES];
    return YES;
}

@end
