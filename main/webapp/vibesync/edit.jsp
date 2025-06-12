<%@ page import="mvc.domain.dto.UserNoteDTO" %>
<%@ page import="mvc.domain.vo.UserVO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String contextPath = request.getContextPath();  // → "/jspPro"
    UserVO user = (UserVO) session.getAttribute("userInfo");
    UserNoteDTO followLike = (UserNoteDTO) request.getAttribute("followLike");
    String pageidx = (String)request.getAttribute("pageidx");
    boolean following = followLike != null && followLike.isFollowing();
    boolean liking = followLike != null && followLike.isLiking();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>PostView</title>
  <link rel="icon" href="./sources/favicon.ico" />
  <link rel="stylesheet" href="./css/style.css">
  <script src="./js/script.js"></script>
  <!-- jQuery -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  
  <!-- summernote -->
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote.min.css" rel="stylesheet">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote.min.js"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.bundle.min.js"></script>
  
  <style>
  .note-editor {
  	background: white;
  }
  </style>
  
</head>
<body>
  <div id="notion-app">
    <input type="hidden" id="mode" value="postview">
    <div class="notion-app-inner">
      <jsp:include page="./includes/sidebar.jsp"></jsp:include>

      <!-- content -->
      <div id="content_wrapper">
        <section id="content">
          <div class="back_icon">
            <a onclick="location.href = history.go(-1)"><img src="./sources/icons/arrow_back.svg" alt="arrow_back"></a>
          </div>

          <div id="postview_Wrapper">
            <div class="title">
            	<p>Edit</p> <!-- 수정: "Create" → "Edit" -->
            </div>

            <div class="line"></div>
            <div class="text_content">
            	<form id="postForm" method="post" action="noteedit.do">
            	  <div id="select_wrapper">
            	  	<div class="category">
            	  	  	<label for="category">category</label>
	                    <select id="category" name="category_idx">
		                    <c:forEach items="${ categoryList }" var="categoryVO">
		                    	<option value="${ categoryVO.category_idx }" <c:if test="${ categoryVO.category_idx == note.category_idx }">selected</c:if>>${ categoryVO.c_name }</option>
		                    </c:forEach>
	                    </select>
            	  	</div>
            	  	<div class="genre">
            	  	  	<label for="genre">genre</label>
	                    <select id="genre" name="genre_idx">
		                    <c:forEach items="${ genreList }" var="genreVO">
		                    	<option value="${ genreVO.genre_idx }" <c:if test="${ genreVO.genre_idx == note.genre_idx }">selected</c:if>>${ genreVO.gen_name }</option>
		                    </c:forEach>
	                    </select>
            	  	</div>
            	  	<div class="contents">
            	  	  	<label for="contents">content</label>
	                    <select id="contents" name="content_idx">
		                    <c:forEach items="${ contentList }" var="contentVO">
		                    	<option value="${ contentVO.content_idx }" <c:if test="${ contentVO.content_idx == note.content_idx }">selected</c:if>>${ contentVO.title }</option>
		                    </c:forEach>
	                    </select>
            	  	</div>
            	  </div>
            	  <input class="title" type="text" name="title" placeholder="title..." required value="${note.title}">
	              <textarea id="summernote" name="content">${note.text}</textarea>
	              <input type="hidden" id="images" name="images">
	              <input type="hidden" id="pageidx" name="pageidx" value="<%= pageidx %>">
	              <input type="hidden" id="noteidx" name="noteidx" value="${note.note_idx}"> <!-- 수정: noteIdx 추가 -->
	              
	              <button type="button" id="saveBtn" class="btn btn-primary mt-3">저장</button>
	              
	            </form>
            </div>
          </div>
        </section>
      </div>
    </div>
  </div>
  
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

	        imgElements.each(function(i) {
	            var src = $(this).attr('src');
	            if (src.startsWith('data:image/')) {
	                base64SrcArray.push(src);

	                // 파일마다 시간 기반으로 고유 이름 + 실제 확장자 추출
	                var ext = src.substring(src.indexOf('/')+1, src.indexOf(';base64'));
	                var tempName = 'temp_' + Date.now() + '_' + i + '.' + ext;
	                
	                $(this).attr('src', '<%= contextPath %>/sources/noteImg/' + tempName);
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