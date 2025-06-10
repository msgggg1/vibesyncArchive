<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>workspace</title>

<link rel="stylesheet" href="./css/style.css">
<script defer src="./js/script.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script
	src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js'></script>
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
							<div class="contents_item"></div>
							<div id="content_plus">+</div>
						</div>
					</div>
				</section>
			</div>

		</div>
	</div>

<script>
    // 캘린더 객체를 다른 스크립트나 함수에서도 접근할 수 있도록 전역 변수로 선언합니다.
    var calendar;
    // 날짜별 일정을 저장할 객체 (key: 'YYYY-MM-DD', value: 해당 날짜의 CalendarEventDTO 배열)
    var schedulesByDate = {};
    // 선택된 날짜의 셀(DOM 요소)을 저장할 변수, 하이라이트 용
    var selectedDateCell = null;

    var todosById = {}; // 할 일 데이터를 ID로 접근하기 위한 캐시

    let dateToRefreshAfterFetch = null; // 캘린더 데이터 로딩 후, 이 날짜의 일정을 다시 그립니다.
    
    let isInitialLoad = true; // 처음 캘린더 로딩 시 일정 불러오기 위한 플래그


    // --- [함수] 일별 일정 로딩 (우측 패널) ---
    function loadDailySchedules(dateString) { // dateString은 'YYYY-MM-DD'
        var schedules = schedulesByDate[dateString]; // 서버 요청 대신, 캐시된 데이터 사용

        var scheduleHtml = '<ul class="schedule-list">';
        if (schedules && schedules.length > 0) {

            // 2. 정렬된 일정으로 HTML을 만듭니다.
            $.each(schedules, function(index, schedule) {
                // Date 객체를 만들어 시간/분을 HH:MM 형식으로 추출합니다.
                var startDate = new Date(schedule.start);
                var endDate = new Date(schedule.end);

                var startHours = String(startDate.getHours()).padStart(2, '0');
                var startMinutes = String(startDate.getMinutes()).padStart(2, '0');
                var startTime = startHours + ":" + startMinutes;

                var endHours = String(endDate.getHours()).padStart(2, '0');
                var endMinutes = String(endDate.getMinutes()).padStart(2, '0');
                var endTime = endHours + ":" + endMinutes;

                var descriptionHtml = '';
                if (schedule.description && typeof schedule.description === 'string' && schedule.description.trim() !== '') {
                    descriptionHtml = '  <span class="schedule-desc">' + schedule.description + '</span>';
                }

                scheduleHtml += '<li data-id="' + schedule.id + '">';
                scheduleHtml += '  <div class="schedule-item-content">'; // 내용을 감싸는 div 추가
                scheduleHtml += '  <span class="schedule-time">' + startTime + ' - ' + endTime + '</span>';
                scheduleHtml += '  <div class="schedule-details">';
                scheduleHtml += '    <span class="schedule-title">' + schedule.title + '</span>';
                scheduleHtml += descriptionHtml;
                scheduleHtml += '  </div>';
                scheduleHtml += '  </div>';
                scheduleHtml += '  <button class="schedule-delete-btn">&times;</button>';
                scheduleHtml += '</li>';
            });
        } else {
            scheduleHtml += '<li class="no-schedule">등록된 일정이 없습니다.</li>';
        }
        scheduleHtml += '</ul>';
        $('#tab_schedule').html(scheduleHtml);
    }

    // --- [함수] 할 일 목록 로딩 ---
    function loadTodoList() {
        $.ajax({
            url: '<%= request.getContextPath() %>/todoList.do',
            type: 'GET',
            dataType: 'json',
            success: function(todos) {
                var todoListHtml = '<ul class="todo-list">'; // 클래스명 변경
                todosById = {}; // 캐시 초기화
                if (todos && todos.length > 0) {
                    $.each(todos, function(index, todo) {
                        let isChecked = todo.status === 1 ? "checked" : "";
                        let textClass = todo.status === 1 ? "completed" : "";

                        todoListHtml += '<li data-id="' + todo.todo_idx + '">'; // 각 li에 id 저장
                        todoListHtml += '  <input type="checkbox" class="todo-checkbox" ' + isChecked + '>';
                        todoListHtml += '  <span class="todo-text ' + textClass + '">' + todo.text + '</span>';
                        todoListHtml += '  <button class="todo-delete-btn">&times;</button>'; // X 모양 아이콘
                        todoListHtml += '</li>';

                        // 할 일 객체 전체를 ID를 키로 하여 캐시합니다.
                        todosById[todo.todo_idx] = todo;
                    });
                } else {
                    todoListHtml += '<li style="justify-content:center; color:#888;">등록된 할 일이 없습니다.</li>';
                }
                todoListHtml += '</ul>';
                $('#tab_todo').html(todoListHtml);
            },
            error: function(xhr, status, error) {
                console.error("[TodoList-AJAX-ERR] 할 일 목록을 불러오는 데 실패했습니다:", error, status, xhr);
                $('#tab_todo').html('<p>할 일 목록을 불러오는 데 실패했습니다.</p>');
            }
        });
    }

    // --- [함수] 오늘 날짜를 "YYYY-MM-DD" 형식으로 반환 ---
    function getTodayString() {
        var today = new Date();
        var year = today.getFullYear();
        var mm = String(today.getMonth() + 1).padStart(2, '0');
        var dd = String(today.getDate()).padStart(2, '0');
        return year + '-' + mm + '-' + dd;
    }


    // --- 페이지 로드 완료 후 실행되는 메인 로직 ---
    document.addEventListener('DOMContentLoaded', function() {

        // 1. 탭 전환 기능 설정
        $('.tab-btn').on('click', function() {
            $('.tab-btn').removeClass('active');
            $('.tab-content').removeClass('active');
            $(this).addClass('active');

            const tabId = $(this).data('tab');
            $('#' + tabId).addClass('active');

            // 탭에 맞는 '추가' 버튼 보여주기/숨기기 로직
            if (tabId === 'tab_schedule') {
                $('#add-schedule-btn').show();
                $('#add-todo-btn').hide();
            } else if (tabId === 'tab_todo') {
                $('#add-schedule-btn').hide();
                $('#add-todo-btn').show();
            }
        });

        // 2. 캘린더 생성 및 렌더링
        var calendarEl = document.getElementById('calendar');
        if (calendarEl) {
            calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek'
                },
                dayMaxEvents: 2,
                height: '100%',
                aspectRatio: 1.8,
                fixedWeekCount: false,

                events: function(fetchInfo, successCallback, failureCallback) {
                    var startIso = fetchInfo.start.toISOString();
                    var endIso = fetchInfo.end.toISOString();

                    $.ajax({
                        url: '<%= request.getContextPath() %>/schedules.do',
                        method: 'GET',
                        data: {
                            action: 'getMonthlySchedules',
                            start: startIso,
                            end: endIso
                        },
                        dataType: 'json',
                        success: function(data) {
                            // 1. 받은 데이터의 날짜 문자열을 Date 객체로 변환
                            var processedEvents = data.map(function(event) {
                                return {
                                    id: event.id, // FullCalendar 표준 ID
                                    title: event.title,
                                    color: event.color,
                                    description: event.description,
                                    start: new Date(event.start), // 문자열을 Date 객체로!
                                    end: new Date(event.end) // 문자열을 Date 객체로!
                                };
                            });

                            // 2. Date 객체로 변환된 데이터를 사용해 schedulesByDate 객체 생성
                            schedulesByDate = {}; // 초기화
                            processedEvents.forEach(function(event) {
                                var dateKey = event.start.toISOString().substring(0, 10);
                                if (!schedulesByDate[dateKey]) {
                                    schedulesByDate[dateKey] = [];
                                }
                                schedulesByDate[dateKey].push(event);
                            });

                            // 3. 날짜별로 일정 정렬
                            for (var date in schedulesByDate) {
                                schedulesByDate[date].sort((a, b) => a.start - b.start);
                            }
                            // 최초 로딩 시 오늘 날짜 일정 로드
                            if (isInitialLoad) {
                                const todayStr = getTodayString();
                                loadDailySchedules(todayStr);
                                // 오늘 날짜 칸을 찾아 하이라이트
                                /* const todayCell = document.querySelector('.fc-day-today');
                                if(todayCell) {
                                    todayCell.classList.add('fc-day-selected');
                                    selectedDateCell = todayCell;
                                } */
                                isInitialLoad = false; // 플래그를 꺼서 다시는 실행되지 않게 함
                            }

                            // 4. 새로고침이 필요한 날짜가 있는지 확인하고, 목록을 다시 그립니다.
                            if (dateToRefreshAfterFetch) {
                                loadDailySchedules(dateToRefreshAfterFetch);
                                dateToRefreshAfterFetch = null; // 변수 초기화
                            }

                            // 5. FullCalendar에게는 Date 객체가 포함된 데이터를 전달
                            successCallback(processedEvents);
                        },
                        error: function(xhr, status, error) {
                            failureCallback(error);
                        }
                    });
                },
                // --- 날짜 클릭 이벤트 ---
                dateClick: function(info) {
                    if (selectedDateCell) {
                        selectedDateCell.classList.remove('fc-day-selected');
                    }
                    info.dayEl.classList.add('fc-day-selected');
                    selectedDateCell = info.dayEl;

                    $('.tab-btn[data-tab="tab_schedule"]').click();
                    loadDailySchedules(info.dateStr);
                },
                eventClick: function(info) {
                    // 클릭된 이벤트의 날짜를 YYYY-MM-DD 형식으로 구합니다.
                    const dateStr = info.event.start.toISOString().substring(0, 10);
                    
                    // 해당 날짜의 DOM 요소를 직접 찾아 dateClick과 동일한 로직을 수행합니다.
                    const dayEl = document.querySelector(`.fc-daygrid-day[data-date="\${dateStr}"]`);
                    if (dayEl) {
                        if (selectedDateCell) {
                            selectedDateCell.classList.remove('fc-day-selected');
                        }
                        dayEl.classList.add('fc-day-selected');
                        selectedDateCell = dayEl;
                        loadDailySchedules(dateStr);
                    }
                }
            });
            calendar.render();
        }

        // 3. 할 일(Todo) 관련 이벤트 핸들러
        // 3-1. 체크박스 클릭 이벤트 처리
        $('#tab_todo').on('click', '.todo-checkbox', function() {
            var $li = $(this).closest('li');
            var todoIdx = $li.data('id');
            var isChecked = $(this).is(':checked');

            $li.find('.todo-text').toggleClass('completed', isChecked);

            $.ajax({
                url: '<%= request.getContextPath() %>/todoList.do',
                type: 'POST',
                data: {
                    action: 'updateStatus',
                    todoIdx: todoIdx,
                    status: isChecked ? 1 : 0
                },
                success: function(response) {
                    console.log("Todo [ID:" + todoIdx + "] 상태 변경 완료:", response);
                },
                error: function() {
                    alert("상태 변경에 실패했습니다. 다시 시도해 주세요.");
                    $(this).prop('checked', !isChecked);
                    $li.find('.todo-text').toggleClass('completed', !isChecked);
                }
            });
        });

        // 3-2. 삭제 버튼 클릭 이벤트 처리
        $('#tab_todo').on('click', '.todo-delete-btn', function() {
            var $li = $(this).closest('li');
            var todoIdx = $li.data('id');

            if (confirm("정말로 이 할 일을 삭제하시겠습니까?")) {
                $.ajax({
                    url: '<%= request.getContextPath() %>/todoList.do',
                    type: 'POST',
                    data: {
                        action: 'delete',
                        todoIdx: todoIdx
                    },
                    success: function(response) {
                        console.log("Todo [ID:" + todoIdx + "] 삭제 완료:", response);
                        $li.fadeOut(300, function() { $(this).remove(); });
                    },
                    error: function() {
                        alert("삭제에 실패했습니다. 다시 시도해 주세요.");
                    }
                });
            }
        });

        //========================================================
        //  통합 모달 관리 로직
        //========================================================
        const $unifiedModal = $('#unified-modal');
        const $modalTitle = $('#modal-title');
        const $scheduleForm = $('#schedule-form');
        const $todoForm = $('#todo-form');

        //--- 모달 열기 ---
        // 1. '+ 새 일정' 버튼 클릭
        $('#add-schedule-btn').on('click', function() {
            $modalTitle.text('새로운 일정 추가');
            $scheduleForm[0].reset();
            $('#schedule-id').val('');
            let defaultDate = new Date(); // 기본값: 오늘

            // 만약 사용자가 캘린더에서 특정 날짜를 선택한 상태라면,
            if (selectedDateCell) {
                // data-date 속성에서 'YYYY-MM-DD' 문자열을 가져옵니다.
                const selectedDateStr = selectedDateCell.getAttribute('data-date');
                if (selectedDateStr) {
                    defaultDate = new Date(selectedDateStr);
                }
            }
            
         // 날짜를 'YYYY-MM-DDTHH:MM' 형식으로 변환하는 함수 (수정 로직에서 재활용)
            const toLocalISOString = (date) => {
                date.setHours(9, 0, 0, 0); // 기본 시작 시간을 오전 9시로 설정
                const y = date.getFullYear(),
                      m = String(date.getMonth() + 1).padStart(2, '0'),
                      d = String(date.getDate()).padStart(2, '0'),
                      h = String(date.getHours()).padStart(2, '0'),
                      min = String(date.getMinutes()).padStart(2, '0');
                return y + "-" + m + "-" + d + "T" + h + ":" + min;
            };

            // 시작 시간을 '선택한 날짜의 오전 9시'로 기본 설정합니다.
            $('#schedule-start').val(toLocalISOString(defaultDate, true));
            // --- ▲▲▲ 여기까지 추가 ▲▲▲ ---
            
            $todoForm.hide();
            $scheduleForm.show();
            $unifiedModal.show();
        });

        // 2. '+ 새 할 일' 버튼 클릭
        $('#add-todo-btn').on('click', function() {
            $modalTitle.text('새로운 할 일 추가');
            $todoForm[0].reset();
            $('#todo-id').val('');
            $('#todo-group').val('');
            $scheduleForm.hide();
            $todoForm.show();
            $unifiedModal.show();
        });

        // 3. 기존 일정 클릭 (수정)
        $('#tab_schedule').on('click', '.schedule-item-content', function() {
            const scheduleId = $(this).closest('li').data('id');
            let clickedSchedule = null;
            for (const date in schedulesByDate) {
                const found = schedulesByDate[date].find(event => event.id == scheduleId);
                if (found) {
                    clickedSchedule = found;
                    break;
                }
            }
            if (!clickedSchedule) { alert("일정 정보를 찾을 수 없습니다."); return; }

            $modalTitle.text('일정 수정');
            $scheduleForm[0].reset();
            $todoForm.hide();

            $('#schedule-id').val(clickedSchedule.id);
            $('#schedule-title').val(clickedSchedule.title);
            $('#schedule-description').val(clickedSchedule.description);
            const toLocalISOString = (date) => {
                const y = date.getFullYear(),
                      m = String(date.getMonth() + 1).padStart(2, '0'),
                      d = String(date.getDate()).padStart(2, '0'),
                      h = String(date.getHours()).padStart(2, '0'),
                      min = String(date.getMinutes()).padStart(2, '0');
                // JSP와 충돌나지 않도록 템플릿 리터럴을 사용하지 않고 문자열 합치기로 변경
                return y + "-" + m + "-" + d + "T" + h + ":" + min;
            };
            
            $('#schedule-start').val(toLocalISOString(new Date(clickedSchedule.start)));
            $('#schedule-end').val(toLocalISOString(new Date(clickedSchedule.end)));
            $('#schedule-color').val(clickedSchedule.color);

            $scheduleForm.show();
            $unifiedModal.show();
        });

        // 4. 기존 할 일 클릭 (수정)
        $('#tab_todo').on('click', '.todo-list li .todo-text', function() {
            const $li = $(this).closest('li');
            const todoId = $li.data('id');
            const clickedTodo = todosById[todoId];

            if(!clickedTodo) {
                console.error("캐시에서 할 일 정보를 찾지 못했습니다. ID:", todoId);
                alert("할 일 정보를 수정할 수 없습니다.");
                return;
            }

            $modalTitle.text('할 일 수정');
            $todoForm[0].reset();
            $scheduleForm.hide();
            
            $('#todo-id').val(clickedTodo.todo_idx);
            $('#todo-text').val(clickedTodo.text);
            $('#todo-group').val(clickedTodo.todo_group || '');
            $('#todo-color').val(clickedTodo.color || '#3788d8');

            $todoForm.show();
            $unifiedModal.show();
        });

        //--- 모달 닫기 (공통 로직) ---
        $unifiedModal.on('click', '.modal-close-btn, .modal-overlay', function(e) {
            if ($(e.target).is('.modal-close-btn') || $(e.target).is('.modal-overlay')) {
                $unifiedModal.hide();
            }
        });

        //--- 폼 제출 로직 (분리) ---
        // 1. 일정 폼 제출
        $scheduleForm.on('submit', function(e) {
            e.preventDefault();
            const scheduleId = $('#schedule-id').val();
            const isUpdating = !!scheduleId;
            const scheduleData = {
                action: isUpdating ? 'updateSchedule' : 'addSchedule',
                title: $('#schedule-title').val(),
                description: $('#schedule-description').val(),
                start_time: $('#schedule-start').val().replace('T', ' ') + ':00',
                end_time: $('#schedule-end').val().replace('T', ' ') + ':00',
                color: $('#schedule-color').val()
            };
            if (isUpdating) { scheduleData.schedule_idx = scheduleId; }
            const alertMessage = isUpdating ? "수정" : "추가";
            $.ajax({
                url: '<%= request.getContextPath() %>/schedules.do',
                type: 'POST',
                data: scheduleData,
                success: function(response) {
                    if (response.success) {
                        alert('일정이 성공적으로 ' + alertMessage + '되었습니다.');
                        $unifiedModal.hide();
                        dateToRefreshAfterFetch = scheduleData.start_time.substring(0, 10);
                        calendar.refetchEvents();
                    } else { alert('일정 ' + alertMessage + '에 실패했습니다.'); }
                },
                error: function() { alert('서버와 통신 중 오류가 발생했습니다.'); }
            });
        });

        // 2. 할 일 폼 제출
        $todoForm.on('submit', function(e) {
            e.preventDefault();
            const todoId = $('#todo-id').val();
            const isUpdating = !!todoId;
            const todoData = {
                action: isUpdating ? 'updateTodo' : 'addTodo',
                text: $('#todo-text').val(),
                todo_group: $('#todo-group').val(),
                color: $('#todo-color').val()
            };
            if (isUpdating) { todoData.todo_idx = todoId; }
            const alertMessage = isUpdating ? "수정" : "추가";
            $.ajax({
                url: '<%= request.getContextPath() %>/todoList.do',
                type: 'POST',
                data: todoData,
                success: function(response) {
                    if (response.success) {
                        alert('할 일이 성공적으로 ' + alertMessage + '되었습니다.');
                        $unifiedModal.hide();
                        loadTodoList();
                    } else { alert('할 일 ' + alertMessage + '에 실패했습니다.'); }
                },
                error: function() { alert('서버와 통신 중 오류가 발생했습니다.'); }
            });
        });

        //========================================================
        //  일정 삭제 기능
        //========================================================
        $('#tab_schedule').on('click', '.schedule-delete-btn', function(e) {
            e.stopPropagation(); // 부모(li)의 수정 이벤트 방지
            const $li = $(this).closest('li');
            const scheduleId = $li.data('id');
            let scheduleDate = null;
            for (const date in schedulesByDate) {
                const found = schedulesByDate[date].find(event => event.id == scheduleId);
                if (found) {
                    const d = new Date(found.start);
                    scheduleDate = `\${d.getFullYear()}-\${String(d.getMonth() + 1).padStart(2, '0')}-\${String(d.getDate()).padStart(2, '0')}`;
                    break;
                }
            }
            if (!scheduleDate) {
                alert('오류: 해당 일정의 날짜 정보를 찾을 수 없습니다.');
                return;
            }
            if (confirm("정말로 이 일정을 삭제하시겠습니까?")) {
                $.ajax({
                    url: '<%= request.getContextPath() %>/schedules.do',
                    type: 'POST',
                    data: {
                        action: 'deleteSchedule',
                        schedule_idx: scheduleId
                    },
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            alert("일정이 삭제되었습니다.");
                            dateToRefreshAfterFetch = scheduleDate;
                            calendar.refetchEvents();
                        } else {
                            alert("삭제에 실패했습니다: " + (response.message || ""));
                        }
                    },
                    error: function() {
                        alert("삭제 중 오류가 발생했습니다.");
                    }
                });
            }
        });

        //========================================================
        //  위젯 기능 구현 (내가 쓴 글, 좋아요한 글)
        //========================================================
        const NOTE_PREVIEW_COUNT = 5;

        function loadMyPostsWidget() {
            const $widget = $('#my-posts');
            $widget.html('<p>로딩 중...</p>');
            $.ajax({
                url: '<%= request.getContextPath() %>/note.do',
                type: 'GET',
                data: { action: 'getMyPostsPreview', limit: NOTE_PREVIEW_COUNT },
                dataType: 'json',
                success: function(posts) {
                    let contentHtml = '<div class="widget-header"><h3>내가 작성한 글 (인기순)</h3><button class="more-btn" data-type="my-posts">더보기</button></div>';
                    contentHtml += '<ul class="widget-list">';
                    if (posts && posts.length > 0) {
                        posts.forEach(function(post) {
                            contentHtml += `<li><a href="postView.do?nidx=\${post.note_idx}"><span class="widget-post-title">\${post.title}</span><span class="widget-post-meta">조회수 \${post.view_count} | 좋아요 \${post.likes_count}</span></a></li>`;
                        });
                    } else {
                        contentHtml += '<li class="no-items">작성한 글이 없습니다.</li>';
                    }
                    contentHtml += '</ul>';
                    $widget.html(contentHtml);
                },
                error: function() { $widget.html('<p>글을 불러오는 데 실패했습니다.</p>'); }
            });
        }

        function loadLikedPostsWidget() {
            const $widget = $('#liked-posts');
            $widget.html('<p>로딩 중...</p>');
            $.ajax({
                url: '<%= request.getContextPath() %>/note.do',
                type: 'GET',
                data: { action: 'getLikedPostsPreview', limit: NOTE_PREVIEW_COUNT },
                dataType: 'json',
                success: function(posts) {
                    let contentHtml = '<div class="widget-header"><h3>좋아요한 글</h3><button class="more-btn" data-type="liked-posts">더보기</button></div>';
                    contentHtml += '<ul class="widget-list">';
                    if (posts && posts.length > 0) {
                        posts.forEach(function(post) {
                            contentHtml += `<li><a href="postView.do?nidx=\${post.note_idx}"><span class="widget-post-title">\${post.title}</span><span class="widget-post-author">by \${post.author_name}</span></a></li>`;
                        });
                    } else {
                        contentHtml += '<li class="no-items">좋아요한 글이 없습니다.</li>';
                    }
                    contentHtml += '</ul>';
                    $widget.html(contentHtml);
                },
                error: function() { $widget.html('<p>글을 불러오는 데 실패했습니다.</p>'); }
            });
        }

        $('#contents_grid').on('click', '.more-btn', function() {
            const type = $(this).data('type');
            let action = '', modalTitle = '';
            if (type === 'my-posts') { action = 'getAllMyPosts'; modalTitle = '내가 작성한 글 전체'; } 
            else if (type === 'liked-posts') { action = 'getAllLikedPosts'; modalTitle = '좋아요한 글 전체'; } 
            else { return; }

            $.ajax({
                url: '<%= request.getContextPath() %>/note.do',
                type: 'GET',
                data: { action: action },
                dataType: 'json',
                success: function(posts) {
                    const $listModal = $('#list-modal');
                    $('#list-modal-title').text(modalTitle);
                    let listHtml = '<ul class="widget-list">';
                    if (posts && posts.length > 0) {
                        posts.forEach(function(post) {
                            listHtml += `<li><a href="postView.do?nidx=\${post.note_idx}"><span class="widget-post-title">\${post.title}</span><span class="widget-post-author">by \${post.author_name}</span><span class="widget-post-meta">조회수 \${post.view_count} | 좋아요 \${post.likes_count}</span></a></li>`;
                        });
                    } else {
                        listHtml += '<li class="no-items">목록이 없습니다.</li>';
                    }
                    listHtml += '</ul>';
                    $listModal.find('.list-modal-content').html(listHtml);
                    $listModal.show();
                }
            });
        });

        $('#list-modal').on('click', '.modal-close-btn, .modal-overlay', function(e) {
            if ($(e.target).is('.modal-close-btn') || $(e.target).is('.modal-overlay')) {
                $('#list-modal').hide();
            }
        });

        //========================================================
        //  날짜 이동(gotoDate) 기능
        //========================================================
        const $datePickerPopover = $('#date-picker-popover');
        const $yearSelect = $('#year-select');
        const $monthSelect = $('#month-select');

        function populateDatePicker() {
            if ($yearSelect.children().length > 0) return;
            const currentYear = new Date().getFullYear();
            for (let i = currentYear - 10; i <= currentYear + 10; i++) {
                $yearSelect.append(`<option value="\${i}">\${i}년</option>`);
            }
            for (let i = 1; i <= 12; i++) {
                $monthSelect.append(`<option value="\${i}">\${i}월</option>`);
            }
        }
        
        // 캘린더 제목 클릭 시 팝오버 토글
        setTimeout(() => {
            $('#calendar .fc-toolbar-title').on('click', function(e) {
                e.stopPropagation();
                
                // 현재 캘린더의 년/월을 select box에 설정
                const currentDate = calendar.getDate();
                $yearSelect.val(currentDate.getFullYear());
                $monthSelect.val(currentDate.getMonth() + 1);

                $datePickerPopover.toggle();
            });
        }, 500); // 캘린더 렌더링 후 이벤트 바인딩을 위해 약간의 지연시간 부여

        // '이동' 버튼 클릭
        $('#goto-date-btn').on('click', function() {
            const year = $('#year-select').val();
            const month = $('#month-select').val();
            const targetDate = `\${year}-\${String(month).padStart(2, '0')}-01`;
            calendar.gotoDate(targetDate);
            $datePickerPopover.hide();
        });

        // 팝오버 외부 영역 클릭 시 닫기
        $(document).on('click', function(e) {
            if (!$datePickerPopover.is(e.target) && $datePickerPopover.has(e.target).length === 0 && !$(e.target).closest('.fc-toolbar-title').length) {
                $datePickerPopover.hide();
            }
        });


        // --- 페이지 로드 시 초기 데이터 로딩 ---
        loadTodoList();
        loadDailySchedules(getTodayString());
        loadMyPostsWidget();
        loadLikedPostsWidget();
        populateDatePicker(); // Date Picker <option> 채우기
    });
</script>

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
<%-- ▼▼▼ 게시글 전체 목록 표시용 모달 창 (새로 추가) ▼▼▼ --%>
<div class="modal-overlay" id="list-modal" style="display: none;">
    <div class="modal-content">
        <h2 id="list-modal-title"></h2>
        <div class="list-modal-content"></div> 
        <div class="modal-buttons">
            <button type="button" class="modal-close-btn">닫기</button>
        </div>
    </div>
</div>
</body>
</html>