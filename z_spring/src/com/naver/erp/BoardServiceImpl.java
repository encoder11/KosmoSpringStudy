package com.naver.erp;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class BoardServiceImpl implements BoardService{
	
	@Autowired
	private BoardDAO boardDAO;
	
	//[검색한 게시판 목록]리턴하는 메소드 선언
	public List<Map<String, String>> getBoardList(BoardSearchDTO boardSearchDTO){
		
		List<Map<String,String>> boardList = this.boardDAO.getBoardList(boardSearchDTO);
		
		return boardList;	
	}
	
	//[검색한 게시판 목록 개수]리턴하는 메소드 선언
	public int getBoardListAllCnt(BoardSearchDTO boardSearchDTO){
		
		//[BoardDAO 인터페이스]를 구현한 객체의 getBoardListAllCnt 메소드를 호출하여 [검색한 게시판 목록 개수]를 얻는다
		//[검색한 게시판 목록 개수]를 리턴받는다
		int boardListAllCnt = this.boardDAO.getBoardListAllCnt(boardSearchDTO);
		
		//[검색한 게시판 목록 개수]를 리턴한다
		return boardListAllCnt;
	}

	public int insertBoard(BoardDTO boardDTO) {
		
		//댓글일 경우 게시판의 출력순서 번호를 1씩 증가 수정하고 수정 적용행의 개수 리턴하기.
		if(boardDTO.getB_no()>0) {
			//[BoardDAOImpl]객체의 updatePrintNo 메소드를 호출하여 출력 순서 번호를 1증가시키고 수정행에 적용 개수를 리턴받는다
			//게시판 글이 입력되는 부분 이후 글들은 출력 순서번호를 1씩 증가하여야한다.
			int updatePrintNoCnt = this.boardDAO.updatePrintNo(boardDTO);
		}
		//1개 게시판 글 입력 후 입력 적용 행의 개수 리턴하기
			//[BoardDTO 인터페이스]를 구현한 객체의 insertBoard 메소드를 호출하여 1개 게시판 글 입력 후 입력 적용 행의 개수를 리턴받는다
		int boardRegCnt = this.boardDAO.insertBoard(boardDTO);
		
		return boardRegCnt;
	}
	
	public BoardDTO getBoardDTO(int b_no) {
		//[BoardDAOImlp 객체]의 updateReadcount메소드를 호출하여 [조회수 증가]하고 수정한 행의 개수를 얻는다
		int readcount = this.boardDAO.updateReadcount(b_no);
		
		//[BoardDAOImpl 객체]의 getBoardDTO 메소드를 호출하여 [1개 게시판 글]을 얻는다
		BoardDTO boardDTO = this.boardDAO.getBoardDTO(b_no);
		
		//[1개 게시판 글]이 저장된 BoardDTO 객체 리턴하기
		return boardDTO;
	}
	
	//조회수 증가 없이 [1개 게시판 글] 리턴하는 메소드 선언
	public BoardDTO getBoardDTO_without_upReadcount(int b_no) {
		
		//[BoardDAO 인터페이스]를 구현한 객체의 getBoardDTO메소드를 호출하여 조회수 증가 없이 [1개 게시판 글]을 얻는다
		BoardDTO boardDTO = this.boardDAO.getBoardDTO(b_no);
		
		//[1개 개시판 글]이 저장된 BoardDTO 객체 리턴하기.
		return boardDTO;
	}
	
	//[1개 게시판]삭제 후 삭제 적용행의 개수를 리턴하는 메소드 선언
	public int deleteBoard(BoardDTO boardDTO) {
		
		//[boardDAOImpl]객체의 getBoardCnt 메소드를 호출하여 삭제할 게시판의 존재 개수를 얻는다.
		int boardCnt = this.boardDAO.getBoardCnt(boardDTO);
		if(boardCnt==0) return -1;
		
		//[boardDAOImpl]객체의 getPwdCnt 메소드를 호출하여 삭제할 게시판의 비밀번호 존재 개수를 얻는다.
		int pwdCnt = this.boardDAO.getPwdCnt(boardDTO);
		if(pwdCnt==0) return -2;

		//[boardDAOImpl]객체의 getSonCnt 메소드를 호출하여 삭제할 게시판의 아들글 존재 개수를 얻는다.
		int sonCnt = this.boardDAO.getSonCnt(boardDTO);
		if(sonCnt>0) return -3;
		
		//[BoardDAOImpl]객체의 upPrintNo메소드를 호출하여 삭제될 게시판 이후 글의 출력 순서번호를 1씩 감소 시킨 후 수정 적용행의 개수를 얻는다.
		int downPrintNoCnt = this.boardDAO.downPrintNo(boardDTO);
		
		//[boardDAOImpl]객체의 updateBoard 메소드를 호출하여 게시판 삭제 명령한 후 삭제 적용행의 존재 개수를 얻는다.
		int boardUpDelCnt = this.boardDAO.deleteBoard(boardDTO);
		
		return boardUpDelCnt;
	}

	//[1개 게시판]수정 후 수정 적용행의 개수를 리턴하는 메소드 선언
	public int updateBoard(BoardDTO boardDTO) {
		
		//[boardDAOImpl]객체의 getBoardCnt 메소드를 호출하여 수정할 게시판의 존재 개수를 얻는다.
		int boardCnt = this.boardDAO.getBoardCnt(boardDTO);
		if(boardCnt==0) return -1;

		//[boardDAOImpl]객체의 getPwdCnt 메소드를 호출하여 수정할 게시판의 비밀번호 존재 개수를 얻는다.
		int pwdCnt = this.boardDAO.getPwdCnt(boardDTO);
		if(pwdCnt==0) return -2;

		//[boardDAOImpl]객체의 updateBoard 메소드를 호출하여 게시판 수정 명령한 후 수정 적용행의 존재 개수를 얻는다.
		int updateCnt = this.boardDAO.updateBoard(boardDTO);
		
		return updateCnt;
	}
	
}
