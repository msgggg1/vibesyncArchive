<%@page import="mvc.domain.vo.UserVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- CSS 및 JS를 모두 이 파일 내에 포함 -->
<style>
.notion-sidebar {
  position: relative;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  height: 100%;
  width: 100%;
}

.notion-sidebar .menu_content {
  display: flex;
  justify-content: center;
  align-items: start;
  flex-direction: column;
  gap: 40px;
  font-size: 20px;
  font-weight: bold;
  margin-left: 10px;
  margin-block: 60px;
}
.notion-sidebar .menu_content .nickname {
  text-decoration: none;
  text-transform: uppercase;
  color: var(--font-color);
}

.search {
  display: inline-flex;
  align-items: center;
  position: relative;
  cursor: pointer;
}

/* 입력창 숨김 상태 */
.search-input {
  width: 100px;
  height: 22px;
  background: none;
  border: none;
  border-bottom: var(--border-color) 2px solid;
  color: var(--font-color);
}

input:focus {
  outline: none;
}

#follow {
  display: flex;
  justify-content: start;
  align-items: center;
  flex-direction: column;
  padding: 0;
  /* (변경) 초기 높이는 콘텐츠 없을 때 최소한만 차지 */
  height: auto;
  overflow: hidden;
}

/* 레이블 스타일 */
.follow_list label {
  text-decoration: none;
  color: var(--font-color);
  cursor: pointer;
}

/* 체크박스 숨김 */
#follow_toggle {
  display: none;
}

/* 토글 메뉴 숨김 상태 */
/* (변경) JS 토글을 위해 .show 클래스를 추가 */
.follow_items {
  list-style: none;
  padding: 0;
  margin: 20px 0 0;
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.3s ease-out;
}
.follow_items.show {
  /* 충분히 큰 max-height나 auto로 설정하여 콘텐츠가 보이도록 함 */
  max-height: 500px;
  transition: max-height 0.3s ease-in;
}

.follow_items li {
  margin: 4px 0;
}

.icon_wrap {
  display: flex;
  gap: 10px;
}

#logout form {
  width: 100%;
  display: flex;
  justify-content: center;
  height: 40px;
  margin-bottom: 20px;
}

#logout form > button {
  width: 150px;
  border: none;
  background-color: red;
  border-radius: 5px;
  font-size: 14px;
  text-transform: uppercase;
  font-weight: bold;
  color: var(--w-fff);
  cursor: pointer;
}

.nickname-container {
  position: relative; 
  display: inline-block; /* 모달을 닉네임 바로 아래에 띄우기 위해 필요 */
}

.nickname {
  display: inline-block;
  max-width: 150px;            /* 최대 너비 */
  white-space: nowrap;         /* 한 줄로 표시 */
  overflow: hidden;            /* 넘치는 부분 숨김 */
  text-overflow: ellipsis;     /* 말줄임표 처리 */
  cursor: pointer;             /* 클릭 가능한 것처럼 보이게 */
  padding: 2px 4px;            /* 필요에 따라 여백 조절 */
}

/* ==================================================
   2. 모달 기본 스타일
=================================================== */
.modal {
  display: none;               /* 기본적으로 숨김 */
  position: absolute;
  top: 100%;                   /* 닉네임 바로 아래 */
  left: 0;
  background-color: #fff;      /* 흰색 배경 */
  border: 1px solid #ccc;      /* 테두리 */
  border-radius: 4px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  padding: 8px 12px;
  z-index: 1000;               /* 위로 떠 있도록 */
  white-space: nowrap;         /* 모달 안의 내용도 한 줄로 */
}

.modal-nickname {
  display: block;
  text-decoration: none;
  color: #333;
}

.modal-nickname:hover {
  text-decoration: underline;
}

#logout form {
  width: 100%;
  display: flex;
  justify-content: center;
  height: 40px;
  margin-bottom: 20px;
}

#logout form > button {
  width: 150px;
  border: none;
  background-color: red;
  border-radius: 5px;
  font-size: 14px;
  text-transform: uppercase;
  font-weight: bold;
  color: var(--w-fff);
  cursor: pointer;
}
</style>

<button id="toggle-btn">☰</button>

<nav class="notion-sidebar-container" id="sidebar">
  <div class="notion-sidebar">
    <div class="menu_content">

      <!-- 닉네임 영역: 클릭 시 모달 토글 -->
      <div class="nickname-container">
        <span class="nickname" id="nickname-display">
          ${userInfo.nickname}
        </span>

        <!-- 모달: 기본 숨김, 클릭 시 보임 -->
        <div id="nickname-modal" class="modal">
          <!-- 모달 내부 닉네임 클릭 시 user.jsp?ui=로 이동 -->
          <a href="userPage.do?acIdx=${userInfo.ac_idx}" class="modal-nickname">
            ${userInfo.nickname}
          </a>
        </div>
      </div>
      <!-- // 닉네임 영역 끝 -->

      <!-- 검색 -->
      <div class="search icon_wrap">
        <img src="./sources/icons/search.svg" alt="search icon" class="sidebar_icon">
        <input type="text" class="search-input" placeholder="Search…">
      </div>

      <!-- HOME -->
      <a href="main.do" class="home icon_wrap">
        <img src="./sources/icons/home.svg" alt="home icon" class="sidebar_icon">
        <span>HOME</span>
      </a>

      <!-- WORKSPACE -->
      <a href="workspace.do" class="workspace icon_wrap">
        <img src="./sources/icons/work.svg" alt="workspace icon" class="sidebar_icon">
        <span>WORKSPACE</span>
      </a>
      
      <!-- FULL PAGE -->
      <a href="page.do" class="workspace icon_wrap">
        <img src="./sources/icons/page.svg" alt="workspace icon" class="sidebar_icon">
        <span>PAGES</span>
      </a>

      <!-- FOLLOW 목록 -->
      <div id="follow">
        <div class="follow_list" id="followButton">
          <div class="follow_tag icon_wrap">
            <img src="./sources/icons/follow.svg" alt="follow icon" class="sidebar_icon">
            <label for="follow_toggle">FOLLOW</label>
          </div>
          
          <!-- (1) AJAX 요청을 위한 form: action, useridx를 숨겨둔다 -->
          <form id="followForm_side">
            <!-- 서버에 어떤 동작을 요청할지(action 파라미터) -->
            <input type="hidden" name="action" value="getFollowing" />
            <!-- 현재 로그인된 사용자의 ac_idx를 숨겨둔다 -->
            <input type="hidden" name="useridx" id="useridx" 
                   value="${sessionScope.userInfo.ac_idx}" />
          </form>

          <!-- (2) AJAX 결과(JSON)로 받은 팔로잉 목록을 이곳에 렌더링 -->
          <ul class="follow_items">
            <!-- 처음 진입 시에는 비어 있음 -->
          </ul>

        </div>
      </div>

    </div>

    <!-- 로그아웃 -->
    <div id="logout">
      <form action="user.do" method="post">
        <input type="hidden" name="accessType" value="logout">
        <button type="submit">Logout</button>
      </form>
    </div>
  </div>
</nav>

<script>
$(document).ready(function() {
    // 팔로우 목록 토글 상태 추적 변수
    var isExpanded = false;

    $('#followButton').on('click', function(e) {
        e.preventDefault();

        var $ul = $('.follow_items');
        var $followDiv = $('#follow');

        if (isExpanded) {
            // 이미 열려 있는 상태라면, 목록 및 show 클래스 제거하여 접기
            $ul.empty();
            $ul.removeClass('show');
            isExpanded = false;
            return;
        }

        // 아직 열려 있지 않다면 AJAX로 데이터 가져오기
        var formData = {
            action: $('input[name="action"]').val(),
            useridx: $('input[name="useridx"]').val()
        };

        $.ajax({
            type: 'POST',
            // 확인 필요
            //url: '<%= request.getContextPath() %>/sidebar.do',
            url: '<%= request.getContextPath() %>/common.do',
            data: formData,
            dataType: 'json',
            success: function(response) {
                var items = response.followingList;
                $ul.empty();

                if (!items || items.length === 0) {
                    $ul.append('<li><p>No Follower</p></li>');
                } else {
                    $.each(items, function(i, user) {
                        var liHtml = ''
                            + '<li>'
                            +   '<a href="userPage.do?acIdx=' + user.ac_idx + '">' 
                            +     user.nickname 
                            +   '</a>'
                            + '</li>';
                        $ul.append(liHtml);
                    });
                }

                // 목록을 채운 뒤 show 클래스를 추가하여 max-height를 늘리기
                $ul.addClass('show');
                isExpanded = true;
            },
            error: function(xhr, status, error) {
                console.error('AJAX Error:', error);
            }
        });
    });

    // 닉네임 클릭 시 모달 토글
    $('#nickname-display').on('click', function() {
        $('#nickname-modal').toggle();
    });
});
</script>
