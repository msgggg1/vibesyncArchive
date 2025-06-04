<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>user</title>

  <link rel="stylesheet" href="./css/style.css">
  <script defer src="./js/script.js"></script>

</head>
<body>
  <div id="notion-app">
    <input type="hidden" id="mode" value="user">
    <input type="hidden" id="profileUserAcIdx" value="${userPageData.userProfile.ac_idx}"> <%-- 무한스크롤용 --%>
    <input type="hidden" id="currentPageNumber" value="${userPageData.nextPageNumber -1}"> <%-- 현재 로드된 페이지 번호 --%>
    <input type="hidden" id="hasMorePosts" value="${userPageData.hasMorePosts ? 'true' : 'false'}">
    
    <div class="notion-app-inner">
      <button id="toggle-btn"><</button>
      <!-- sidebar -->
      <nav class="notion-sidebar-container" id="sidebar">
        <div class="notion-sidebar">
          <div class="menu_content">

            <a class="nickname icon_wrap" href="./user.html">
              <span>Duck Hammer</span>
            </a>

            <div class="search icon_wrap">
              <img src="./sources/icons/search.svg" alt="search icon" class="sidebar_icon">
              <input type="text" class="search-input" placeholder="Search…">
            </div>

            <a href="./main.html" class="home icon_wrap">
              <img src="./sources/icons/home.svg" alt="" class="sidebar_icon">
              <span>HOME</span>
            </a>

            <a href="./workspace.html" class="workspace icon_wrap">
              <img src="./sources/icons/work.svg" alt="" class="sidebar_icon">
              <span>WORKSPACE</span>
            </a>

            <div id="follow">
              <div class="follow_list">
                <div class="follow_tag icon_wrap">
                  <img src="./sources/icons/follow.svg" alt="follow icon" class="sidebar_icon">
                  <!-- label 클릭 시 체크박스 토글 -->
                  <label for="follow_toggle">FOLLOW</label>
                </div>
                <!-- 체크박스를 follow_items 형제 요소로 이동 -->
                <input type="checkbox" id="follow_toggle">
                <ul class="follow_items">
                  <li><a href="postView.html">PostView</a></li>
                  <li><a href="list.html">List</a></li>
                </ul>
              </div>
            </div>

          </div>

          <div id="logout">
            <button>Logout</button>
          </div>

        </div>
      </nav>
      <!-- content -->
      <div id="content_wrapper">
        <section id="content">
          <div id="user_wrapper">
            <div id="userInfo">
    
              <div class="user_profile_img">
              <c:choose>
                                    <c:when test="${not empty userPageData.userProfile.img}">
                                        <img src="${pageContext.request.contextPath}/${userPageData.userProfile.img}" alt="${userPageData.userProfile.nickname} 프로필">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/sources/icons/default_profile.png" alt="기본 프로필"> <%-- 기본 프로필 이미지 경로 --%>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="userInfo_detail">
                                <div class="name_function">
                                    <p>${userPageData.userProfile.nickname}</p>
                                    <%-- 팔로우 버튼: 현재 로그인한 사용자가 프로필 사용자가 아닌 경우에만 표시 --%>
                                    <c:if test="${sessionScope.loggedInUserAcIdx != null && sessionScope.loggedInUserAcIdx != userPageData.userProfile.ac_idx}">
                                        <button type="button" id="profileFollowBtn" class="btn_follow_1"
                                                data-author-id="${userPageData.userProfile.ac_idx}"
                                                data-following="${userPageData.userProfile.followedByCurrentUser ? 'true' : 'false'}">
                                            ${userPageData.userProfile.followedByCurrentUser ? 'UNFOLLOW' : 'FOLLOW'}
                                        </button>
                                    </c:if>
                                    <%-- Watch Party 버튼 (기능 구현 시 활성화) --%>
                                    <%-- <button class="btn_follow_2">Watch Party</button> --%>
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
                                <div class="con_item">
                                    <a href="${pageContext.request.contextPath}/noteView.do?noteIdx=${post.note_idx}">
                                        <c:choose>
                                            <c:when test="${not empty post.thumbnail_img}">
                                                <img src="${pageContext.request.contextPath}/${post.thumbnail_img}" alt="${post.title} 썸네일">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/sources/images/default_thumbnail.png" alt="기본 썸네일"> <%-- 기본 썸네일 이미지 경로 --%>
                                            </c:otherwise>
                                        </c:choose>
                                        <p>${post.title}</p>
                                    </a>
                                </div>
                            </c:forEach>
                        </div>
                        <div id="loadingIndicator" style="display:none; text-align:center; padding:20px;">로딩 중...</div>
                    </div>
                </section>
            </div>
        </div>
    </div>

<script>
$(document).ready(function() {
    // 사이드바 토글, 로그아웃 등 기존 스크립트 ...
    $("#logout").on("click", function(){
        location.href= "${pageContext.request.contextPath}/logout.jsp"; // 예시
    });

    // 프로필 페이지의 팔로우 버튼 처리
    $('#profileFollowBtn').on('click', function() {
        var $button = $(this);
        var authorId = $button.data('author-id');
        var isLoggedIn = ${sessionScope.loggedInUserAcIdx != null}; // 로그인 상태 확인

        if (!isLoggedIn) {
            alert("로그인이 필요합니다.");
            // location.href = "${pageContext.request.contextPath}/login.jsp"; // 로그인 페이지로 이동 (선택)
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
                        // 팔로워 수 실시간 업데이트 (선택 사항 - 복잡도 증가)
                        // var currentFollowers = parseInt($('.user_count p:contains("팔로워") span').text());
                        // $('.user_count p:contains("팔로워") span').text(currentFollowers + 1);
                    } else {
                        $button.data('following', false).text('FOLLOW');
                        // var currentFollowers = parseInt($('.user_count p:contains("팔로워") span').text());
                        // $('.user_count p:contains("팔로워") span').text(currentFollowers - 1);
                    }
                    
                 // 팔로워 수 업데이트 (새로 추가된 로직)
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
        if (!hasMore || isLoading) {
            return;
        }

        // (window의 높이 + 스크롤된 양) >= (문서 전체의 높이 - 특정 버퍼값)
        if ($(window).scrollTop() + $(window).height() >= $(document).height() - 200) {
            isLoading = true;
            $('#loadingIndicator').show();
            var nextPage = parseInt($('#currentPageNumber').val()) + 1;
            var profileUserId = $('#profileUserAcIdx').val();

            console.log("Loading more posts for user: " + profileUserId + ", page: " + nextPage);

            $.ajax({
                url: '${pageContext.request.contextPath}/loadMorePosts.do', // 추가 게시물 로드 핸들러
                type: 'GET', // 또는 POST
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

});
</script>
</body>
</html>