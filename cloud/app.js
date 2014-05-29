// 在 Cloud code 里初始化 Express 框架
var express = require('express');
var app = express();


var User = AV.Object.extend('_User');
var Photo = AV.Object.extend('Photo');
var Comment = AV.Object.extend('Comment');
var Content = AV.Object.extend('Content');

//时间
var moment = require('moment');

// App 全局配置
app.set('views','cloud/views');     // 设置模板目录

app.set('view engine', 'ejs');          // 设置template引擎
//app.use(avosExpressHttpsRedirect());    //启用HTTPS
app.use(express.bodyParser());          // 读取请求 body 的中间件

// 使用 Express 路由 API 服务 /hello 的 HTTP GET 请求
app.get('/sharePhoto/:objectId', function(request, response) {

//  res.render('sharePhoto', { objectId: request.params.objectId });
//    res.render('hello', { message: request.params.objectId });

    var photoId = request.params.objectId;
    sharePhoto(photoId,function(photoDict,error){

        if (photoDict && !error)
        {
            response.render('sharePhoto',{ photoDict : photoDict});
        }
        else
        {
            response.render('500',500)
        }
    });
});

app.get('/uploadAdPhoto', function(request, response) {

    response.render('uploadAdPhoto', {'title':"请选择需要上传的文件"});
//    res.render('hello', { message: request.params.objectId });

});

var fs = require('fs');
app.post('/uploadAdPhoto', function(request, response) {
    var file = request.files.file;
    if(file)
    {
        fs.readFile(file.path, function(error, data)
        {
            if(error)
            {
//                return response.send("读取文件失败");
                return response.render('uploadAdPhoto', {'title':"读取文件失败!!!"});
            }

            var base64Data = data.toString('base64');
            var theFile = new AV.File(file.name, {base64: base64Data});
            theFile.save().then(function(theFile){
//                response.send("上传成功！");
                response.render('uploadAdPhoto', {'title':"上传成功!!!"});
            });
        });
    }
    else
    {
//        response.send("请选择一个文件。");
        response.render('uploadAdPhoto', {'title':"请选择一个文件!!!"});
    }
});



//
function userDictFromUserObject(user){
    var userDict = {};
    userDict['objectId'] = user.id;
    if (user.get('gender'))
    {
        userDict['gender'] = true;
    }
    else
    {
        userDict['gender'] = false;
    }
    userDict['nickname'] = user.get('nickname');
    userDict['largeHeadViewURL'] = user.get('largeHeadViewURL');
    return userDict;
}

function userDictsFromUserObjects(users){

    var userDicts = [];

    for (var userKey in users)
    {
        userDicts.push(userDictFromUserObject(users[userKey]));
    }

    return userDicts;
}

function commentDictFromCommentObject(comment){

    var commentDict = {};
    commentDict['objectId'] = comment.id;
    commentDict['user'] = userDictFromUserObject(comment.get('user'));
    commentDict['createdAt'] = calculateDate(comment.createdAt);//comment.get('createdAt'); bug
    var content = comment.get('content');
    if (content)
    {
        var contentDict = {};
        contentDict['text'] = content.get('text');
        commentDict['content'] = contentDict;
    }
    else
    {
        commentDict['content'] = {'text':''};
    }

    return commentDict;
}

function commentDictsFromCommentObjects(comments){

    var commentDicts = [];

    for (var commentKey in comments)
    {
        commentDicts.push(commentDictFromCommentObject(comments[commentKey]));
    }

    return commentDicts;
}


function calculateDate(date){

    console.dir(date);
    console.dir(moment(date).format("YYYY-MM-DD"));
    console.dir(typeof moment(date).format("YYYY-MM-DD"));

    var diff = moment(new Date()).diff(moment(date));

    if (diff < 0)
    {
        diff = moment(new Date()).diff(moment(date).add('hours',-8));
    }

    diff /= 1000;

    console.log(diff);

    if (diff<60)
    {
        return parseInt(diff)+"秒前";
    }
    else if (diff>=60 && diff<3600)
    {
        return parseInt(diff/60)+"分钟前";
    }
    else if (diff>=3600 && diff<86400)
    {
        return parseInt(diff/60/60)+"小时前";
    }
    else if (diff>=86400 && diff<432000)
    {
        return parseInt(diff/60/60/24)+"天前";
    }
    else
    {
        return moment(date).format("YYYY-MM-DD");
    }

//    else if (diff>=86400 && diff<2592000)
//    {
//        return parseInt(diff/60/60/24)+"天前";
//    }
//
//    else if(diff>=2592000 && diff<31104000)
//    {
//        return parseInt(diff/60/60/24/30)+"月前";
//    }
//    else
//    {
//        return parseInt(diff/60/60/24/30/12)+"年前";
//    }

//    //年
//    var yearD = moment(new Date()).year()-moment(date).year();
//
//    if (yearD > 0)
//    {
//        return yearD + "年前";
//    }
//
//    //月
//    var monthD = moment(new Date()).month()-moment(date).month();
//
//    if (monthD > 0)
//    {
//        return monthD + "月前";
//    }
//
//    //日
//    var dayD = moment(new Date()).day()-moment(date).day();
//
//    if (dayD > 0)
//    {
//        return dayD + "天前";
//    }
//
//    //小时
//    var hourD = moment(new Date()).hour()-moment(date).hour();
//    if (hourD<0)
//    {
//        hourD = moment(new Date()).hour()-moment(date).hour()+8;
//    }
//
//    if (hourD > 0)
//    {
//        return hourD + "小时前";
//    }
//
//    //分
//    var minuteD = moment(new Date()).minute()-moment(date).minute();
//
//    if (minuteD > 0)
//    {
//        return minuteD + "分钟前";
//    }
//
//    //秒
//    var secondD = moment(new Date()).second()-moment(date).second();
//
//    if (secondD > 0)
//    {
//        return secondD + "秒前";
//    }

    return '未知';
}


AV.Cloud.define("calculateDate",function(request, response) {
    calculateDate(new Date());
});

function sharePhoto(photoId,done){

    console.log("分享照片");

    if (!photoId)
    {
        done(null,'参数错误');
    }

    var resultDic = {};
    resultDic['objectId'] = photoId;

    var photoQ = new AV.Query(Photo);
    photoQ.include('user');
    photoQ.include('content');
    photoQ.get(photoId, {
        success: function(photo) {

            resultDic['originalURL'] = photo.get('originalURL');
            resultDic['thumbnailURL'] = photo.get('thumbnailURL');
            resultDic['width'] = photo.get('width');
            resultDic['height'] = photo.get('height');
            resultDic['createdAt'] = calculateDate(photo.createdAt);

//            console.dir(photo.createdAt);
//            console.log(photo.createdAt);
//            return;

            var content = photo.get('content');

            if (content)
            {
                var contentDict = {};
                contentDict['text'] = content.get('text');
                resultDic['content'] = contentDict;
            }
            else
            {
                resultDic['content'] = {'text':''};
            }

            var user = photo.get('user');
            resultDic['user'] = userDictFromUserObject(user);

            var userFQ = photo.relation('faviconUsers').query();
            userFQ.limit(8);
            userFQ.find().then(function(faviconUsers){
//
                resultDic['faviconsCount'] = faviconUsers.length;

//                   console.log(faviconUsers.length);
                if (faviconUsers.length > 0)
                    resultDic['faviconUsers'] = userDictsFromUserObjects(faviconUsers);
                else
                    resultDic['faviconUsers'] = [];

                var commentQ = new AV.Query(Comment);

                commentQ.equalTo('photo',AV.Object.createWithoutData("Photo", photoId));
                commentQ.include(['user','content']);
                return commentQ.find();

            }, function(error) {

//                response.error('查询收藏列表失败 : ' + error);
                cosole.dir(error);
                done(null,'查询收藏列表失败');

            }).then(function(comments){

//                    console.log(comments.length);
                    resultDic['commentsCount'] = comments.length;
                    if (comments.length > 0)
                        resultDic['comments'] = commentDictsFromCommentObjects(comments);
                    else
                        resultDic['comments'] = [];
//                    response.success(resultDic);
                    done(resultDic,null);

                }, function(error) {

//                    response.error('查询评论列表失败 : ' + error);
                    cosole.dir(error);
                    done(null,'查询评论列表失败');

                });
        },
        error: function(photo, error) {
//            response.error('查找图片失败 : ' + error);
            cosole.dir(error);
            done(null,'查找图片失败');
        }
    });
}

AV.Cloud.define("sharePhoto",function(request, response) {
    var photoId = request.params.photoId;
    sharePhoto(photoId,function(photoDict,error){

        if (photoDict && !error)
        {
            response.success(photoDict);
        }
        else
        {
            response.error(error);
        }
    });
});

// 最后，必须有这行代码来使 express 响应 HTTP 请求
app.listen();