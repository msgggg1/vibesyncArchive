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
    
    <style> /* 추가 블록 편집 모드 */
		.workspace-controls {
		    display: flex;
		    justify-content: space-between;
		    align-items: center;
		    padding: 10px 20px;
		    margin-bottom: 10px;
		}
		
		.workspace-controls h3 {
		    margin: 0;
		    font-size: 1.5em;
		    color: var(--font-color);
		}
		
		.control-btn {
		    background-color: var(--sidebar-color);
		    color: var(--font-color);
		    border: 1px solid var(--border-color);
		    padding: 8px 15px;
		    border-radius: 5px;
		    cursor: pointer;
		    margin-left: 10px;
		    transition: background-color 0.2s, color 0.2s;
		}
		
		.control-btn:hover {
		    background-color: var(--point-color);
		    color: white;
		}
		
		/* 편집 모드일 때 생성된 블록에 적용될 스타일 */
		#contents_grid.edit-mode .generated_block {
		    position: relative; /* 화살표 버튼의 기준점 */
		    border: 2px dashed var(--point-color);
		    box-shadow: 0 0 10px rgba(var(--point-color-rgb), 0.5);
		    gap: 0px, 20px;
    		transition: padding 0.2s ease-in-out;
		}
		
		#contents_grid.edit-mode .generated_block:hover {
		    z-index: 15;
		}
		
		/* 블록 이동 화살표 버튼 */
		.move-block-btn {
		    position: absolute;
		    top: 50%;
		    transform: translateY(-50%);
		    width: 30px;
		    height: 30px;
		    background-color: rgba(0, 0, 0, 0.6);
		    color: white;
		    border: none;
		    border-radius: 50%;
		    font-size: 16px;
		    cursor: pointer;
		    display: flex;
		    align-items: center;
		    justify-content: center;
		    z-index: 10;
		    opacity: 0.7;
		    transition: opacity 0.2s;
		}
		
		.move-block-btn:hover {
		    opacity: 1;
		}
		
		.move-left-btn {
		    left: 5px;
		}
		
		.move-right-btn {
		    right: 5px;
		}
    </style>
    
    <style> /* 통계 기간 변경 */
		.stats-controls {
		    display: flex;
		    justify-content: space-between;
		    align-items: center;
		    margin-bottom: 15px;
		    flex-wrap: wrap; /* 창이 좁을 때 줄바꿈 */
		}
		
		.period-selector button {
		    background: #eee;
		    border: 1px solid #ddd;
		    border-radius: 4px;
		    padding: 4px 8px;
		    font-size: 12px;
		    cursor: pointer;
		    margin-left: 5px;
		}
		
		.period-selector button.active {
		    background-color: var(--point-color);
		    color: white;
		    border-color: var(--point-color);
		    font-weight: bold;
		}
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
										 <%-- 날짜 제목이 표시될 영역 --%>
									    <h4 class="schedule-date-title"></h4> 
									    <%-- 실제 일정 목록이 들어갈 컨테이너 --%>
									    <div id="daily-schedule-list-container">
									        <p>캘린더에서 날짜를 선택해주세요.</p>
									    </div>
									</div>
									<div id="tab_todo" class="tab-content">
										<p>로딩 중...</p>
									</div>
								</div>
							</div>
						</div>


						<div class="line"></div>
						
						<!-- 블록 위치 변경을 위한 수정, 저장, 취소 버튼 -->
						<div class="workspace-controls">
						    <h3><i class="fa-solid fa-shapes"></i>&nbsp;&nbsp;My Workspace</h3>
						    <div class="workspace-buttons">
						        <button id="edit-order-btn" class="control-btn"><i class="fa-solid fa-pen-to-square"></i> 편집</button>
						        <button id="save-order-btn" class="control-btn" style="display: none;"><i class="fa-solid fa-save"></i> 저장</button>
						        <button id="cancel-order-btn" class="control-btn" style="display: none;"><i class="fa-solid fa-times"></i> 취소</button>
						    </div>
						</div>

						<div id="contents_grid">
							<!-- 내가 작성한 전체 글 목록 (인기글 순) -->
							<div class="contents_item" id="my-posts">
								<div class="widget-header">
						        <h4><i class="fa-solid fa-pen-nib"></i>&nbsp;&nbsp;내가 작성한 글</h4>
						        <button class="more-btn" data-type="my-posts">더보기</button>
						    </div>
						    <ul>
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
							<!-- 좋아요한 포스트 목록 -->
							<div class="contents_item" id="liked-posts">
								<div class="widget-header">
							        <h4><i class="fa-solid fa-heart"></i>&nbsp;&nbsp;좋아요한 글</h4>
							        <button class="more-btn" data-type="liked-posts">더보기</button>
							    </div>
							    <ul>
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

							<!-- 동적으로 추가된 블록들 -->
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
										<div class="block-actions">
									        <button class="refresh-block-btn" data-block-id="${block.block_id}" title="새로고침">
									            <i class="fa-solid fa-arrows-rotate"></i>
									        </button>
									        <button class="delete-block-btn" data-block-id="${block.block_id}" title="삭제">
									            <i class="fa-solid fa-trash-can"></i>
									        </button>
									    </div>
									</div>
									<div class="block-content">
										<%-- 각 블록 타입에 맞는 JSP 프래그먼트를 include --%>
										<c:set var="block" value="${block}" scope="request" />
										<jsp:include page="/WEB-INF/views/workspace/fragments/_${block.block_type}Content.jsp" />
									</div>
								</div>
						</c:forEach>

                        <!-- 블록 추가 버튼(블록) -->
			            <div id="content_plus" class="contents_item">+</div>

						</div>
					</div>
				</section>
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
	<!-- 모달 끝 -->

<script> /* 모달, 블록 */
	
    // 전역 차트 인스턴스 저장소
    const userCharts = {};
    
    // 추가 블록 편집 모드 시 사용할 전역 변수
    let isEditMode = false; // 편집 모드 상태 관리
    let initialBlockOrder = null; // 편집 시작 시의 블록 순서 저장
	
    /* 모달, 블록 관련 js, jquery */
    $(document).ready(function() {
    	// 초기 페이지 로드
        <c:forEach var="block" items="${workspaceData.blocks}">
            <c:if test="${block.block_type == 'UserStats'}">
                // 서버에서 받은 JSON 문자열을 사용해 차트 생성 함수를 호출하는 코드를 반복문으로 생성
                createOrUpdateChart(${block.block_id}, JSON.parse('<c:out value="${block.chartDataJson}" escapeXml="false"/>'));
            </c:if>
        </c:forEach>
        
        // + 버튼 표시여부 결정
        updateAddBlockButtonVisibility();
		
        // 이벤트 관련
        const grid = $('#contents_grid');

     	// 이벤트 위임을 사용하여 새로고침 및 삭제 버튼 이벤트 한 번에 처리
        grid.on('click', '.block-actions button', function() {
            const button = $(this);
            const blockId = button.data('block-id');

            if (button.hasClass('refresh-block-btn')) {
                const blockContentDiv = $('#block-' + blockId + ' .block-content');
                blockContentDiv.html('<div class="loading-spinner"></div>');
                $.ajax({
                    url: '${pageContext.request.contextPath}/block.do',
                    type: 'GET',
                    data: { block_id: blockId },
                    dataType: 'json', // 서버로부터 JSON 응답을 기대한다고 명시
                    success: function(res) {
                        // 1. 새로운 HTML로 내용을 교체
                        blockContentDiv.html(res.html);

                        // 2. 만약 블록 타입이 'UserStats'이고 차트 데이터가 있다면 차트를 다시 그림
                        if (res.block_type === 'UserStats' && res.chart_data) {
                        	$('#block-' + blockId).find('.block-header h4').html('<i class="fa-solid fa-chart-simple"></i>&nbsp;' + res.title);
                        	createOrUpdateChart(blockId, res.chart_data);
                        }
                    },
                    error: function() {
                        blockContentDiv.html('<p style="color:red;">새로고침 실패</p>');
                    }
                });
            } else if (button.hasClass('delete-block-btn')) {
                deleteBlock(blockId);
            }
        });

        // 차트 데이터셋 토글
        grid.on('change', '.dataset-toggle-cb', function() {
            const checkbox = $(this);
            const chartId = checkbox.closest('.chart-toggles').data('chart-id');
            const datasetIndex = checkbox.data('dataset-index');
            const chart = userCharts[chartId];
            if (chart) {
                chart.setDatasetVisibility(datasetIndex, checkbox.prop('checked'));
                chart.update();
            }
        });
        
        // 통계 블록의 기간 변경 버튼 이벤트 핸들러
        grid.on('click', '.period-btn', function() {
            const $button = $(this);
            const blockId = $button.data('block-id');
            const period = $button.data('period');

            // 이미 활성화된 버튼을 누르면 아무것도 하지 않음
            if ($button.hasClass('active')) {
                return;
            }
            
            // 버튼 활성 상태 UI 업데이트
            $button.siblings().removeClass('active');
            $button.addClass('active');

            // 로딩 스피너 표시
            const blockContentDiv = $('#block-' + blockId + ' .block-content');
            blockContentDiv.html('<div class="loading-spinner"></div>');

            // 해당 블록을 새로운 기간으로 새로고침
            $.ajax({
                url: '${pageContext.request.contextPath}/block.do',
                type: 'GET',
                data: { 
                    block_id: blockId,
                    period: period
                },
                dataType: 'json',
                success: function(res) {
                	// 새 HTML로 교체
                    blockContentDiv.html(res.html);
                    // 차트 다시 그리기
                    if (res.block_type === 'UserStats' && res.chart_data) {
                    	const $headerTitle = $('#block-' + blockId).find('.block-header h4');
                    	$headerTitle.html('<i class="fa-solid fa-chart-simple"></i>&nbsp;' + res.title);
                        createOrUpdateChart(blockId, res.chart_data);
                    }
                },
                error: function() {
                    blockContentDiv.html('<p style="color:red;">새로고침 실패</p>');
                }
            });
        });

        // --- 블록 추가 모달 관련 이벤트 ---
        $('#content_plus').on('click', function() {
  		  $('html, body').scrollTop(0);
		  $('#addBlockModal').css({
			  position: 'fixed',
			  top: '50%',
			  left: '50%',
			  transform: 'translate(-50%, -50%)',
			  backgroundColor: 'rgba(0,0,0,0.8)',
			  display: 'flex',
			  zIndex: 99999
		  });
        });
        
        $('#blockTypeSelector').on('change', function() {
            if ($(this).val() === 'CategoryPosts') { $('#category').show(); } 
            else { $('#category').hide(); }
        }).change();

        $('#confirmAddBlock').on('click', function() {
            const blockType = $('#blockTypeSelector').val();
            let dataToSend = {
                block_type: blockType,
                _method: 'ADD'
            };
            if (blockType === 'CategoryPosts') {
                dataToSend.category_idx = $('#categorySelector').val();
                dataToSend.category_name = $('#categorySelector option:selected').text();
                dataToSend.sort_type = $('#sortTypeSelector').val();
            }
            addBlockToServer(dataToSend);
            $('#addBlockModal').hide();
        });
        
	    // 모달 외부 클릭/ESC로 닫기
	    $(document).on('keydown', function(e) {
	        if (e.key === 'Escape') {
	          $('#addBlockModal').hide();
	        }
	    });

	    $('#addBlockModal').on('click', function(e) {
	        if (e.target.id === 'addBlockModal') {
	          $(this).hide();
	        }
	    });
       
	 	// --- 워크스페이스 순서 편집 관련 이벤트 ---
	 	// 편집 모드 진입
	    $('#edit-order-btn').on('click', function() {
	        enterEditMode();
	    });

	 	// 편집 취소
	    $('#cancel-order-btn').on('click', function() {
	        if (initialBlockOrder) {
	        	// 이동시킨 블록들 전부 제거
	            $('.generated_block').remove();

	            // 초기 상태의 블록들 다시 삽입
	            initialBlockOrder.each(function() {
	                $('#content_plus').before(this);
	                
	                if ($(this).find('canvas[id^="userStatsChart_"]').length > 0) {
	                	$(this).find('.refresh-block-btn').trigger('click');
	                }
	            });
	        }
	        exitEditMode();
	    });

	 	// 편집된 순서 저장
	    $('#save-order-btn').on('click', function() {
	        saveBlockOrder();
	    });

	    // 동적으로 생성된 화살표 버튼 클릭 처리 : 이벤트 위임 사용
	    $('#contents_grid').on('click', '.move-block-btn', function() {
	        const $thisBlock = $(this).closest('.generated_block');
	        const movableBlocks = $('.generated_block').toArray();
	        const currentIndex = movableBlocks.indexOf($thisBlock[0]);

	        let targetIndex = -1;

	        if ($(this).hasClass('move-left-btn')) {
	            targetIndex = currentIndex - 1;
	        } else if ($(this).hasClass('move-right-btn')) {
	            targetIndex = currentIndex + 1;
	        }

	        if (targetIndex >= 0 && targetIndex < movableBlocks.length) {
	            const $targetBlock = $(movableBlocks[targetIndex]);
	            if ($(this).hasClass('move-left-btn')) {
	                $targetBlock.before($thisBlock);
	            } else {
	                $targetBlock.after($thisBlock);
	            }
	            updateArrowVisibility(); // 화살표 상태 즉시 업데이트
	        }
	    });
    });
    
	/* 모달, 블록 관련 함수 */

	// '+' 버튼 표시 여부를 업데이트하는 함수
	function updateAddBlockButtonVisibility() {
	    if ($('.generated_block').length >= 5) {
	        $("#content_plus").hide();
	    } else {
	        $("#content_plus").show();
	    }
	}
	
    // 차트 생성 함수
    function createOrUpdateChart(blockId, chartData) {
        const chartId = 'userStatsChart_' + blockId;
        if (userCharts[chartId]) {
            userCharts[chartId].destroy();
        }
        const ctx = document.getElementById(chartId)?.getContext('2d');
        if (!ctx) return;

        const chart = new Chart(ctx, {
            type: 'line',
            data: chartData,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: { y: { beginAtZero: true } },
                plugins: { legend: { position: 'top' }, tooltip: { mode: 'index', intersect: false } },
                hover: { mode: 'index', intersect: false }
            }
        });
        userCharts[chartId] = chart;
    }

    // 블록 추가 함수
	function addBlockToServer(payload) {
	    $.ajax({
	        url: '${pageContext.request.contextPath}/block.do',
	        type: 'POST',
	        data: payload,
	        dataType: 'json', // 응답 타입을 'html'에서 'json'으로 변경
	        success: function(res) { // 응답 변수 이름을 res (response)로 변경
	            // 1. 새로운 HTML을 화면에 추가
	            $('#content_plus').before(res.html);
	            
	            // 2. 만약 추가된 블록이 차트 블록이라면, 차트를 그려줌
	            if (res.block_type === 'UserStats' && res.chart_data) {
	                createOrUpdateChart(res.block_id, res.chart_data);
	            }
	            
	            // 3. '+' 버튼 표시 여부 업데이트
	            updateAddBlockButtonVisibility();
	        },
	        error: function() { alert('블록을 추가하는 데 실패했습니다.'); }
	    });
	}

	// 블록 삭제 함수
	function deleteBlock(blockId) {
	    if (!confirm("블록을 정말 삭제하시겠습니까?")) return;
	    $.ajax({
	        url: '${pageContext.request.contextPath}/block.do',
	        type: 'POST',
	        data: {
	            block_id: blockId,
	            _method: 'DELETE'
	        },
	        dataType: 'json',
	        success: function(res) {
	            if (res.success) {
	                $('#block-' + blockId).fadeOut(function() {
	                    $(this).remove();
	                    
	                    updateAddBlockButtonVisibility();
	                });
	            } else { alert(res.message); }
	        },
	        error: function() { alert('블록 삭제 중 오류가 발생했습니다.'); }
	    });
	}
	
	// --- 워크스페이스 순서 편집 관련 함수 ---

	// 편집 모드로 진입하는 함수
	function enterEditMode() {
	    isEditMode = true;
	    initialBlockOrder = $('.generated_block').clone(true, true); // 초기 상태 저장

	    $('#contents_grid').addClass('edit-mode');
	    $('#edit-order-btn').hide();
	    $('#save-order-btn, #cancel-order-btn').show();

	    // 각 블록에 화살표 버튼 추가
	    $('.generated_block').each(function() {
	        $(this).append(`
	            <button class="move-block-btn move-left-btn" title="왼쪽으로 이동"><i class="fa-solid fa-chevron-left"></i></button>
	            <button class="move-block-btn move-right-btn" title="오른쪽으로 이동"><i class="fa-solid fa-chevron-right"></i></button>
	        `);
	    });
	    updateArrowVisibility();
	}

	// 편집 모드를 종료하는 함수
	function exitEditMode() {
	    isEditMode = false;
	    initialBlockOrder = null; // 초기 상태 리셋

	    $('#contents_grid').removeClass('edit-mode');
	    $('#edit-order-btn').show();
	    $('#save-order-btn, #cancel-order-btn').hide();

	    // 모든 화살표 버튼 제거
	    $('.move-block-btn').remove();
	}

	// 화살표 버튼의 표시 여부를 업데이트하는 함수
	function updateArrowVisibility() {
	    const movableBlocks = $('.generated_block');
	    const totalMovable = movableBlocks.length;

	    movableBlocks.each(function(index) {
	        const $leftArrow = $(this).find('.move-left-btn');
	        const $rightArrow = $(this).find('.move-right-btn');

	        // 첫 번째 블록이면 왼쪽 화살표 숨김
	        if (index === 0) {
	            $leftArrow.hide();
	        } else {
	            $leftArrow.show();
	        }

	        // 마지막 블록이면 오른쪽 화살표 숨김
	        if (index === totalMovable - 1) {
	            $rightArrow.hide();
	        } else {
	            $rightArrow.show();
	        }
	    });
	}

	// 변경된 블록 순서를 서버에 저장하는 함수
	function saveBlockOrder() {
	    const orderData = [];
	    $('.generated_block').each(function(index) {
	        const blockId = $(this).attr('id').split('-')[1];
	        // block_order는 1부터 시작하도록 index + 1
	        orderData.push({ block_id: parseInt(blockId), block_order: index + 1 });
	    });

	    $.ajax({
	        url: '${pageContext.request.contextPath}/block.do',
	        type: 'POST',
	        data: {
	            _method: 'EDIT',
	            orders: JSON.stringify(orderData)
	        },
	        dataType: 'json',
	        success: function(res) {
	            if (res.success) {
	                alert('블록 순서가 저장되었습니다.');
	                exitEditMode();
	            } else {
	                alert(res.message || '순서 저장에 실패했습니다.');
	            }
	        },
	        error: function() {
	            alert('서버와 통신 중 오류가 발생했습니다.');
	        }
	    });
	}

    
</script>

<script> /* 채팅방 */
	/* 채팅방 관련 js, jquery */
	let currentChatSenderIdx = null;
	
	$(document).ready(function() {
	    $('.message_item').on('click', function () {
	      const senderIdx = $(this).data('sender-idx');
	      currentChatSenderIdx = senderIdx;
	      const nickname = $(this).data('nickname');
	      $('#chatTitle').text(nickname);
	      
	      $.ajax({
	        url: '${pageContext.request.contextPath}/message.do',
	        type: 'GET',
	        data: { senderIdx },
	        dataType: 'json',
	        success: function (chatList) {
	        	$('#chatHistory').empty();
	
	            if (!chatList || !Array.isArray(chatList) || chatList.length === 0) {
	                $('#chatHistory').html('<p style="text-align:center; color:grey;">채팅 내역이 없습니다.</p>');
	                return;
	            }
	            
	            const chatContainer = $('<div class="chat-container"></div>');
	            let lastDate = null;
	
	            chatList.forEach(msg => {
	                if (msg.date !== lastDate) {
	                    lastDate = msg.date;
	                    const dateLabel = $('<div class="chat-date-separator"></div>').text(lastDate);
	                    chatContainer.append(dateLabel);
	                }
	            	
	                const who = msg.isMine ? 'bubble-me' : 'bubble-other';
	                const formattedText = msg.text.replace(/\n/g, '<br>');
	
	                const messageHtml = `
	                    <div class="chat-bubble \${who}">
	                        <div class="bubble-text">\${formattedText}</div>
	                        <div class="bubble-time">\${msg.relativeTime}</div>
	                    </div>
	                `;
	                chatContainer.append(messageHtml);
	            });
	
	            $('#chatHistory').append(chatContainer);
	
	            $('#chatModal').css({
	                display: 'flex',
	                top: '50%',
	                left: '50%',
	                transform: 'translate(-50%, -50%)',
	                backgroundColor: 'rgba(0,0,0,0.8)'
	            });
	            
	            if(chatContainer.length) {
	                chatContainer.scrollTop(chatContainer[0].scrollHeight);
	            }
	        },
	        error: function () {
	          alert('채팅 내역 불러오기 실패');
	        }
	      });
	    });
	    
	    // 채팅방에서 메시지 전송 (버튼 클릭 또는 엔터)
	    $("#sendMessageBtn").on("click", sendChatMessage);
	
	    $("#chatInput").on("keydown", function(e) {
	      if (e.key === "Enter" && !e.shiftKey) {
	        e.preventDefault();
	        sendChatMessage();
	      }
	   });
	});

	/* 채팅방 함수 */
	// 채팅 내역 닫기
	function closeChatModal() {
		$('#chatModal').hide();
		location.reload();
	}
	
	// 채팅방에서 메시지 전송
	function sendChatMessage() {
	    const message = $("#chatInput").val().trim();
	    if (!message || !currentChatSenderIdx) return;
	
	    $.ajax({
	      url: '${pageContext.request.contextPath}/message.do',
	      type: 'POST',
	      data: JSON.stringify({
	        receiverIdx: currentChatSenderIdx,
	        text: message
	      }),
	      contentType: "application/json; charset=utf-8",
	      success: function(res) {
	        $("#chatInput").val(""); // 입력창 비우기
	
	        // 메시지 전송 성공시 채팅 내역 갱신
	        // 서버에서 새 메시지 저장 후, 최신 내역 반환
	        // 채팅내역 새로 불러오기
	        reloadChatHistory();
	      },
	      error: function() {
	        alert('메시지 전송 실패!');
	      }
	    });
	}
	
	// 채팅내역 새로 불러오기
    function reloadChatHistory() {
      if (currentChatSenderIdx) {
        $('.message_item[data-sender-idx="'+currentChatSenderIdx+'"]').click();
      }
    }

</script>

<script>
        const contextPath = "${pageContext.request.contextPath}";
</script>
<script defer src="./js/workspace.js"></script>
</body>
</html>















