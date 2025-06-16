<%@page import="java.util.Enumeration"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder"%>
<% String contextPath = request.getContextPath() + "/vibesync"; %>
<%
Enumeration<String> names = request.getParameterNames();
while (names.hasMoreElements()) {
    String name = names.nextElement();
    String name_val = request.getParameter(name);
    System.out.println("name : " + name + "/ val : " + name_val);
}
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>user</title>
  <link rel="icon" href="./sources/favicon.ico" />
  <link rel="stylesheet" href="./css/style.css">
  <link rel="stylesheet" href="./css/sidebar.css">
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script defer src="./js/script.js"></script>
  <style>
    h3 {
      margin: 0;
    }
	.wp_btn {background: black;}
    #pageCreateBtn {
      position: fixed;
      bottom: 20px;
      right: 20px;
      width: 50px;
      height: 50px;
      border-radius: 50%;
      background: #8ac4ff;
      color: #fff;
      font-size: 24px;
      z-index: 1000;
      border: none;
      cursor: pointer;
    }

    .modal-overlay {
      position: fixed;
      top: 0; left: 0;
      width: 100%; height: 100%;
      background: rgba(0,0,0,0.5);
      display: none;
      justify-content: center;
      align-items: center;
      z-index: 2000;
    }
    
    #modalWrapper {
      width: 100%;
      height: 100%;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    
    .modal-content {
      display: flex;
      flex-direction: column;
      justify-content: space-evenly;
      align-items: center;

      background: #fff;
      padding: 20px;
      border-radius: 8px;
      width: 90%; max-width: 400px;
      min-height: 14rem;
      position: relative;
    }

    #pageSelect {
      width: 100%;
      height: 2rem;
      text-align: center;
      border-radius: 10px;
      font-weight: bold;
      text-transform: uppercase;
    }

    #btn_wrapper {
      display: flex;
      gap: 2rem;
    }

    .btn_deco {
      background: #8ac4ff;
      border: none;
      color: white;
      padding: 4px 12px;
      border-radius: 6px;
    }

    .btn_deco:hover {
      background: #4da3f9;
    }

    #pageCreateForm {
      display: flex;
      flex-direction: column;
    }

    .modal-close {
      position: absolute;
      top: 10px; right: 10px;
      cursor: pointer;
      font-size: 18px;
      border: none;
      background: none;
    }
  </style>
</head>
<body>
  <div id="notion-app">
    <input type="hidden" id="mode" value="user">
    <input type="hidden" id="profileUserAcIdx" value="${userPageData.userProfile.ac_idx}">
    <%-- 무한스크롤용 --%>
    <input type="hidden" id="currentPageNumber" value="${userPageData.nextPageNumber - 1}">
    <%-- 현재 로드된 페이지 번호 --%>
    <input type="hidden" id="hasMorePosts" value="${userPageData.hasMorePosts ? 'true' : 'false'}">

    <div class="notion-app-inner">
      <jsp:include page="./includes/sidebar.jsp" flush="true"></jsp:include>

      <div id="content_wrapper">
        <section id="content">
          <div id="user_wrapper">
            <div id="userInfo">
              <div class="user_profile_img">
                <c:choose>
                  <c:when test="${not empty userPageData.userProfile.img}">
                    <img src="<%=contextPath %>/${userPageData.userProfile.img}" alt="프로필">
                  </c:when>
                  <c:otherwise>
                    <img src="<%=contextPath %>/sources/default/default_user.jpg" alt="기본 프로필">
                  </c:otherwise>
                </c:choose>
              </div>

              <div class="userInfo_detail">
                <div class="name_function">
                  <p>${userPageData.userProfile.nickname}</p>
                  <%-- 팔로우 버튼: 현재 로그인한 사용자가 프로필 사용자가 아닌 경우에만 표시 --%>
                  <c:if test="${sessionScope.userInfo != null && sessionScope.userInfo.ac_idx != userPageData.userProfile.ac_idx}">
                    <button type="button" id="profileFollowBtn"
                            class="btn_follow_1"
                            data-author-id="${userPageData.userProfile.ac_idx}"
                            data-following="${userPageData.userProfile.followedByCurrentUser ? 'true' : 'false'}">
                      ${userPageData.userProfile.followedByCurrentUser ? 'UNFOLLOW' : 'FOLLOW'}
                    </button>
                  </c:if>
                  <%-- Watch Party 버튼 (기능 구현 시 활성화) --%>
                  <c:if test="${sessionScope.userInfo != null && sessionScope.userInfo.ac_idx == userPageData.userProfile.ac_idx}">
                     <button class="wp_btn" onclick="location.href='waList.jsp'">Watch Party</button>
                  </c:if>
                </div>
                <div class="user_count">
                  <p>POST <span>${userPageData.userProfile.postCount}</span></p>
                  <p>FOLLOWER <span id="profileFollowerCount">${userPageData.userProfile.followerCount}</span></p>
                  <p>FOLLOW <span>${userPageData.userProfile.followingCount}</span></p>
                </div>
              </div>
            </div>

            <div class="line"></div>

            <div id="con_wrapper">
              <c:forEach var="post" items="${userPageData.posts}">
                  <a href="<%=contextPath %>/postView.do?nidx=${post.note_idx}">
                	<div class="con_item">
                    <c:choose>
                      <c:when test="${not empty post.thumbnail_img}">
                        <img src="${pageContext.request.contextPath}/${post.thumbnail_img}" alt="${post.title} 썸네일" style="width: 100%; height: 100%; object-fit:cover;" >
                      </c:when>
                      <c:otherwise>
                        <img src="${pageContext.request.contextPath}/sources/images/default_thumbnail.png" alt="기본 썸네일">
                      </c:otherwise>
                    </c:choose>             
                   </div>
                  </a>
              </c:forEach>
            </div>
            <div id="loadingIndicator" style="display: none; text-align: center; padding: 20px;">로딩 중...</div>
          </div>
        </section>
      </div>
    </div>
  </div>
  
  <!-- 페이지 생성 모달 트리거 버튼 -->
  <c:if test="${sessionScope.userInfo != null && sessionScope.userInfo.ac_idx == userPageData.userProfile.ac_idx}">
  	<button id="pageCreateBtn">＋</button>
  </c:if>

  <!-- 모달 오버레이 및 컨텐츠 -->
  <div id="pageModalOverlay" class="modal-overlay">
    <div id="modalWrapper">
    	<div class="modal-content" id="pageModalContent">
	    <button class="modal-close" id="pageModalClose">&times;</button>
	    <!-- AJAX로 로드된 <select> + 버튼들 삽입 -->
    </div>
    </div>
  </div>

  <script>
    $(document).ready(function() {
      // 프로필 페이지의 팔로우 버튼 처리
      $('#profileFollowBtn').on('click', function() {
        var $button = $(this);
        var authorId = $button.data('author-id');
        var isLoggedIn = ${sessionScope.userInfo != null}; 

        if (!isLoggedIn) {
          alert("로그인이 필요합니다.");
          location.href = "${pageContext.request.contextPath}/login.jsp"; 
          return;
        }

        $.ajax({
          url: '${pageContext.request.contextPath}/followToggle.do', 
          type: 'POST',
          data: { authorId: authorId },
          dataType: 'json',
          success: function(response) {
            if (response.success) {
              if (response.following) {
                $button.data('following', true).text('UNFOLLOW');
              } else {
                $button.data('following', false).text('FOLLOW');
              }
              // 팔로워 수 업데이트
              if (typeof response.newFollowerCount !== 'undefined') {
                $('#profileFollowerCount').text(response.newFollowerCount);
              }
            } else {
              alert('오류: ' + (response.message || '팔로우 처리에 실패했습니다.'));
            }
          },
          error: function() {
            alert('팔로우 요청 중 오류가 발생했습니다.');
          }
        });
      });

      // 무한 스크롤 로직
      var isLoading = false; // 중복 요청 방지 플래그
      $(window).scroll(function() {
        var hasMore = ($('#hasMorePosts').val() === 'true');
        if (!hasMore || isLoading) return;

        // (window의 높이 + 스크롤된 양) >= (문서 전체의 높이 - 특정 버퍼값)
        if ($(window).scrollTop() + $(window).height() >= $(document).height() - 200) {
          isLoading = true;
          $('#loadingIndicator').show();
          var nextPage = parseInt($('#currentPageNumber').val()) + 1;
          var profileUserId = $('#profileUserAcIdx').val();

          $.ajax({
            url: '${pageContext.request.contextPath}/loadMorePosts.do', 
            type: 'GET', 
            data: {
              userId: profileUserId,
              page: nextPage
            },
            dataType: 'json',
            success: function(response) {
              if (response.posts && response.posts.length > 0) {
                var postsHtml = '';
                $.each(response.posts, function(index, post) {
                  postsHtml += '<div class="con_item">';
                  postsHtml += '  <a href="${pageContext.request.contextPath}/noteView.do?noteIdx=' + post.note_idx + '">';
                  postsHtml += '    <img src="${pageContext.request.contextPath}/' + (post.thumbnail_img ? post.thumbnail_img : 'sources/images/default_thumbnail.png') + '" alt="' + post.title + ' 썸네일">';
                  postsHtml += '    <p>' + post.title + '</p>';
                  postsHtml += '  </a>';
                  postsHtml += '</div>';
                });
                $('#con_wrapper').append(postsHtml);
                $('#currentPageNumber').val(nextPage); // 현재 페이지 번호 업데이트
              }
              if (!response.hasMore) {
                $('#hasMorePosts').val('false');
                $('#loadingIndicator').text('더 이상 게시물이 없습니다.');
              } else {
                $('#loadingIndicator').hide();
              }
              isLoading = false;
            },
            error: function() {
              alert('게시물을 추가로 불러오는 중 오류가 발생했습니다.');
              $('#loadingIndicator').hide();
              isLoading = false;
            }
          });
        }
      });
      
      // 모달 열기: 페이지 목록 로드
      $('#pageCreateBtn').on('click', function() {
        var acIdx = $('#profileUserAcIdx').val();
        $.get('${pageContext.request.contextPath}/page/modalList.do', { ac_idx: acIdx }, function(html) {
          $('#pageModalContent').children(':not(.modal-close)').remove();
          $('#pageModalContent').append(html);
          $('#pageModalOverlay').fadeIn();
        });
      });

      // 모달 닫기
      $('#pageModalOverlay').on('click', '#pageModalClose, .modal-overlay', function(e) {
        e.stopPropagation();
        $('#pageModalOverlay').fadeOut(function() {
          $('#pageModalContent').children(':not(.modal-close)').remove();
        });
      });

      // '＋ 새 페이지' 클릭 시 JS로 폼 전환 (페이지 생성 폼)
      $('#pageModalOverlay').on('click', '#newPageBtn', function() {
        $('#pageModalContent').children(':not(.modal-close)').remove();
        var formHtml = ''
          + '<h3>새 페이지 생성</h3>'
          + '<form id="pageCreateForm" enctype="multipart/form-data">'
          + '  <label>Subject&nbsp<input type="text" id="subject" name="subject" required/></label><br/>'
          + '  <button type="submit" class="btn_deco">Create</button>'
          + '</form>';
        $('#pageModalContent').append(formHtml);
      });
      
      $('#pageModalOverlay').on('click', '#newNoteBtn', function() {
    	  // select 박스에서 현재 선택된 페이지 idx
    	  var selectedIdx = $('#pageSelect').val();
    	  // 새 글쓰기 링크 href 업데이트
    	  $('#newNoteLink').attr('href', 'notecreate.do?pageidx=' + selectedIdx);
    	  // 실제 이동
    	  window.location.href = $('#newNoteLink').attr('href');
    	});


      // 폼 제출 시 pageCreateHandler 호출
      $('#pageModalOverlay').on('submit', '#pageCreateForm', function(e) {
        e.preventDefault();
        var formData = new FormData(this);
        let subject = document.getElementById("subject").value;
        $.ajax({
          url: '${pageContext.request.contextPath}/page/create.do?subject=' + subject,
          type: 'GET',
          data: formData,
          processData: false,
          contentType: false,
          dataType: 'json',
          success: function(res) {
            if (res.success) {
              $('#pageModalOverlay').fadeOut();
            } else {
              alert('페이지 생성 실패: ' + (res.message || ''));
            }
          },
          error: function() {
            alert('페이지 생성 중 오류가 발생했습니다.');
          }
        });
      });
    });
  </script>
</body>
</html>