<%@ page import="mvc.domain.dto.UserNoteDTO" %>
<%@ page import="mvc.domain.vo.UserVO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String contextPath = request.getContextPath();  // → "/jspPro"
    UserVO user = (UserVO) session.getAttribute("userInfo");
    UserNoteDTO followLike = (UserNoteDTO) request.getAttribute("followLike");
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
  <script>
    $(document).ready(function() {
      // ▶ 중요: properties 파일에 매핑된 URL을 그대로 사용해야 함
      const ajaxUrl = '<%= contextPath %>' + '/vibesync/postView.do';
      // contextPath 를 JS 변수로 사용
      const ctx = '<%= contextPath %>';
      
      // Follow/Unfollow AJAX (Owner only)
      <c:if test="${sessionScope.userInfo != null && sessionScope.userInfo.ac_idx == note.upac_idx}">

       $('#followForm').on('submit', function(e) {
        e.preventDefault();
        const userIdx   = $('#followBtn').data('userIdx');
        const writerIdx = $('#followBtn').data('writerIdx');
        const nidx      = $('#followBtn').data('nidx');
        console.log("[AJAX-FOLLOW] 보내기 전", { userIdx, writerIdx, nidx });

        $.ajax({
          url: ajaxUrl,
          type: 'POST',
          data: {
            action: 'toggleFollow',
            userIdx: userIdx,
            writerIdx: writerIdx,
            nidx : nidx 
          },
          dataType: 'json',
          cache: false,
          success: function(data) {
            console.log("[AJAX-FOLLOW] 응답:", data);
             $('#followBtn').text(data.following ? 'Unfollow' : 'Follow');
          },
          error: function(xhr, status, error) {
            console.error('[AJAX-FOLLOW] 에러 발생:', error);
          }
        });
      });
    </c:if>
      // Like/Unlike AJAX
      $('#likeForm').on('submit', function(e) {
        e.preventDefault();
        const userIdx = $('#likeBtn').data('userIdx');
        const noteIdx = $('#likeBtn').data('noteIdx');
        const currentCount = parseInt($('#likeCount').text(), 10);
        console.log("[AJAX-LIKE] 보내기 전 userIdx:", userIdx, "noteIdx:", noteIdx);

        $.ajax({
          url: ajaxUrl,
          type: 'POST',
          data: {
            action: 'toggleLike',
            userIdx: userIdx,
            noteIdx: noteIdx
          },
          dataType: 'json',
          cache: false,
          success: function(data) {
            console.log("[AJAX-LIKE] 응답:", data);
            if (data.liked) {
              $('#likeImg').attr('src', ctx + '/vibesync/sources/icons/fill_heart.png');
              $('#likeCount').text(currentCount + 1);
            } else {
              $('#likeImg').attr('src', ctx + '/vibesync/sources/icons/heart.svg');
              $('#likeCount').text(currentCount - 1);
            }
          },
          error: function(xhr, status, error) {
            console.error('[AJAX-LIKE] 에러 발생:', error);
          }
        });
      });
      // 1) 텍스트 내용 내 img 태그 src에 contextPath를 prefix
      $('.text_content img').each(function() {
        const src = $(this).attr('src');
        // modified: contextPath 가 붙어있지 않으면 prefix
        if (src && !src.startsWith('http') && !src.startsWith(ctx)) {
          $(this).attr('src', ctx + '/' + src); // modified
        }
      });   
    });
  </script>
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
            <a onclick="history.back()"><img src="./sources/icons/arrow_back.svg" alt="arrow_back"></a>
          </div>

          <div id="postview_Wrapper">
            <div class="title">
              <p>${note.title}</p>
              <c:if test="${sessionScope.userInfo != null && sessionScope.userInfo.ac_idx == note.upac_idx}">
              <div>
                <button><a href="noteedit.do?noteidx=${note.note_idx}">edit</a></button>
                <button><a href="notedelete.do?noteidx=${note.note_idx}">delete</a></button>
              </div>
              </c:if>
            </div>
              <div class="writer_info">
               <div class="writer">
                <img src="${note.img}" alt="writer_profile">
                <p>${note.nickname}</p>

                <!-- follow 버튼 -->
               <c:if test="${sessionScope.userInfo != null && sessionScope.userInfo.ac_idx != note.upac_idx}">
                <form id="followForm" style="display:inline; margin:0; padding:0;">
                  <button
                    id="followBtn"
                    type="submit"
                    data-user-idx="${ sessionScope.userInfo.ac_idx }"
                    data-writer-idx="${note.upac_idx}"
                    data-nidx="${note.note_idx}"
                    style="background:#99bc85; border-radius:5px; border:none; cursor:pointer; padding:5px 10px;">
                    <%= following ? "Unfollow" : "Follow" %>
                  </button>
                </form>
                </c:if>
              </div>
			   <!-- like + share -->
              <div class="like_share">
              	<div>
	               <p><span>view : </span><span>${note.view_count}</span></p>
	            </div>
              	
                <!-- like 버튼 -->
                <form id="likeForm" style="display:inline; margin:0; padding:0;">
                  <button
                    id="likeBtn"
                    type="submit"
                    data-user-idx="<%= user.getAc_idx() %>"
                    data-note-idx="${note.note_idx}"
                    style="border:none; background:none; cursor:pointer;">
                    <img
                      id="likeImg"
                      src="<%= liking ? "./sources/icons/fill_heart.png" : "./sources/icons/heart.svg" %>"
                      alt="heart"
                      style="vertical-align:middle; width:2rem; height:2rem;">
                    <span id="likeCount" style="vertical-align:middle;">${note.like_num}</span>
                  </button>
                </form>
              </div>
            </div>

            <div class="line"></div>
            <div class="text_content">
              <c:out value="${note.text}" escapeXml="false"/> <!-- modified -->
            </div>
          </div>
        </section>
      </div>
    </div>
  </div>
</body>
</html>
