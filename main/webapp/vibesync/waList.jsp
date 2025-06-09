<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    String contextPath = request.getContextPath(); // ex) "/MyApp"
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>User Page - Watch Party</title>
  <script>
    const CONTEXT_PATH = '<%= contextPath %>';
  </script>
  <link rel="icon" href="./sources/favicon.ico" />
  <script src="https://www.youtube.com/iframe_api"></script>
  <script defer src="./js/watchparty.js"></script>
  <style>
    /* 최소한의 스타일 */
    .tab-buttons { display: flex; gap: 1rem; margin-bottom: 1rem; }
    .tab-buttons button { padding: 0.5rem 1rem; cursor: pointer; }
    .tab-buttons button.active { background-color: #007bff; color: white; }
    #list-container, #host-container { border: 1px solid #ccc; padding: 1rem; min-height: 200px; }
    ul { list-style: none; padding: 0; }
    li { padding: 0.5rem; border-bottom: 1px solid #ddd; cursor: pointer; }
    li:hover { background-color: #f0f0f0; }
    #btn-add-video {
      position: absolute;
      top: 1rem;
      right: 1rem;
      font-size: 1.2rem;
      background: #28a745;
      color: white;
      border: none;
      border-radius: 4px;
      width: 32px;
      height: 32px;
      line-height: 32px;
      text-align: center;
      cursor: pointer;
      display: none; /* 기본 숨김 */
    }
  </style>
</head>
<body>

  <h1>Watch Party</h1>

  <!-- 탭 버튼 -->
  <div class="tab-buttons">
    <button id="btn-list">전체 영상 목록</button>
    <button id="btn-host">내가 올린 영상</button>
  </div>

  <!-- 전체 List -->
  <div id="list-container"></div>

  <!-- Host List (로그인 유저 본인이 올린 영상) -->
  <button id="btn-add-video">＋</button>
  <div id="host-container" style="display:none;">
  </div>
  
  <div id="add-modal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; 
                              background:rgba(0,0,0,0.5); z-index:1000;">
    <div id="add-modal-content" style="background:white; width:360px; padding:1rem; border-radius:8px;
                                       position:absolute; top:50%; left:50%; transform:translate(-50%,-50%);">
      <h2>새 WatchParty 추가</h2>
      <form id="add-form">
        <div style="margin-bottom:0.5rem;">
          <label for="wp-title">제목:</label><br/>
          <input type="text" id="wp-title" name="title" style="width:100%;" required />
        </div>
        <div style="margin-bottom:0.5rem;">
          <label for="wp-url">YouTube URL:</label><br/>
          <input type="text" id="wp-url" name="url" style="width:100%;" placeholder="https://youtu.be/..." required />
        </div>
        <div style="text-align:right;">
          <button type="button" id="add-cancel">취소</button>
          <button type="submit" id="add-submit">추가</button>
        </div>
      </form>
    </div>
  </div>
  

</body>
</html>