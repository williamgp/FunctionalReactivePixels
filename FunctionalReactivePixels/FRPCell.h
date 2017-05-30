//
//  FRPCell.h
//  FunctionalReactivePixels
//
//  Created by William Peregoy on 5/29/17.
//  Copyright © 2017 William Peregoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRPPhotoModel;

@interface FRPCell : UICollectionViewCell

@property (nonatomic, strong) FRPPhotoModel *photoModel;

//- (void)setPhotoModel:(FRPPhotoModel *)photoModel;

@end
