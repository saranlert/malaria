//
//  ViewController.m
//  MalariaScreening
//
//  Created by Decha Tesapirat on 2/12/2557 BE.
//  Copyright (c) 2557 Decha Tesapirat. All rights reserved.
//

#import "ViewController.h"
#import "UIImageCVMatConverter.h"
@interface ViewController ()
//@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;

@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *takePictureButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *startStopButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *delayedPhotoButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic) UIImagePickerController *imagePickerController;

@property (nonatomic, weak) NSTimer *cameraTimer;
@property (nonatomic) NSMutableArray *capturedImages;

@property UIImage *finalImage,*temp;
@property cv::Mat globalMat;

@end

@implementation ViewController
@synthesize myScrollView,imageView,WBCSum;

NSInteger srctype = 0;

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    
    self.capturedImages = [[NSMutableArray alloc] init];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Camera not found"
                                                              message:@"if click take photo, it will lldb"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }
    
    CALayer *btnLayer = [_roundedButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    
    CALayer *btnLayer2 = [_roundedButton2 layer];
    [btnLayer2 setMasksToBounds:YES];
    [btnLayer2 setCornerRadius:5.0f];
    
    CALayer *btnLayer3 = [_roundChoosePic layer];
    [btnLayer3 setMasksToBounds:YES];
    [btnLayer3 setCornerRadius:5.0f];
    
    CALayer *btnLayer4= [_roundTakePic layer];
    [btnLayer4 setMasksToBounds:YES];
    [btnLayer4 setCornerRadius:5.0f];
    
    CALayer *btnLayer5 = [_Noob1 layer];
    [btnLayer5 setMasksToBounds:YES];
    [btnLayer5 setCornerRadius:5.0f];

    CALayer *btnLayer6= [_Noob2 layer];
    [btnLayer6 setMasksToBounds:YES];
    [btnLayer6 setCornerRadius:5.0f];
    
    
    CALayer *btnLayer7= [_wbcCount layer];
    [btnLayer7 setMasksToBounds:YES];
    [btnLayer7 setCornerRadius:5.0f];
    
    
    CALayer *btnLayer8= [_greenThreshold layer];
    [btnLayer8 setMasksToBounds:YES];
    [btnLayer8 setCornerRadius:5.0f];
    
    CALayer *btnLayer9= [_reset layer];
    [btnLayer9 setMasksToBounds:YES];
    [btnLayer9 setCornerRadius:5.0f];
    
    CALayer *btnLayer10= [_resetPara layer];
    [btnLayer10 setMasksToBounds:YES];
    [btnLayer10 setCornerRadius:5.0f];
    
    ///////
}
- (IBAction)showImagePickerForCamera:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}
- (IBAction)showImagePickerForPhotoPicker:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if (self.imageView.isAnimating)
    {
        [self.imageView stopAnimating];
    }
    
    if (self.capturedImages.count > 0)
    {
        [self.capturedImages removeAllObjects];
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
//    check source type
   if (sourceType == UIImagePickerControllerSourceTypeCamera)
   {
       srctype = 1; // camera
   }else{
       srctype = 0; // library
   }
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (BOOL)shouldAutorotate
{
    return NO;
}
- (void)finishAndUpdate
{
    /// remove before add
    self.imageView.image = nil;
    [[myScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    ///
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if ([self.capturedImages count] > 0)
    {
        if (srctype==1)
        {
           // [self.imageView setImage:[self.capturedImages objectAtIndex:0]];
            UIImage *temp = [self.capturedImages objectAtIndex:0];
            ////
            CGRect newSize = CGRectMake(640.0, 720.0, 1700.0, 1100.0);
            // Create a new image in quartz with our new bounds and original image
            CGImageRef tmp = CGImageCreateWithImageInRect([temp CGImage], newSize);
            // Pump our cropped image back into a UIImage object
            UIImage *newImage = [UIImage imageWithCGImage:tmp];
            // Be good memory citizens and release the memory
            CGImageRelease(tmp);
            [self.imageView setImage:newImage];
            self.finalImage = newImage;
            // save to lib --> need to be remove
            UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
            srctype = 0;
        }else{
            self.finalImage = [self.capturedImages objectAtIndex:0];
            srctype = 0;
        }
        // To be ready to start again, clear the captured images array.
        [self.capturedImages removeAllObjects];
    }
    
    self.imagePickerController = nil;
    
    ///// scroll
    [myScrollView setBackgroundColor:[UIColor blackColor]];
    [myScrollView setCanCancelContentTouches:NO];
    myScrollView.clipsToBounds = YES;
    myScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    NSInteger width = self.finalImage.size.width;
    NSInteger height =self.finalImage.size.height;
    myScrollView.contentSize = CGSizeMake(width,height);
    ///
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    ////
    NSLog(@"width = %f", self.imageView.frame.size.width);
    NSLog(@"height = %f",self.imageView.frame.size.height);
    myScrollView.maximumZoomScale = 6;
	myScrollView.minimumZoomScale = 0.25;
    [myScrollView setZoomScale:0.5 animated:YES];
    [myScrollView setScrollEnabled:YES];
	myScrollView.delegate = self;
    ///
    [self.imageView setImage:self.finalImage];
    [myScrollView addSubview:imageView];

}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self.capturedImages addObject:image];
    
    if ([self.cameraTimer isValid])
    {
        return;
    }
    
    [self finishAndUpdate];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)findContourButton:(id)sender{
    self.globalMat = [UIImageCVMatConverter cvMatFromUIImage:self.finalImage];
    self.finalImage = [self findContour:self.globalMat];
    [self.imageView setImage:self.finalImage];
}
- (void)greyScaleButton:(id)sender{
    self.finalImage = [self greyScaleImage:self.globalMat];
    [self.imageView setImage:self.finalImage];
}
- (void)thresholdButton:(id)sender{
    self.finalImage = [self threshold:self.globalMat];
    [self.imageView setImage:self.finalImage];
}
- (void)createMat:(id)sender{
    self.globalMat = [UIImageCVMatConverter cvMatFromUIImage:self.finalImage];
}
- (void)greenThreshold:(id)sender{
    self.finalImage = [self greenThresholdFromMat:self.globalMat];
    [self.imageView setImage:self.finalImage];
}
- (void)wbcCount:(id)sender{
    self.globalMat = [UIImageCVMatConverter cvMatFromUIImage:self.finalImage];
    self.finalImage = [self wbcCountMethod:self.globalMat];
    [self.imageView setImage:self.finalImage];
}


-(UIImage*)greyScaleImage:(cv::Mat)mat
{   cv::Mat mask;
    cv::inRange(mat,cv::Scalar(105,120,130,0),cv::Scalar(140,160,170,255),mask);
    //cv::inRange(mat,cv::Scalar(150,135,115,0),cv::Scalar(165,150,130,255),mask);
     int morph_size = 20;
    cv::Mat element = getStructuringElement( cv::MORPH_ELLIPSE, cv::Size( morph_size , morph_size ), cv::Point(-1,-1) );
    cv::dilate(mask, mask, element);
    cv::erode(mask, mask, element);
    mat.setTo(cv::Scalar(255,255,255),mask);
    self.globalMat = mat;
    return [UIImageCVMatConverter UIImageFromCVMat:mat];
    
}

int def1 = 0;
int def = 0;
int nsum;
-(UIImage*)findContour:(cv::Mat)mat2
{NSLog(@"test2 %d",nsum);
    
    cv::Mat originalMat = mat2;
    UIImage *image2 = [UIImageCVMatConverter UIImageFromCVMat:mat2];
    cv::Mat mat = [UIImageCVMatConverter cvMatFromUIImage:image2];
    cv::Mat mask;
    cv::inRange(mat,cv::Scalar(105,120,130,0),cv::Scalar(140,160,170,255),mask);
    //cv::inRange(mat,cv::Scalar(150,135,115,0),cv::Scalar(165,150,130,255),mask);
    int morph_size = 20;
    cv::Mat element = getStructuringElement( cv::MORPH_ELLIPSE, cv::Size( morph_size , morph_size ), cv::Point(-1,-1) );
    cv::dilate(mask, mask, element);
    cv::erode(mask, mask, element);
    mat.setTo(cv::Scalar(255,255,255),mask);

    
//    cv::vector<cv::Mat> layers;
//    split(mat, layers);
//    mat = layers[1];
    //change to greyscale
    cv::cvtColor(mat, mat, CV_RGB2GRAY);
    //perform threshold
    cv::adaptiveThreshold(mat, mat, 255, cv::ADAPTIVE_THRESH_MEAN_C, cv::THRESH_BINARY_INV, 901, 70);
    //opening to join scattered pieces of contours
    element = getStructuringElement( cv::MORPH_ELLIPSE, cv::Size( morph_size , morph_size ), cv::Point(-1,-1) );
    cv::dilate(mat, mat, element);
    cv::erode(mat, mat, element);
    //count contours
    std::vector<std::vector<cv::Point>> contours;
    cv::findContours(mat,contours,CV_RETR_EXTERNAL,CV_CHAIN_APPROX_SIMPLE);
    //change back to rgb
    cv::cvtColor(mat,mat,CV_GRAY2BGR);
    int ncont = contours.size();
    cv::Scalar color = cv::Scalar(255,0,255);
    //cut out the contours that are at the edge
    Boolean atEdge;
    for(int i=0;i<contours.size();i++){
        atEdge = false;
        NSLog(@"area %f",cv::contourArea(contours[i]));
        if(cv::contourArea(contours[i])<60&&cv::contourArea(contours[i])>2){
            for(int j =1;j<1699;j++){cv::Point point = cv::Point(j,1);
                if(cv::pointPolygonTest(contours[i], point, false)==0||cv::pointPolygonTest(contours[i], point, false)==1){
                    atEdge = true;
                    NSLog(@"area %s","TRUE 1");
                    break;
                }
            }
            if (atEdge==false)
            for(int j =1;j<1699;j++){cv::Point point = cv::Point(j,1098);
                if(cv::pointPolygonTest(contours[i], point, false)==0||cv::pointPolygonTest(contours[i], point, false)==1){
                    atEdge = true;
                    NSLog(@"area %s","TRUE 2");
                    break;
                }
            }
            if (atEdge==false)
            for(int j =1;j<1099;j++){cv::Point point = cv::Point(1,j);
                if(cv::pointPolygonTest(contours[i], point, false)==0||cv::pointPolygonTest(contours[i], point, false)==1){
                    atEdge = true;
                    NSLog(@"area %s","TRUE 3");
                    break;
                }
            }
            if (atEdge==false)
            for(int j =1;j<1099;j++){cv::Point point = cv::Point(1698,j);
                if(cv::pointPolygonTest(contours[i], point, false)==0||cv::pointPolygonTest(contours[i], point, false)==1){
                    atEdge = true;
                    NSLog(@"area %s","TRUE 4");
                    break;
                }
            }
            if(atEdge==false)
            cv::drawContours(originalMat, contours, i, color);
            else ncont--;
        }
        else ncont--;
    }
    
    
    int nsum2 = def1+ncont;
    def1 = nsum2;


    NSString *Sum = self.WBCSum.text;
    NSString *temp = [Sum substringWithRange:NSMakeRange(4, ([Sum length]-4))];
    int value = [temp intValue];

    
    NSLog(@"%d",ncont);
    showCount2.text = [NSString stringWithFormat:@"Parasite:%d",ncont];
    
    
    self.globalMat = originalMat;
    showCount2.text = [NSString stringWithFormat:@"Parasite:%d",ncont];
   
    showSum2.text = [NSString stringWithFormat:@"SUM:%d",nsum2];
    
    if (value<200) {
        showResult.text = [NSString stringWithFormat:@"Processing"];
        NSLog(@"test value1 %d",value);
         NSLog(@"aa nsum1 %d",nsum2);
    }
    else if (value>=200&&value<500){
        showResult.text = [NSString stringWithFormat:@"Processing"];
        NSLog(@"testd2 nsum %d",nsum);
        
    }
    else if (value>=200&&nsum2>0){
        showResult.text = [NSString stringWithFormat:@"Positive"];
    }
    else showResult.text = [NSString stringWithFormat:@"Negative"];
    
    return [UIImageCVMatConverter UIImageFromCVMat:originalMat];
}
-(UIImage*)threshold:(cv::Mat)mat
{
    //cv::cvtColor(mat, mat, CV_RGB2GRAY);
    cv::adaptiveThreshold(mat, mat, 255, cv::ADAPTIVE_THRESH_MEAN_C, cv::THRESH_BINARY_INV, 901, 70);
    //cv::threshold(mat,mat,thresholdSlider.value,255,cv::THRESH_BINARY);
    
    
    //    cv::erode(mat, mat, element);
    //    cv::dilate(mat, mat, element);
    self.globalMat = mat;
    return [UIImageCVMatConverter UIImageFromCVMat:mat];
    
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return imageView;
}
- (UIImage*)greenThresholdFromMat:(cv::Mat)mat
{
    //closing
    int morph_size = 20;
    cv::Mat element = getStructuringElement( cv::MORPH_ELLIPSE, cv::Size( morph_size , morph_size ), cv::Point(-1,-1) );

    //cv::Mat element(8,8,CV_8U,cv::Scalar(1));
    cv::dilate(mat, mat, element);
    cv::erode(mat, mat, element);
    
    self.globalMat = mat;
    return [UIImageCVMatConverter UIImageFromCVMat:mat];
}

- (UIImage*)wbcCountMethod:(cv::Mat)mat
{
    
    cv::Mat originalMat = mat;
    
    cv::cvtColor(mat, mat, CV_RGB2GRAY);
    cv::GaussianBlur(mat, mat, cv::Size(9,9),0,0);
    cv::adaptiveThreshold(mat, mat, 255, cv::ADAPTIVE_THRESH_MEAN_C, cv::THRESH_BINARY_INV, 901, 50);
    int morph_size = 10;
    cv::Mat element = getStructuringElement( cv::MORPH_ELLIPSE, cv::Size( morph_size , morph_size ), cv::Point(-1,-1) );
    
    //cv::Mat element(8,8,CV_8U,cv::Scalar(1));
    cv::dilate(mat, mat, element);
    cv::erode(mat, mat, element);
    std::vector<std::vector<cv::Point>> contours;
    cv::findContours(mat,contours,CV_RETR_EXTERNAL,CV_CHAIN_APPROX_SIMPLE);
    cv::cvtColor(mat,mat,CV_GRAY2BGR);
    
    int ncont = contours.size();
    cv::Scalar color = cv::Scalar(30,200,30);
    for(int i=0;i<contours.size();i++){
        NSLog(@"area%f",cv::contourArea(contours[i]));
        if(cv::contourArea(contours[i])>400&&cv::contourArea(contours[i])<2000)cv::drawContours(originalMat, contours, i, color);
        else if(cv::contourArea(contours[i])>=2000&&cv::contourArea(contours[i])<4000){cv::drawContours(originalMat,contours,i,cv::Scalar(0,0,255)); ncont++;}
        else ncont--;
    }
    
    int nsum = def+ncont;
    def = nsum;
    
    NSLog(@"%d",nsum);
    showCount.text = [NSString stringWithFormat:@"WBC:%d",ncont];
    self.globalMat = originalMat;
    showCount.text = [NSString stringWithFormat:@"WBC:%d",ncont];
    
    showSum.text = [NSString stringWithFormat:@"SUM:%d",nsum];
    
    
    return [UIImageCVMatConverter UIImageFromCVMat:originalMat];
}

- (IBAction)resetWBC:(id)sender {
    showCount.text = [NSString stringWithFormat:@"WBC:%d",0];
    showSum.text = [NSString stringWithFormat:@"SUM:%d",0];
    showResult.text = [NSString stringWithFormat:@"Result"];
    def = 0;
}


- (IBAction)resetPara:(id)sender {
    showCount2.text = [NSString stringWithFormat:@"Parasite:%d",0];
    showSum2.text = [NSString stringWithFormat:@"Sum:%d",0];
    showResult.text = [NSString stringWithFormat:@"Result"];
    def1 = 0;
}



@end