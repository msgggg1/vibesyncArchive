package com.listener;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import mvc.domain.vo.UserVO;

@WebListener
public class DuplicateLoginPreventer implements HttpSessionListener {

    // 로그인한 사용자들을 관리하는 전역 목록 (Key: 유저ID, Value: 세션 객체)
    // 여러 사용자가 동시에 접근할 수 있으므로 thread-safe한 ConcurrentHashMap 사용
    public static final Map<String, HttpSession> loginUsers = new ConcurrentHashMap<>();

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        // 세션이 소멸될 때(로그아웃, 타임아웃 등) 호출됨
        HttpSession destroyedSession = se.getSession();
        
        // loginUsers 맵을 뒤져서, 소멸된 세션과 같은 값을 가진 엔트리를 찾아서 제거
        // (세션에 저장된 userInfo에서 직접 키를 찾는 것이 더 효율적)
        synchronized (loginUsers) {
            UserVO user = (UserVO) destroyedSession.getAttribute("userInfo");
            if (user != null) {
                // 이 유저의 ID(이메일)를 키로 사용하여 맵에서 제거
                loginUsers.remove(user.getEmail());
                System.out.println("[DuplicateLoginPreventer] 세션 소멸, 사용자(" + user.getEmail() + ")를 로그인 목록에서 제거했습니다.");
            }
        }
    }
    
    @Override
    public void sessionCreated(HttpSessionEvent se) {
        // 세션 생성 시에는 특별히 할 일이 없음
    }
}