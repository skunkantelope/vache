//
//  DrawOnPhotoViewController.m
//  City 311
//
//  Created by Qian Wang on 1/14/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "DrawOnPhotoViewController.h"
#import "CityFixoryViewController.h"

@interface DrawOnPhotoViewController () {
    CGPoint point0;
    CGPoint point1;
    CGPoint point2;
    CGPoint point3; // use 4 points to smooth lines. use bezier curve.
    BOOL draw;
    BOOL start;
    CGContextRef context;
    UIView *drawing;
}

@property (weak, nonatomic) IBOutlet UIButton *drawingButton;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
- (IBAction)returnImage:(id)sender;
- (IBAction)switchBrushEraser:(id)sender;

@end

@implementation DrawOnPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    float w = self.image.size.width;
    float h = self.image.size.height;
    
    const float width_max = 280;
    float height_max = self.view.bounds.size.height - 120;
    CGRect rect;
    if (w >= h) {
        float height = width_max * h / w;
        rect = CGRectMake(20, 90 + (height_max - height)/2, width_max, height);
    } else { // image view frame is not a square. height_max is greater than width_max.
        float width = w * height_max /h;
        if (width > width_max) {
            // fit the width
            float height = width_max * h / w;
            rect = CGRectMake(20, 90 + (height_max - height)/2, width_max, height);
        } else {
            rect = CGRectMake(20 + (width_max - width)/2, 90, width, height_max);
        }
    }
    self.photo.frame = rect;
    self.photo.image = self.image;

    draw = true; // initialize the editing with drawing mode until the user switch to eraser.
    start = false;
    
    drawing = [[UIView alloc] initWithFrame:self.photo.frame];
    drawing.contentMode = UIViewContentModeScaleAspectFit;

    // root layer uses the UIKit coordinate system.
    
    [self.view addSubview:drawing];
    // initialize points to some negative values.
    point0 = CGPointMake(-3.0, -3.0);
    point1 = point0;
    point2 = point1;
}

    // Two methods.
    // No. 1: Use drawRect: method and setNeedsDisplay to update the view. It draws directly on the user screen. Inside the method, UIGraphicsGetCurrentContext will return a valid context.
    // NO. 2: Use bit-map context. Draw off screen and get the image from CGContext and display on the user screen.
    // Maintain the image context. Draw on the second context. Combine the two contexts and get the composite image to show on the user interface. Eraser is to clear the context drawn on the second context. Whenever on the user screen, it is the composite UIImage retrieved from current graphics context. Create a second UIImageView as a container to store the drawings made by the user. Erase will be modified on this UIImageView with clear color. Here the first context is the original photo itself.

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    point3 = [touch locationInView:drawing];

    // Will not start drawing if the touch is outside the photo image.
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
        UITouch *touch = [touches anyObject];
        point0 = point1;
        point1 = point2;
        point2 = point3;
        point3 = [touch locationInView:drawing];
    
    if ( CGRectContainsPoint(drawing.bounds, point0) ) {
        start = true;
    } else {
        start = false;
    }
    
     if (start) {
        if (!context) {
            UIGraphicsBeginImageContext(drawing.bounds.size);
            context = UIGraphicsGetCurrentContext();
        }
        if (draw) {
            
            CGContextSetBlendMode(context, kCGBlendModeNormal);
            CGContextSetLineWidth(context, 5);

            CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 0.3);
        
        } else { // to erase
           
            CGContextSetBlendMode(context, kCGBlendModeClear);
            CGContextSetLineWidth(context, 10);
                
            CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.0);
        
        }
         CGContextSetLineCap(context, kCGLineCapRound);
         double xc1 = (point0.x + point1.x) / 2.0;
         double yc1 = (point0.y + point1.y) / 2.0;
         double xc2 = (point1.x + point2.x) / 2.0;
         double yc2 = (point1.y + point2.y) / 2.0;
         double xc3 = (point2.x + point3.x) / 2.0;
         double yc3 = (point2.y + point3.y) / 2.0;
         
         double len1 = sqrt((point1.x-point0.x) * (point1.x-point0.x) + (point1.y-point0.y) * (point1.y-point0.y));
         double len2 = sqrt((point2.x-point1.x) * (point2.x-point1.x) + (point2.y-point1.y) * (point2.y-point1.y));
         double len3 = sqrt((point3.x-point2.x) * (point3.x-point2.x) + (point3.y-point2.y) * (point3.y-point2.y));
         
         double k1 = len1 / (len1 + len2);
         double k2 = len2 / (len2 + len3);
         
         double xm1 = xc1 + (xc2 - xc1) * k1;
         double ym1 = yc1 + (yc2 - yc1) * k1;
         double xm2 = xc2 + (xc3 - xc2) * k2;
         double ym2 = yc2 + (yc3 - yc2) * k2;
         
         double smooth_value = 0.5;
         float ctrl1_x = xm1 + (xc2 - xm1) * smooth_value + point1.x - xm1;
         float ctrl1_y = ym1 + (yc2 - ym1) * smooth_value + point1.y - ym1;
         float ctrl2_x = xm2 + (xc2 - xm2) * smooth_value + point2.x - xm2;
         float ctrl2_y = ym2 + (yc2 - ym2) * smooth_value + point2.y - ym2;

         CGContextMoveToPoint(context, point1.x, point1.y);
         CGContextAddCurveToPoint(context, ctrl1_x, ctrl1_y, ctrl2_x, ctrl2_y, point2.x, point2.y);
         CGContextStrokePath(context);
         
         UIImage *highlights = UIGraphicsGetImageFromCurrentImageContext();
         drawing.layer.contents = (__bridge id)(highlights.CGImage); // shall translate the coordinate.

    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ShowImage"]) {
        UIGraphicsEndImageContext();
        
        CityFixoryViewController *viewController = [segue destinationViewController];
        
        UIGraphicsBeginImageContext(self.image.size);
        [self.image drawInRect:CGRectMake(0, 0, self.image.size.width, self.image.size.height)];
        CGContextRef cgContext = UIGraphicsGetCurrentContext();
        [drawing.layer renderInContext:cgContext];
        
        UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
        viewController.incidentImage.image = theImage;
        
        UIGraphicsEndImageContext();
    }
}

- (IBAction)returnImage:(id)sender {
    // send a notification to presentingViewController to receive the image.
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"ShowImage" sender:nil];
}

- (IBAction)switchBrushEraser:(id)sender {
    if (draw) {
        self.drawingButton.backgroundColor = [UIColor yellowColor];
        draw = false;
       
    } else {
        self.drawingButton.backgroundColor = [UIColor greenColor];
        draw = true;
    }
}

@end
