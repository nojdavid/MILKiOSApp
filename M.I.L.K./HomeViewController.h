//
//  HomeViewController.h
//  M.I.L.K.
//
//  Created by noah davidson on 12/12/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end
