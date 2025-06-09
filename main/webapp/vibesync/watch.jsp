
<%@page import="mvc.domain.vo.WatchPartyVO"%>
<%@page import="mvc.persistence.dao.WatchPartyDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String contextPath = request.getContextPath();

    // 1) 파라미터로 전달된 watchPartyIdx를 가져옴
    String strIdx = request.getParameter("watchPartyIdx");
    int watchPartyIdx = Integer.parseInt(strIdx);

    // 2) DAO를 통해 해당 WatchParty 정보(제목, video_id 등)를 가져옴
    WatchPartyDAO wpDao = new WatchPartyDAO();
    WatchPartyVO wp = wpDao.selectOne(watchPartyIdx);
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Watch Party - <%= wp.getTitle() %></title>
  <link rel="icon" href="./sources/favicon.ico" />
  <style>
    body { font-family: Arial, sans-serif; width: 100%; height: 100vh; margin: 0;}
    h1 {margin: 0; height: 10%;}
    section.container {height: 90%; display: flex; justify-content: center; align-items: center;}
    .videowrapper {flex: 7; height: 100%; display: flex; flex-direction: column; gap: 20px;}
    .chatting-wrapper {flex: 2; height: 100%;} 
    #video-container { text-align: center; width: 100%; height: 90%;}
    iframe {width: 100%; height: 100%;}
    #chat-container { border: 1px solid #ccc; height: 83%; overflow-y: scroll; padding: 0.5rem; margin-bottom: 30px;}
    #chat-input { width: calc(100% - 110px); padding: 0.5rem; }
    #send-btn { width: 80px; padding: 0.5rem; }
    #status { margin-top: 0.5rem; font-size: 0.9rem; color: gray; }
    #sync-button {
      margin-top: 1rem;
      padding: 0.5rem 1rem;
      background-color: #28a745;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
    #sync-status-message {
      margin-top: 0.5rem;
      color: #d9534f; /* 빨간색 경고 메시지 */
    }
  </style>
</head>
<body>
  <h1><%= wp.getTitle() %></h1>

  <section class="container">
    <!-- 영상 재생 영역 -->
    <div class="videowrapper">
      <div id="video-container">
        <iframe id="youtube-player"
                src="https://www.youtube.com/embed/<%= wp.getVideoId() %>?enablejsapi=1"
                frameborder="0"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                allowfullscreen>
        </iframe>
      </div>
      
      <button id="sync-button">Sync</button>
      <div id="sync-status-message"></div>
    </div>
  
    <div class="chatting-wrapper">
      <!-- 채팅 + 동기화 상태 영역 -->
      <div id="status">동기화 상태: <span id="sync-status">연결 중...</span></div>
      <div id="chat-container"></div>
      <div>
        <input type="text" id="chat-input" placeholder="메시지를 입력하세요..." />
        <button id="send-btn">전송</button>
      </div>
    </div>
  </section>

  <!-- YouTube IFrame API 로드 -->
  <script src="https://www.youtube.com/iframe_api"></script>
  <!-- watch.jsp 전용 JS -->
  <script>
    // JSP 표현식으로 서버 변수 주입
    const CONTEXT_PATH   = '<%= contextPath %>';
    const watchPartyIdx  = <%= watchPartyIdx %>;
    const hostIdx        = '<%= wp.getHost() %>';

    let player, wsSync, wsComment;
    let playState       = false;   // DB 기준 현재 play 상태 저장
    let latestTimeline  = 0.0;
    let isSynced        = false;   // <<<<< 수정: 최초 Sync 버튼 클릭 여부 판단

    // 1) YouTube IFrame API 준비
    function onYouTubeIframeAPIReady() {
      player = new YT.Player('youtube-player', {
        events: {
          onReady: onPlayerReady,
          onStateChange: onPlayerStateChange
        }
      });
    }

    // 2) 플레이어 준비 완료 시: 마지막 동기화 상태 가져오기
    function onPlayerReady(event) {
      connectWebSocket();
      fetch(`<%= contextPath %>/GetSyncStatusServlet?watchPartyIdx=<%= watchPartyIdx %>`)
      .then(res => res.json())
      .then(data => {
        playState = (data.play === "PLAY");
        latestTimeline = data.timeline;
        if (playState) {
          // PLAY 상태라면 사용자에게 안내만 하고 실제 재생은 Sync 버튼 후에 이루어짐
          document.getElementById('sync-status-message').textContent =
            '호스트가 재생 중입니다. Sync 버튼을 눌러주세요.';
        } else {
          document.getElementById('sync-status-message').textContent = '';
        }
      })
      .catch(err => console.error(err));
    }

    // 3) 플레이어 상태 변경 시: wasync 테이블 업데이트 제거
    function onPlayerStateChange(event) {
      if (!isSynced) return; // <<<<< 수정: 최초 Sync가 되기 전에는 stateChange 무시
      if (event.data === YT.PlayerState.PLAYING || event.data === YT.PlayerState.PAUSED) {
        const timeline = player.getCurrentTime();
        const playStr = (event.data === YT.PlayerState.PLAYING) ? "PLAY" : "PAUSE";
        const syncMsg = JSON.stringify({
          type: "sync",
          watchPartyIdx: watchPartyIdx,
          timeline: timeline,
          play: playStr
        });
        wsSync.send(syncMsg);
      } else if (event.data === YT.PlayerState.ENDED) {
        stopPeriodicSync();
      }
    }

    // 4) WebSocket 연결 함수
    function connectWebSocket() {
      // 4-1) 재생 동기화 WS
     wsSync = new WebSocket("ws://" + location.host + CONTEXT_PATH + "/waSyncEndpoint");
	 console.log(wsSync)
      wsSync.onopen = () => {
	   	  const initMsg = JSON.stringify({
	   	      type: "initSync",
	   	      watchPartyIdx: watchPartyIdx
	   	  });
	   	  wsSync.send(initMsg);
      };
      wsSync.onmessage = (event) => {
          const msg = JSON.parse(event.data);
          console.log("wsSync : " + msg);
          if (msg.type === "sync" && msg.watchPartyIdx === watchPartyIdx) {
            latestTimeline = msg.timeline;
            playState = (msg.play === "PLAY");
            if (isSynced) {
              if (playState) {
                // player.seekTo(latestTimeline, true);
                player.playVideo();
              } else {
                player.pauseVideo();
              }
            }
          }
        };

      // 4-2) 채팅 WS
      wsComment = new WebSocket("ws://" + location.host + CONTEXT_PATH + "/waCommentEndpoint");
      console.log(wsComment)
      wsComment.onopen = () => {
        const initMsg = JSON.stringify({
          type: "initComment",
          watchPartyIdx: watchPartyIdx
        });
        wsComment.send(initMsg);
      };
      wsComment.onmessage = (event) => {
        const msg = JSON.parse(event.data);
        console.log(msg);
        if (msg.type === "comment") {
          appendChat(msg.nickname, msg.chatting, msg.timeline, msg.timestamp);
        } else if (msg.type === "initCommentList") {
          msg.comments.forEach(c => {
            appendChat(c.nickname, c.chatting, c.timeline, c.createdAt);
          });
        }
      };

      // 5) 채팅 전송 버튼 이벤트
      document.getElementById("send-btn").addEventListener("click", () => {
        const input = document.getElementById("chat-input");
        const text = input.value.trim();
        if (text === "") return;
        const currentTime = player.getCurrentTime();
        const nickname = "익명";
        const chatMsg = JSON.stringify({
          type: "comment",
          watchPartyIdx: watchPartyIdx,
          nickname: nickname,
          chatting: text,
          timeline: currentTime
        });
        wsComment.send(chatMsg);
        input.value = "";
      });
    }
    
    // 6) Sync 버튼 클릭 핸들러
    document.getElementById("sync-button").addEventListener("click", () => {
      // 6-1) DB에서 최신 상태를 다시 가져옴
      fetch(`<%= contextPath %>/GetSyncStatusServlet?watchPartyIdx=<%= watchPartyIdx %>`)
      .then(res => res.json())
      .then(data => {
        playState = (data.play === "PLAY");
        latestTimeline = data.timeline;
        if (playState) {
          // 6-2) playState가 true일 때만 영상을 latestTimeline부터 재생
          player.seekTo(latestTimeline, true);
          player.playVideo();
          isSynced = true;              // <<<<< 수정: 최초 Sync가 완료됨을 표시
          document.getElementById("sync-status-message").textContent = '';
        } else {
          document.getElementById("sync-status-message").textContent = '아직 재생 중이 아닙니다.';
        }
      })
      .catch(err => {
        console.error(err);
        document.getElementById("sync-status-message").textContent =
          '동기화 상태를 가져오는 중 오류가 발생했습니다.';
      });
    });

    // 7) 채팅 메시지를 화면에 추가하는 헬퍼 함수
    function appendChat(nick, text, timeline, timestamp) {
      const chatContainer = document.getElementById("chat-container");
      const p = document.createElement("p");
      const timeLabel = formatTime(timeline);
      p.innerHTML = "<strong>[" + timeLabel + "] " + nick + ":</strong> " + text;
      chatContainer.appendChild(p);
      chatContainer.scrollTop = chatContainer.scrollHeight;
    }

    // 시간(초)을 mm:ss 형태로 변환
    function formatTime(sec) {
      const m = Math.floor(sec / 60);
      const s = Math.floor(sec % 60);
      return (m < 10 ? "0" + m : m) + ":" + (s < 10 ? "0" + s : s);
    }
  </script>
</body>
</html>
