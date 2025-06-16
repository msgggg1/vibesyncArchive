<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mvc.domain.vo.CategoryVO, java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 세션에서 카테고리 목록 가져오기 (변수명 대소문자 수정: categoryvolist -> categoryVOList) --%>
<c:set var="categoryList" value="${applicationScope.categoryVOList}" />

<%-- 컨트롤러에서 전달된 페이징 결과 데이터 --%>
<c:set var="result" value="${requestScope.result}" />
<c:set var="list" value="${result.list}" />
<c:set var="searchType" value="${requestScope.searchType}" />
<c:set var="keyword" value="${requestScope.keyword}" />
<c:set var="currentCategory" value="${requestScope.category_idx}" />

<%-- 현재 선택된 카테고리 이름 찾기 --%>
<c:set var="categoryName" value="전체" />
<c:if test="${currentCategory > 0}">
    <c:forEach var="cat" items="${categoryList}">
        <c:if test="${cat.category_idx == currentCategory}">
            <c:set var="categoryName" value="${cat.c_name}" />
        </c:if>
    </c:forEach>
</c:if>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>노트 목록</title>
    <link rel="stylesheet" href="./css/style.css">
    <link rel="stylesheet" href="./css/sidebar.css">
    <link rel="icon" href="./sources/favicon.ico" />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <style>
        #board_all { width: 100%; }
        .board_info { display: flex; justify-content: space-between; align-items: center; }
        .board_info p { font-size: 24px; font-weight: bold; }
        #filterForm { display: flex; gap: 10px; }
        .filter_select, .searchInput { padding: 5px; border: 1px solid #ccc; border-radius: 4px; }
        #search_bar { margin-bottom: 20px; display: flex; justify-content: center; }
        #note-list { display: flex; flex-direction: column; gap: 2px; margin-bottom: 2rem }
        #note-list .full-post { display: flex; padding: 10px; border-bottom: 1px solid #000; cursor: pointer; }
        #note-list .full-post:hover { background-color: #f5f5f5; }
        #note-list .post-index { min-width: 50px; color: #888; }
        #note-list .post-title { font-weight: bold; }
        #note-list .post-author { margin-left: auto; color: #555; }
        #searchForm { display: flex; justify-content: center; align-items: center; gap: 0.2rem; }
		.searchInput { background: none; border: none; border-bottom: 1px solid black; font-weight: bold; }
		.searchBtn { background: none; border: 1px solid black; border-radius: 5px; padding-block: 2px; padding-inline: 8px; font-weight: bold; }
		.searchBtn:hover { background: rgba(256, 256, 256, 0.88) !important; }
        .pagination { display: flex; justify-content: center; align-items: center; gap: 10px;}
        .pagination a, .pagination strong { margin: 0 5px; text-decoration: none; color: #333; }
        .pagination strong { font-weight: bold; transform: scale(1.4); }
    </style>
</head>
<body>
<div id="notion-app">
    <input type="hidden" id="mode" value="board">
    <div class="notion-app-inner">
        <jsp:include page="./includes/sidebar.jsp" flush="true"></jsp:include>
        
        <div id="content_wrapper">
            <section id="content">
                <div id="board_all">
                    <div class="board_info">
                        <p><c:out value="${categoryName}" /> 노트</p>
                        <form id="filterForm" action="list.do" method="get">
                            <select name="category_idx" class="filter_select" onchange="$('#filterForm').submit();">
                                <option value="0" ${currentCategory == 0 ? 'selected' : ''}>전체</option>
                                <c:forEach var="cat" items="${categoryList}">
                                    <option value="${cat.category_idx}" ${currentCategory == cat.category_idx ? 'selected' : ''}>
                                        <c:out value="${cat.c_name}" />
                                    </option>
                                </c:forEach>
                            </select>
                        </form>
                    </div>

                    <div class="line"></div>

                    <div id="list-container">
                        <div id="note-list">
                            <c:if test="${not empty list}">
                                <c:forEach var="note" items="${list}">
                                    <div class="full-post" onclick="location.href='postview.do?noteIdx=${note.note_idx}'">
                                        <div class="post-index">${note.note_idx}</div>
                                        <div class="post-title"><c:out value="${note.title}"/></div>
                                        <div class="post-author"><c:out value="${note.author_name}"/></div>
                                    </div>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty list}">
                                <p style="text-align:center; padding: 20px;">게시물이 없습니다.</p>
                            </c:if>
                        </div>
                        
                        <div id="search_bar">
	                        <form id="searchForm" action="list.do" method="get">
	                             <input type="hidden" name="category_idx" value="${currentCategory}">
	                             <select name="searchType" class="searchInput">
	                                 <option value="title" ${searchType == 'title' ? 'selected' : ''}>제목</option>
	                                 <option value="author" ${searchType == 'author' ? 'selected' : ''}>작성자</option>
	                                 <option value="title_content" ${searchType == 'title_content' ? 'selected' : ''}>제목+내용</option>
	                             </select>
	                             <input type="text" class="searchInput" name="keyword" value="<c:out value='${keyword}'/>" placeholder="검색어 입력"/>
	                             <button type="submit" class="searchBtn">검색</button>
	                        </form>
	                    </div>
    
                        <div class="pagination" id="pagination-container">
                             <c:if test="${result.prev}">
                                <a href="list.do?page=${result.startPage - 1}&size=${result.pageSize}&category_idx=${currentCategory}&searchType=${searchType}&keyword=${keyword}">&laquo;</a>
                            </c:if>
                            <c:forEach begin="${result.startPage}" end="${result.endPage}" var="p">
                                <c:choose>
                                    <c:when test="${p == result.currentPage}">
                                        <strong>${p}</strong>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="list.do?page=${p}&size=${result.pageSize}&category_idx=${currentCategory}&searchType=${searchType}&keyword=${keyword}">${p}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            <c:if test="${result.next}">
                                <a href="list.do?page=${result.endPage + 1}&size=${result.pageSize}&category_idx=${currentCategory}&searchType=${searchType}&keyword=${keyword}">&raquo;</a>
                            </c:if>
                        </div>
                    
                    </div>

                </div>
            </section>
        </div>
    </div>
</div>

<script>
$(function() {
    function loadContent(url) {
        $.ajax({
            url: url,
            type: 'GET',
            cache: false,
            success: function(html) {
                // 서버에서 렌더링된 HTML 조각으로 컨테이너를 교체
                var newContent = $(html).find('#list-container').html();
                $('#list-container').html(newContent);
            },
            error: function() {
                alert('콘텐츠를 불러오는 중 오류가 발생했습니다.');
            }
        });
    }

    // 카테고리 변경 시 (폼 제출은 onchange가 처리)

    // 검색 폼 제출
    $('#searchForm').on('submit', function(e) {
        e.preventDefault();
        var url = 'list.do?' + $(this).serialize();
        loadContent(url);
    });

    // 페이지네이션 링크 클릭
    $(document).on('click', '#pagination-container a', function(e) {
        e.preventDefault();
        var url = $(this).attr('href');
        loadContent(url);
    });
});
</script>

</body>
</html>