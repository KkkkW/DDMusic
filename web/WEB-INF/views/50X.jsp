<%--
  Created by IntelliJ IDEA.
  User: 小感触
  Date: 2019/5/21
  Time: 7:57
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>服务器异常</title>
    <link rel="stylesheet" type="text/css" href="/resource/css/copyRight.css"/>
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
    <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon"/>
    <style>
        *{
            padding: 0;
            margin: 0;
            outline: 0;
        }
        #content{
            user-select: none;
        }
        #pic{
            width: 30rem;
            height: 27rem;
            background: red;
            margin: 0 auto;
            background-attachment: fixed;
            background: url("/resource/app-images/error.jpg");
            background-size: cover;
        }
        #text{
            margin: 0 auto;
            text-align: center;
            color: white;
            font-size: 2rem;
            box-sizing: border-box;
            padding: 2rem 3rem;
            background: darkred;
        }
        #text h1{
            font-size: 5rem;
            font-style: italic;
        }
        #copyRight{
            position: absolute;
            bottom: 0;
        }
        @media screen and (max-width: 1024px){
            #pic{
                width: 20rem;
                height: 15rem;
                background: red;
                margin: 0 auto;
                background-attachment: fixed;
                background: url("/resource/app-images/error.jpg");
                background-size: cover;
            }
            #text{
                margin:1rem auto;
                text-align: center;
                color: white;
                font-size: 1.2rem;
                box-sizing: border-box;
                padding: 2rem 3rem;
            }
            #text h1{
                font-size: 5rem;
                font-style: italic;
            }
        }
    </style>
</head>
<body>
    <div id="content">
        <div id="pic"></div>
        <div id="text">
            <h1>500!</h1>
            <p>请求无法被正常处理</p>
            <p>服务器异常，请稍后重试</p>
        </div>
    </div>
    <jsp:include page="copyright.jsp"/>
</body>
</html>
