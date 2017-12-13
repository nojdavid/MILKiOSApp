//
//  ImageCollectionViewCell.m
//  M.I.L.K.
//
//  Created by noah davidson on 12/12/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.imageView.image = nil;
}

@end
