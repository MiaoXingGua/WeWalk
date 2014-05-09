// 在 Cloud code 里初始化 Express 框架
var express = require('express');
var app = express();


var User = AV.Object.extend('_User');
var Photo = AV.Object.extend('Photo');
var Comment = AV.Object.extend('Comment');
var Content = AV.Object.extend('Content');

// App 全局配置
app.set('views','cloud/views');     // 设置模板目录

app.set('view engine', 'ejs');          // 设置template引擎
//app.use(avosExpressHttpsRedirect());    //启用HTTPS
app.use(express.bodyParser());          // 读取请求 body 的中间件

// 使用 Express 路由 API 服务 /hello 的 HTTP GET 请求
app.get('/sharePhoto/:objectId', function(request, response) {

//  res.render('sharePhoto', { objectId: request.param.objectId });
//    res.render('hello', { message: request.params.objectId });

    var photoId = request.param.objectId;
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
    commentDict['createdAt'] = comment.createdAt//comment.get('createdAt'); bug
    var content = comment.get('content');
    var contentDict = {};
    contentDict['text'] = content.get('text');
    commentDict['content'] = contentDict;
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


function sharePhoto(photoId,done){

    if (!photoId)
    {
        response.error('参数错误');
    }

    var resultDic = {};
    resultDic['objectId'] = photoId;

    var photoQ = new AV.Query(Photo);
    photoQ.include(['user','content']);
    photoQ.get(photoId, {
        success: function(photo) {

            resultDic['originalURL'] = photo.get('originalURL');
            resultDic['thumbnailURL'] = photo.get('thumbnailURL');
            resultDic['width'] = photo.get('width');
            resultDic['height'] = photo.get('height');
            resultDic['content'] = photo.get('content');

            var user = photo.get('user');

            resultDic['user'] = userDictFromUserObject(user);

            var userFQ = photo.relation('faviconUsers').query();
            userFQ.find().then(function(faviconUsers){
//
                resultDic['faviconsCount'] = faviconUsers.length;

//                   console.log(faviconUsers.length);
                if (faviconUsers.length > 0)
                    resultDic['faviconUsers'] = userDictsFromUserObjects(faviconUsers);

                var commentQ = new AV.Query(Comment);

                commentQ.equalTo('photo',AV.Object.createWithoutData("Photo", photoId));
                commentQ.include(['user','content']);
                return commentQ.find();

            }, function(error) {

//                response.error('查询收藏列表失败 : ' + error);
                done(null,'查询收藏列表失败');

            }).then(function(comments){

//                    console.log(faviconUsers.length);
                    resultDic['commentsCount'] = comments.length;
                    if (comments.length > 0)
                        resultDic['comments'] = commentDictsFromCommentObjects(comments);

//                    response.success(resultDic);
                    done(resultDic,null);

                }, function(error) {

//                    response.error('查询评论列表失败 : ' + error);
                    done(null,'查询评论列表失败');

                });
        },
        error: function(photo, error) {
//            response.error('查找图片失败 : ' + error);
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