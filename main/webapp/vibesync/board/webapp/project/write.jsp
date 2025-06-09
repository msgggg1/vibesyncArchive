<%-- write.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>글 작성</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" rel="stylesheet">
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

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote.min.js"></script>
<script>
$(function() {
    $('#summernote').summernote({
        height: 300,
        callbacks: {
            onImageUpload: function(files) {
                for (let i = 0; i < files.length; i++) {
                    sendFile(files[i], this);
                }
            }
        }
    });

    function sendFile(file, editor) {
        const reader = new FileReader();
        reader.onloadend = function() {
            const base64Data = reader.result;
            // 에디터에 이미지 삽입 (src는 Base64)
            $('#summernote').summernote('insertImage', base64Data);
        }
        reader.readAsDataURL(file);
    }

    $('#saveBtn').click(function() {
        var markup = $('#summernote').summernote('code');
        var tempDiv = $('<div>').html(markup);
        var imgElements = tempDiv.find('img');
        var base64SrcArray = [];

        imgElements.each(function() {
            var src = $(this).attr('src');
            if (src.startsWith('data:image/')) {
                base64SrcArray.push(src);
                $(this).attr('src', './source/temp_filename.jpg'); // 임시 src로 변경 (save.jsp에서 실제 경로로 변경)
            }
        });

        $('#images').val(base64SrcArray.join('|')); // Base64 데이터들을 |로 연결하여 hidden 필드에 저장
        $('textarea[name=content]').val(tempDiv.html()); // 변경된 content 저장
        $('#postForm').submit();
    });
});
</script>

</body>
</html>