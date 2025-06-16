// 전역 변수 선언
var calendar;
var schedulesByDate = {};
var selectedDateCell = null;
var todosById = {};
let dateToRefreshAfterFetch = null;
let isInitialLoad = true;

// ========================================================
//  함수 선언 영역
// ========================================================

// [함수] 일별 일정 로딩 (우측 패널)
function loadDailySchedules(dateString) {
	
	// 1. 전달받은 dateString으로 Date 객체 생성
    const date = new Date(dateString);

    // 2. 요일을 한글로 변환하기 위한 배열
    const weekdays = ['일', '월', '화', '수', '목', '금', '토'];

    // 3. 'YYYY년 MM월 DD일 (요일)' 형식으로 날짜 포맷팅
    const formattedDate = `${date.getFullYear()}년 ${date.getMonth() + 1}월 ${date.getDate()}일 (${weekdays[date.getDay()]})`;

    // 4. JSP에 추가한 h4 태그에 포맷된 날짜 텍스트를 삽입
    $('#tab_schedule .schedule-date-title').text(formattedDate);
	
    var schedules = schedulesByDate[dateString];
    var scheduleHtml = '<ul class="schedule-list">';
    if (schedules && schedules.length > 0) {
        $.each(schedules, function(index, schedule) {
            var startDate = new Date(schedule.start);
            var endDate = new Date(schedule.end);
            var startTime = String(startDate.getHours()).padStart(2, '0') + ":" + String(startDate.getMinutes()).padStart(2, '0');
            var endTime = String(endDate.getHours()).padStart(2, '0') + ":" + String(endDate.getMinutes()).padStart(2, '0');
            var descriptionHtml = (schedule.description && schedule.description.trim() !== '') ? ' <span class="schedule-desc">' + schedule.description + '</span>' : '';
            
            scheduleHtml += `<li data-id="${schedule.id}">
                               <div class="schedule-item-content">
                                   <span class="schedule-time">${startTime} - ${endTime}</span>
                                   <div class="schedule-details">
                                       <span class="schedule-title">${schedule.title}</span>
                                       ${descriptionHtml}
                                   </div>
                               </div>
                               <button class="schedule-delete-btn">&times;</button>
                           </li>`;
        });
    } else {
        scheduleHtml += '<li class="no-schedule">등록된 일정이 없습니다.</li>';
    }
    scheduleHtml += '</ul>';
    $('#tab_schedule .schedule-date-title').html('<i class="fa-regular fa-calendar-check"></i>' + formattedDate);
    $('#daily-schedule-list-container').html(scheduleHtml);
}

// [함수] 할 일 목록 로딩
function loadTodoList() { 
    $.ajax({
        url: contextPath + '/todoList.do', // ★ contextPath 변수 사용
        type: 'GET',
        dataType: 'json',
        success: function(todos) {
            var todoListHtml = '<ul class="todo-list">';
            todosById = {};
            if (todos && todos.length > 0) {
                $.each(todos, function(index, todo) {
                    let isChecked = todo.status === 1 ? "checked" : "";
                    let textClass = todo.status === 1 ? "completed" : "";
                    // 1. 색상 코드를 RGB 객체로 변환
				    let rgb = hexToRgb(todo.color);
				
				    // 2. li 태그에 CSS 변수로 RGB 값을 전달하고, 체크박스 구조 변경
				    todoListHtml += `<li data-id="${todo.todo_idx}" style="--todo-r: ${rgb.r}; --todo-g: ${rgb.g}; --todo-b: ${rgb.b};">
				                        <label class="custom-checkbox-label">
				                            <input type="checkbox" class="todo-checkbox" ${isChecked}>
				                            <span class="custom-checkbox-span"></span>
				                        </label>
				                        <span class="todo-text \${textClass}">${todo.text}</span>
				                        <button class="todo-delete-btn">&times;</button>
				                    </li>`;
				    todosById[todo.todo_idx] = todo;
                });
            } else {
                todoListHtml += '<li style="justify-content:center; color:#888;">등록된 할 일이 없습니다.</li>';
            }
            todoListHtml += '</ul>';
            $('#tab_todo').html(todoListHtml);
        },
        error: function(xhr, status, error) {
            console.error("[TodoList-AJAX-ERR]", error);
            $('#tab_todo').html('<p>할 일 목록을 불러오는 데 실패했습니다.</p>');
        }
    });
}

// [함수] 오늘 날짜 문자열 반환
function getTodayString() {
    var today = new Date();
    var year = today.getFullYear();
    var mm = String(today.getMonth() + 1).padStart(2, '0');
    var dd = String(today.getDate()).padStart(2, '0');
    return year + '-' + mm + '-' + dd;
}
    
// 하나의 범용 위젯 로딩 함수
/* 추후 필요시 사용
function loadPostsWidget(options) {
    const $widget = $(options.selector);
    $widget.html('<p>로딩 중...</p>');

    $.ajax({
        url: contextPath + '/note.do',
        type: 'GET',
        data: { action: options.action },
        dataType: 'json',
        success: function(posts) {
            // 헤더 HTML 생성
            let contentHtml = `<div class="widget-header">
                                   <h4><i class="${options.iconClass}"></i>&nbsp;&nbsp;${options.title}</h4>
                                   <button class="more-btn" data-type="${options.type}">더보기</button>
                               </div>`;
            contentHtml += '<ul>';

            if (posts && posts.length > 0) {
                posts.forEach(function(post) {
                    // 리스트 아이템 HTML 생성 (options.metaGenerator 함수 사용)
                    contentHtml += `<li>
                                        <a href="postView.do?nidx=${post.note_idx}" title="${post.title}">
                                            <span>${post.title}</span>
                                            ${options.metaGenerator(post)}
                                        </a>
                                    </li>`;
                });
            } else {
                contentHtml += `<li class="no-items">${options.noItemText}</li>`;
            }
            contentHtml += '</ul>';
            $widget.html(contentHtml);
        },
        error: function() { $widget.html('<p>글을 불러오는 데 실패했습니다.</p>'); }
    });
}
*/

// [함수] 날짜 선택 팝오버 채우기
function populateDatePicker() {
    const $yearSelect = $('#year-select');
    const $monthSelect = $('#month-select');
    if ($yearSelect.children().length > 0) return;
    const currentYear = new Date().getFullYear();
    for (let i = currentYear - 10; i <= currentYear + 10; i++) {
        $yearSelect.append(`<option value="${i}">${i}년</option>`);
    }
    for (let i = 1; i <= 12; i++) {
        $monthSelect.append(`<option value="${i}">${i}월</option>`);
    }
}

/** 16진수 색상을 RGB 객체로 변환하는 헬퍼 함수 */
function hexToRgb(hex) {
    if (!hex || hex.length < 4) {
        hex = '#3788d8'; // 기본값
    }
    let result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16)
    } : { r: 55, g: 136, b: 216 }; // 기본값의 RGB
}

// ========================================================
//  페이지 로드 완료 후 실행되는 메인 로직
// ========================================================
$(document).ready(function() {

    // --- 변수 선언 ---
    const $unifiedModal = $('#unified-modal');
    const $modalTitle = $('#modal-title');
    const $scheduleForm = $('#schedule-form');
    const $todoForm = $('#todo-form');
    const $datePickerPopover = $('#date-picker-popover');
    const $yearSelect = $('#year-select');
    const $monthSelect = $('#month-select');

    // --- 이벤트 핸들러 설정 ---

    // 1. 탭 전환
    $('.tab-btn').on('click', function() {
        $('.tab-btn, .tab-content').removeClass('active');
        $(this).addClass('active');
        const tabId = $(this).data('tab');
        $('#' + tabId).addClass('active');
        
        if (tabId === 'tab_schedule') {
            $('#add-schedule-btn').show();
            $('#add-todo-btn').hide();
        } else if (tabId === 'tab_todo') {
            $('#add-schedule-btn').hide();
            $('#add-todo-btn').show();
        }
    });

    // 2. 할 일(Todo) 관련
    $('#tab_todo').on('click', '.todo-checkbox', function() {
            var $li = $(this).closest('li');
            var todoIdx = $li.data('id');
            var isChecked = $(this).is(':checked');

            $li.find('.todo-text').toggleClass('completed', isChecked);

            $.ajax({
                url: contextPath + '/todoList.do',
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
    $('#tab_todo').on('click', '.todo-delete-btn', function() {
    	var $li = $(this).closest('li');
        var todoIdx = $li.data('id');
            
            console.log("삭제 버튼 클릭! 선택된 Todo의 ID:", todoIdx, "타입:", typeof todoIdx);

            if (confirm("정말로 이 할 일을 삭제하시겠습니까?")) {
                $.ajax({
                    url: contextPath + '/todoList.do',
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
    $('#tab_todo').on('click', '.todo-list li .todo-text', function() {const $li = $(this).closest('li');
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
            
            
             }); // 수정 모달 열기

    // 3. 일정(Schedule) 관련
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
     }); // 수정 모달 열기
     
    $('#tab_schedule').on('click', '.schedule-delete-btn', function(e) { 
    	e.stopPropagation(); // 부모(li)의 수정 이벤트 방지
            const $li = $(this).closest('li');
            const scheduleId = $li.data('id');
            let scheduleDate = null;
            for (const date in schedulesByDate) {
                const found = schedulesByDate[date].find(event => event.id == scheduleId);
                if (found) {
                    const d = new Date(found.start);
                    scheduleDate = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
                    break;
                }
            }
            if (!scheduleDate) {
                alert('오류: 해당 일정의 날짜 정보를 찾을 수 없습니다.');
                return;
            }
            if (confirm("정말로 이 일정을 삭제하시겠습니까?")) {
                $.ajax({
                    url: contextPath + '/schedules.do',
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

    // 4. 통합 모달(추가/수정) 관련
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

            $todoForm.hide();
            $scheduleForm.show();
            $unifiedModal.show();
	 });
	 
    $('#add-todo-btn').on('click', function() { 
    	$modalTitle.text('새로운 할 일 추가');
            $todoForm[0].reset();
            $('#todo-id').val('');
            $('#todo-group').val('');
            $scheduleForm.hide();
            $todoForm.show();
            $unifiedModal.show();
     });
     
     // 모달 닫기
    $unifiedModal.on('click', '.modal-close-btn, .modal-overlay', function(e) { 
			if ($(e.target).is('.modal-close-btn') || $(e.target).is('.modal-overlay')) {
                $unifiedModal.hide();
            }
	 });
	 
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
                url: contextPath +'/schedules.do',
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
    $todoForm.on('submit', function(e) {  e.preventDefault();
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
                url: contextPath +'/todoList.do',
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
            }); });
    
    
    // 6. 위젯 '더보기' 및 전체 목록 모달
    $('#contents_grid').on('click', '.more-btn', function() { 
			const type = $(this).data('type');
            let action = '', modalTitle = '';
            if (type === 'my-posts') { action = 'getAllMyPosts'; modalTitle = '내가 작성한 글 전체'; } 
            else if (type === 'liked-posts') { action = 'getAllLikedPosts'; modalTitle = '좋아요한 글 전체'; } 
            else { return; }

            $.ajax({
                url: contextPath + '/note.do',
                type: 'GET',
                data: { action: action },
                dataType: 'json',
                success: function(posts) {
                    const $listModal = $('#list-modal');
                    $('#list-modal-title').text(modalTitle);
                    let listHtml = '<ul class="widget-list">';
                    if (posts && posts.length > 0) {
                        posts.forEach(function(post) {
                            listHtml += `<li>
                                        <a href="postView.do?nidx=${post.note_idx}">
                                            <div class="post-main-info">
                                                <span class="widget-post-title">${post.title}</span>
                                                <span>조회수 ${post.view_count} | 좋아요 ${post.like_count}</span>
                                            </div>
                                            <div class="widget-post-author">
                                                <span class="widget-post-meta">BY ${post.author_name}</span>
                                            </div>
                                        </a>
                                    </li>`;
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
    
    // 7. 날짜 이동 팝오버 관련
    setTimeout(() => {
        $('#calendar .fc-toolbar-title').on('click', function(e) { 
        		e.stopPropagation();
                
                // 현재 캘린더의 년/월을 select box에 설정
                const currentDate = calendar.getDate();
                $yearSelect.val(currentDate.getFullYear());
                $monthSelect.val(currentDate.getMonth() + 1);

                $datePickerPopover.toggle();
         }); // 캘린더 렌더링 후 이벤트 바인딩을 위해 약간의 지연시간 부여
    }, 500);
    // '이동' 버튼 클릭
    $('#goto-date-btn').on('click', function() { 
			const year = $('#year-select').val();
            const month = $('#month-select').val();
            const targetDate = `${year}-${String(month).padStart(2, '0')}-01`;
            calendar.gotoDate(targetDate);
            $datePickerPopover.hide();
	 });
	 
	  // 팝오버 외부 영역 클릭 시 닫기
    $(document).on('click', function(e) {
        if (!$datePickerPopover.is(e.target) && $datePickerPopover.has(e.target).length === 0 && !$(e.target).closest('.fc-toolbar-title').length) {
            $datePickerPopover.hide();
        }
    });
   

    // 9. ESC 키로 모달 닫기
    $(document).on('keydown', function(e) { if (e.key === 'Escape') $('#addBlockModal, #list-modal').hide(); });

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
                        url: contextPath +'/schedules.do',
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
                    const dayEl = document.querySelector(`.fc-daygrid-day[data-date="${dateStr}"]`);
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

    // --- 초기 데이터 로딩 함수 호출 ---
    loadTodoList();
    loadDailySchedules(getTodayString());
    populateDatePicker();
});