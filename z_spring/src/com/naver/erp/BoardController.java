package com.naver.erp;

import java.util.*;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class BoardController {
	
	//속성변수 boardService선언하고 [BoardService 인터페이스]를 구현받은 객체를 생성해 저장
	//관용적으로 [boardService 인터페이스]를 구현받은 객체명은 boardServiceImpl이다
	@Autowired
	private BoardService boardService;
	
	//이 주소로 들어오면 SessionInterceptor class안에 있는 preHandle메소드가 먼저 실행된다.
	@RequestMapping(value="/boardListForm.do")
	public ModelAndView getBoardList(
		//파라미터값이 저장되는 [BoardSearchDTO 객체]를 매개변수로 선언
			//[파라미터명]과 [BoardSearchDTO객체]의 [속성변수명]이 같으면 setter메소드가 작동되어 [파라미터값]이 [속성변수]에 저장된다.
			//[속성변수명]에 대응하는 [파라미터명]이 없으면 setter 메소드가 작동되지 않는다.
			//[속성변수명]에 대응하는 [파라미터명]이 있는데 [파라미터값]이 없으면 [속성변수]의 자료형에 관계 없이 무조건 null값이 저장된다.
				//이때 [속성변수]의 자료형이 기본형일 경우 null값이 저장될 수 없어 에러가 발생한다
				//이런 에러를 피하려면 파라미터값이 기본형이거나 속성변수의 자료형을 String으로 해야한다
				//이런 에러가 발생하면 메소드안의 실행구문은 하나도 실행되지 않음에 주의한다
		BoardSearchDTO boardSearchDTO
		
		//HttpSession 객체를 받아오는 매개변수 선언
		,HttpSession session
		
	) {
		/*
		String admin_id = (String)session.getAttribute("admin_id");
		if(admin_id==null) {
			ModelAndView mav = new ModelAndView();
			mav.setViewName("logout.jsp");
			return mav;
		}
		String pwd = (String)session.getAttribute("pwd");
		*/
		ModelAndView mav = new ModelAndView();
		mav.setViewName("boardListForm.jsp");
		try {
			
			//HttpSession 객체에 uri라는 키값으로 저장된 문자열 꺼내기
			String uri=(String)session.getAttribute("uri");
			//만약 꺼낸 문자열이 null이거나 boardListForm이라면 매개변수로 받은 BoardSearchDTO객체를 HttpSession객체에 boardSearchDTO라는 키값으로 저장하기
	        if(uri==null || uri.equals("boardListForm.do") ) {
	           session.setAttribute("boardSearchDTO", boardSearchDTO);
	        }
	        //만약 꺼낸 문자열이 null이 아니고 boardListForm도 아니라면 HttpSession객체에 boardSearchDTO라는 키값으로 저장된 놈 꺼내서 매개변수 boardSearchDTO에 저장하기
	        else {
	           boardSearchDTO=(BoardSearchDTO)session.getAttribute("boardSearchDTO");
	        }
	        //HttpSession객체에 uri라는 키값으로 boardListForm.do 문자열 저장하기
	        session.setAttribute("uri", "boardListForm.do");
			
			//[게시판 검색 개수] 얻기
				//BoardServiceImpl 객체 소유의 getBoardListAllCnt메소드 호출로 게시판 검색 개수를 얻기
			int boardListAllCnt = this.boardService.getBoardListAllCnt(boardSearchDTO);
			//System.out.println("boardListAllCnt => " + boardListAllCnt);
			
			//검색된 게시판 총 개수가 1개 이상일때 [선택된 페이지 번호] 보정하기
			//선택된 페이지 번호와 총개수 간의 관계가 이상할 경우가 있다
			//예) 총개수3개, 선택페이지번호 2페이지일 경우(단 보여질 행의 개수가 10개일때) = 모순이다.
			//2페이지라면 11~20행까지 짤라서 가져오란 이야기인데 현재 3행밖에 없어서 어떻게 가져오냐는 이야기이다.
			if(boardListAllCnt>0) {
				//선택한 페이지 번호 구하기
				int selectPageNo = boardSearchDTO.getSelectPageNo();
				//한 화면에 보여지는 행의 개수 구하기
				int rowCntPerPage = boardSearchDTO.getRowCntPerPage();
				//검색할 시작행 번호 구하기
				int beginRowNo = (selectPageNo*rowCntPerPage-rowCntPerPage+1);
				//만약 검색한 총 개수가 검색할 시작행 번호보다 작으면 선택한페이지 번호를 1로 세팅하기
				if(boardListAllCnt<beginRowNo) boardSearchDTO.setSelectPageNo(1);
			}
			/*  //직접 짠 코드
			int startNum = ( boardSearchDTO.getSelectPageNo()*boardSearchDTO.getRowCntPerPage()-boardSearchDTO.getRowCntPerPage()+1 );
			if(boardListAllCnt<startNum) {
				boardSearchDTO.setSelectPageNo(1);
			}
			*/
			//[검색된 게시판 목록] 얻기
			List<Map<String,String>> boardList = this.boardService.getBoardList(boardSearchDTO);
			//System.out.println("boardList.size() => " + boardList.size() );
			
			//ModelAndView객체에 검색 개수, 게시판 검색 목록 저장하기
			//ModelAndView객체에 저장된 DB연동 결과물은 JSP페이지에서 EL문법으로 꺼낼수있다 -> ${저장키값명}
			//ModelAndView객체에 addObject로 저장한 데이터는 JSP페이지에서 꺼내 쓰기 위함
			mav.addObject("boardList", boardList);
			mav.addObject("boardListAllCnt", boardListAllCnt);
		}catch(Exception e){
			//try구문에서 예외가 발생하면 실행할 구문 설정
			System.out.println("<에러발생>");
		}
		
		//[ModelAndView] 객체 리턴하기
		return mav;
	}
	@RequestMapping(value="/boardRegForm.do")
	public ModelAndView goBoardRegForm(/*@RequestParam(value="b_no") int b_no*/) {
		
		//[ModelAndView 객체] 생성하기
		//[ModelAndView 객체]에 [호출 JSP 페이지명]을 저장하기
		ModelAndView mav = new ModelAndView();
		mav.setViewName("boardRegForm.jsp");
		//mav.addObject(b_no);
		//System.out.println(boardDTO.getB_no() + "REG");
		

		//[ModelAndView 객체] 리턴하기
		return mav;
	}
	
	///boardRegProc.do로 접근하면 호출되는 메소드 선언
	@RequestMapping(
			value="/boardRegProc.do"
			,method=RequestMethod.POST
			,produces="application/json;charset=UTF-8"
		)
	@ResponseBody
	public int insertBoard(
			//파라미터값을 저장할 [Board DTO객체]를 매개변수로 선언
			BoardDTO boardDTO
	){
		//[게시판 입력 적용행의 개수] 저장할 변수 선언
		System.out.println("99");
		int boardRegCnt = 0;
		try {
			//[BoardServiceImpl 객체]의 insertBoard 메소드 호출로 게시판 입력하고 [게시판 입력 적용행의 개수] 얻기
			boardRegCnt = this.boardService.insertBoard(boardDTO);
		}catch(Exception e) {
			System.out.println("<에러발생>");
			boardRegCnt= -1;
		}
		return boardRegCnt;
		
	}
	
	// /boardContentForm.do 접속 시 호출되는 메소드 선언
	@RequestMapping( value="/boardContentForm.do" )
	//GET, POST다 허락할시 method값을 안쓰면 된다.
	public ModelAndView goBoardContentForm(
			//b_no라는 파라미터명에 해당하는 파라미터값이 저장되는 매개변수 b_no 선언
			//관용적으로 하라미터명과 하라미터값의 스펠링은 동일하게 준다.
			//게시판 PK번호가 매개변수로 들어옴으로 매개변수 자료형은 int로 한다.(String으로 받아도 문제 없다)
			@RequestParam(value="b_no") int b_no
			,HttpSession session) {
		
		//[ModelAndView 객체] 생성하기
		//[ModelAndView 객체]에 [호출 JSP 페이지명]을 저장하기
		ModelAndView mav = new ModelAndView();
		mav.setViewName("boardContentForm.jsp");
		
		try {
			session.setAttribute("uri", "boardContentForm.do");
			//[BoardServiceImpl 객체]의 getBoardDTO 메소드 호출로 1개의 게시판 글을 BoardDTO객체에 담아오기
			BoardDTO boardDTO = this.boardService.getBoardDTO(b_no);
			//[ModelAndView 객체]에 1개의 게시판 글을 담고 있는 BoardDTO객체 저장하기
			mav.addObject("boardDTO", boardDTO);
		}catch(Exception e) {
			System.out.println("goBoardContentForm <에러발생>");
		}
		
		//[ModelAndView 객체] 리턴하기
		return mav;
	}
	
	// /boardUpDelForm.do 접속시 호출되는 메소드 선언
	@RequestMapping( value="/boardUpDelForm.do" )
	public ModelAndView goBoardUpDelForm(
			//b_no라는 파라미터명의 파라미터값이 저장되는 매개변수 b_no 선언
			@RequestParam(value="b_no") int b_no
			,HttpSession session
		) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("boardUpDelForm.jsp");
		try {
			
			session.setAttribute("uri", "boardUpDelForm.do");
			
			//[수정/삭제할 1개의 게시판 글 정보] 얻기
			//[BoardServiceImpl 객체]의 getBoardDTO_without_upReadcount 메소드를 호출하여 얻는다.
			BoardDTO boardDTO = this.boardService.getBoardDTO_without_upReadcount(b_no);
			mav.addObject("boardDTO", boardDTO);
			System.out.println("<접속성공> [접속URL]->/boardUpDelForm.do [호출메소드]->BoardController.goBoardUpDelForm(~) \n\n\n");
		}catch(Exception e) {
			System.out.println("<접속실패> [접속URL]->/boardUpDelForm.do [호출메소드]->BoardController.goBoardUpDelForm(~) \n\n\n");
		}
		return mav;
	}
	

	@RequestMapping(
			value="/boardUpDelProc.do"
			,method=RequestMethod.POST
			,produces="application/json;charset=UTF-8"
			)
	@ResponseBody
	public int goBoardUpDelProc(
				@RequestParam(value="upDel") String upDel
				,BoardDTO boardDTO
			) {

		//수정 or 삭제 적용행의 개수가 저장되는 변수선언.
		int boardUpDelCnt = 0;
		
		try {
			
			//만약 수정 모드이면 수정 실행하고 수정 적용행의 개수를 저장
			if(upDel.equals("up")){
				boardUpDelCnt = this.boardService.updateBoard(boardDTO);
			}
			//만약 삭제 모드이면 수정 실행하고 삭제 적용행의 개수를 저장
			else if(upDel.equals("del")){
				boardUpDelCnt = this.boardService.deleteBoard(boardDTO);
			}
			
		}catch(Exception e) {
			System.out.println("오류 발생");
		}
		return boardUpDelCnt;
	}
}
