package com.naver.erp;

import java.util.*;

public interface BoardService {
	List<Map<String,String>> getBoardList(BoardSearchDTO boardSearchDTO);
	
	int getBoardListAllCnt(BoardSearchDTO boardSearchDTO);
	
	int insertBoard(BoardDTO boardDTO);
	
	BoardDTO getBoardDTO(int b_no);
	
	BoardDTO getBoardDTO_without_upReadcount(int b_no);
	
	int updateBoard(BoardDTO boardDTO);
	
	int deleteBoard(BoardDTO boardDTO);
}
