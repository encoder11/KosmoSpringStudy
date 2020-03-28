package com.naver.erp;

import java.util.*;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

//DAO클래스 인 BoardDAOImpl 클래스 선언
	//@Repository를 붙임으로써 [DAO 클래스]임을 지정하게되고, bean태그로 자동 등록된다.
@Repository
public class BoardDAOImpl implements BoardDAO{
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	//검색한 게시판 목록 리턴하는 메소드 선언
	public List<Map<String,String>> getBoardList(BoardSearchDTO boardSearchDTO){
		
		List<Map<String,String>> boardList = this.sqlSession.selectList(
				"com.naver.erp.BoardDAO.getBoardList"			//실행할 SQL구문의 위치 지정
				,boardSearchDTO									//실행할 SQL구문에서 사용할 데이터 지정
				);
		return boardList;
		
	}
	
	//검색한 게시판 목록 개수 리턴하는 메소드 선언
	public int getBoardListAllCnt(BoardSearchDTO boardSearchDTO) {

		int boardListAllCnt = this.sqlSession.selectOne(
				"com.naver.erp.BoardDAO.getBoardListAllCnt"		//실행할 SQL구문의 위치 지정
				,boardSearchDTO									//실행할 SQL구문에서 사용할 데이터 지정
				);

		return boardListAllCnt;
	}
	
	public int insertBoard(BoardDTO boardDTO) {
		//[SqlSessionTemplate 객체]의 insert(~,~)를 호출하여[게시판 글 입력 후 입력 적용 행의 개수]얻기
		//int insert("쿼리문설정 XML 파일 안에 mapper 태그의 namespace 속성값.insert태그 id 속성값"
		//			,insert 쿼리에 삽입되는 외부 데이터 자료형)
		/*
		int boardRegCnt = 0 ;
		if(boardDTO.getB_no()>0) {
			boardRegCnt = sqlSession.insert(
					"com.naver.erp.BoardDAO.reInsertBoard"
					,boardDTO
				);
					
		}else {
			if(boardDTO.getB_no()==0) {
				boardRegCnt = sqlSession.insert(
							"com.naver.erp.BoardDAO.insertBoard"
							,boardDTO
						);
			}
		}
		*/
		int boardRegCnt = sqlSession.insert(
				"com.naver.erp.BoardDAO.insertBoard"
				,boardDTO
			);
		return boardRegCnt;
	}
	
	//[1개 게시판 글 정보]리턴하는 메소드 선언
	public BoardDTO getBoardDTO(int b_no) {
		//[SqlSessionTemplate 객체]의 selectOne(~,~)을 호출하여 [1개 게시판 글 정보] 얻기
		BoardDTO boardDTO = this.sqlSession.selectOne(
					"com.naver.erp.BoardDAO.getBoardDTO"
					,b_no
				);
		return boardDTO;
	}
	
	
	//[게시판 글 조회수 증가하고 수정행의 개수]리턴하는 메소드 선언
	public int updateReadcount(int b_no) {
		//[SqlSessionTemplate 객체]의 update(~,~)를 호출하여 [조회수 증가]하기
		int readcount = this.sqlSession.update(
					"com.naver.erp.BoardDAO.updateReadcount"
					,b_no
				);
		return readcount;
	}
	
	
	public int deleteBoard(BoardDTO boardDTO) {
		
		int deleteCnt = this.sqlSession.delete(
					"com.naver.erp.BoardDAO.deleteBoard"
					,boardDTO
				);
		return deleteCnt;
	}
	
	public int updateBoard(BoardDTO boardDTO) {
		int updateCnt = this.sqlSession.update(
				"com.naver.erp.BoardDAO.updateBoard"
				,boardDTO
			);
		return updateCnt;
	}
	
	public int getBoardCnt(BoardDTO boardDTO) {
		int boardCnt = this.sqlSession.selectOne(
				"com.naver.erp.BoardDAO.getBoardCnt"
				,boardDTO);
		return boardCnt;
	}

	public int getPwdCnt(BoardDTO boardDTO) {
		int pwdCnt = this.sqlSession.selectOne(
				"com.naver.erp.BoardDAO.getPwdCnt"
				,boardDTO);
		return pwdCnt;
	}

	public int getSonCnt(BoardDTO boardDTO) {
		int sonCnt = this.sqlSession.selectOne(
				"com.naver.erp.BoardDAO.getSonCnt"
				,boardDTO);
		return sonCnt;
	}
	public int downPrintNo(BoardDTO boardDTO) {
		int downPrintNoCnt = this.sqlSession.update(
				"com.naver.erp.BoardDAO.downPrintNo"
				,boardDTO);
		return downPrintNoCnt;
	}

	public int updatePrintNo(BoardDTO boardDTO) {
		int updatePrint_NoCnt = this.sqlSession.update(
				"com.naver.erp.BoardDAO.updatePrintNo"
				,boardDTO);
		return updatePrint_NoCnt;
	}
	
	
	
	
	
	
	
}
