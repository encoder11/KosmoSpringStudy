package com.naver.erp;

import java.util.Map;

//로그인 관련 메소드 이름을 제공하는 [DAO인터페이스]선언
public interface LoginDAO {
	//[로그인 아이디, 암호 존재 개수] 검색 메소드 선언
	public int getAdminCnt(Map<String, String> admin_id_pwd);
}
