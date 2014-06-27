// Use AV.Cloud.define to define as many cloud functions as you want.
// For example:

require('cloud/app.js');

var array = ['a1','2b','ccc'];

AV.Cloud.define("hello", function(request, response) {

    var date1 = new Date(parseInt(1393216000 * 1000));
    console.log('date1 : '+date1);

    var date2 = new Date(parseInt(1393416000 * 1000));
    console.log('date2 : '+date2);

    response.success("Hello world!");
});

/****************
 通用AVObject
 *****************/
var User = AV.Object.extend('_User');
var Installation = AV.Object.extend('_Installation');
var Follow = AV.Object.extend('Follow');
var Friend = AV.Object.extend('Friend');
var Message = AV.Object.extend('Message');
var Schedule = AV.Object.extend('Schedule');

var Photo = AV.Object.extend('Photo');
var Comment = AV.Object.extend('Comment');
var Content = AV.Object.extend('Content');
var Brand = AV.Object.extend('Brand');
var Temperature = AV.Object.extend('Temperature');
var WeatherType = AV.Object.extend('WeatherType');
var Tickler = AV.Object.extend('Tickler');

var Relation = AV.Object.extend('Relation');

var Test = AV.Object.extend('Test');

var Notification = AV.Object.extend('_Notification');

var AirQualityIndex = AV.Object.extend('AirQualityIndex');

var PM25AppKey = "siv7h7ydxAEBoQw5Z3Lj";

AV._initialize('sy9s3xqtcdi3nsogyu1gnojg0wxslws0kl28lgd02hgsddff', 'bc0cullpfyceroe12164i8evoi5cw4zpbszssgtqp0k78xyh', 'k7prl1jmpwk7lx5q49b8rfz0mfkdlft1otj3abzxvdpiqx76');
AV.Cloud.useMasterKey();

/****************
 通用函数
 *****************/
//xml
var parseString = require('xml2js').parseString;

//json
var parse = require('xml2js').Parser();

//时间
var moment = require('moment');

//photo查询
function _includeKeyWithPhoto(photoQuery){
    photoQuery.include('content');
    photoQuery.include('brand');
    photoQuery.include('temperature');
    photoQuery.include('user');
}

//comment查询
function _includeKeyWithComment(commentQuery){

    commentQuery.include("user");
    commentQuery.include("content");
    commentQuery.include("photo");
}

//生成guid
function newGuid()
{
    var guid = "";
    for (var i = 1; i <= 32; i++){
        var n = Math.floor(Math.random()*16.0).toString(16);
        guid += n;
        if((i==8)||(i==12)||(i==16)||(i==20))
            guid += "-";
    }
    return guid;
}

//检查是否登录
function _checkLogin(request, response){

    if (!request.user)
    {
        response.error('请先登录');
    }
}

//字符串————>时间
function toDate(dateStr,formateStr,addHours){
    if (!formateStr) formateStr = "YYYY-MM-DD HH:mm:ss";
    if (!addHours) addHours = 8;
    return moment(dateStr, formateStr).add('hours',addHours).toDate()
}

function getDate(datestamp) {
//    console.log('stamp : '+datestamp);
    var date = new Date(parseInt(datestamp * 1000));
//    console.log('date : '+date);
    return date;//.toLocaleString().replace(/:\d{1,2}$/,' ');
}

//限制返回的调试
function limitQuery(request,query,done){

    var lessThenDateStr = request.params.lessThenDateStr;
    var limit = request.params.limit;

    if (lessThenDateStr)
    {
        var lessThenDate = toDate(lessThenDateStr,"YYYY-MM-DD HH:mm:ss");
        query.lessThan('createdAt',lessThenDate);
    }

    query.limit(limit);

    done(query);
}

AV.Cloud.define("getRequest",function(request, response) {
    var url = request.params.url;
    AV.Cloud.httpRequest({
        url: url,
        success: function(httpResponse) {
//            console.dir(httpResponse);
            response.success(httpResponse.text);
        },
        error: function(httpResponse) {
//            console.dir(httpResponse);
            response.error('Request failed with response code ' + httpResponse.status);
        }
    });
});

AV.Cloud.define("headView",function(request, response) {



});

AV.Cloud.define("getUserFromSinaWebUid",function(request, response) {

    var uid = request.params.uid;
    if (uid)
    {
        var userQ = new AV.Query(User);
        userQ.equalTo('username',"sina"+uid);
        userQ.first({
            success: function(user) {

                if (user)
                {
                    if (!__production) console.log("已存在user");
                    user.set("password", "sina"+uid+"youweek2014");
                    user.set("userKey", "sina"+uid+"youweek2014");

                    user.save(null, {
                        success: function(user) {
                            response.success({"username":user.get("username"),"password":user.get("userKey"),"isFrist":false});
                        },
                        error: function(user, error) {
                            response.error(error);
                        }
                    });
                }
                else
                {
                    if (!__production) console.log("不存在user");
                    var user = new AV.User();
                    user.set("username", "sina"+uid);
                    user.set("password", "sina"+uid+"youweek2014");
                    user.set("userKey", "sina"+uid+"youweek2014");

                    user.signUp(null, {
                        success: function(user) {
                            response.success({"username":user.get("username"),"password":user.get("userKey"),"isFrist":true});
                        },
                        error: function(user, error) {
                            response.error(error);
                        }
                    });
                }
            },
            error: function(error) {
                response.error(error);
            }
        });
    }
});

AV.Cloud.define("sharePhotoDomian",function(request, response) {

    //1.3
    response.success("http://youweek.avosapps.com/sharePhoto/");

});

AV.Cloud.define("sharePhotoDomian1.4",function(request, response) {

    //1.4
    var photoId = request.params.objectId;
    if (photoId)      //不去确认photo是否存在
    {
        response.success({'url':"http://youweek.avosapps.com/sharePhoto/"+photoId,'title':"来自微行的分享",'content':""});
    }
    else
    {
        response.error("参数错误哦~");
    }

});

AV.Cloud.define("shareConstellationDomian",function(request, response) {

    //1.3
    response.success("http://youweek.avosapps.com/shareConstellation/");

});

AV.Cloud.define("shareConstellationDomian1.4",function(request, response) {

    //1.4
    var constellationId = request.params.objectId;
    if (constellationId)      //不去确认constellation是否存在
    {
        response.success({'url':"http://youweek.avosapps.com/shareConstellation/"+constellationId,'title':"来自微行的分享",'content':""});
    }
    else
    {
        response.error("参数错误哦~");
    }
});

//538d3786e4b0518d450c4369
//AV.Cloud.define("changePhotoCreatedAt",function(request, response) {
//
//    var photo = AV.Object.createWithoutData("Photo", "538d3786e4b0518d450c4369");
//    photo.set('createdAt',toDate("2014-07-01 00:00:00","YYYY-MM-DD HH:mm:ss"));
//    photo.save();
//
//});

//getAdPhoto
AV.Cloud.define("getAdPhoto",function(request, response) {

    var cityNo = request.params.cityNo;
    var districtNo = request.params.districtNo;
    var lastPhotoId = request.params.lastPhotoId;


});

AV.Cloud.define("robot", function(request, response) {

    var robotQ = new AV.Query(User);
    robotQ.equalTo('isRobot',true);
    robotQ.ascending('createdAt');
    robotQ.doesNotExist('robotName');
//    robotQ.select('objectId');
//    robotQ.skip(100);
    robotQ.limit(100);

    var firstNumber = request.params.firstNumber;
    if (firstNumber)
    robotQ.find().then(function(robots) {

        for (var i in robots)
        {
            var robot = robots[i];
            robot.set('robotName',parseInt(i)+parseInt(firstNumber));
            robot.save(null, {
                success: function(robot) {
                    response.success("保存成功:",robot.id);
                },
                error: function(robot, error) {
                    console.dir(error);
                    response.error("保存失败"+error.description);
                }
            });
        }
    }, function(error) {

        console.dir("查询失败 : "+error);
        response.error("查询失败"+error.description);
    });
    else response.error("firstNumber为空");


//    robot(null,robotQ,0,function (robotList,error){
//
//        console.log(robotList.length);
//
//        for (var i in robotList)
//        {
//            robotList[i].set('robotName',parseInt(i));
////            robotList[i].save();
////            console.log(robotList[i].id);
////            var robot = robotList[i];
////            robot.set('robotName',parseInt(i));
////            robot.save(null, {
////                success: function(robot) {
////                    response.success("保存成功:",robot.id);
////                },
////                error: function(robot, error) {
////                    console.dir(error);
////                    response.error("保存失败"+error.description);
////                }
////            });
//        }
//
////        AV.Object.saveAll(aqis, function(list, error) {
////            if (list) {
////                // All the objects were saved.
////                console.log('保存PM25成功');
////                //                            console.log('成功存入aqi数量 ： '+list.length);
////
////            } else {
////                // An error occurred.
////                console.log('保存PM25失败1');
////                console.dir(error);
////            }
////        });
//
//        AV.Object.saveAll(robotList, function(list, error){
//            if (!error) {
//                console.log('保存成功');
//                response.success("保存成功:");
//            } else {
//                response.error("保存失败");
//                console.dir(error);
//            }
//        });
//    });
});


function robot(robotList,query,skip,done){

    if (!robotList)
    {
        robotList = new Array();
    }
    query.skip(skip);
//    console.log(skip);
    query.find().then(function(robots) {

        console.log(robotList.length);

        if (robots.length==0)
        {
            done(robotList,null);
        }

        for (var i in robots)
        {
            robotList.push(robots[i]);
        }

        if (robots.length<100)
        {
            done(robotList,null);
        }
        else
        {
            robot(robotList,query,skip+100,done);
        }

    }, function(error) {

        console.dir("查询失败 : "+error);
        done(robotList,error);
    });
}

AV.Cloud.define("updateRobot", function(request, response) {

    var robotId =  request.params.roborId;
    var robot =  AV.Object.createWithoutData("_User", robotId);
    var nickname =  request.params.nickname;
    var headViewURL =  request.params.headViewURL;
    robot.set('nickname',nickname);
    robot.set('largeHeadViewURL',headViewURL+"?imageMogr2/auto-orient/");
    robot.set('smallHeadViewURL',headViewURL+"?imageMogr2/auto-orient/thumbnail/128x128");
    robot.set('headViewURL',headViewURL);
    robot.save().then(function(obj) {
        response.success(obj);
    }, function(error) {
        response.error(error);
    });
});

AV.Cloud.define("countTest", function(request, response) {

    var testQ = new AV.Query(Test);
    testQ.count({
        success: function(count) {
            // The count request succeeded. Show the count
            console.log("Sean has played " + count + " games");
        },
        error: function(error) {
            console.dir(error);
        }
    });
});

AV.Cloud.define("addUrl", function(request, response) {

    addUrl(function (string){
     response.success(string);

    });

});

function addUrl(done)
{

    var photoQ = new AV.Query(Photo);
    photoQ.doesNotExist('url');
    photoQ.limit(1);
    photoQ.first({
        success: function(photo) {
            var url = photo.get('originalURL').split('?')[0];
            photo.set('url',url);
            photo.save().then(function(obj) {
                console.log('保存成功')
                addUrl(done);
            }, function(error) {
                console.log('保存失败');
                console.dir(error);
                addUrl(done);
            });
        },
        error: function(error) {
            console.log('查询失败');
            console.dir(error);
            addUrl(done);
        }
    });
}


//AV.Cloud.define("toDate", function(request, response) {
//
////    console.log(toDate("2014-01-21T10:00:00Z","yyyy-MM-dd'T'HH:mm:ssZ",0));
//                console.log(moment("2014-01-21T10:00:00Z","yyyy-MM-dd'T'HH:mm:ss'Z'").toDate());
//
//});

AV.Cloud.beforeSave("ReportLog", function(request, response){

    var reason = request.object.get('reason');
    var photo = request.object.get('photo');

    if (reason == '图片比例显示异常' && photo)
    {
        var photoId = photo.id;
        console.log("图片比例显示异常");
        var photoQ = new AV.Query(Photo);
        photoQ.get(photoId, {
            success: function(photo) {

                var originalURL = photo.get("originalURL");
                if (originalURL)
                {
                    AV.Cloud.httpRequest({
                        url: originalURL+'|imageInfo',
                        success: function(httpResponse) {
                            console.log('photo : ' + photo.id + '\n图片信息 : ' + httpResponse.text);
                            var resultInfo = JSON.parse(httpResponse.text);
                            if (resultInfo)
                            {
                                photo.set('width',resultInfo['width']);
                                photo.set('height',resultInfo['height']);
                                photo.save(null, {
                                    success: function(photo) {
                                        response.success();
                                    },
                                    error: function(photo, error) {

                                        console.error('保存图片信息失败 ：' + error.description);
                                        response.error('保存图片信息失败 ：' + error.description);
                                    }
                                });
                            }
                        },
                        error: function(httpResponse) {
                            console.error('请求图片信息失败 ：' + httpResponse.status);
                            response.error('请求图片信息失败 ：' + httpResponse.status);
                        }
                    });
                }
            },
            error: function(photo, error) {
                console.error('查找图片失败 ：' + error);
                response.error('查找图片失败 ：' + error);
            }
        });
    }
    else
    {
        response.success();
    }
});

//AV.Cloud.beforeSave("_User", function(request, response) {
//
//    var user = request.object;
//    console.dir(user);
//    console.dir(user.relation('faviconPhotos'));
//    response.success();
//
//});

//AV.Cloud.afterUpdate("_User", function(request) {
//
//    var user = request.object;
//    var appVer = user.get('appVer');
//    if (!appVer || appVer < 1.3)
//    {
//        console.log("新增收藏");
//
//        var faviconPhotosQ = user.relation('faviconPhotos').query();
//        faviconPhotosQ.descending('updatedAt');
//        faviconPhotosQ.select('objectId');
//        getFaviconPhotos(faviconPhotosQ,null,function (photoIdList,error){
//
//            if (!error)
//            {
//                console.log("发现"+photoIdList.length+"个收藏的图片");
//                var user =  AV.Object.createWithoutData("_User", request.object.id);
//
//                for (var i in photoIdList)
//                {
//                    var photo = AV.Object.createWithoutData("Photo", photoIdList[i]);
//
//                    //因为是异步 所以必须写成一个方法
//                    addRelation(user,photo,'favicon');
//                }
//            }
//            else
//            {
//                 console.dir(error);
//            }
//        });
//    }
//});

function addRelation(user,photo,type){

    var relationQuery = new AV.Query(Relation);
    relationQuery.equalTo('photo',photo);
    relationQuery.equalTo('user',user);
    relationQuery.equalTo('type',type);

    relationQuery.count({
        success: function(count) {
            if (count==0)
            {
                console.log("添加收藏");
                var relation = new Relation();
                relation.set('photo',photo);
                relation.set('user',user);
                relation.set('type',type);
                relation.save();
            }
            else
            {
                console.log("已经收藏");
            }

        },
        error: function(error) {
            console.log("查看收藏失败");
            console.dir(error);
        }
    });
}

function getFaviconPhotos(faviconPhotosQ,photoList,done){

    if (!photoList)
    {
        photoList = new Array();
    }

    faviconPhotosQ.find().then(function(photos) {

        if (photos.length==0)
        {
            done(photoList,null);
        }

        for (var i in photos)
        {
            photoList.push(photos[i].id);
        }

        if (photos.length<100)
        {
            done(photoList,null);
        }
        else
        {
            faviconPhotosQ.skip+=100;
            getFaviconPhotos(faviconPhotosQ,photoList,done);
        }


    }, function(error) {

        console.log("查询失败1");
        done(photoList,error);

    });

}


AV.Cloud.beforeSave("Photo", function(request, response){

//    console.dir(request.object);

    var type = request.object.get('type');
    var isOfficial = request.object.get('isOfficial');
    request.object.set('hot',0);
//    request.object.set('isHidden',false);

    var thumbnailURL = request.object.get("thumbnailURL");
    var originalURL = request.object.get("originalURL");
    var url = request.object.get("url");

    request.object.set("isAuth",false);

    if (!type)  //1.0版
    {
        console.log("1.0版");
        if (!originalURL)
        {
            response.error();
            console.log("originalURL为空old");
        }
        else
        {
            request.object.set("url",originalURL);
            request.object.set("originalURL",originalURL+"?imageMogr2/auto-orient/");
            request.object.set("thumbnailURL",originalURL+"?imageMogr2/auto-orient/thumbnail/180x");

            if (isOfficial)
            {
                request.object.set("type",1);
                console.log("成功设置一张官方图old");
            }
            else
            {
                request.object.set("type",2);
                console.log("成功设置一张街拍图old");
            }
            response.success();
        }
    }
    else if (!url)      //1.2 版
    {
        console.log("1.2版");
        url = originalURL.split('?')[0];
        console.log(url);
        if (url) request.object.set("url",url);
        response.success();
    }
    else if (type == 1)
    {
        console.log("成功设置一张官方图new");
        response.success();
    }
    else if (type == 2)
    {
        if (!thumbnailURL)
        {
            request.object.set("thumbnailURL",originalURL+"thumbnail/180x");
        }
        console.log("成功设置一张街拍图new");
        response.success();
    }
    else if (type == 11)
    {
        request.object.set("isOfficial",true);
        console.log("成功设置一张焦点图new");
        response.success();
    }
    else if (type == 21)
    {
        response.success();
    }
    else
    {
        console.log("图类型无法识别？ type: "+ type + "isOfficial: " + isOfficial);
        response.error("图类型无法识别？ type: "+ type);
    }
});

AV.Cloud.beforeSave("Message", function(request, response){

    var toUser = request.object.get('toUser');
    var fromUser = request.object.get('fromUser');

    console.dir(toUser);
    console.dir(fromUser);
    console.log('id1 : '+toUser.id);
    console.log('id2 : '+fromUser.id);

    var user1;
    var user2;

    if (!toUser.id || !fromUser.id)
    {
        console.log("联系人id为空");
        response.error("联系人id为空");
    }

    var User = AV.Object.extend('_User');
    var userQ = new AV.Query(User);
    userQ.equalTo('objectId',toUser.id);
    userQ.first().then(function(user) {

        console.log("1");
        user1 = user;
        var userQ = new AV.Query(User);
        userQ.equalTo('objectId',fromUser.id);
        return userQ.first();

    }).then(function(user) {

            console.log("2");
            user2 = user;
            //        user2 = AV.Object.createWithoutData("_User", user.id);
            user1.relation('contacts').add(user2);
            return user1.save();

        }).then(function(user) {

            console.log("3");
            //        user1 =  AV.Object.createWithoutData("_User", user.id);
            user2.relation('contacts').add(user1);
            return user2.save();

        }).then(function(user) {

            console.log("4");
            response.success();

        }, function(error) {
            console.log("5");
            response.error(error);

        });


});


function PM25() {

    console.log('开始请求PM25');

    AV.Cloud.httpRequest({
        url: "http://www.pm25.in/api/querys/all_cities.json?token="+PM25AppKey,
        success: function(httpResponse) {

            console.log('请求PM25成功');
            try {
                //                console.dir(httpResponse.text);
                var resultInfo = JSON.parse(httpResponse.text);

                //                var guid = newGuid();

                if (resultInfo)
                {
                    var aqis = new Array();

                    console.log('获得aqi数量 ： '+resultInfo.length);
                    for (var i in resultInfo)
                    {
                        var aqiInfo = resultInfo[i];
                        //                        if (!__production)
                        //                        console.dir(aqiInfo);
                        //                        console.dir(aqiInfo.primary_pollutant);

                        var aqi = new AirQualityIndex();
                        aqi.set('area', aqiInfo.area);
                        aqi.set('aqi',aqiInfo.aqi);
                        aqi.set('position_name', aqiInfo.position_name);
                        aqi.set('station_code', aqiInfo.station_code);
                        aqi.set('so2', aqiInfo.so2);
                        aqi.set('so2_24h', aqiInfo.so2_24h);
                        aqi.set('no2', aqiInfo.no2);
                        aqi.set('no2_24h', aqiInfo.no2_24h);
                        aqi.set('pm10', aqiInfo.pm10);
                        aqi.set('pm10_24h', aqiInfo.pm10_24h);
                        aqi.set('co', aqiInfo.co);
                        aqi.set('co_24h', aqiInfo.co_24h);
                        aqi.set('o3', aqiInfo.o3);
                        aqi.set('o3_24h', aqiInfo.o3_24h);
                        aqi.set('o3_8h', aqiInfo.o3_8h);
                        aqi.set('o3_8h_24h', aqiInfo.o3_8h_24h);
                        aqi.set('pm2_5', aqiInfo.pm2_5);
                        aqi.set('pm2_5_24h', aqiInfo.pm2_5_24h);
                        aqi.set('primary_pollutant', aqiInfo.primary_pollutant);
                        //                        aqi.set('guid',guid);

                        aqi.set('quality', aqiInfo.quality);
                        //                        aqi.set('time_point', aqiInfo.time_point);
                        aqis.push(aqi);
                    }
                    console.log('存入aqi数量 ： '+aqis.length);
                    AV.Object.saveAll(aqis, function(list, error) {
                        if (list) {
                            // All the objects were saved.
                            console.log('保存PM25成功');
                            //                            console.log('成功存入aqi数量 ： '+list.length);

                        } else {
                            // An error occurred.
                            console.log('保存PM25失败1');
                            console.dir(error);
                        }
                    });
                }
                else
                {
                    console.dir("resultInfo : "+resultInfo.result);
                }
            }
            catch(error) {

                console.log('保存PM25失败2');
                console.dir(error);
            }
        },
        error: function(error) {

            console.log('保存PM25失败3');
            console.dir(error);
        }
    });

}

//release
//release
//release
//release

if (__production)
{
    AV.Cloud.setInterval('PM25_timer', 60*60, PM25);
}
else
{
    AV.Cloud.define("PM25_define", PM25);
}

//创建通知
function createPush(users,pushDate,alert,done){

    console.log("开始创建通知");
    //创建通知
    var installationQuery = new AV.Query(Installation);
    //    var user = AV.Object.createWithoutData("_User", '52d4e3a7e4b0b492ca548e1b');
    installationQuery.containedIn('user',users);

    var guid = newGuid();

    if (!(pushDate && alert && users[0].id && guid))
    {
        console.log('创建通知参数错误');

        done(null,'创建通知参数错');
        return;
    }

    //    console.dir(pushDate);
    //    console.dir(alert);
    //    console.dir(users);
    //    console.dir(guid);

    AV.Push.send({
        where: installationQuery,
        data: {
            type:3,
            alert:alert,
            sound:"sqy.mp3"
        },

        push_time:pushDate,
        guid:guid

    }).then(function() {

            console.log("开始获取通知");
            //获取通知
            var pushQ = new AV.Query(Notification);
            pushQ.equalTo('guid',guid);
            pushQ.first().then(function(push) {

                if (push)
                {
                    console.log('push查询成功 : '+push.id);
                    var pushId = AV.Object.createWithoutData("_Notification", push.id);
                    done(pushId,null);
                }
                else
                {
                    console.log('push查询失败');
                    done(null,'push查询失败');
                }

            }, function(error) {

                done(null,error);

            });

        }, function(error) {

            done(null,error);
        });
}

//删除通知
function deletePush(push,done){

    //    var pushId = AV.Object.createWithoutData("_Notification", push.id);
    push.destroy().then(function() {

        console.log('删除成功');
        done(null);

    }, function(error) {

        console.log('删除失败');
        done(error);
    });

}

AV.Cloud.define("tickler_date", function(request, response){

    var dateStamp1 = request.params.date1;
    var dateStamp2 = request.params.date2;
    console.log('stamp1 : '+dateStamp1);
    console.log('stamp2 : '+dateStamp2);

    var date1 = new Date(parseInt(dateStamp1 * 1000));
    console.log('date1 : '+date1);

    var date2 = new Date(parseInt(dateStamp2 * 1000));
    console.log('date2 : '+date2);

    var user = request.user;

    if (!date1 || !date2 || !user)
    {
        response.error("参数错误");
        return;
    }

    var ticklerQuery = new AV.Query(Tickler);
    ticklerQuery.greaterThanOrEqualTo('remindTime',date1);
    ticklerQuery.lessThanOrEqualTo('remindTime',date2);
    ticklerQuery.limit(1000);
    ticklerQuery.equalTo('user',AV.Object.createWithoutData("_User", user.id));
    ticklerQuery.ascending('createdTime');

    ticklerList = new Array();

    getTickler(ticklerQuery,ticklerList,function(ticklers,error){

        console.log("回调 : "+ticklers.length);
        if (error)
        {
            response.error(ticklers,error);
        }
        else
        {
            response.success(ticklers,error);
        }

    });

});

function getTickler(ticklerQuery,ticklerList,done){

    if (!ticklerList)
    {
        ticklerList = new Array();
    }

    console.log("开始查询");
    ticklerQuery.find().then(function(ticklers) {

        if (ticklers.length==0)
        {
            done(ticklerList,null);
        }

        console.log("查询到 : "+ticklers.length);
        for (var i in ticklers)
        {
//            var dict = {"objectId":ticklers[i].id,"createdTime":ticklers[i].get('createdTime')};
//            console.dir(dict);
            ticklerList.push(ticklers[i].id);
//            ticklerList.push({"objectId":ticklers[i].id,"createdTime":ticklers[i].get('createdTime')});
        }

        if (ticklers.length<1000)
        {
            done(ticklerList,null);
        }
        else
        {
            ticklerQuery.skip+=1000;
            getTickler(ticklerQuery,ticklerList,done);
        }


    }, function(error) {

        console.log("查询失败1 : "+ticklers.length);
        done(ticklerList,error);

    });
}


//保存日程之前（创建推送通知）
AV.Cloud.beforeSave("Schedule", function(request, response) {

    _checkLogin(request, response);

    var user = request.user;
    var userId = AV.Object.createWithoutData("_User", user.id);

    var schedlue = request.object;
    var pushDate = schedlue.get('remindDate');
    console.dir(schedlue.get('text'));
//    console.dir(pushDate);

    createPush([userId],pushDate,schedlue.get('text'),function(push,error){

        if (push && !error)
        {
            //            var pushId = AV.Object.createWithoutData("_Notification", push.id);
            schedlue.set('pushId',push.id);
            response.success();
        }
        else
        {
            console.log('日程保存失败');
            response.error(error);
        }
    });
});

//AV.Cloud.afterSave("Schedule", function(request) {
//
//});

//AV.Cloud.afterUpdate("Schedule", function(request) {
//
//});

//删除日程之前(删除推送通知)
AV.Cloud.beforeDelete("Schedule", function(request, response) {

    _checkLogin(request, response);
    //    var user = request.user;
    //    var userId = AV.Object.createWithoutData("_User", user.id);
    var schedlue = request.object;
    var pushId = AV.Object.createWithoutData("_Notification", schedlue.get('pushId'));

    deletePush(pushId,function(error){

        if (!error)
        {
            response.success();
        }
        else
        {
            response.error(error);
        }
    });
});

//AV.Cloud.afterDelete("Schedule", function(request) {
//
//});

//创建通知
AV.Cloud.define("created_push", function(request, response){

    _checkLogin(request, response);

    var userId = AV.Object.createWithoutData("_User", request.user.id);

    var remindDateStr = request.params.remindDateStr;

    var alert = request.params.alert;

    if (!(remindDateStr && alert))
    {
        response.error('参数错误');
    }

    var push_time = toDate(remindDateStr);

    createdPush([userId],push_time,alert,function(push,error){

        if (push && !error)
        {
            //            var pushId = AV.Object.createWithoutData("_Notification", push.id);
            response.success(push.id);
        }
        else
        {
            response.error(error);
        }
    });
});

//删除通知
AV.Cloud.define("delete_push", function(request, response){

    _checkLogin(request, response);

    var pushId = request.params.pushId;

    if (!pushId)
    {
        response.error('参数错误');
    }

    var pushid = AV.Object.createWithoutData("_Notification", pushId);

    deletePush(pushid,function(error){
        if (!error)
        {
            console.log('删除成功1');
            response.success('成功');
        }
        else
        {
            response.error(error);
        }

    });


    //    pushid.destroy().then(function() {
    //
    //        console.log('删除成功1');
    //        response.success('成功');
    //
    //    }, function(error) {
    //
    //        response.error(error);
    //
    //    });

});

/****************
 天气
 *****************/
AV.Cloud.define("datetime", function(request, response) {

    //    var timestamp = Date.parse(new Date());
    var timestamp = new Date().getTime();
    //    console.log(timestamp);
    response.success(timestamp);
});

var yahooCityNameToWoeidAPI = "http://query.yahooapis.com/v1/public/yql?q=select%20woeid,name,country%20from%20geo.places%20where%20text=";
AV.Cloud.define("get_woeid_from_city_name", function(request, response) {

    var cityName = request.params.cityName;

    AV.Cloud.httpRequest({
        url: yahooCityNameToWoeidAPI+cityName,
        success: function(httpResponse) {

            parseString(httpResponse.text, function (error, result) {

                console.dir(result);
                if (result)
                {
                    cloopen2avos(request, response, user, result);
                }
                else
                {
                    response.error('Request failed with response code ' + error);
                }
            });

        },
        error: function(error){

            response.error(error);

        }
    });
});

/****************
 用户资料
 *****************/

//更新用户资料
AV.Cloud.define("update_user_info", function(request, response) {

    _checkLogin(request, response);

    var headViewURL = request.params.headViewURL;
    var backgroundViewURL = request.params.backgroundViewURL;
    var nickname = request.params.nickname;
    var gender = request.params.gender;
    var city = request.params.city;

    var user = request.user;
    if (headViewURL)
    {
        user.set('largeHeadViewURL',headViewURL);
        user.set('smallHeadViewURL',headViewURL+'?imageMogr/auto-orient/thumbnail/100x100');
    }

    if (backgroundViewURL)
    {
        user.set('backgroundViewURL',backgroundViewURL);
    }

    if (nickname)
    {
        user.set('nickname',nickname);
    }

    user.set('gender',gender);

    if (city)
    {
        user.set('city',city);
    }

    user.set('isCompleteSignUp',true);

    user.save().then(function(user) {

        response.success(user);

    }, function(error) {

        response.error(error);

    });
});

//关注
AV.Cloud.define("add_friend", function(request, response) {

    _checkLogin(request, response);

    var user = request.user;
    var friend = request.params.friend;

//    console.dir(user);
//    console.dir(friend);

    console.log('1');
    var friendId = AV.Object.createWithoutData("_User", friend);
    console.log(friendId);
    user.relation('friends').add(friendId);
    user.save().then(function(user) {
        console.log('2');
        console.dir(user);

        var userId = AV.Object.createWithoutData("_User", user.id);
        friend.relation('follows').add(userId);
        friend.save().then(function(user) {
            console.log('3');
            console.dir(user);

            response.success(user);

        }, function(error) {

            response.error(error);

        });

    }, function(error) {

        response.error(error);

    });

});

//解除关注
AV.Cloud.define("remove_friend", function(request, response) {

    _checkLogin(request, response);

    var user = request.user;
    var friend = request.params.friend;

    user.relation('friends').remove(friend);
    user.save().then(function(user) {

        friend.relation('follow').remove(user);
        friend.save().then(function(user) {

            response.success(user);

        }, function(error) {

            response.error(error);

        });

    }, function(error) {

        response.error(error);

    });

});

//我关注的人 (bug:没分页)
AV.Cloud.define("get_friends", function(request, response) {

    _checkLogin(request, response);

    var user = request.user;

    var friendsQuery = user.relation('friends').query();

    friendsQuery.find().then(function(friends) {

        response.success(friends);

    }, function(error) {

        response.error(error);

    });

});

//我关注的人数
AV.Cloud.define("get_friends_count", function(request, response) {

    _checkLogin(request, response);

    var user = request.user;
    user.relation('friends').query().count().then(function(count) {

        response.success(count);

    }, function(error) {

        response.error(error);

    });
});

//粉丝 (bug:没分页)
AV.Cloud.define("get_follows", function(request, response) {

    _checkLogin(request, response);

    var user = request.user;

    var followsQuery = user.relation('follows').query();

    followsQuery.find().then(function(follows) {

        response.success(follows);

    }, function(error) {

        response.error(error);

    });
});

//粉丝数
AV.Cloud.define("get_follows_count", function(request, response) {

    _checkLogin(request, response);

    var user = request.user;
    user.relation('follows').count().then(function(count) {

        response.success(count);

    }, function(error) {

        response.error(error);

    });
});

/**************
 用户消息
 ***************/

//发消息
AV.Cloud.define("post_message", function(request, response){

    _checkLogin(request, response);

    var fromUser = request.user;
    var toUser = request.params.toUser;
    var voiceURL = request.params.voiceURL;
    var text = request.params.text;


    if (!(fromUser && toUser && content))
    {
        response.error(error);
    }

    var message = new Message();
    message.set('fromUser',fromUser);
    message.set('toUser',toUser);
    var content = new Content();
    content.text = text;
    content.voiceURL = voiceURL;
    message.set('content',content);
    message.save().then(function(message) {

        toUser.relation('contacts').add(fromUser);
        toUser.save().then(function(message) {

            response.success(message);

        }, function(error) {

            response.error(error);

        });

    }, function(error) {

        response.error(error);

    });
});

//更改会话中未读状态为已读
AV.Cloud.define("update_message_to_is_read", function(request, response){

    _checkLogin(request, response);

    var toUser = request.user;
    var fromUser = request.params.fromUser;

    var fromUserId = AV.Object.createWithoutData("_User", fromUser.id);
    var toUserId = AV.Object.createWithoutData("_User", toUser.id);

    var messageQuery = new AV.Query(Message);
    messageQuery.equalTo('fromUser',fromUserId);
    messageQuery.equalTo('toUser',toUserId);
    messageQuery.equalTo('isRead',false);

    messageQuery.find().then(function(messages) {

        for (var i in messages)
        {
            var message = messages[i];
            message.set('isRead',true);
        }
        AV.Object.saveAll(messages).then(function() {

            response.success();

        }, function(error) {

            response.error(error);

        });

    }, function(error) {

        response.error(error);

    });
});

//获取与某用户的聊天记录
AV.Cloud.define("search_messages_about_user", function(request, response){

    _checkLogin(request, response);

    var fromUser = request.user;
    var toUser = request.params.toUser;

    //查询两人间的私信
    var fromUserId = AV.Object.createWithoutData("_User", fromUser.id);
    var toUserId = AV.Object.createWithoutData("_User", toUser.id);

    var messQuery1 = new AV.Query(Message);
    messQuery1.equalTo('fromUser',fromUserId);
    messQuery1.equalTo('toUser',toUserId);
    messQuery1.equalTo('isDelete',false);

    var messQuery2 = new AV.Query(Message);
    messQuery2.equalTo('fromUser',toUserId);
    messQuery2.equalTo('toUser',fromUserId);
    messQuery2.equalTo('isDelete',false);

    var messageQuery = AV.Query.or(messQuery1, messQuery2);

    limitQuery(request,messageQuery,function(messageQuery){

        messageQuery.find().then(function(messages) {

            response.success(messages);

        }, function(error) {

            response.error(error);

        });

    });
});

//获取与某用户的未读聊天记录
AV.Cloud.define("search_messages_about_user_for_unread", function(request, response){

    _checkLogin(request, response);

    var toUser = request.user;
    var fromUser = request.params.fromUser;

    var fromUserId = AV.Object.createWithoutData("_User", fromUser.id);
    var toUserId = AV.Object.createWithoutData("_User", toUser.id);

    var messageQuery = new AV.Query(Message);
    messageQuery.equalTo('fromUser',fromUserId);
    messageQuery.equalTo('toUser',toUserId);
    messageQuery.descending('createdAt');
    messageQuery.equalTo('isRead',false);
    messageQuery.equalTo('isDelete',false);

    limitQuery(request,messageQuery,function(messageQuery){

        messageQuery.find().then(function(messages) {

            response.success(messages);

        }, function(error) {

            response.error(error);

        });

    });
});

//获得全部未读的聊天记录数
AV.Cloud.define("get_all_message_count_for_unread", function(request, response){

    _checkLogin(request, response);

    var toUser = request.user;
//    var fromUser = request.params.toUser;

//    var fromUserId = AV.Object.createWithoutData("_User", fromUser.id);
    var toUserId = AV.Object.createWithoutData("_User", toUser.id);

    var messageQuery = new AV.Query(Message);
//    messageQuery.equalTo('fromUser',fromUserId);
    messageQuery.equalTo('toUser',toUserId);
    messageQuery.equalTo('isRead',false);
    messageQuery.equalTo('isDelete',false);

    messageQuery.count().then(function(count) {

        response.success(count);

    }, function(error) {

        response.error(error);

    });
});

//获取最近联系人列表
AV.Cloud.define("get_contacts", function(request, response){

    _checkLogin(request, response);

    var user = request.user;

    var coutactsQuery = user.relation('contacts').query();

    limitQuery(request,coutactsQuery,function(coutactsQuery){

        coutactsQuery.find().then(function(contacts) {

            response.success(contacts);

        }, function(error) {

            response.error(error);

        });
    });

});

//删除联系人（同时将所有该联系人的消息delete）
AV.Cloud.define("delete_contacts", function(request, response){

    _checkLogin(request, response);

    var toUser = request.user;
    var fromUser = request.params.fromUser;

    var fromUserId = AV.Object.createWithoutData("_User", fromUser.id);
    var toUserId = AV.Object.createWithoutData("_User", toUser.id);

    var messageQuery = new AV.Query(Message);
    messageQuery.equalTo('fromUser',fromUserId);
    messageQuery.equalTo('toUser',toUserId);
    messageQuery.equalTo('isRead',false);

    messageQuery.find().then(function(messages) {

        for (var i in messages)
        {
            var message = messages[i];
            message.set('isRead',true);
        }
        AV.Object.saveAll(messages).then(function() {

//            var user = request.user;
            toUser.relation('contacts').remove(fromUser);

            return toUser.save().then(function() {

                response.success();

            }, function(error) {

                response.error(error);

            });

        }, function(error) {

            response.error(error);

        });

    }, function(error) {

        response.error(error);

    });
});


/**************
 用户日程
 ***************/

//创建日程
AV.Cloud.define("create_schedule", function(request, response){

    _checkLogin(request, response);

    var user = request.user;
    var userId = AV.Object.createWithoutData("_User", user.id);
    var dateStr = request.params.dateStr;
    var type = request.params.type;
    var woeid = request.params.woeid;
    var place = request.params.place;
    var text = request.params.text;
    var voiceURL = request.params.voiceURL;
    var URL = request.params.URL;
    var remindDateStr = request.params.remindDateStr;

//    console.log('dateStr'+dateStr);
//    console.log('remindDateStr'+remindDateStr);
//    console.log('woeid'+woeid);
//    console.log('place'+place);

    if (!(user && dateStr && remindDateStr && woeid && place))
    {
        response.error('参数错误');
    }

//    var push_time = moment(new Date()).add('hours',8).toDate();
//    var push_time = new Date();
//    push_time.setSeconds(push_time.getSeconds()+remindTime);

//    console.dir(remindDateStr);
    var push_time = toDate(remindDateStr);
//    console.dir(push_time);

    //创建通知
    createdPush([userId],push_time,'你有一个新的日程',function(push,error){

        if (push && !error)
        {
            //创建日程
            var schedule = new Schedule();

//            var date_time = moment(new Date()).add('hours',8).toDate();
//            var date_time = new Date();
//            date_time.setSeconds(date_time.getSeconds());
            var date_time = toDate(dateStr);

            schedule.set('date',date_time);
            schedule.set('type',type);
            schedule.set('woeid',woeid);
            schedule.set('place',place);
            schedule.set('user',userId);
            schedule.set('remindDate',push_time);

            var content = new Content();
            content.set('text',text);
            content.set('voiceURL',voiceURL);
            content.set('URL',URL);
            schedule.set('content',content);

            var pushId = AV.Object.createWithoutData("_Notification", push.id);
            schedule.set('push',pushId);
            schedule.save().then(function(schedule) {

                response.success(schedule);

            }, function(error) {

                response.error(error);

            });
        }
        else
        {
            response.error(error);
        }

    });
});

//查看全部日程
AV.Cloud.define("my_schedule", function(request, response){

    _checkLogin(request, response);

    var scheduleQuery = new AV.Query(Schedule);
    var user = request.user;
    var userId = AV.Object.createWithoutData("_User", user.id);
    scheduleQuery.equalTo('user',userId);
    scheduleQuery.find().then(function(schedules) {

        response.success(schedules);

    }, function(error) {

        response.error(error);

    });

});



//编辑日程
AV.Cloud.define("update_schedule", function(request, response){

    _checkLogin(request, response);

    var user = request.user;
    var userId = AV.Object.createWithoutData("_User", user.id);
    var dateStr = request.params.dateStr;
    var type = request.params.type;
    var woeid = request.params.woeid;
    var place = request.params.place;
    var text = request.params.text;
    var voiceURL = request.params.voiceURL;
    var URL = request.params.URL;
    var remindDateStr = request.params.remindDateStr;
    var scheduleId = request.params.scheduleId;

    console.log("scheduleId:"+scheduleId);

    if (!scheduleId)
    {
        response.error('参数错误');
    }

    var schedule = AV.Object.createWithoutData("Schedule", scheduleId);

    //修改属性
    schedule.set('type',type);

    if (woeid) schedule.set('woeid',woeid);
    if (place) schedule.set('place',place);

    if (dateStr)
    {
        var date_time = toDate(dateStr);
        schedule.set('date',date_time);
    }

    if (text || voiceURL || URL)
    {
        var content = new Content();
        content.set('text',text);
        content.set('voiceURL',voiceURL);
        content.set('URL',URL);
        schedule.set('content',content);
    }

    if (remindDateStr)
    {
        //删除老通知
        var push = schedule.get('push');
        push.delete().then(function() {

            //创建新通知
            var push_time = toDate(remindDateStr);

            createdPush([userId],push_time,'你有一个新的日程',function(push,error){

                if (push && !error)
                {
                    var pushId = AV.Object.createWithoutData("_Notification", push.id);
                    schedule.set('push',pushId);
                    schedule.set('remindDate',push_time);
                    schedule.save().then(function(schedule) {

                        response.success(schedule);

                    }, function(error) {

                        response.error(error);

                    });
                }
                else
                {
                    response.error(error);
                }
            });

        }, function(error) {

            response.error(error);

        });
    }
});

//删除日程
AV.Cloud.define("delete_schedule", function(request, response){

    _checkLogin(request, response);

    var schedule = request.params.schedule;
    if (!schedule)
    {
        response.error('参数错误');
    }

    var push = schedule.get('push');
    push.delete().then(function() {

        schedule.delete().then(function() {

            response.success();

        }, function(error) {

            response.error(error);

        });

    }, function(error) {

        response.error(error);

    });
});

/****************
 图片
 *****************/

//上传街拍
AV.Cloud.define("upload_photo", function(request, response) {
//    _checkLogin(request, response);

    var user = request.user;
    var imageURLs = request.params.imageURLs;
    var voiceURL = request.params.voiceURL;
    var text = request.params.text;
    var temperature = request.params.temperature;
    var weatherCode = request.params.weatherCode;
    var latitude = request.params.latitude;
    var longitude = request.params.longitude;

    if (!(imageURLs.length && imageURLs && temperature))
    {
        response.error('缺少必要参数');
    }

    var photos = [];
    console.log('开始');
    console.dir(imageURLs);

    for (var i in imageURLs)
    {
        var imageURL = imageURLs[i];
         console.log(imageURL);
        //图片对象
        var photo = new Photo();

        //坐标
        var location = new AV.GeoPoint({latitude: latitude, longitude: longitude});
        photo.set('location',location);

        //用户
        photo.set('user',user);

        //内容
        var content = new Content();
        if (voiceURL) content.set('voiceURL',voiceURL);
        if (text) content.set('text',text);

        photo.set('content',content);

        //图片url
        photo.set('originalURL',imageURL);
        photo.set('thumbnailURL',imageURL+'?imageMogr/auto-orient/thumbnail/200x');

        console.log('请求'+imageURL);
        //图片尺寸
        AV.Cloud.httpRequest({
            url: imageURL+'?imageInfo',
            success: function(httpResponse) {

//                console.log(httpResponse.text);

//                    JSON.parse(httpResponse.text, function (error, result) {
                var result = JSON.parse(httpResponse.text);
                if (result)
                {
//                            console.log('图片大小'+result.width,result.height);
                        photo.set('width',result.width);
                        photo.set('height',result.height);

                        var weatherTypeQuery = new AV.Query(WeatherType);
                        weatherTypeQuery.equalTo('code',weatherCode);
                        weatherTypeQuery.first().then(function(weatherTypeObj){

                                var weatherTypeId = AV.Object.createWithoutData("WeatherType", weatherTypeObj.id);
                                //天气code
                                photo.set('weatherType',weatherTypeId);

                                console.log('查询'+temperature);

                                var temperatureQuery = new AV.Query(Temperature);
                                temperatureQuery.greaterThanOrEqualTo('maxTemperture',temperature);
                                temperatureQuery.lessThanOrEqualTo('minTemperture',temperature);
                                temperatureQuery.first().then(function(temperatureObj){


                                    var temperatureId = AV.Object.createWithoutData("Temperature", temperatureObj.id);
                                    //气温种类
                                    photo.set('temperature',temperatureId);

                                    photos.push(photo);

                                    console.log('保存'+photos.count);
                                    if (photos.length == imageURLs.length)
                                    {
                                        console.log('结束');
                                        AV.Object.saveAll(photos).then(function(photos) {

                                            response.success(photos);

                                        }, function(error) {

                                            response.error(error);

                                        });
                                    }

                                }, function(error) {

                                    response.error(error);

                                });


                    },function(error){
                            response.error(error);
                        });
                }
                else
                {
                    response.error("result 失败");
                }

            },
            error: function(error){

                response.error(error);

            }
        });

    }
});

//查看用户的相册
AV.Cloud.define("search_user_photo", function(request, response) {

    var user = request.params.user;
    var lessThenDateStr = request.params.lessThenDateStr;
    var limit = request.params.limit;

    var photoQ = new AV.Query(Photo);
    _includeKeyWithPhoto(photoQ);

    if (lessThenDateStr)
    {
        var lessThenDate = toDate(lessThenDateStr);
        photoQ.lessThan('createdAt',lessThenDate);
    }

    photoQ.limit(limit);
    photoQ.descending('createdAt');
    photoQ.equal('user',user);
    photoQ.find().then(function(photos) {

        response.success(photos);

    }, function(error) {

        response.error(error);

    });
});

//查看全部图片 //0.官方 1.最新街拍 2.最热街拍 3.附近的
AV.Cloud.define("search_all_photo", function(request, response) {

    var type = request.params.type;
    var lessThenDateStr = request.params.lessThenDateStr;
    var limit = request.params.limit;

    var photoQ = new AV.Query(Photo);

    _includeKeyWithPhoto(photoQ);

    if (lessThenDateStr)
    {
        var lessThenDate = toDate(lessThenDateStr);
        photoQ.lessThan('createdAt',lessThenDate);
    }

    photoQ.limit(limit);

    if (type == 0)
    {
        photoQ.equal('isOfficial',true);
        photoQ.descending('updatedAt');
    }
    else if (type == 1)
    {
        photoQ.equal('isOfficial',false);
        photoQ.descending('createdAt');
    }
    else if (type == 2)
    {
        photoQ.equal('isOfficial',false);
        photoQ.descending('hot');
    }
    else if (type == 3)
    {
        photoQ.equal('isOfficial',false);
        var latitude = request.params.latitude;
        var longitude = request.params.longitude;
        var location = new AV.GeoPoint({latitude: latitude, longitude: longitude});
        photoQ.near('location',location);
    }
    photoQ.find().then(function(photos) {

        response.success(photos);

    }, function(error) {

        response.error(error);

    });
});

//评论照片
AV.Cloud.define("comment_photo", function(request, response) {

    _checkLogin(request, response);

    var user = request.user;
    var photo = request.params.photo;
    var voiceURL = request.params.voiceURL;
    var text = request.params.text;

    if (!photo || !(voiceURL || text))
    {
        response.error('参数错误');
    }

    var comment = new Comment();

    comment.set('user',user);

    photo.increment('hot');
    comment.set('photo',photo);

    var content = new Content();
    content.set('voiceURL',voiceURL);
    content.set('text',text);
    comment.set('content',content);

    comment.save().then(function(comment) {

        response.success(comment);

    }, function(error) {

        response.error(error);

    });
});

//查看照片评论
AV.Cloud.define("search_photo_comments", function(request, response) {

    var photo = request.params.photo;

    if (!photo)
    {
        response.error('参数错误');
    }

    var commentQ = new AV.Query(Comment);
    _includeKeyWithComment(commentQ);

    limitQuery(request,commentQ,function(commentQ){

        commentQ.descending('createdAt');
        commentQ.equal('photo',photo);
        commentQ.find().then(function(comments) {

            response.success(comments);

        }, function(error) {

            response.error(error);

        });

    });

});

//查看照片评论数
AV.Cloud.define("search_photo_comments_count", function(request, response) {

    var photo = request.params.photo;

    if (!photo)
    {
        response.error('参数错误');
    }

    var commentQ = new AV.Query(Comment);
    _includeKeyWithComment(commentQ);
    commentQ.descending('createdAt');
    commentQ.equal('photo',photo);
    commentQ.find().then(function(comments) {

        response.success(comments);

    }, function(error) {

        response.error(error);

    });
});

//收藏照片
AV.Cloud.define("favicon_photo", function(request, response) {

    _checkLogin(request, response);

    var user = request.user;
    var photo = request.params.photo;

    if (!photo)
    {
        response.error('参数错误');
    }

    user.relation('faviconPhotos').add(photo);

    user.save().then(function(user) {

        photo.relation('faviconUsers').add(user);
        photo.increment('hot');
        return photo.save();

    }).then(function() {

        response.success();

    }, function(error) {

        response.error(error);

    });

});

//查看照片的收藏者
AV.Cloud.define("search_photo_favicon_users", function(request, response) {

    var photo = request.params.photo;
    var lessThenDateStr = request.params.lessThenDateStr;
    var limit = request.params.limit;

    if (!photo)
    {
       response.error('参数错误');
    }

    var PhotofaviconsQuery =  photo.relation('faviconUsers').query();
    if (lessThenDateStr)
    {
        var lessThenDate = toDate(lessThenDateStr);
        PhotofaviconsQuery.lessThan('createdAt',lessThenDate);
    }

    PhotofaviconsQuery.limit(limit);

    PhotofaviconsQuery.find().then(function(Photofavicons) {

        response.success(Photofavicons);

    }, function(error) {

        response.error(error);

    });
});

//查看照片的收藏者数
AV.Cloud.define("search_photo_favicon_users_count", function(request, response) {

    var photo = request.params.photo;

    if (!photo)
    {
        response.error('参数错误');
    }

    var PhotofaviconsQuery =  photo.relation('faviconUsers').query();

    PhotofaviconsQuery.count().then(function(PhotofaviconsCount) {

        response.success(PhotofaviconsCount);

    }, function(error) {

        response.error(error);

    });
});

//查看我收藏的照片
AV.Cloud.define("get_my_favicon_photos", function(request, response) {

    _checkLogin(request, response);

    var user = request.user;
    var faviconPhotosQuery =  user.relation('faviconPhotos').query();
    var lessThenDateStr = request.params.lessThenDateStr;
    var limit = request.params.limit;

    if (lessThenDateStr)
    {
        var lessThenDate = toDate(lessThenDateStr);
        faviconPhotosQuery.lessThan('createdAt',lessThenDate);
    }

    faviconPhotosQuery.limit(limit);

    faviconPhotosQuery.find().then(function(faviconPhotos) {

        response.success(faviconPhotos);

    }, function(error) {

        response.error(error);

    });
});

//查看我收藏的照片数
AV.Cloud.define("get_my_favicon_photos_count", function(request, response) {

    _checkLogin(request, response);

    var user = request.user;

    var faviconPhotosQuery =  user.relation('faviconPhotos').query;

    faviconPhotosQuery.count().then(function(faviconPhotosCount) {

        response.success(faviconPhotosCount);

    }, function(error) {

        response.error(error);

    });
});