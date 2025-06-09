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
  <!-- jQuery -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script>
    $(document).ready(function() {
      // ▶ 중요: properties 파일에 매핑된 URL을 그대로 사용해야 함
      const ajaxUrl = '<%= contextPath %>' + '/vibesync/postView.do';
      
      // 페이지 로드시 data 속성 값들 확인
      console.log("data-user-idx:", $('#followBtn').data('userIdx'));
      console.log("data-writer-idx:", $('#followBtn').data('writerIdx'));
      console.log("data-note-idx:", $('#followBtn').data('nidx'));
      console.log("like data-user-idx:", $('#likeBtn').data('userIdx'));
      console.log("like data-note-idx:", $('#likeBtn').data('noteIdx'));

      // Follow/Unfollow AJAX
      $('#followForm').on('submit', function(e) {
        e.preventDefault();
        const userIdx = $('#followBtn').data('userIdx');
        const writerIdx = $('#followBtn').data('writerIdx');
        const nidx = $('#followBtn').data('nidx');
        console.log("[AJAX-FOLLOW] 보내기 전 userIdx:", userIdx,
                    "writerIdx:", writerIdx, "noteIdx:", nidx);

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
            if (data.following) {
              $('#followBtn').text('Unfollow');
            } else {
              $('#followBtn').text('Follow');
            }
          },
          error: function(xhr, status, error) {
            console.error('[AJAX-FOLLOW] 에러 발생:', error);
          }
        });
      });

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
              $('#likeImg').attr('src', '<%= contextPath %>' + '/vibesync/sources/icons/fill_heart.png');
              $('#likeCount').text(currentCount + 1);
            } else {
              $('#likeImg').attr('src', '<%= contextPath %>' + '/vibesync/sources/icons/heart.svg');
              $('#likeCount').text(currentCount - 1);
            }
          },
          error: function(xhr, status, error) {
            console.error('[AJAX-LIKE] 에러 발생:', error);
          }
        });
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
            <a href="#"><img src="./sources/icons/arrow_back.svg" alt="arrow_back"></a>
          </div>

          <div id="postview_Wrapper">
            <p>${note.title}</p>
            <div class="writer_info">
              <div class="writer">
                <img src="${note.img}" alt="writer_profile">
                <p>${note.nickname}</p>

                <!-- follow 버튼 -->
                <form id="followForm" style="display:inline; margin:0; padding:0;">
                  <button
                    id="followBtn"
                    type="submit"
                    data-user-idx="<%= user.getAc_idx() %>"
                    data-writer-idx="${note.upac_idx}"
                    data-nidx="${note.note_idx}"
                    style="background:#99bc85; border-radius:5px; border:none; cursor:pointer; padding:5px 10px;">
                    <%= following ? "Unfollow" : "Follow" %>
                  </button>
                </form>
              </div>

              <div class="like_share">
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
              <p>${note.text}</p>
            </div>
          </div>
        </section>
      </div>
    </div>
  </div>
</body>
</html>
