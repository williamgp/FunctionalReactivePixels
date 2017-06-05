//
//  FRPPhotoViewController.m
//  FunctionalReactivePixels
//
//  Created by William Peregoy on 5/29/17.
//  Copyright © 2017 William Peregoy. All rights reserved.
//

#import "FRPPhotoViewController.h"

//Model
#import "FRPPhotoModel.h"

//Utilities
#import "FRPPhotoImporter.h"
#import <SVProgressHUD.h>

@interface FRPPhotoViewController ()

//Private assignment
@property (nonatomic, assign) NSInteger photoIndex;
@property (nonatomic, strong) FRPPhotoModel *photoModel;

//Private properties
@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation FRPPhotoViewController

- (instancetype)initWithPhotoModel:(FRPPhotoModel *)photoModel index:(NSInteger)photoIndex {
    self = [self init];
    if (!self) return nil;
    
    _photoModel = photoModel;
    _photoIndex = photoIndex;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //Configure selfs view
    self.view.backgroundColor = [UIColor blackColor];

    //Configure subviews
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    RAC(imageView, image) = [RACObserve(self.photoModel, fullsizedData) map:^id(id value) {
        return [UIImage imageWithData:value];
    }];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    self.imageView = imageView;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [SVProgressHUD show];
    
    //Fetch data
    [[FRPPhotoImporter fetchPhotoDetails:self.photoModel] subscribeError:^(NSError * _Nullable error) {
        [SVProgressHUD showErrorWithStatus:@"Error"];
    } completed:^{
        [SVProgressHUD dismiss];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (NSURLRequest *)photoURLRequest:(FRPPhotoModel *)photoModel {
    return [[PXRequest apiHelper] urlRequestForPhotoID:photoModel.identifier.integerValue];
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
