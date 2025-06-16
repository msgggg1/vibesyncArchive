<%@page import="mvc.domain.vo.UserVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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

.follow_items {
  list-style: none;
  padding: 0;
  margin: 20px 0 0;
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.3s ease-out;
}
.follow_items.show {
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
  display: inline-block;
}

.nickname {
  display: inline-block;
  max-width: 150px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  cursor: pointer;
  padding: 2px 4px;
}

.modal-sidebar {
  display: none; 
  position: absolute;
  top: 100%; 
  left: 0;
  background-color: #fff;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  z-index: 1000;
  white-space: nowrap;
  width: 170px; height: 220px; overflow-x: hidden;
}

.modal-nickname {
  display: block;
  text-decoration: none;
  color: var(--modal-font);
  padding: 4px 10px; background-color: #c7e5ff;/*임시 구분용 색상*/
}

.modal-nickname:hover {
  text-decoration: underline;
}
</style>

<button id="toggle-btn">☰</button>

<nav class="notion-sidebar-container" id="sidebar">
  <div class="notion-sidebar">
    <div class="menu_content">

      <div class="nickname-container">
        <span class="nickname" id="nickname-display">
          ${userInfo.nickname}
        </span>
        <div id="nickname-modal" class="modal-sidebar">
          <a href="userPage.do?acIdx=${userInfo.ac_idx}" class="modal-nickname">
            ${userInfo.nickname}
          </a>
        </div>
      </div>
      <div class="search icon_wrap">
        <img src="./sources/icons/search.svg" alt="search icon" class="sidebar_icon">
        <input type="text" class="search-input" placeholder="Search…">
      </div>

      <a href="main.do" class="home icon_wrap">
        <img src="./sources/icons/home.svg" alt="home icon" class="sidebar_icon">
        <span>HOME</span>
      </a>

      <a href="workspace.do" class="workspace icon_wrap">
        <img src="./sources/icons/work.svg" alt="workspace icon" class="sidebar_icon">
        <span>WORKSPACE</span>
      </a>
      
      <a href="page.do" class="workspace icon_wrap">
        <img src="./sources/icons/page.svg" alt="workspace icon" class="sidebar_icon">
        <span>PAGES</span>
      </a>

      <div id="follow">
        <div class="follow_list" id="followButton">
          <div class="follow_tag icon_wrap">
            <img src="./sources/icons/follow.svg" alt="follow icon" class="sidebar_icon">
            <label for="follow_toggle">FOLLOW</label>
          </div>
          
          <form id="followForm_side">
            <input type="hidden" name="action" value="getFollowing" />
            <input type="hidden" name="useridx" id="useridx" 
                   value="${sessionScope.userInfo.ac_idx}" />
          </form>

          <ul class="follow_items">
            </ul>

        </div>
      </div>

    </div>

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
    var isExpanded = false;

    $('#followButton').on('click', function(e) {
        // [수정] 클릭된 대상이 <a> 태그이거나 그 자식일 경우, 아무것도 하지 않고 기본 동작(링크 이동)을 허용
        if ($(e.target).closest('a').length) {
            return;
        }

        // 링크가 아닌 다른 곳을 클릭했을 때만 아래 로직 실행
        e.preventDefault();

        var $ul = $('.follow_items');
        var $followDiv = $('#follow');

        if (isExpanded) {
            $ul.empty();
            $ul.removeClass('show');
            isExpanded = false;
            return;
        }

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
