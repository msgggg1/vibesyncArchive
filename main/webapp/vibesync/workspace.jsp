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
							<div class="contents_item" id="my-posts"></div>
							<div class="contents_item" id="liked-posts"></div>

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
	
	<script>
        const contextPath = "${pageContext.request.contextPath}";
    </script>

    <script defer src="./js/workspace.js"></script>
</body>
</html>