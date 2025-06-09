<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%>
<%@page import="mvc.domain.vo.NoteVO"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="mvc.domain.vo.CategoryVO"%>
<%@page import="com.util.DBConn"%>
<%@page import="mvc.domain.vo.UserVO"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.Objects"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// session에서 로그인된 회원 이메일 정보 얻어오기
	String loggedInUserEmail = Objects.toString(session.getAttribute("loggedInUserEmail"), "");

	// DB에서 정보 불러오기
    Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String sql = null;

	// 회원
	UserVO uvo = null;
	
	// 카테고리
	ArrayList<CategoryVO> clist = null;
	Iterator<CategoryVO> cir = null;
	CategoryVO cvo = null;
	
	// 게시글
	Map<Integer, ArrayList<NoteVO>> nmap = new LinkedHashMap<Integer, ArrayList<NoteVO>>();
	Set<Entry<Integer, ArrayList<NoteVO>>> nset = null; // nmap.entrySet();
	Iterator<Entry<Integer, ArrayList<NoteVO>>> nsir = null; // nset.iterator();
	ArrayList<NoteVO> nlist = null;
	Iterator<NoteVO> nir = null;
	NoteVO nvo = null;
	
	try{
		
		conn = DBConn.getConnection();
		
		// userInfo : 회원정보
		if(session.getAttribute("userInfo")==null) {
			if(loggedInUserEmail.isEmpty()){ // 로그인이 되어있지 않을 때
				uvo = new UserVO().builder()
				 .nickname("Guest")
				 .img("guest_profile.jpg")
				 .category_idx(1)
				 .build();
			} else {
				// UserVO에 회원 정보 불러와서 브라우저(session)에 저장 : 닉네임, 선호 카테고리 등 파악 의도
				sql = "SELECT nickname, img, category_idx FROM userAccount WHERE email = ? ";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, loggedInUserEmail);
				rs = pstmt.executeQuery();
				
				if(rs.next()){
			String nickname = rs.getString("nickname");
			String img = rs.getString("img");
			int category_idx = rs.getInt("category_idx");
			
			uvo = new UserVO().builder()
							 .nickname(nickname)
							 .img(img)
							 .category_idx(category_idx)
							 .build();
			
			session.setAttribute("userInfo", uvo);
			
			rs.close();
			pstmt.close();
				}
			}
	
		} else {
			uvo = (UserVO) session.getAttribute("userInfo");
		}
		
		if(session.getAttribute("categoryInfo")==null){
			// Category 정보 브라우저(sessoion)에 저장 : 카테고리 index와 카테고리명 매치 목적
			sql = "SELECT category_idx, c_name, img FROM category ORDER BY category_idx ASC ";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()){
				clist = new ArrayList<CategoryVO>();
				do{
			int category_idx = rs.getInt("category_idx");
			String c_name = rs.getString("c_name");
			String img = rs.getString("img");
			
			cvo = new CategoryVO().builder()
								.category_idx(category_idx)
								.c_name(c_name)
								.img(img)
								.build();
			
			clist.add(cvo);
				} while(rs.next());
				
				session.setAttribute("categoryInfo", clist);
				
				rs.close();
				pstmt.close();
			}
		} else {
			clist = (ArrayList<CategoryVO>) session.getAttribute("categoryInfo");
		}
		
		// 카테고리별 인기 게시글 조회
		sql = " SELECT rnk.note_idx, n_orig.title, rnk.popularity_score, n_orig.img "
		+ " FROM ( "
	    + " 	SELECT "
	    + " 	n.note_idx, "
	    + " 	(COALESCE(COUNT(l.likes_idx), 0) + n.view_count) AS popularity_score, "
	    + " 	ROW_NUMBER() OVER (ORDER BY (COALESCE(COUNT(l.likes_idx), 0) + n.view_count) DESC, n.create_at DESC) AS rn "
	    + " 	FROM note n LEFT JOIN likes l ON n.note_idx = l.note_idx "
	    + " 	WHERE n.category_idx = ? "
	    + " 	GROUP BY n.note_idx, n.view_count, n.create_at "
		+ " ) rnk JOIN note n_orig ON rnk.note_idx = n_orig.note_idx "
		+ " WHERE rnk.rn <= 5 "
		+ " ORDER BY rnk.rn ";
		
		for(int i = 0; i < clist.size(); i++){
			cvo = clist.get(i);
			int category_idx = cvo.getCategory_idx();
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, category_idx);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				nlist = new ArrayList<NoteVO>();
				do{
					int note_idx = rs.getInt("note_idx");
					String title = rs.getString("title");
					String img = rs.getString("img");
					
					nvo = new NoteVO().builder()
									  .note_idx(note_idx)
									  .title(title)
									  .img(img)
									  .build();
					nlist.add(nvo);
				} while(rs.next());
			
				nmap.put(category_idx, nlist);
				
				rs.close();
				pstmt.close();
			}
		}
		
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		if(rs != null) rs.close();
		if(pstmt != null) pstmt.close();
		DBConn.close();
	}
	
	request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>main</title>

  <!-- swiper -->
  <script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
  <link
    rel="stylesheet"
    href="https://unpkg.com/swiper/swiper-bundle.min.css"
  />
  <!-- css,js -->
  <link rel="stylesheet" href="../css/style.css">
  <script defer src="../js/script.js"></script>
  
</head>
<body>
  <div id="notion-app">
    <input type="hidden" id="mode" value="main">
    <div class="notion-app-inner">
      <button id="toggle-btn">☰</button>
      <!-- sidebar -->
      <nav class="notion-sidebar-container" id="sidebar">
        <div class="notion-sidebar">
          <div class="menu_content">

            <a class="nickname icon_wrap" href="../html/user.html">
              <span><%= uvo.getNickname() %></span>
            </a>

            <div class="search icon_wrap">
              <img src="../sources/icons/search.svg" alt="search icon" class="sidebar_icon">
              <input type="text" class="search-input" placeholder="Search…">
            </div>

            <a href="../html/main.html" class="home icon_wrap">
              <img src="../sources/icons/home.svg" alt="" class="sidebar_icon">
              <span>HOME</span>
            </a>

            <a href="../html/workspace.html" class="workspace icon_wrap">
              <img src="../sources/icons/work.svg" alt="" class="sidebar_icon">
              <span>WORKSPACE</span>
            </a>

            <div id="follow">
              <div class="follow_list">
                <div class="follow_tag icon_wrap">
                  <img src="../sources/icons/follow.svg" alt="follow icon" class="sidebar_icon">
                  <!-- label 클릭 시 체크박스 토글 -->
                  <label for="follow_toggle">FOLLOW</label>
                </div>
                <!-- 체크박스를 follow_items 형제 요소로 이동 -->
                <input type="checkbox" id="follow_toggle">
                <ul class="follow_items">
                  <li><a href="../html/postView.html">PostView</a></li>
                  <li><a href="../html/list.html">List</a></li>
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
  
          <!-- banner -->
          <div class="slider-container">
            <div class="swiper" id="swiper1">
              <div class="swiper-wrapper">
                <div class="swiper-slide">Card 1</div>
                <div class="swiper-slide">Card 2</div>
                <div class="swiper-slide">Card 3</div>
                <div class="swiper-slide">Card 4</div>
                <div class="swiper-slide">Card 5</div>
              </div>
              <div class="swiper-button-prev" id="prev"></div>
              <div class="swiper-button-next" id="next"></div>
            </div>
          </div>
  
          <!-- category btn -->
          <div class="category_btn_group">
          	<%
          	for (CategoryVO ca : clist) {
          		if(ca.getCategory_idx() != uvo.getCategory_idx()){
          		%>
          		<button style="background-image: url(../sources/button_bg/<%= ca.getImg() %>); background-size: cover;">
          			<p><%= ca.getC_name() %></p>
          		</button>
          		<%
          	
          		}
          	}
          	%>
          </div>
  
          <!-- grid -->
          <div class="grid_wrapper">
            <div class="grid_item">
            </div>
            <div class="grid_item">
            </div>
            <div class="grid_item">
            </div>
          </div>
  
          <!-- other category -->
          <div class="slider-container">
            <div class="swiper" id="swiper2">
              <div class="swiper-wrapper">
              	<%
              		nset = nmap.entrySet();
              		nsir = nset.iterator();
              		
              		while(nsir.hasNext()){
              			Entry<Integer, ArrayList<NoteVO>> en = nsir.next();
              			int userCategoryIdx = uvo.getCategory_idx();
              			if(!en.getKey().equals(userCategoryIdx)){
              				%>
              				<div class="swiper-slide">
	              				<ul>
	              				<%
	              				nlist = en.getValue();
	              				nir = nlist.iterator();
	              				while(nir.hasNext()){
	              					nvo = nir.next();
	              					%>
	              					<li>
	              					  <a>
	              						<div class="post-index" style="display: inline-block; align-self: left;"><%= nvo.getNote_idx() %></div>
		              					<div class="post-title" style="display: inline-block; align-self: right;"><%= nvo.getTitle() %></div>
	              					  </a>
	              					</li>
	              					<%
	              				}
	              				%>
	              				</ul>
              				</div>
              				<%
              			}
              		}
              	%>
              </div>
              <div class="swiper-button-prev" id="prev2"></div>
              <div class="swiper-button-next" id="next2"></div>
            </div>
          </div>
          
        </section>
      </div>

    </div>
  </div>
</body>
</html>