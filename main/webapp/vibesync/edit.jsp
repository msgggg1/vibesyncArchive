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
  <link rel="stylesheet" href="./css/sidebar.css">
  <script src="./js/script.js"></script>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote.min.css" rel="stylesheet">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote.min.js"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.bundle.min.js"></script>
  
  <style>
  span {
   color: var(--font-color) !important;
  }
  
  .note-editor {
  	background: white;
  }
  
  #select_wrapper {
  	display: flex;
    justify-content: flex-start;
    align-items: center;
    margin-top: 1rem;
    gap: 14px;
    height: 2rem;
  }
  
  #select_wrapper select{
  	border-radius: 4px;
  	height: 2rem;
  }
  
  #select_wrapper .sel {
  	display: flex;
    gap: 10px;
    text-transform: uppercase;
    font-weight: bold;
    align-items: center;
    justify-content: center;
  }
  
  #select_wrapper label {
  	margin: 0;
  }
  
	#title_info {
	width: 100%;
    height: 100%;
    display: flex;
    font-weight: bold;
    align-items: center;
    justify-content: center;
    margin-bottom: 1.4rem;
	}

	.note-editor {
	position: relative;
	width: 100%;
    min-height: 800px;
    border: none !important;
    background: transparent;
	}

	.note-editing-area {
		width: 100%;
    height: 94%;
    background: transparent;
	}
	
	.note-editable {
		height: 100% !important;
	}
	.note-statusbar{
		display: none;
	}
	
	.note-toolbar{
		display: flex;
		justify-content: space-evenly;
		border: solid 2px var(--border-color);
		border-radius: 4px;
	}
	
	.note-editing-area{
		margin-top: 20px;
	}
	
	.note_op{
		border: solid 2px var(--border-color);
	    padding: 10px;
	    border-radius: 4px;
	    background-color: var(--background-color);
	}

	#save_btn {
		display: flex;
    justify-content: flex-end;
    align-items: center;
    margin-top: 10px;
	}

	#saveBtn {
		background: #8ac4ff;
		font-weight: bold;
		margin: 0 !important;
	}
	
	#saveBtn:hover {
		background: #1f8efdb7;
		font-weight: bold;
		margin: 0 !important;
	}
  </style>
  
</head>
<body>
  <div id="notion-app">
    <input type="hidden" id="mode" value="postview">
    <div class="notion-app-inner">
      <jsp:include page="./includes/sidebar.jsp"></jsp:include>

      <div id="content_wrapper">
        <section id="content">
          <div class="back_icon">
            <a onclick="location.href = history.go(-1)"><img src="./sources/icons/arrow_back.svg" alt="arrow_back"></a>
          </div>

          <div id="postview_Wrapper">
            <div class="title">
            	<p>Edit</p>
            </div>

            <div class="line"></div>
            <div class="text_content">
            	<form id="postForm" method="post" action="noteedit.do" style="margin-bottom: 4rem;" >
            	  <input class="title" type="text" name="title" placeholder="title..." required value="${note.title}">
	              <textarea id="summernote" name="content">${note.text}</textarea>
	              <div class="note_op">
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
	              <input type="hidden" id="images" name="images">
	              <input type="hidden" id="pageidx" name="pageidx" value="<%= pageidx %>">
	              <input type="hidden" id="noteidx" name="noteidx" value="${note.note_idx}">
	              <div id="save_btn">
	              <button type="button" id="saveBtn" class="btn btn-primary mt-3">SAVE</button>
	              </div>
	              </div>
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
            toolbar: [
	            ['style', ['style']],
	            ['font', ['bold', 'italic', 'underline', 'strikethrough', 'clear']],
	            ['fontname', ['fontname']],
	            ['fontsize', ['fontsize']],
	            ['color', ['color']],
	            ['para', ['ul', 'ol', 'paragraph']],
	            ['height', ['height']],
	            ['insert'],
	        ],
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
	            // 새로 추가된 Base64 인코딩된 이미지만 수집
	            if (src.startsWith('data:image/')) {
	                base64SrcArray.push(src);
	            }
	        });

	        $('#images').val(base64SrcArray.join('|')); 
	        $('textarea[name=content]').val(markup); // [수정] 원본 markup을 전송
	        $('#postForm').submit();
	    });
	});
  </script>
</body>
</html>