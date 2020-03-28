package com.naver.erp;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class ContactServiceImpl implements ContactService{
	
	@Autowired
	private ContactDAO ContactDAO;
	
	//[검색한 게시판 목록]리턴하는 메소드 선언
	public List<Map<String, String>> getcontactList(ContactSearchDTO contactSearchDTO){
		
		List<Map<String,String>> contactList = this.ContactDAO.getContactList(contactSearchDTO);
		
		return contactList;	
	}
	
	//[검색한 게시판 목록 개수]리턴하는 메소드 선언
	public int getcontactListAllCnt(ContactSearchDTO contactSearchDTO){
		
		//[BoardDAO 인터페이스]를 구현한 객체의 getBoardListAllCnt 메소드를 호출하여 [검색한 게시판 목록 개수]를 얻는다
		//[검색한 게시판 목록 개수]를 리턴받는다
		int contactListAllCnt = this.ContactDAO.getContactListAllCnt(contactSearchDTO);
		
		//[검색한 게시판 목록 개수]를 리턴한다
		return contactListAllCnt;
	}

	public int insertContact(ContactDTO contactDTO) {
		
		int contactRegCnt = this.ContactDAO.insertContact(contactDTO);

		int skillsCnt = this.ContactDAO.insertSkills(contactDTO);
		
		return contactRegCnt;
	}
	
	public int goUpContact(ContactDTO contactDTO) {
		int delContactCnt = this.ContactDAO.goDelContact(contactDTO);
		return delContactCnt;
	}
	
	public int goDelContact(ContactDTO contactDTO) {
		int upContactCnt = this.ContactDAO.goUpContact(contactDTO);
		return upContactCnt;
	}
	
}
