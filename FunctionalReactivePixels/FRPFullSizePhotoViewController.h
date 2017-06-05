//
//  FRPFullSizePhotoViewController.h
//  FunctionalReactivePixels
//
//  Created by William Peregoy on 5/29/17.
//  Copyright © 2017 William Peregoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRPFullSizePhotoViewController;
@class FRPFullSizePhotoViewModel;

@protocol FRPFullSizePhotoViewControllerDelegate <NSObject>

- (void)userDidScroll:(FRPFullSizePhotoViewController *)viewController toPhotoAtIndex:(NSInteger)index;

@end

@interface FRPFullSizePhotoViewController : UIViewController

@property (nonatomic, strong) FRPFullSizePhotoViewModel *viewModel;

@property (nonatomic, weak) id<FRPFullSizePhotoViewControllerDelegate> delegate;

@end
