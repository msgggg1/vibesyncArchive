<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="mvc.domain.vo.PageVO" %>
<%@ page import="mvc.domain.vo.NoteVO" %>
<%@ page import="mvc.domain.vo.UserVO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    List<PageVO> list      = (List<PageVO>) request.getAttribute("list");
    int totalCount         = (Integer) request.getAttribute("totalCount");
    int currentPage        = (Integer) request.getAttribute("currentPage");
    int pageSize           = (Integer) request.getAttribute("pageSize");
    String searchType      = (String)  request.getAttribute("searchType");
    String keyword         = (String)  request.getAttribute("keyword");
    List<NoteVO> notes     = (List<NoteVO>) request.getAttribute("notes");
    String getPageTitle    = (String) request.getAttribute("pagetitle");
    Integer selectedIdx    = (Integer) request.getAttribute("selectedUserPgIdx");
    int totalPages         = (int) Math.ceil((double) totalCount / pageSize);
 // 로그인한 사용자 정보 및 선택된 페이지의 ac_idx 확인
    UserVO user = (UserVO) session.getAttribute("userInfo");
    Integer userAcIdx = user != null ? user.getAc_idx() : null;
    Integer selAcIdx = null;
    if (selectedIdx != null) {
        for (PageVO vo : list) {
            if (vo.getUserpg_idx() == selectedIdx) {
                selAcIdx = vo.getAc_idx();
                break;
            }
        }
    }
  %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>게시물 목록</title>
  <link rel="stylesheet" href="./css/style.css">
  <link rel="icon" href="./sources/favicon.ico" />
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
   
  <style>
  #searchForm {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 0.2rem;
  }
  
  .searchInput {
    background: none;
    border: none;
    border-bottom: 1px solid black;
    font-weight: bold;
  }

  .searchBtn {
    background: none;
    border: 1px solid black;
    border-radius: 5px;
    padding-block: 2px;
    padding-inline: 8px;
    font-weight: bold;
  }

  .searchBtn:hover {
    background: rgba(256, 256, 256, 0.88) !important;
  }

  #add_note_btn {
    width: 2vw;
    height: 2vw;
    border-radius: 50%;
    background: #8ac4ff;
    border: none;
    font-size: 1.4vw;
  }

  #add_note_btn a {
    color: white;
    font-weight: bold;
  }
  </style>
  
</head>
<body>
  <div id="notion-app">
    <input type="hidden" id="mode" value="board">
    <div class="notion-app-inner">
      <jsp:include page="./includes/sidebar.jsp" flush="true" />

      <div id="content_wrapper">
        <section id="content">
          <div class="back_icon">
            <a href="#"><img src="./sources/icons/arrow_back.svg" alt="arrow_back"></a>
          </div>
          
          <div id="board_all">
            <div class="board_info">
              <p><%= getPageTitle == null ? "Page" : getPageTitle %></p>
              <%-- 로그인 사용자와 선택 페이지의 작성자가 일치할 때만 노트 생성 버튼 표시 --%>
              <% if (selectedIdx != null && userAcIdx != null && selAcIdx != null && userAcIdx.equals(selAcIdx)) { %>
                <button id="add_note_btn"><a href="notecreate.do?pageidx=<%= selectedIdx %>">+</a></button>
              <% } %>
            </div>
            <div class="line"></div>

            <div id="board_list">
              <section id="page-board-full" class="page">
                <div id="ajax-container">

                  <!-- 1) notes 가 있을 때: page 리스트 숨기고 notes 리스트만 출력 -->
                  <c:if test="${not empty notes}">
                    <div class="full-list subfont" id="full-list-notes" style="position: relative;">
                      <c:forEach var="note" items="${notes}">
                      	<a href="postView.do?nidx=${note.note_idx}&pageidx=<%= selectedIdx %>">
                          <div class="full-post" style="margin-bottom:8px; border-bottom: 1px solid #666;">
                            <div class="post-index">${note.note_idx}</div>
                            <div class="post-title"><c:out value="${note.title}"/></div>
                          </div>
                      	</a>
                      </c:forEach>
                      <c:if test="${empty notes}">
                        <p>노트가 없습니다.</p>
                      </c:if>
                      <!-- 뒤로가기: 다시 페이지 리스트 보기 -->
                      <button type="button" class="searchBtn"
                              onclick="location.href='<c:url value="/vibesync/page.do"/>?page=${currentPage}&size=${pageSize}&searchType=${searchType}&keyword=${keyword}'"
                              style="margin-top:16px; position: absolute; right: 18px">List</button>
                    </div>
                  </c:if>

                  <!-- 2) notes 가 없을 때: 기존 page 리스트 + 검색/페이징 -->
                  <c:if test="${empty notes}">
                    <!-- 게시물 리스트 -->
                    <div class="full-list subfont" id="full-list">
                      <c:forEach var="vo" items="${list}">
                        <div class="full-post" 
                             style="cursor:pointer; margin-bottom:8px;"
                             onclick="location.href='<c:url value="/vibesync/page.do"/>?page=${currentPage}&size=${pageSize}&searchType=${searchType}&keyword=${keyword}&userPgIdx=${vo.userpg_idx}'">
                          <div class="post-index">${vo.userpg_idx}</div>
                          <div class="post-title"><c:out value="${vo.subject}"/></div>
                        </div>
                      </c:forEach>
                      <c:if test="${empty list}">
                        <p>게시물이 없습니다.</p>
                      </c:if>
                    </div>

                    <!-- 검색 바 -->
                    <div class="search-bar" style="margin:16px 0;">
                      <form id="searchForm" action="page.do" method="get">
                        <select name="searchType" class="searchInput">
                          <option value="subject"         ${searchType=='subject'          ? 'selected':''}>제목</option>
                          <option value="content"         ${searchType=='content'          ? 'selected':''}>내용</option>
                          <option value="subject_content" ${searchType=='subject_content'  ? 'selected':''}>제목+내용</option>
                        </select>
                         <input type="text" class="searchInput" name="keyword" value="<c:out value='${keyword}'/>" placeholder="검색어 입력"/>
                        <button type="submit" class="searchBtn" >Search</button>
                        <button type="button" id="resetBtn" class="searchBtn">List</button>
                      </form>
                    </div>

                    <!-- 서버사이드 페이징 -->
                    <div class="pagination" id="pagination" style="font-weight: bold;">
                      <c:if test="${currentPage > 1}">
                        <a href="page.do?page=${currentPage-1}&size=${pageSize}&searchType=${searchType}&keyword=${keyword}">Prev</a>
                      </c:if>
                      <c:forEach begin="1" end="<%= totalPages %>" var="p">
                        <c:choose>
                          <c:when test="${p == currentPage}">
                            <strong>${p}</strong>
                          </c:when>
                          <c:otherwise>
                            <a href="page.do?page=${p}&size=${pageSize}&searchType=${searchType}&keyword=${keyword}">${p}</a>
                          </c:otherwise>
                        </c:choose>
                      </c:forEach>
                      <c:if test="${currentPage < totalPages}">
                        <a href="page.do?page=${currentPage+1}&size=${pageSize}&searchType=${searchType}&keyword=${keyword}">Next</a>
                      </c:if>
                    </div>
                  </c:if>

                </div>
              </section>
            </div>
          </div>
        </section>
      </div>
    </div>
  </div>

  <script>
    $(function(){
      // 검색·페이징은 AJAX로 처리 (notes 없는 경우)
      function loadPage(params) {
        $.ajax({
          url: 'page.do',
          data: params,
          cache: false,
          success: function(html) {
            var $resp = $('<div>').append($.parseHTML(html));
            $('#full-list').html( $resp.find('#full-list').html() );
            $('#pagination').html( $resp.find('#pagination').html() );
          },
          error: function(){
            alert('데이터 로드 중 오류가 발생했습니다.');
          }
        });
      }

      $('#searchForm').on('submit', function(e){
        e.preventDefault();
        loadPage( $(this).serialize() );
      });
      $('#resetBtn').on('click', function(){
        $('#searchForm select').val('subject');
        $('#searchForm input[name=keyword]').val('');
        loadPage({});
      });
      $('#pagination').on('click', 'a', function(e){
        e.preventDefault();
        loadPage( this.href.split('?')[1] );
      });

      // 게시물 클릭 시 노트 조회는 전체 새로고침으로 동작 (JS 핸들러 없음)
    });
  </script>
</body>
</html>