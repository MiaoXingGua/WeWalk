// 在 Cloud code 里初始化 Express 框架
var express = require('express');
var app = express();


var User = AV.Object.extend('_User');
var Photo = AV.Object.extend('Photo');
var Comment = AV.Object.extend('Comment');
var Content = AV.Object.extend('Content');
var Constellation = AV.Object.extend('Constellation');
var Relation = AV.Object.extend('Relation');
//时间
var moment = require('moment');

// App 全局配置
app.set('views','cloud/views');     // 设置模板目录

app.set('view engine', 'ejs');          // 设置template引擎
//app.use(avosExpressHttpsRedirect());    //启用HTTPS
app.use(express.bodyParser());          // 读取请求 body 的中间件

// 使用 Express 路由 API 服务 /hello 的 HTTP GET 请求
app.get('/hello', function(request, response) {

    response.render('hello', { message: "http://www.w3school.com.cn/i/movie.ogg" });
});

app.get('/sharePhoto/:objectId', function(request, response) {

    var photoId = request.params.objectId;
    sharePhoto(photoId,function(photoDict,error){

//        console.log("呵呵");
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

app.get('/shareConstellation/:objectId', function(request, response) {

    var constellationId = request.params.objectId;

    shareConstellation(constellationId,function(constellationDict,error){

        if (constellationDict && !error)
        {
            response.render('shareConstellation',{ constellationDict : constellationDict});
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

//    console.dir(date);
//    console.dir(moment(date).format("YYYY-MM-DD"));
//    console.dir(typeof moment(date).format("YYYY-MM-DD"));

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

    return '未知';
}


AV.Cloud.define("calculateDate",function(request, response) {
    calculateDate(new Date());
});

function sharePhoto(photoId,done){

    console.log("分享照片 : "+photoId);

    if (!photoId)
    {
        done(null,'参数错误');
    }

    var resultDic = {};
    resultDic['objectId'] = photoId;

    var photoQ = new AV.Query(Photo);
    photoQ.equalTo('objectId',photoId);

    photoQ.include('user');
    photoQ.include('content');

    photoQ.first().then(function(photo) {

            resultDic['originalURL'] = photo.get('originalURL');
            resultDic['thumbnailURL'] = photo.get('thumbnailURL');

            resultDic['width'] = photo.get('width');
            resultDic['height'] = photo.get('height');
            resultDic['createdAt'] = calculateDate(photo.createdAt);

            var commentsCount = photo.get('numberOfComments');
            if (commentsCount) resultDic['commentsCount'] = photo.get('numberOfComments');
            else resultDic['commentsCount'] = 0;

            var faviconsCount = photo.get('numberOfFavicons');
            if (faviconsCount) resultDic['faviconsCount'] = photo.get('numberOfFavicons');
            else resultDic['faviconsCount'] = 0;

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
            if (user) resultDic['user'] = userDictFromUserObject(user);
            else resultDic['user'] = {};

//            var userFQ = photo.relation('faviconUsers').query();
            var relationQ = new AV.Query(Relation);
            relationQ.equalTo('photo',AV.Object.createWithoutData("Photo", photoId));
            relationQ.equalTo('type','favicon');
            relationQ.descending('createdAt');
            relationQ.select('user');
            relationQ.include('user');
            relationQ.limit(8);
            relationQ.find().then(function(relations){
//
//                resultDic['faviconsCount'] = faviconUsers.length;

//                   console.log(faviconUsers.length);
                if (relations.length > 0)
                {
                    var faviconUsers = new Array();;
                    for (var i in relations)
                    {
                        faviconUsers.push(relations[i].get('user'));
                    }
                    resultDic['faviconUsers'] = userDictsFromUserObjects(faviconUsers);
                }
                else
                {
                    resultDic['faviconUsers'] = [];
                }
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
//                    resultDic['commentsCount'] = comments.length;
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
        },function(error) {
//            response.error('查找图片失败 : ' + error);
            cosole.dir(error);
            done(null,'查找图片失败');
        });//.then().then().then();
}

if (!__production) AV.Cloud.define("test_sharePhoto",function(request, response) {
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

function shareConstellation(constellationId,done){

    console.log("分享星座 : "+constellationId);

    if (!constellationId)
    {
        done(null,'参数错误');
    }

    var resultDic = {};
    resultDic['objectId'] = constellationId;

    var constellationQ = new AV.Query(Constellation);
    constellationQ.equalTo('objectId',constellationId);
    constellationQ.first().then(function(constellation) {

        resultDic['name'] = constellation.get('name');
        resultDic['star'] = constellation.get('star');
        resultDic['description'] = constellation.get('description');
        resultDic['luckyColor'] = constellation.get('luckyColor');
        resultDic['luckyNumber'] = constellation.get('luckyNumber');
        resultDic['luckyFortune'] = constellation.get('luckyFortune');
        resultDic['luckyConstellation'] = constellation.get('luckyConstellation');

        resultDic['updatedAt'] = calculateDate(constellation.updatedAt);

        done(resultDic,null);

    },function(error) {

        cosole.dir(error);
        done(null,'查找星座失败');
    });
}

if (!__production) AV.Cloud.define("test_shareConstellation",function(request, response) {
    var constellationId = request.params.constellationId;
    shareConstellation(constellationId,function(constellationDict,error){

        if (constellationDict && !error)
        {
            response.success(constellationDict);
        }
        else
        {
            response.error(error);
        }
    });
});

// 最后，必须有这行代码来使 express 响应 HTTP 请求
app.listen();