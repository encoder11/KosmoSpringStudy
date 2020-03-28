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
public class ContactController {
	
	//속성변수 boardService선언하고 [BoardService 인터페이스]를 구현받은 객체를 생성해 저장
	//관용적으로 [boardService 인터페이스]를 구현받은 객체명은 boardServiceImpl이다
	@Autowired
	private ContactService contactService;
	
	//이 주소로 들어오면 SessionInterceptor class안에 있는 preHandle메소드가 먼저 실행된다.
	@RequestMapping(value="/contactListForm.do")
	public ModelAndView getContactList(
		//파라미터값이 저장되는 [BoardSearchDTO 객체]를 매개변수로 선언
			//[파라미터명]과 [BoardSearchDTO객체]의 [속성변수명]이 같으면 setter메소드가 작동되어 [파라미터값]이 [속성변수]에 저장된다.
			//[속성변수명]에 대응하는 [파라미터명]이 없으면 setter 메소드가 작동되지 않는다.
			//[속성변수명]에 대응하는 [파라미터명]이 있는데 [파라미터값]이 없으면 [속성변수]의 자료형에 관계 없이 무조건 null값이 저장된다.
				//이때 [속성변수]의 자료형이 기본형일 경우 null값이 저장될 수 없어 에러가 발생한다
				//이런 에러를 피하려면 파라미터값이 기본형이거나 속성변수의 자료형을 String으로 해야한다
				//이런 에러가 발생하면 메소드안의 실행구문은 하나도 실행되지 않음에 주의한다
		ContactSearchDTO contactSearchDTO
		
		//HttpSession 객체를 받아오는 매개변수 선언
		,HttpSession session
		
	) {
		
		
		//String admin_id = (String)session.getAttribute("admin_id");
		//String pwd = (String)session.getAttribute("pwd");
		
		
		//System.out.println("pwd=="+pwd);
		
		//String admin_id = (String)session.getAttribute("admin_id");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("contactListForm.jsp");
		/*
		if(admin_id==null) {
			System.out.println("admin_id is null");
			mav = new ModelAndView();
			mav.setViewName("logout.jsp");
			return mav;
		} else {
			System.out.println("admin_id is not null");
		}
		*/
		
		try {
			
			/*
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
			*/
			//[게시판 검색 개수] 얻기
				//BoardServiceImpl 객체 소유의 getBoardListAllCnt메소드 호출로 게시판 검색 개수를 얻기
			int contactListAllCnt = this.contactService.getcontactListAllCnt(contactSearchDTO);
			//System.out.println("boardListAllCnt => " + boardListAllCnt);
			//검색된 게시판 총 개수가 1개 이상일때 [선택된 페이지 번호] 보정하기
			//선택된 페이지 번호와 총개수 간의 관계가 이상할 경우가 있다
			//예) 총개수3개, 선택페이지번호 2페이지일 경우(단 보여질 행의 개수가 10개일때) = 모순이다.
			//2페이지라면 11~20행까지 짤라서 가져오란 이야기인데 현재 3행밖에 없어서 어떻게 가져오냐는 이야기이다.
			
			
			/*
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
			*/
			/*  //직접 짠 코드
			int startNum = ( boardSearchDTO.getSelectPageNo()*boardSearchDTO.getRowCntPerPage()-boardSearchDTO.getRowCntPerPage()+1 );
			if(boardListAllCnt<startNum) {
				boardSearchDTO.setSelectPageNo(1);
			}
			*/
			//[검색된 게시판 목록] 얻기
			List<Map<String,String>> contactList = this.contactService.getcontactList(contactSearchDTO);
			
			//System.out.println("boardList.size() => " + boardList.size() );
			//ModelAndView객체에 검색 개수, 게시판 검색 목록 저장하기
			//ModelAndView객체에 저장된 DB연동 결과물은 JSP페이지에서 EL문법으로 꺼낼수있다 -> ${저장키값명}
			//ModelAndView객체에 addObject로 저장한 데이터는 JSP페이지에서 꺼내 쓰기 위함
			mav.addObject("contactList", contactList);
			mav.addObject("contactListAllCnt", contactListAllCnt);
			
		}catch(Exception e){
			//try구문에서 예외가 발생하면 실행할 구문 설정
			System.out.println("<에러발생>");
		}
		
		//[ModelAndView] 객체 리턴하기
		return mav;
	}

	@RequestMapping(value="/contactRegForm.do")
	public ModelAndView goContactRegForm(/*@RequestParam(value="b_no") int b_no*/) {
		
		//[ModelAndView 객체] 생성하기
		//[ModelAndView 객체]에 [호출 JSP 페이지명]을 저장하기
		ModelAndView mav = new ModelAndView();
		mav.setViewName("contactRegForm.jsp");
		//mav.addObject(b_no);
		//System.out.println(boardDTO.getB_no() + "REG");
		

		//[ModelAndView 객체] 리턴하기
		return mav;
	}
	@RequestMapping(
			value="/contactRegProc.do"
			,method=RequestMethod.POST
			,produces="application/json;charset=UTF-8"
		)
	@ResponseBody
	public int insertContact(
			//파라미터값을 저장할 [Board DTO객체]를 매개변수로 선언
			ContactDTO contactDTO
	){
		//[게시판 입력 적용행의 개수] 저장할 변수 선언
		int contactRegCnt = 0;
		try {
			//[BoardServiceImpl 객체]의 insertBoard 메소드 호출로 게시판 입력하고 [게시판 입력 적용행의 개수] 얻기
			contactRegCnt = this.contactService.insertContact(contactDTO);
		}catch(Exception e) {
			System.out.println("<연락처 추가 에러발생>");
			contactRegCnt= -1;
		}
		return contactRegCnt;
		
	}
	
	@RequestMapping(value="/contactUpDelProc.do")
	@ResponseBody
	public int upDelContact(
			ContactDTO contactDTO
			,@RequestParam(value="upDel") String upDel
		) {
		
		int contactUpDelCnt=0;
		
		try {
			if(upDel.equals("up")){
				contactUpDelCnt = this.contactService.goDelContact(contactDTO);
			}else if(upDel.equals("del")){
				contactUpDelCnt = this.contactService.goUpContact(contactDTO);
			}
		}catch(Exception e) {
			System.out.println("<수정,삭제 에러발생>");
			contactUpDelCnt= -1;
		}
		return contactUpDelCnt;
	}
}
