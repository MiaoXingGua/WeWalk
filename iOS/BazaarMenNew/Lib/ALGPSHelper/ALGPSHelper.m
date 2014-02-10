//
//  ALGPSHelper.m
//  TestGPS
//
//  Created by Albert on 13-8-29.
//
//

#import "ALGPSHelper.h"

static ALGPSHelper *gps = nil;

@class Annotation;

@interface ALGPSHelper()
@property (nonatomic, retain) CSqlite *m_sqlite;
@property (nonatomic, retain) CLLocationManager *locationManager;
@end

@implementation ALGPSHelper

- (void)dealloc
{
    [_country release];
    [_administrativeArea release];
    [_locality release];
    [_subLocality release];
    [_locationName release];
    [_m_sqlite release];
    
    [super dealloc];
}

- (void)setLatitude:(CLLocationDegrees)latitude
{
    _latitude = latitude;
}

- (void)setLongitude:(CLLocationDegrees)longitude
{

    _longitude = longitude;
}

- (void)setOffLatitude:(CLLocationDegrees)offLatitude
{

    _offLatitude = offLatitude;
}

- (void)setOffLongitude:(CLLocationDegrees)offLongitude
{

    _offLongitude = offLongitude;
}

- (void)setCountry:(NSString *)country
{
    _country = [country retain];
}

- (void)setLocality:(NSString *)locality
{
    _locality = [locality retain];
}

- (void)setAdministrativeArea:(NSString *)administrativeArea
{
    _administrativeArea = [administrativeArea retain];
}

- (void)setSubLocality:(NSString *)subLocality
{
    _subLocality = [subLocality retain];
}

- (void)setLocationName:(NSString *)locationName
{
    _locationName = [locationName retain];
}

- (void)setM_map:(MKMapView *)m_map
{
    [_m_map release];
    _m_map = [m_map retain];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.m_sqlite = [[[CSqlite alloc] init] autorelease];
//        m_sqlite
        
    }
    return self;
}

+ (ALGPSHelper *)OpenGPS
{
    if (!gps) {
        gps = [[ALGPSHelper alloc] init];
        [gps OpenGPS];
        [gps.m_sqlite openSqlite];
    }
    
    return gps;
}

- (BOOL)OpenGPS
{
    if ([CLLocationManager locationServicesEnabled])
    {
        // 检查定位服务是否可用
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter=1000;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation]; // 开始定位
        
        NSLog(@"GPS 启动成功");
        
        return YES;
    }
    else
    {
        NSLog(@"GPS 启动失败！！！");
        return NO;
    }
}

- (void)initMapWithFrame:(CGRect)frame superView:(UIView *)superView
{
    self.m_map = [[[MKMapView alloc] initWithFrame:frame] autorelease];
    self.m_map.showsUserLocation = YES;//显示ios自带的我的位置显示
    
    [self OpenGPS];
}

- (void)refreshLocation
{
    if (self.locationManager!=nil)
    {
        self.locationManager=nil;
        
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter=1000;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation]; // 开始定位
    }
}

// 定位成功时调用
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    self.canGPS = YES;
    
    CLLocationCoordinate2D mylocation2d = newLocation.coordinate;//手机GPS
    self.latitude = mylocation2d.latitude;
    self.longitude = mylocation2d.longitude;
    
    mylocation2d = [self zzTransGPS:mylocation2d];///火星GPS
    self.offLatitude = mylocation2d.latitude;
    self.offLongitude = mylocation2d.longitude;
    
    //显示火星坐标
    if (self.m_map) [self SetMapPoint:mylocation2d];
    
    CLLocation *mylocation = [[[CLLocation alloc] initWithLatitude:mylocation2d.latitude longitude:mylocation2d.longitude] autorelease];
    /////////获取位置信息
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:mylocation completionHandler:^(NSArray* placemarks,NSError *error)
     {
         if (placemarks.count > 0)
         {
             CLPlacemark * plmark = [placemarks objectAtIndex:0];
//             NSString *location = plmark.addressDictionary[@"FormattedAddressLines"];
             
             self.LocationName = plmark.name;
             self.country = plmark.country;
//             NSMutableString *administ = [NSMutableString stringWithFormat:plmark.administrativeArea];
             self.administrativeArea = plmark.administrativeArea;
             self.locality = plmark.locality;
             self.subLocality = plmark.subLocality;
             
             NSLog(@"定位成功，位置：%@--%@",self.administrativeArea,self.locationName);
             
             [[NSNotificationCenter defaultCenter] postNotificationName:GPSLOCATIONSUCCESS object:nil];
             
             
//             NSString * country = plmark.country;
//             NSString * city    = plmark.locality;
//             NSLog(@"%@-%@-%@",country,city,plmark.name);
//
//             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@,%@,%@",country,city,plmark.name] delegate:nil cancelButtonTitle:@"" otherButtonTitles:nil, nil];
//             [alert show];
//             [alert release];
//
//             NSLog(@"plmark=%@",plmark.addressDictionary);
//             NSLog(@"plmark=%@",plmark.thoroughfare);
//             NSLog(@"plmark=%@",plmark.subThoroughfare);
//             NSLog(@"plmark=%@",plmark.name);
//             NSLog(@"plmark=%@",plmark.locality);
//             NSLog(@"plmark=%@",plmark.subLocality);
//             NSLog(@"plmark=%@",plmark.administrativeArea);
//             NSLog(@"plmark=%@",plmark.subAdministrativeArea);
//
//             self.LocationName = plmark.locality;
         }
//         NSLog(@"placemarks = %@ plmark.name = %@",placemarks,self.LocationName);
     }];
    
    [geocoder release];
}


// 定位失败时调用
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    self.canGPS = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GPSLOCATIONERROR object:nil];
    
    NSLog(@"定位失败!!!");
}

//坐标修正
-(CLLocationCoordinate2D)zzTransGPS:(CLLocationCoordinate2D)yGps
{
    int TenLat=0;
    int TenLog=0;
    TenLat = (int)(yGps.latitude*10);
    TenLog = (int)(yGps.longitude*10);
    NSString *sql = [[NSString alloc]initWithFormat:@"select offLat,offLog from gpsT where lat=%d and log = %d",TenLat,TenLog];
   // NSLog(sql);
    sqlite3_stmt* stmtL = [self.m_sqlite NSRunSql:sql];
    int offLat=0;
    int offLog=0;
    while (sqlite3_step(stmtL)==SQLITE_ROW)
    {
        offLat = sqlite3_column_int(stmtL, 0);
        offLog = sqlite3_column_int(stmtL, 1);
        
    }
    
    yGps.latitude = yGps.latitude+offLat*0.0001;
    yGps.longitude = yGps.longitude + offLog*0.0001;
    return yGps;
}

//地图
-(void)SetMapPoint:(CLLocationCoordinate2D)myLocation
{
    Annotation* m_poi = [[Annotation alloc] initWithCoords:myLocation];
    
    [self.m_map addAnnotation:m_poi];
    
    MKCoordinateRegion theRegion = { {0.0, 0.0 }, { 0.0, 0.0 } };
    theRegion.center=myLocation;
    [self.m_map setZoomEnabled:YES];
    [self.m_map setScrollEnabled:YES];
    theRegion.span.longitudeDelta = 0.01f;
    theRegion.span.latitudeDelta = 0.01f;
    [self.m_map setRegion:theRegion animated:YES];
}
@end

@interface Annotation : NSObject <MKAnnotation> {
    
    CLLocationCoordinate2D coordinate;
    NSString *subtitle;
    NSString *title;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSString *title;

-(id) initWithCoords:(CLLocationCoordinate2D) coords;

@end

@implementation Annotation

@synthesize coordinate,subtitle,title;

- (id) initWithCoords:(CLLocationCoordinate2D) coords{
    
    self = [super init];
    
    if (self != nil) {
        coordinate = coords;
    }
    return self;
}
@end