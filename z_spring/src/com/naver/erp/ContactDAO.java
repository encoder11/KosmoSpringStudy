package com.naver.erp;

import java.util.*;

//DAO인터페이스 선언
public interface ContactDAO {
	
	//검색한 게시판 목록 리턴하는 메소드
	List<Map<String,String>> getContactList(ContactSearchDTO contactSearchDTO);
	
	//검색한 게시판 목록 개수 리턴하는 메소드
	int getContactListAllCnt(ContactSearchDTO contactSearchDTO);
	
	int insertContact(ContactDTO contactDTO);
	
	int insertSkills(ContactDTO contactDTO);
	
	int goDelContact(ContactDTO contactDTO);
	
	int goUpContact(ContactDTO contactDTO);
}
