<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>PostView</title>

<link rel="stylesheet" href="./css/style.css">
<script defer src="./js/script.js"></script>
</head>
<body>
	<div id="notion-app">
		<input type="hidden" id="mode" value="postview">
		<div class="notion-app-inner">
			<button id="toggle-btn"><</button>
			<!-- sidebar -->
			<nav class="notion-sidebar-container" id="sidebar">
				<div class="notion-sidebar">
					<div class="menu_content">

						<a class="nickname icon_wrap" href="./user.html"> <span>Duck
								Hammer</span>
						</a>

						<div class="search icon_wrap">
							<img src="./sources/icons/search.svg" alt="search icon"
								class="sidebar_icon"> <input type="text"
								class="search-input" placeholder="Search…">
						</div>

						<a href="./main.do" class="home icon_wrap"> <img
							src="./sources/icons/home.svg" alt="" class="sidebar_icon">
							<span>HOME</span>
						</a> <a href="./workspace.html" class="workspace icon_wrap"> <img
							src="./sources/icons/work.svg" alt="" class="sidebar_icon">
							<span>WORKSPACE</span>
						</a>

						<div id="follow">
							<div class="follow_list">
								<div class="follow_tag icon_wrap">
									<img src="./sources/icons/follow.svg" alt="follow icon"
										class="sidebar_icon">
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
					<div class="back_icon">
						<a href="#"><img src="./sources/icons/arrow_back.svg"
							alt="arrow_back"></a>
					</div>

					<div id="postview_Wrapper">
						<p>${note.title}</p>
						<div class="writer_info">

							<div class="writer">
								<c:if test="${not empty note.img}">
									<img src="${pageContext.request.contextPath}/${note.img}"
										alt="${note.nickname}">
								</c:if>
								<p>${note.nickname }</p>
								<%-- 팔로우 버튼: 현재 로그인한 사용자가 글 작성자가 아닌 경우에만 표시 --%>
							    <c:if test="${sessionScope.loggedInUserAcIdx != null && sessionScope.loggedInUserAcIdx != note.ac_idx}">
							        <button type="button" id="followBtn" class="btn_like_follow"
							                data-author-id="${note.ac_idx}" <%-- NoteDetailDTO의 작성자 ID 필드(ac_idx) 사용 --%>
							                data-following="${note.followedByCurrentUser ? 'true' : 'false'}">
							            ${note.followedByCurrentUser ? 'UNFOLLOW' : 'FOLLOW'}
							        </button>
							    </c:if>
							</div>

							<div class="post_meta_info">
								<div>
									<fmt:formatDate value="${note.create_at}"
										pattern="yyyy.MM.dd HH:mm" />
								</div>
							</div>
							<div class="post_meta_info">
								<div>조회수: ${note.view_count}</div>
							</div>

							<div class="like_share">
								<div class="like">
                                    <button type="button" id="likeBtn" class="like-button"
                                            data-note-id="${note.note_idx}"
                                            data-liked="${note.likedByCurrentUser ? 'true' : 'false'}">
                                        <img id="likeIcon" src="${pageContext.request.contextPath}/vibesync/sources/icons/${note.likedByCurrentUser ? 'heart_filled.svg' : 'heart.svg'}" alt="like">
                                        <span id="likeBtnText">${note.likedByCurrentUser ? '좋아요 취소' : ''}</span>
                                    </button>
                                    <p style="margin-left: 10px;"><span id="likeCount">${note.like_count}</span></p>
                                </div>
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
	
		<script>
  	$("#logout").on("click", function(){
  		location.href="./logout.jsp";
  	});
  </script>
  
  <script>
    $(document).ready(function() {
           // 좋아요 버튼 클릭 이벤트
        $('#likeBtn').on('click', function() {
            var $button = $(this); // 현재 클릭된 버튼
            var noteId = $button.data('note-id');
            // var currentLikedStatus = $button.data('liked'); // 현재 data-liked 값 (boolean)

            console.log("Like button clicked for note ID: " + noteId);

            $.ajax({
                url: '${pageContext.request.contextPath}/likeToggle.do', // 서버의 좋아요 처리 URL
                type: 'POST',
                data: {
                    noteId: noteId
                    // 서버에서 토글 방식으로 처리하므로 'action' 파라미터는 불필요할 수 있음
                },
                dataType: 'json', // 서버로부터 JSON 응답을 기대
                success: function(response) {
                    console.log("Server response:", response);
                    if (response.success) {
                        // 좋아요 수 업데이트
                        $('#likeCount').text(response.newLikeCount);

                        // 버튼 아이콘 및 텍스트 업데이트
                        if (response.liked) { // 현재 '좋아요' 상태가 됨
                            $button.data('liked', true); // data 속성 업데이트
                            $('#likeIcon').attr('src', '${pageContext.request.contextPath}/sources/icons/heart_filled.svg');
 
                        } else { // 현재 '좋아요 안함' 상태가 됨
                            $button.data('liked', false); // data 속성 업데이트
                            $('#likeIcon').attr('src', '${pageContext.request.contextPath}/vibesync/sources/icons/heart.svg');
          
                        }
                    } else {
                        alert('오류: ' + (response.message || '좋아요 처리에 실패했습니다.'));
                    }
                },
                error: function(xhr, status, error) {
                    console.error("AJAX Error: ", status, error);
                    console.error("Response Text: ", xhr.responseText);
                    alert('좋아요 요청 중 오류가 발생했습니다. (콘솔 확인)');
                }
            });
        });


     // 팔로우 버튼 클릭 이벤트
        $('#followBtn').on('click', function() {
            var $button = $(this);
            var authorId = $button.data('author-id'); // 팔로우/언팔로우 대상 작성자 ID
            // var currentFollowingStatus = $button.data('following'); // 현재 data-following 값

            console.log("Follow button clicked for author ID: " + authorId);

            $.ajax({
                url: '${pageContext.request.contextPath}/followToggle.do', // 팔로우 처리 핸들러 URL
                type: 'POST',
                data: {
                    authorId: authorId // 서버 핸들러에서 받을 파라미터 이름
                },
                dataType: 'json',
                success: function(response) {
                    console.log("Follow Server response:", response);
                    if (response.success) {
                        // 버튼 텍스트 및 data 속성 업데이트
                        if (response.following) { // 현재 '팔로우' 상태가 됨
                            $button.data('following', true);
                            $button.text('UNFOLLOW');
                        } else { // 현재 '언팔로우' 상태가 됨
                            $button.data('following', false);
                            $button.text('FOLLOW');
                        }
                    } else {
                        alert('오류: ' + (response.message || '팔로우 처리에 실패했습니다.'));
                    }
                },
                error: function(xhr, status, error) {
                    console.error("Follow AJAX Error: ", status, error);
                    console.error("Follow Response Text: ", xhr.responseText);
                    alert('팔로우 요청 중 오류가 발생했습니다. (콘솔 확인)');
                }
            });
        });
    });
    </script>
</body>
</html>