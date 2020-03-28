package com.naver.erp;

import java.util.*;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

//DAO클래스 인 BoardDAOImpl 클래스 선언
	//@Repository를 붙임으로써 [DAO 클래스]임을 지정하게되고, bean태그로 자동 등록된다.
@Repository
public class ContactDAOImpl implements ContactDAO{
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	//검색한 게시판 목록 리턴하는 메소드 선언
	public List<Map<String,String>> getContactList(ContactSearchDTO contactSearchDTO){
		
		List<Map<String,String>> contactList = this.sqlSession.selectList(
				"com.naver.erp.ContactDAO.getcontactList"			//실행할 SQL구문의 위치 지정
				,contactSearchDTO									//실행할 SQL구문에서 사용할 데이터 지정
				);
		return contactList;
		
	}
	
	//검색한 게시판 목록 개수 리턴하는 메소드 선언
	public int getContactListAllCnt(ContactSearchDTO contactSearchDTO) {

		int contactListAllCnt = this.sqlSession.selectOne(
				"com.naver.erp.ContactDAO.getContactListAllCnt"		//실행할 SQL구문의 위치 지정
				,contactSearchDTO									//실행할 SQL구문에서 사용할 데이터 지정
				);

		return contactListAllCnt;
	}
	public int insertContact(ContactDTO contactDTO) {
		int contactRegCnt = this.sqlSession.insert(
				"com.naver.erp.ContactDAO.insertContact"		
				,contactDTO	
				);
		
		
		return contactRegCnt;
	}
	public int insertSkills(ContactDTO contactDTO) {
		int skillsCnt = this.sqlSession.insert(
				"com.naver.erp.ContactDAO.insertSkills"		
				,contactDTO	
				);
		return skillsCnt;
	}

	public int goDelContact(ContactDTO contactDTO) {
		int delContact = this.sqlSession.delete(
				"com.naver.erp.ContactDAO.getDelCnt"
				,contactDTO
				);
		return delContact;
	}
	
	public int goUpContact(ContactDTO contactDTO) {
		int upContact = this.sqlSession.update(
				"com.naver.erp.ContactDAO.getUpCnt"
				,contactDTO
				);
		return upContact;
	}
}
