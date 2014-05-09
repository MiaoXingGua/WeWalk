// 在 Cloud code 里初始化 Express 框架
var express = require('express');
var app = express();

// App 全局配置
app.set('views','cloud/views');     // 设置模板目录

app.set('view engine', 'ejs');          // 设置template引擎
//app.use(avosExpressHttpsRedirect());    //启用HTTPS
app.use(express.bodyParser());          // 读取请求 body 的中间件

// 使用 Express 路由 API 服务 /hello 的 HTTP GET 请求
app.get('/sharePhoto/:objectId', function(req, res) {

//  res.render('sharePhoto', { objectId: req.param.objectId });
    res.render('hello', { message: req.params.objectId });
});

// 最后，必须有这行代码来使 express 响应 HTTP 请求
app.listen();