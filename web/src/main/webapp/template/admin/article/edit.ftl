<#include "../common/_layout.ftl"/>

<#if article?exists>
    <#assign title = "编辑文章"/>
<#else>
    <#assign title = "添加文章"/>
</#if>

<@html title=title>
<div class="row">
    <div class="col-md-9">
        <!-- Default panel -->
        <div class="panel panel-default panel-border">
            <div class="panel-heading">
                ${title}
            </div>

            <div class="panel-body">
                <form class="form-horizontal" action="javascript:return false;" id="actionForm">
                    <#if article?exists>
                        <input type="hidden" value="${(article.id)!}" name="id">
                    </#if>
                    <div class="form-group">
                        <label for="title" class="col-sm-1 control-label">标题</label>

                        <div class="col-sm-11">
                            <input type="text" value="${(article.title)!}" name="title" class="form-control"
                                   id="title" placeholder="此处输入标题">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="content" class="col-sm-1 control-label">内容</label>
                        <div class="col-sm-11">
                            <textarea name="content" id="content" class="form-control ckeditor" rows="10">${(article.content)!}</textarea>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="content" class="col-sm-1 control-label">标签</label>

                        <div class="col-sm-11">
                            <input type="text" name="articleTags" class="form-control" id="tags-input"
                                   value="<#if article?exists && article.tags?exists>
                                            <#list article.tags as tag>
                                                ${(tag.name)!},
                                            </#list>
                                            </#if>"
                                   style="display: none;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="title" class="col-sm-2 control-label">封面图片:</label>
                        <div class="col-sm-10">
                            <#if article?exists && article.cover?exists && article.cover != ''>
                                <div id="back-img">
                                    <img id="backImg" style="min-height: 160px;" src="${BASE_PATH}/${(article.cover)!}" alt="背景图片" width="250px" height="160px" class="img-rounded">
                                    <input type="hidden" name="cover" value="${(article.cover)!}" id="cover">
                                </div>
                                <input type="button" value="删除图片" id="deleteImg" class="btn btn-default">
                                <div id="advancedDropzone" class="droppable-area dz-clickable img-rounded" style="display: none; min-height: 200px;">
                                    点击上传封面图片
                                </div>
                            <#else>
                                <div id="back-img" style="display: none; ">
                                    <img id="backImg" style="min-height: 160px;" src="" alt="背景图片" width="250px" height="160px" class="img-rounded">
                                    <input type="hidden" name="cover" value="" id="cover">
                                </div>
                                <div id="advancedDropzone" class="droppable-area dz-clickable img-rounded" style="min-height: 200px;">
                                    点击上传封面图片
                                </div>
                            </#if>

                            <button type="submit" id="js-publish" class="btn btn-default pull-right">
                                <#if article?exists>
                                    更新文章
                                <#else>
                                    发表文章
                                </#if>
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

    </div>

    <div class="col-md-3">

        <!-- 分类 -->
        <div class="panel panel-default panel-border">
            <div class="panel-heading">
                分类目录
            </div>

            <div class="panel-body">
                <form role="form" class="form-horizontal" id="catForm">
                    <div class="form-group">
                        <div class="col-sm-10">
                            <div class="checkbox">
                                <label>
                                    <input type="checkbox">
                                    默认分类
                                </label>
                            </div>
                            <#list cats as cat>
                                <div class="checkbox">
                                    <label>
                                        <input class="cat" name="catId" type="checkbox"
                                               value="${(cat.category.id)!}">
                                    ${(cat.category.name)!}
                                    </label>
                                </div>
                                <#list cat.subs as sub>
                                    <div class="checkbox">
                                        <label>
                                            <input class="cat" name="catId" type="checkbox"
                                                   value="${(sub.category.id)!}">
                                            --&nbsp;${(sub.category.name)!}
                                        </label>
                                    </div>
                                </#list>
                            </#list>
                        </div>
                    </div>
                </form>
            </div>
        </div>

    </div>
</div>


<!-- Imported scripts on this page -->
<script src="${BASE_PATH}/static/admin/js/ckeditor/ckeditor.js"></script>
<script src="${BASE_PATH}/static/admin/js/ckeditor/adapters/jquery.js"></script>
<script src="${BASE_PATH}/static/admin/js/dropzone/dropzone.min.js"></script>



<script type="text/javascript">
    jQuery(document).ready(function($)
    {
        var i = -1,
                colors = ['primary', 'secondary', 'red', 'blue', 'warning', 'success', 'purple'];

        colors = shuffleArray(colors);

        $("#tags-input").tagsinput({
            tagClass: function()
            {
                i++;
                return "label label-" + colors[i%colors.length];
            }
        });
    });
    // Just for demo purpose
    function shuffleArray(array)
    {
        for (var i = array.length - 1; i > 0; i--)
        {
            var j = Math.floor(Math.random() * (i + 1));
            var temp = array[i];
            array[i] = array[j];
            array[j] = temp;
        }
        return array;
    }
</script>

<script type="text/javascript">

    var cats = [
        <#if article?exists>
            <#list (article.cats)! as cat>
            ${(cat.id)!},
            </#list>
        </#if>];

    $(document).ready(function () {

        $("input[name='catId']").each(function (index) {
            //alert($(this).val());
            var id = $(this).val();
            for (var key in cats) {
                if (cats[key] == id) {
                    $(this).attr("checked", 'checked');
                }
                //alert(key);
                //alert(cats[key]);
            }
        });

        $("#deleteImg").click(function(){
            var that = $(this);
            $.ajax({
                type: "POST",
                url: "deleteCover.json",
                data: {id:'${(article.id)!}'},
                dataType: "json",
                success: function (data) {
                    if (data.status === true) {
                        $("#back-img").hide();
                        that.hide();
                        $("#advancedDropzone").show();
                    } else {
                        alert("error");
                    }
                }
            });

        });

        $('#actionForm').bootstrapValidator({
            message: 'This value is not valid',
            fields: {
                title: {
                    message: '标题不能为空',
                    validators: {
                        notEmpty: {
                            message: '标题不能为空'
                        },
                        stringLength: {
                            min: 2,
                            message: '标题必须为两个字以上'
                        }
                    }
                }
            }
        }).on('success.form.bv', function(e) {
            var catForm = $('#catForm').serialize();
            var actionForm = $('#actionForm').serialize();
            $.ajax({
                type: "POST",
                url: "ajaxEdit.json",
                data: actionForm + "&" + catForm,
                dataType: "json",
                success: function (data) {
                    if (data.status === true) {
                        //window.location.reload();
                        window.location.href = "list.html";
                    } else {
                        alert("error");
                    }
                }
            });
        });
    });
</script>
<script type="text/javascript">
    jQuery(document).ready(function ($) {
        example_dropzone = $("#advancedDropzone").dropzone({
        <#--url: '${BASE_PATH}/admin/upload/ueditor.json?action=uploadimage',-->
            url: '${BASE_PATH}/admin/upload/uploadImg.json?type=thumbs',
            paramName:'upload',
            acceptedFiles: ".png,.jpg,.gif,.bmp,.jpeg",
            // Events
            addedfile: function (file) {

            },
            uploadprogress: function (file, progress, bytesSent) {
            },

            success: function (file) {
                console.log(file);
                var imagePath = file.xhr.response;
                console.log(imagePath);
//                        var responJson = JSON.parse(file.xhr.response);
                $("#backImg").attr("src","${BASE_PATH}/"+imagePath);
                $("#cover").val(imagePath);
                $("#back-img").show();
                $("#advancedDropzone").hide();
                console.log("url " + imagePath + " uploaded");
            },

            error: function (file) {
                alert("error");
            }
        });

        $("#advancedDropzone").css({
            minHeight: 200
        });

    });
</script>

</@html>