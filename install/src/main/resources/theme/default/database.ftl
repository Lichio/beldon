<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Belog安装程序</title>

    <!-- Bootstrap -->
    <link href="${BASE_PATH}/static/default/css/bootstrap.min.css" rel="stylesheet">

    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="//cdn.bootcss.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="//cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body>
<div class="container">
    <div class="col-md-10 col-md-offset-1">
        <ol class="breadcrumb">
            <li>首页</li>
            <li class="active">数据库信息</li>
            <li>用户信息</li>
            <li>安装</li>
        </ol>

        <div class="alert alert-danger alert-dismissible hide" role="alert" id="alert-danger">
            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <strong>错误!</strong> 数据库连接失败，请检查数据库信息！
        </div>

        <form class="form-horizontal" action="javascript:return false;" id="actionForm">
            <div class="panel panel-default panel-border">
                <div class="panel-heading">
                    数据库信息配置
                </div>
                <div class="panel-body">
                    <div class="form-group">
                        <label for="title" class="col-sm-2 control-label">数据库地址</label>
                        <div class="col-sm-10">
                            <input type="text" value="" name="host" class="form-control"
                                   id="title" placeholder="数据库服务器地址，一般为127.0.0.1，如为127.0.0.1则可以留空">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="title" class="col-sm-2 control-label">数据库名称</label>
                        <div class="col-sm-10">
                            <input type="text" value="" name="database" class="form-control"
                                   id="title" placeholder="所要安装的数据库名">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="title" class="col-sm-2 control-label">数据库用户名</label>
                        <div class="col-sm-10">
                            <input type="text" value="" name="dataUser" class="form-control"
                                   id="title" placeholder="数据库用户名">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="title" class="col-sm-2 control-label">数据库密码</label>
                        <div class="col-sm-10">
                            <input type="text" value="" name="dataPass" class="form-control"
                                   id="title" placeholder="数据库用户密码">
                        </div>
                    </div>
                </div>
            </div>
            <div class="btn-group pull-right" role="group" aria-label="belog安装程序">
                <a href="${BASE_PATH}/index.html" type="button" class="btn btn-default">上一步</a>
                <#--<a href="${BASE_PATH}/user.html" id="next" type="button" class="btn btn-default">下一步</a>-->
                <button id="next" type="button" class="btn btn-default">下一步</button>
            </div>
        </form>
    </div>
</div>

<script src="${BASE_PATH}/static/default/js/jquery-1.11.1.min.js"></script>
<script src="${BASE_PATH}/static/default/js/bootstrap.min.js"></script>

<script type="text/javascript">
    $(document).ready(function(){
        $("#next").click(function(){
            $.ajax({
                type: "POST",
                url: "database.json",
                data: $('#actionForm').serialize(),
                dataType: "json",
                success: function(data){
                    if(data.status===true){
                        if (data.errCode ==1) {
                            if(confirm("数据表已存在，是否清空用户数据？")){
                                $.ajax({
                                    type: "POST",
                                    url: "clearUserData.json",
                                    dataType: "json",
                                    success: function(data){
                                        if (data.status===true) {
                                            window.location.href = '${BASE_PATH}/user.html';
                                        }else{
                                            alert(data.errMsg);
                                        }
                                    }
                                })
                            }else{
                                window.location.href = '${BASE_PATH}/user.html';
                            }
                        }else{
                            window.location.href = '${BASE_PATH}/user.html';
                        }
                    }else{
                        $("#alert-danger").removeClass("hide");
                        $("#alert-danger").show();
                        setInterval(function(){
                            $("#alert-danger").hide();
                        },3000)
                    }
                }
            });
        });
    });
</script>

</body>
</html>