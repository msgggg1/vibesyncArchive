<%@ page import="mvc.domain.dto.UserNoteDTO" %>
<%@ page import="mvc.domain.vo.UserVO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String contextPath = request.getContextPath();  // → "/jspPro"
    UserVO user = (UserVO) session.getAttribute("userInfo");
    UserNoteDTO followLike = (UserNoteDTO) request.getAttribute("followLike");
    String pageidx = request.getParameter("pageidx");
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
            <a onclick="history.back()"><img src="./sources/icons/arrow_back.svg" alt="arrow_back"></a>
          </div>

          <div id="postview_Wrapper">
            <div class="title">
            	<p>Create</p>
            </div>


            <div class="line"></div>
            <div class="text_content">
            	<form id="postForm" method="post" action="notecreate.do" style="margin-bottom: 4rem;">
            	  <div id="title_info">
	            	  <label for="title"></label>
	            	  <input class="title" id="title" type="text" name="title" placeholder="title..." required>
            	  </div>
            	  
            	  
	              <textarea id="summernote" name="content"></textarea>
	              <div class="note_op">
            	  <div style="margin-top: 1rem;">
						<label for="thumbnail_input" style="font-weight:bold;">Thumbnail Image (JPG, JPEG only)</label>
						<input type="file" id="thumbnail_input" accept=".jpg, .jpeg" required>
            	  </div>
            	  <div id="select_wrapper">
            	  	<div class="category sel" >
            	  	  	<label for="category">category</label>
	                  <select id="category" name="category_idx">
		                  <c:forEach items="${ categoryList }" var="categoryVO">
		                  	<option value="${ categoryVO.category_idx }">${ categoryVO.c_name }</option>
		                  </c:forEach>
	                  </select>
            	  	</div>
            	  	<div class="genre sel">
            	  	  	<label for="genre">genre</label>
	                  <select id="genre" name="genre_idx">
		                  <c:forEach items="${ genreList }" var="genreVO">
		                  	<option value="${ genreVO.genre_idx }">${ genreVO.gen_name }</option>
		                  </c:forEach>
	                  </select>
            	  	</div>
            	  	<div class="contents sel" >
            	  	  	<label for="contents">content</label>
	                  <select id="contents" name="content_idx">
		                  <c:forEach items="${ contentList }" var="contentVO">
		                  	<option value="${ contentVO.content_idx }">${ contentVO.title }</option>
		                  </c:forEach>
	                  </select>
            	  	</div>
            	  </div>
	              
	              <input type="hidden" id="images" name="images">
	              <input type="hidden" name="thumbnail_base64"> <input type="hidden" name="thumbnail_ext">    <input type="hidden" id="pageidx" name="pageidx" value="<%= pageidx %>">
	              
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
	        placeholder: '여기에 내용을 입력하세요...',
	        toolbar: [
	            ['style', ['style']],
	            ['font', ['bold', 'italic', 'underline', 'strikethrough', 'clear']],
	            ['fontname', ['fontname']],
	            ['fontsize', ['fontsize']],
	            ['color', ['color']],
	            ['para', ['ul', 'ol', 'paragraph']],
	            ['height', ['height']],
	            ['insert', ['picture']], // 링크, 비디오 등 제외
	        ],
	        callbacks: {
	            onImageUpload: function(files) {
	                for (let i = 0; i < files.length; i++) {
	                    sendFile(files[i]);
	                }
	            }
	        }
	    });

	    function sendFile(file) {
	        const reader = new FileReader();
	        reader.onloadend = function() {
	            const base64Data = reader.result;
	            $('#summernote').summernote('insertImage', base64Data);
	        }
	        reader.readAsDataURL(file);
	    }
	    
	    // [추가] 썸네일 파일 선택 시 유효성 검사 및 Base64 변환
	    $('#thumbnail_input').on('change', function() {
	    	const file = this.files[0];
	    	if (!file) return;

	    	const fileName = file.name;
	    	const fileExt = fileName.slice(fileName.lastIndexOf(".") + 1).toLowerCase();

	    	if(fileExt !== "jpg" && fileExt !== "jpeg"){
	    	  alert("JPG, JPEG 파일만 업로드 가능합니다.");
	    	  $(this).val(""); // 파일 선택 초기화
	    	  $('input[name="thumbnail_base64"]').val("");
	    	  $('input[name="thumbnail_ext"]').val("");
	    	  return;
	    	}
	    	
	    	// 유효한 파일이면 Base64로 변환하여 hidden input에 저장
	    	const reader = new FileReader();
	        reader.onloadend = function() {
	            $('input[name="thumbnail_base64"]').val(reader.result);
	            $('input[name="thumbnail_ext"]').val(fileExt);
	        }
	        reader.readAsDataURL(file);
	    });
	    
	    $('#saveBtn').click(function() {
	        // [추가] 썸네일이 선택되었는지 최종 확인
	        if (!$('input[name="thumbnail_base64"]').val()) {
	        	alert('대표 이미지를 선택해주세요.');
	        	$('#thumbnail_input').focus();
	        	return;
	        }
	    
	        var markup = $('#summernote').summernote('code');
	        var tempDiv = $('<div>').html(markup);
	        var imgElements = tempDiv.find('img');
	        var base64SrcArray = [];

	        imgElements.each(function(i) {
	            var src = $(this).attr('src');
	            if (src.startsWith('data:image/')) {
	                base64SrcArray.push(src);
	            }
	        });

	        $('#images').val(base64SrcArray.join('|'));
	        $('textarea[name=content]').val(tempDiv.html());
	        $('#postForm').submit();
	    });
	});
  </script>
</body>
</html>
