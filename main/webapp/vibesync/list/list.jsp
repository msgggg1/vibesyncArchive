<%@page import="mvc.domain.BoardVO"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.util.DBConn"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	String sql = " SELECT title, note_idx "
				+ " FROM note ";
	ResultSet rs = null;
	
	String title;
	int note_idx;
	
	BoardVO vo = null;
	ArrayList<BoardVO> list = null;
	Iterator<BoardVO> ir = null;
	
	 try{
		   conn = DBConn.getConnection();
		   pstmt = conn.prepareStatement(sql);
		   rs = pstmt.executeQuery();
		   if( rs.next() ){
			   list = new ArrayList<>();
			   do{
				   
				   	title = rs.getString("title");
					note_idx = rs.getInt("note_idx");
				   	vo = new BoardVO().builder()
							.title(title).note_idx(note_idx)
							.build(); 
				    /* vo = new BoardVO(); // builder 말고 이 방식 추천 (JSP 호환성 ↑)
				    vo.setTitle(title);
				    vo.setNote_idx(note_idx); */
				    
				   /*  vo = new BoardVO(note_idx, title); */
				    
				   list.add(vo);
				   
			   }while( rs.next() );
		   } // if
	   }catch(Exception e){
		   e.printStackTrace();
	   }finally{
		   try{
			 rs.close();
			 pstmt.close();  
		     DBConn.close(); 
		   }catch(Exception e){
			   e.printStackTrace();
		   }
	   } // try 
	   
	   %>   
	   
	         	
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>list</title>

  <link rel="stylesheet" href="../css/style.css">
  <script defer src="../js/script.js"></script>
</head>
<body>
  <div id="notion-app">
    <input type="hidden" id="mode" value="board">
    <div class="notion-app-inner">
      <button id="toggle-btn"></button>
      <!-- sidebar -->
      <nav class="notion-sidebar-container" id="sidebar">
        <div class="notion-sidebar">
          <div class="menu_content">

            <a class="nickname icon_wrap" href="./user.html">
              <span>Duck Hammer</span>
            </a>

            <div class="search icon_wrap">
              <img src="./sources/icons/search.svg" alt="search icon" class="sidebar_icon">
              <input type="text" class="search-input" placeholder="Search…">
            </div>

            <a href="./main.html" class="home icon_wrap">
              <img src="./sources/icons/home.svg" alt="" class="sidebar_icon">
              <span>HOME</span>
            </a>

            <a href="./workspace.html" class="workspace icon_wrap">
              <img src="./sources/icons/work.svg" alt="" class="sidebar_icon">
              <span>WORKSPACE</span>
            </a>

            <div id="follow">
              <div class="follow_list">
                <div class="follow_tag icon_wrap">
                  <img src="./sources/icons/follow.svg" alt="follow icon" class="sidebar_icon">
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
            <a href="#"><img src="./sources/icons/arrow_back.svg" alt="arrow_back"></a>
          </div>
          
          <!-- top -->
          <div id="board_all">
            <div class="board_info">
              <p>Title</p>
            </div>
  
            <div class="line"></div>
  
            <div id="board_list">
              <section id="page-board-full" class="page">
                <div class="full-list subfont" id="full-list">
                  <!-- Dummy 게시글이 JS를 통해 동적으로 채워집니다. -->
                  
                </div>
                <div class="pagination" id="pagination" style="font-weight: bold;">
                  <!-- 페이지네이션 컨트롤이 JS를 통해 생성됩니다. -->
                </div>
              </section>
            </div>
          </div>
        </section>
      </div>
    </div>
  </div>
  
<script>
loadFullBoardData(10); 
function loadFullBoardData(maxPage) {
  const posts = [];
 <% 
  for (BoardVO item : list ) {
  %>
		posts.push({id:<%= item.getNote_idx() %>, title:"<%=item.getTitle() %>"});
	<%
		}
  	%> 
  	

  const postsPerPage = maxPage;
  let currentPage = 1;
  const totalPages = Math.ceil(posts.length / postsPerPage);
  const fullListEl = document.getElementById('full-list');
  const paginationEl = document.getElementById('pagination');
  
  function renderPage(page) {
    currentPage = page;
    fullListEl.innerHTML = '';
    const start = (page - 1) * postsPerPage;
    const end = start + postsPerPage;
    const pagePosts = posts.slice(start, end);
    
    pagePosts.forEach(post => {
      const postDiv = document.createElement('div');
      postDiv.className = 'full-post';
      postDiv.setAttribute('data-post-id', post.id);
      postDiv.innerHTML = `<div class="post-index">\${post.id}</div><div class="post-title">\${post.title}</div>`;
      fullListEl.appendChild(postDiv);
    });
    renderPagination();
  }
  
  function renderPagination() {
    paginationEl.innerHTML = '';
  
    // "<<" First-page button
    const firstBtn = document.createElement('button');
    firstBtn.classList.add('subfont');
    firstBtn.textContent = '<<';
    // hide on first page
    firstBtn.style.display = currentPage === 1 ? 'none' : '';
    firstBtn.addEventListener('click', () => renderPage(1));
    paginationEl.appendChild(firstBtn);
  
    // Prev button
    const prevBtn = document.createElement('button');
    prevBtn.classList.add('subfont');
    prevBtn.textContent = 'prev';
    prevBtn.disabled = currentPage === 1;
    prevBtn.style.display = currentPage === 1 ? 'none' : '';
    prevBtn.addEventListener('click', () => {
      if (currentPage > 1) renderPage(currentPage - 1);
    });
    paginationEl.appendChild(prevBtn);
  
    // Page-number buttons (window of 5)
    const pageGroupSize = 5;
    const groupStart = Math.floor((currentPage - 1) / pageGroupSize) * pageGroupSize + 1;
    const groupEnd = Math.min(groupStart + pageGroupSize - 1, totalPages);
    for (let i = groupStart; i <= groupEnd; i++) {
      const pageBtn = document.createElement('button');
      pageBtn.textContent = i;
      if (i === currentPage) {
        pageBtn.disabled = true;
        pageBtn.style.fontWeight = 'bold';
        pageBtn.style.fontSize = '18px';
      }
      pageBtn.addEventListener('click', () => renderPage(i));
      paginationEl.appendChild(pageBtn);
    }
  
    // Next button
    const nextBtn = document.createElement('button');
    nextBtn.classList.add('subfont');
    nextBtn.textContent = 'next';
    nextBtn.disabled = currentPage === totalPages;
    nextBtn.style.display = currentPage === totalPages ? 'none' : '';
    nextBtn.addEventListener('click', () => {
      if (currentPage < totalPages) renderPage(currentPage + 1);
    });
    paginationEl.appendChild(nextBtn);
  
    // ">>" Last-page button
    const lastBtn = document.createElement('button');
    lastBtn.classList.add('subfont');
    lastBtn.textContent = '>>';
    // hide on last page
    lastBtn.style.display = currentPage === totalPages ? 'none' : '';
    lastBtn.addEventListener('click', () => renderPage(totalPages));
    paginationEl.appendChild(lastBtn);
  }
  
  renderPage(1);
}
</script>
</body>
</html>