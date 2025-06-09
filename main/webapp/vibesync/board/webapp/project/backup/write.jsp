<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>글 작성</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" rel="stylesheet">
    <!-- Summernote CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <h2>새 글 작성</h2>
    <form id="postForm" method="post" action="save.jsp">
        <input class="form-control mb-2" type="text" name="title" placeholder="제목" required>
        <textarea id="summernote" name="content"></textarea>
        <input type="hidden" id="images" name="images">
        <button type="button" id="saveBtn" class="btn btn-primary mt-3">저장</button>
    </form>
</div>

<!-- jQuery, Bootstrap JS, Summernote JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote.min.js"></script>
<script>
$(function() {
    $('#summernote').summernote({
        height: 300,
        callbacks: {
            onImageUpload: function(files) {
                // 이미지 미리보기만 처리
                var reader = new FileReader();
                reader.onload = function(e) {
                    $('#summernote').summernote('insertImage', e.target.result);
                };
                reader.readAsDataURL(files[0]);
            }
        }
    });

    $('#saveBtn').click(function() {
        var markup = $('#summernote').summernote('code');
        var tempDiv = $('<div>').html(markup);
        var imgSrc = tempDiv.find('img').attr('src') || '';
        $('#images').val(imgSrc);
        $('textarea[name=content]').val(markup);
        $('#postForm').submit();
    });
});
</script>