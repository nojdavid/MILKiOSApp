//
//  DetailViewController.m
//  M.I.L.K.
//
//  Created by noah davidson on 12/13/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

#import "DetailViewController.h"
#import "CommentBoardViewController.h"
@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"openCommentView" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openCommentView"])
    {
        CommentBoardViewController *commentBoardViewController = segue.destinationViewController;
        
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *indexPath = (NSIndexPath*)sender;
                //pass info here
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = self.imageToPresent;
    // Do any additional setup after loading the view.
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
