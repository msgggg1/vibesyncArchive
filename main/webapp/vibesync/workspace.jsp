                <%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder"%>
<% String contextPath = request.getContextPath() + "/vibesync"; %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>workspace</title>
<link rel="icon" href="./sources/favicon.ico" />
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script defer src="./js/script.js"></script>
  <!-- 폰트 추가 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
  <!-- 차트 그리기 : chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <%-- 달력 --%>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js'></script>
<link rel="stylesheet" href="./css/workspace.css">
<link rel="stylesheet" href="./css/style.css"> 
<link rel="stylesheet" href="./css/sidebar.css">
  
    <style> /* 추가 블록 */
        .block-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
        .block-header h4 { margin: 0; }
        .block-actions button { background: none; border: none; cursor: pointer; color: #888; font-size: 14px; margin-left: 5px; }
        .block-actions button:hover { color: #000; }
        .chart-toggles { margin-bottom: 10px; }
        .chart-toggles label { margin-right: 15px; font-size: 13px; cursor: pointer; }
        .loading-spinner { border: 4px solid #f3f3f3; border-top: 4px solid #3498db; border-radius: 50%; width: 30px; height: 30px; animation: spin 1s linear infinite; margin: 20px auto; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
    </style>
  
</head>
<body>
	<div id="notion-app">
		<input type="hidden" id="mode" value="workspace">
		<div class="notion-app-inner">
			<jsp:include page="./includes/sidebar.jsp"></jsp:include>
			<!-- content -->
			<div id="content_wrapper">
				<section id="content">
					<div id="workspace_wrapper">
						<div id="todolist">
							<div id="calendar"></div>
							<div id="date-picker-popover" style="display: none;">
					            <div class="date-picker-body">
					                <select id="year-select"></select>
					                <select id="month-select"></select>
					                <button id="goto-date-btn">이동</button>
					            </div>
					        </div>
							<%-- 우측 영역: .calendar_contents --%>
							<div class="calendar_contents">
								<%-- 탭 버튼 영역 --%>
								<div class="tab-buttons">
									<button class="tab-btn active" data-tab="tab_schedule">일정</button>
									<button class="tab-btn" data-tab="tab_todo">할 일</button>
								</div>
								<div class="add-btn-container">
									<button id="add-schedule-btn" class="add-btn">+ 새 일정</button>
									<button id="add-todo-btn" class="add-btn"
										style="display: none;">+ 새 할 일</button>
								</div>
								<%-- 탭 컨텐츠 영역 --%>
								<div class="tab-content-wrapper">
									<div id="tab_schedule" class="tab-content active">
										<p>캘린더에서 날짜를 선택해주세요.</p>
									</div>
									<div id="tab_todo" class="tab-content">
										<p>로딩 중...</p>
									</div>
								</div>
							</div>
						</div>


						<div class="line"></div>

						<div id="contents_grid">
							<div class="contents_item" id="my-posts">
								<div class="widget-header">
						        <h4><i class="fa-solid fa-pen-nib"></i>&nbsp;&nbsp;내가 작성한 글</h4>
						        <button class="more-btn" data-type="my-posts">더보기</button>
						    </div>
						    <ul>
						        <%-- initialData에 담겨온 myPosts 목록을 사용 --%>
						        <c:choose>
						            <c:when test="${not empty initialData.myPosts}">
						                <c:forEach var="post" items="${initialData.myPosts}">
						                    <li>
						                        <a href="postView.do?nidx=${post.note_idx}" title="${post.title}">
						                            <span>${post.title}</span>
						                            <span class="block-meta">
						                                <i class="fa-regular fa-eye"></i> ${post.view_count}&nbsp;&nbsp;
						                                <i class="fa-regular fa-thumbs-up"></i>${post.like_count}
						                            </span>
						                        </a>
						                    </li>
						                </c:forEach>
						            </c:when>
						            <c:otherwise>
						                <li class="no-items">작성한 글이 없습니다.</li>
						            </c:otherwise>
						        </c:choose>
						    </ul>
							</div>
							<div class="contents_item" id="liked-posts">
								<div class="widget-header">
							        <h4><i class="fa-solid fa-heart"></i>&nbsp;&nbsp;좋아요한 글</h4>
							        <button class="more-btn" data-type="liked-posts">더보기</button>
							    </div>
							    <ul>
							        <%-- initialData에 담겨온 likedPosts 목록을 사용 --%>
							        <c:choose>
							            <c:when test="${not empty initialData.likedPosts}">
							                <c:forEach var="post" items="${initialData.likedPosts}">
							                    <li>
							                        <a href="postView.do?nidx=${post.note_idx}" title="${post.title}">
							                            <span>${post.title}</span>
							                            <span class="block-meta">by ${post.author_name}</span>
							                        </a>
							                    </li>
							                </c:forEach>
							            </c:when>
							            <c:otherwise>
							                <li class="no-items">좋아요한 글이 없습니다.</li>
							            </c:otherwise>
							        </c:choose>
							    </ul>
							</div>

							<!-- 안읽은 메시지 목록 -->
                            <div id="unread_messages" class="contents_item" style="background-color: var(--sidebar-color); border-radius: 20px; padding: 20px; box-shadow: 0 4px 20px rgba(0,0,0,0.2);">
                            <h3 style="font-size: 18px; margin-bottom: 16px; color: var(--font-color); border-bottom: 1px solid var(--border-color); padding-bottom: 8px;"><i class="fa-solid fa-bell"></i> 안읽은 메시지</h3>
                            <div class="message_card_list">
                                <c:choose>
                                <c:when test="${not empty initialData.unreadMessages}">
                                    <c:forEach var="msg" items="${initialData.unreadMessages}">
                                    <div class="message_card message_item" data-sender-idx="${msg.ac_sender}" data-nickname="${msg.latestMessage.sender_nickname}">
                                        <%-- <div class="msg_profile">
                                        <img src="${pageContext.request.contextPath}/vibesync/sources/profile/${msg.latestMessage.sender_img}" alt="profile">
                                        </div> --%>
                                        <div class="msg_text_area">
                                        <div class="msg_sender_row">
                                        <div class="msg_sender">${msg.latestMessage.sender_nickname}</div>
                                        <span class="unread-badge">${msg.numOfUnreadMessages}</span>
                                        </div>
                                        <div class="msg_preview">${msg.latestMessage.text}</div>
                                        <div class="msg_time">${msg.latestMessage.relativeTime}</div>
                                        </div>
                                    </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="no_message">새로운 메시지가 없습니다.</div>
                                </c:otherwise>
                                </c:choose>
                            </div>
                            </div>

							<%-- 동적으로 추가된 블록들을 렌더링하는 부분 --%>
							<c:forEach var="block" items="${workspaceData.blocks}">
								<div class="contents_item generated_block" id="block-${block.block_id}">
									<div class="block-header">
										<h4>
											<c:choose>
												<c:when test="${block.block_type == 'CategoryPosts'}"><i class="fa-solid fa-layer-group"></i>&nbsp;${block.categoryName} ${block.sortType == 'popular' ? '인기' : '최신'}글</c:when>
												<c:when test="${block.block_type == 'WatchParties'}"><i class="fa-solid fa-tv"></i>&nbsp;진행중인 워치파티</c:when>
												<c:when test="${block.block_type == 'UserStats'}"><i class="fa-solid fa-chart-simple"></i>&nbsp;${block.title}</c:when>
											</c:choose>
										</h4>
										<button class="refresh-block-btn" data-block-id="${block.block_id}" title="새로고침">
											<i class="fa-solid fa-arrows-rotate"></i>
										</button>
									</div>
									<div class="block-content">
										<%-- 각 블록 타입에 맞는 JSP 프래그먼트를 include --%>
										<c:set var="block" value="${block}" scope="request" />
										<jsp:include page="/WEB-INF/views/workspace/fragments/_${block.block_type}Content.jsp" />
									</div>
								</div>
						</c:forEach>

                        <!-- 추가 블록 -->
			            <div id="content_plus" class="contents_item">+</div>

						</div>
					</div>
				</section>
			</div>
		</div>
	</div>

<%-- ======================================================== --%>
<%--                통합 추가/수정 모달 창                     --%>
<%-- ======================================================== --%>
<div class="modal-overlay" id="unified-modal" style="display: none;">
    <div class="modal-content">
        <h2 id="modal-title"></h2> <%-- 제목은 JS가 채워줍니다 --%>
        
        <form id="schedule-form" style="display: none;">
            <input type="hidden" id="schedule-id" name="schedule_idx">
            <div class="form-group">
                <label for="schedule-title">제목</label>
                <input type="text" id="schedule-title" name="title" required>
            </div>
            <div class="form-group">
                <label for="schedule-description">설명</label>
                <textarea id="schedule-description" name="description" rows="3"></textarea>
            </div>
            <div class="form-group-row">
                <div class="form-group">
                    <label for="schedule-start">시작 시간</label>
                    <input type="datetime-local" id="schedule-start" name="start_time" required>
                </div>
                <div class="form-group">
                    <label for="schedule-end">종료 시간</label>
                    <input type="datetime-local" id="schedule-end" name="end_time" required>
                </div>
            </div>
            <div class="form-group">
                <label for="schedule-color">색상</label>
                <input type="color" id="schedule-color" name="color" value="#3788d8">
            </div>
            <div class="modal-buttons">
                <button type="button" class="modal-close-btn">취소</button>
                <button type="submit" class="modal-save-btn">저장</button>
            </div>
        </form>

        <form id="todo-form" style="display: none;">
            <input type="hidden" id="todo-id" name="todo_idx">
            <div class="form-group">
                <label for="todo-text">내용</label>
                <textarea id="todo-text" name="text" rows="4" required></textarea>
            </div>
            <div class="form-group">
                <label for="todo-group">그룹</label>
                <input type="text" id="todo-group" name="todo_group">
            </div>
            <div class="form-group">
        		<label for="todo-color">색상</label>
        		<input type="color" id="todo-color" name="color" value="#3788d8">
    		</div>
            
            <div class="modal-buttons">
                <button type="button" class="modal-close-btn">취소</button>
                <button type="submit" class="modal-save-btn">저장</button>
            </div>
        </form>
    </div>
</div>
<%-- 게시글 전체 목록 표시용 모달 창 --%>
<div class="modal-overlay" id="list-modal" style="display: none;">
    <div class="modal-content">
        <h2 id="list-modal-title"></h2>
        <div class="list-modal-content"></div> 
        <div class="modal-buttons">
            <button type="button" class="modal-close-btn">닫기</button>
        </div>
    </div>
</div>

<!-- 모달 -->
	<!-- 메시지 모달 -->
	<div id="chatModal" class="modal">
	  <div class="modal-content" style="min-width:350px; max-width:430px;">
	    <span class="close-modal" onclick="closeChatModal()"> &times; </span>
	    <h4 id="chatTitle" style="text-align:center;">채팅</h4>
	    <div id="chatHistory"></div>
		<div class="chat-input-row">
		  <input type="text" id="chatInput" placeholder="메시지를 입력하세요..." autocomplete="off" />
		  <button type="button" id="sendMessageBtn" title="전송">
		    <svg width="22" height="22" viewBox="0 0 22 22" fill="none">
		      <path d="M3 19L20 11L3 3V10L15 11L3 12V19Z" fill="#fff"/>
		    </svg>
		  </button>
		</div>
	  </div>
	</div>
	
	<!-- 블록 추가 모달 -->
	<div id="addBlockModal" class="modal">
		<div class="modal-content" style="text-align: center;">
			<h4>추가할 블록 선택</h4>
			<hr><br>
			<select id="blockTypeSelector">
				<option value="CategoryPosts">카테고리별 글</option>
				<option value="WatchParties">구독 워치파티</option>
				<option value="UserStats">내 활동 통계</option>
			</select>
	
			<div id="category" style="display: none;">
				<select id="categorySelector" name="category">
					<c:forEach items="${ categoryVOList }" var="categoryVO">
						<option value="${ categoryVO.category_idx }">${ categoryVO.c_name }</option>
					</c:forEach>
				</select>
				<br>
				<select id="sortTypeSelector">
					<option value="popular">인기순</option>
					<option value="latest">최신순</option>
				</select>
			</div>
			<button id="confirmAddBlock" style="display: block;">추가</button>
		</div>
	</div>
	  <c:forEach var="block" items="${workspaceData.blocks}">
    <c:if test="\${block.block_type == 'UserStats'}">
          (function() {
              const block_id = \${block.block_id};
              const chartData = JSON.parse('<c:out value="\${block.chartDataJson}" escapeXml="false"/>');
              createOrUpdateChart(block_id, chartData);
          })();
    </c:if>
    </c:forEach>
	<script>
        const contextPath = "${pageContext.request.contextPath}";
    </script>
    <script defer src="./js/workspace.js"></script>
    <script>
    $(document).ready(function() {
	    <c:forEach var="block" items="${workspaceData.blocks}">
	    	<c:if test="\${block.block_type == 'UserStats'}">
	          (function() {
	              const block_id = \${block.block_id};
	              const chartData = JSON.parse('<c:out value="\${block.chartDataJson}" escapeXml="false"/>');
	              createOrUpdateChart(block_id, chartData);
	          })();
	    	</c:if>
	    </c:forEach>
    });
    </script>
    
    <script>
    $(document).ready(function() {
        console.log("JSP 파일의 스크립트가 실행되었습니다.");

        <c:if test="${empty workspaceData.blocks}">
            console.warn("서버로부터 받은 workspaceData.blocks가 비어있습니다.");
        </c:if>

        <c:forEach var="block" items="${workspaceData.blocks}" varStatus="status">
            console.log("블록 루프 실행 [${status.index}]: block.block_type = '${block.block_type}'");

            <c:if test="${block.block_type == 'UserStats'}">
                console.log("UserStats 블록을 찾았습니다. block_id = ${block.block_id}");
                const chartDataString = '<c:out value="${block.chartDataJson}" />';
                console.log("서버에서 받은 차트 데이터:", chartDataString);

                try {
                    const block_id = ${block.block_id};
                    const chartData = JSON.parse(chartDataString);
                    // JS 파일에 정의된 함수 호출
                    createOrUpdateChart(block_id, chartData);
                    console.log("createOrUpdateChart(${block.block_id}) 함수 호출 성공!");
                } catch (e) {
                    console.error("차트 데이터 파싱 또는 차트 생성 중 오류 발생:", e);
                }
            </c:if>
        </c:forEach>
    });
</script>
</body>
</html>