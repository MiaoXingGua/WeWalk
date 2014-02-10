//
//  ALGPSHelper.h
//  TestGPS
//
//  Created by Albert on 13-8-29.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CSqlite.h"
#import <MapKit/MapKit.h>

@interface ALGPSHelper : NSObject <CLLocationManagerDelegate>
{
    CSqlite *_m_sqlite;
    CLLocationManager *_locationManager;
}

+ (ALGPSHelper *)OpenGPS;
- (void)initMapWithFrame:(CGRect)frame superView:(UIView *)superView;
- (void)refreshLocation;

@property (readonly, nonatomic)  CLLocationDegrees latitude;
@property (readonly, nonatomic)  CLLocationDegrees longitude;
@property (readonly, nonatomic)  CLLocationDegrees offLatitude;
@property (readonly, nonatomic)  CLLocationDegrees offLongitude;

@property (readonly, nonatomic)  NSString *country;//中国
@property (readonly, nonatomic)  NSString *locality;//河北省
@property (readonly, nonatomic)  NSString *administrativeArea;//北京市
@property (readonly, nonatomic)  NSString *subLocality;//石景山区
@property (readonly, nonatomic)  NSString *locationName;//永乐小区

@property(nonatomic,assign)BOOL canGPS;

@property (readonly, nonatomic)  MKMapView *m_map;

@end
