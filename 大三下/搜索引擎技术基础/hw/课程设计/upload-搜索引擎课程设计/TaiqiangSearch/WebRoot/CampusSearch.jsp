<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
    request.setCharacterEncoding("utf-8");
    response.setCharacterEncoding("utf-8");
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>太强搜索</title>
    <link type="text/css" href="css/speech-input.css" rel="stylesheet"/>
    <link type="text/css" href="css/Campus-search.css" rel="stylesheet"/>
    <link type="text/css" href="css/extend.css" rel="stylesheet"/>
    <script type="text/javascript" src="js/speech.js"></script>
    <script type="text/javascript" src="js/jquery-1.4.3.min.js"></script>

</head>
<body>
<div class="search-layer1">
    <a href="<%=basePath%>CampusSearch.jsp">
        <img src="<%=basePath%>image/logo.jpg" alt="logo" class="search-logo" />
    </a>

    <form id="form1" name="form1" method="get" action="servlet/CampusServer">
        <div class="si-wrapper">
            <input id="index_input" type="text" class="search-input" autocomplete="off" name="query" size="50" >
            <button style="display: none"></button>
            <button onclick="startDictation(this,event)">
                <img class="search-speech" src="image/micro.png">
            </button>
        </div>

        <button class="search-button" type="submit" name="Submit">搜索</button>

        <div style="text-align: center">
            <div class="search_suggest" id="search_suggest">
                <ul style="margin: 0px;padding: 0px;">
                </ul>
            </div>
        </div>
        <%--<input class="search-input" name="query" type="text" size="50" />--%>

    </form>

</div>

<script type="text/javascript" src="js/extend.js"></script>

</body>
</html>
