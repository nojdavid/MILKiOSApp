//
//  HomeViewController.m
//  M.I.L.K.
//
//  Created by noah davidson on 12/12/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

#import "HomeViewController.h"
#import "ViewController.h"
#import "ImageCollectionViewCell.h"
#import "CustomImageFlowLayout.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

#pragma mark - collectionView methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *imageName = indexPath.row % 2 ? @"image1" : @"image2";
    
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 25.0;
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.collectionViewLayout = [[CustomImageFlowLayout alloc] init];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
