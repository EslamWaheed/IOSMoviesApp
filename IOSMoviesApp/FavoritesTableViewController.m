//
//  FavoritesTableViewController.m
//  IOSMoviesApp
//
//  Created by EslamWaheed on 5/18/18.
//  Copyright © 2018 EslamWaheed. All rights reserved.
//

#import "FavoritesTableViewController.h"

@interface FavoritesTableViewController (){
    NSMutableArray<Movie*> *moviesList;
}

@end

@implementation FavoritesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    moviesList = [NSMutableArray new];
    
    MoviesDB *moviesDB = [MoviesDB new];
    
    moviesList = [moviesDB getAllMovies];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [moviesList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favorites" forIndexPath:indexPath];
    
    cell.textLabel.text = [[moviesList objectAtIndex:indexPath.row] title];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[moviesList objectAtIndex:indexPath.item ] poster_path]] placeholderImage:[UIImage imageNamed:@"avgeneric.png"]];
    
    cell.detailTextLabel.text = [[moviesList objectAtIndex:indexPath.row] release_date];
    return cell;
}

@end
