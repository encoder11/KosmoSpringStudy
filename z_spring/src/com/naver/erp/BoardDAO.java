package com.naver.erp;

import java.util.*;

//DAO인터페이스 선언
public interface BoardDAO {
	
	//검색한 게시판 목록 리턴하는 메소드
	List<Map<String,String>> getBoardList(BoardSearchDTO boardSearchDTO);
	
	//검색한 게시판 목록 개수 리턴하는 메소드
	int getBoardListAllCnt(BoardSearchDTO boardSearchDTO);
	
	//게시판 글 입력 후 입력 적용 행의 개수 리턴하는 메소드
	int insertBoard(BoardDTO boardDTO);
	
	//조회수 증가 하는 메소드
	int updateReadcount(int b_no);
	
	//1개의 게시판 정보를 리턴하는 메소드
	BoardDTO getBoardDTO(int b_no);
	
	//수정할 게시판의 존재 개수를 리턴하는 메소드 선언
	int updateBoard(BoardDTO boardDTO);
	//게시판 삭제 명령한 후 삭제 적용행의 개수를 리턴하는 메소드 선언
	int deleteBoard(BoardDTO boardDTO);
	//삭제or수정할 게시판의 존재 개수를 리턴하는 메소드 선언
	int getBoardCnt(BoardDTO boardDTO);
	//삭제or수정할 게시판의 비밀번호 존재 개수를 리턴하는 메소드 선언
	int getPwdCnt(BoardDTO boardDTO);
	//삭제할 게시판의 아들글 존재 개수를리턴하는 메소드 선언
	int getSonCnt(BoardDTO boardDTO);
	//삭제될 게시판 이후 글의 출력 순서번호를 1씩 감소 시킨 후 수정 적용행의 개수를 리턴하는 메소드 선언
	int downPrintNo(BoardDTO boardDTO);
	
	int updatePrintNo(BoardDTO boardDTO);
}
