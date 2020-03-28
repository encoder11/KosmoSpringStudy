package com.naver.erp;

import java.util.*;

import javax.servlet.http.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

//가상 URL주소로 접속하여 호출되는 메소드를 소유한 [컨트롤러 클래스] 선언
	//@Controller를 붙임으로써 [컨트롤러 클래스] 임을 지정한다.

@Controller
@ControllerAdvice
public class LoginController {
	
	//속성변수 loginService를 선언하고, @Autowired에 의해 LoginService라는 인터페이스를 구현한 클래스를 객체화하여 저장한다.
	//이때 LoginService라는 인터페이스를 구현한 클래스의 이름을 몰라도 관계없다. 1개 존재하기만 하면 된다.
	@Autowired
	private LoginService loginService;
	
	//------------------------------------
	// 가상주소 /z_spring/loginForm.do 로 접근하면 호출되는 메소드 선언
	//------------------------------------
	@RequestMapping(value="/loginForm.do")
	public ModelAndView loginForm() {
		
		//[ModelAndView 객체] 생성하기
		//[ModelAndView 객체] 에 [호출할 JSP 페이지명]을 저장하기
		//[ModelAndView 객체] 리턴하기
		ModelAndView mav = new ModelAndView();
    	mav.setViewName("loginForm.jsp");
    	return mav;
    }
   
   //-----------------------
   //가상주소 /z_spring/loginProc.do 로 접근하면 호출되는 메소드 선언 메소드 호출 후 아이디 암호의 존재개수를 리턴하도록 설정한다.
   //아이디 암호의 존재개수를 리턴하도록 설정한다.
   //-----------------------
   @RequestMapping(
         value="/loginProc.do"                			//접속하는 클의 URL 주소 설정
         ,method=RequestMethod.POST           		    //접속하는 클의 파값 전송 방법
         ,produces="application/json;charset=UTF-8"		//응당할 데이터 종류 json 설정
   )
   		//method를 풀시 post, get방식 둘다 쓸수있게된다.
   @ResponseBody //비동기방식으로 들어온것이며 HTML소스가 아닌 DB연동의 결과물을 얻고 싶을때 메소드 위에 설정한다.
   public int loginProc(
		   //admin_id라는 파라미터명에 해당하는 파라미터값을 저장할 매개변수 admin_id 선언
		   @RequestParam(value="admin_id") String admin_id
		   //pwd라는 파라미터명에 해당하는 파라미터값을 저장할 매개변수 pwd 선언
		   ,@RequestParam(value="pwd") String pwd
		   //is_login이라는 파라미터명에 해당하는 파라미터값을 저장할 매개변수 is_login 선언
		   ,@RequestParam(value="is_login", required=false) String is_login
		   //HttpSession 객체의 메위주를 받아오는 매개변수 선언
		   ,HttpSession session
		   //HttpServletResponse 객체가 들어올 매개변수 선언
		   ,HttpServletResponse response
		   //@RequestParam Map<String, String> paramMap
		   //String admin_id, String pwd
		   ) {
	   /*
	   System.out.println("admin_id =>"+admin_id);
	   System.out.println("pwd =>"+pwd);
	   */
	   //매개변수에 저장된 파라미터값(즉 아이디,암호)을 HashMap에 저장하기
	   //이렇게 한 군데에 모으는 이유는 서비스 클래스에게 전달할 때 하나로 단일화하기 위함이다.
	   Map<String, String> map = new HashMap<String, String>();
	   map.put("admin_id", admin_id);
	   map.put("pwd", pwd);
	   /*
	   System.out.print("admin_id2 =>"+paramMap.get("admin_id"));
	   System.out.print("pwd2 =>"+paramMap.get("pwd"));
	   */
	   
	   //로그인 아이디, 암호의 존재 개수를 저장하는 변수 선언하기
	   int admin_idCnt = 0;
	   try {

		   //서비스클래스의 메소드를 호출하여 admin 테이블에 존재하는 로그인 아이디의 존재 개수 얻기
		   admin_idCnt = this.loginService.getAdminCnt(map);

		   //LoginServiceImpl loginServiceImpl = new LoginServiceImpl();
		   //admin_idCnt = loginServiceImpl.getAdminCnt(map);
		   
		   //만약 로그인 아이디의 존재 개수가 1이면(즉, 로그인이 성공했으면)HttpSession객체에 로그인 아이디 저장하기
		   if(admin_idCnt==1) {
			   //HttpSession객체에 키값"admin_id"로 아이디를 저장해 놓는다.
			   session.setAttribute("admin_id", admin_id);
			   
			   /*
			   [아이디, 암호 저장 의사]가 있으면
			   쿠키를 생성하고 쿠키명-쿠키값을["admin_id"-"입력아이디"]로 하고 수명은 60*60*24로 하기 그리고 이 쿠키를 HttpServletResponse객체에 저장하기
			   쿠키를 생성하고 쿠키명-쿠키값을["pwd"-"입력암호"]로 하고 수명은 60*60*24로 하기 그리고 이 쿠키를 HttpServletResponse객체에 저장하기
			   HttpServletResponse객체에 저장된 쿠키는 클라이언트에게 전송된다.
			   */
			   if(is_login!=null) {
				   Cookie cookie1 = new Cookie("admin_id", admin_id);
				   cookie1.setMaxAge(60*60*24);
				   response.addCookie(cookie1);
				   Cookie cookie2 = new Cookie("pwd", pwd);
				   cookie2.setMaxAge(60*60*24);
				   response.addCookie(cookie2);
			   }
			   /*
			   [아이디, 암호 저장 의사]가 없을 경우
			   쿠키를 생성하고 쿠키명-쿠키값을["admin_id"-"null"]로 하고 수명은 0로 하기 그리고 이 쿠키를 HttpServletResponse객체에 저장하기
			   쿠키를 생성하고 쿠키명-쿠키값을["pwd"-"null"]로 하고 수명은 0로 하기 그리고 이 쿠키를 HttpServletResponse객체에 저장하기
			   HttpServletResponse객체에 저장된 쿠키는 클라이언트에게 전송된다.
			   */
			   else {
				   Cookie cookie1 = new Cookie("admin_id", null);
				   cookie1.setMaxAge(0);
				   response.addCookie(cookie1);
				   Cookie cookie2 = new Cookie("pwd", null);
				   cookie2.setMaxAge(0);
				   response.addCookie(cookie2);
			   }
		   }
		   System.out.println("<접속성공> [접속URL]->/loginProc.do [호출메소드]->LoginController.loginProc(~) \n");
	   }catch(Exception e) {
			System.out.println("<접속실패> [접속URL]->/loginProc.do [호출메소드]->LoginController.loginProc(~) \n");
			admin_idCnt = -1;
		}
	   //admin 테이블에 존재하는 로그인 아이디의 존재 개수 리턴하기
	   return admin_idCnt;
   }
   
   //가상주소 /z_spring/logout.do 로 접근하면 호출되는 메소드 선언
   		//두분류로 온다
   			//-boardListForm 등 로그인 이후에 들어갈수있는 URL주소를 로그인없이 들어가는경우
   			//-로그아웃 버튼을 누른경우
   @RequestMapping(value="/logout.do")
   public ModelAndView logout(
	   //[HttpSession 객체]의 메위주가 저장된 매개변수 선언
	   HttpSession session
	) {
	   //HttpSession 객체에 저장된 로그인 아이디, uri키값으로 저장된 데이터, boardSearchDTO로 저장된 데이터 삭제하기
	   session.removeAttribute("admin_id");
	   session.removeAttribute("uri");
	   session.removeAttribute("boardSearchDTO");
	   	//<참고>HttpSession객체에 저장된 모든 데이터 제거하기
	   	//session.invalidate();
	   //[ModelAndView 객체] 생성하기
	   //[ModelAndView 객체] 에 [호출할 JSP 페이지명]을 저장하기
	   //[ModelAndView 객체] 리턴하기
	   ModelAndView mav = new ModelAndView();
	   mav.setViewName("logout.jsp");
	   System.out.println("<접속성공> [접속URL]->/logout.do [호출메소드]->LoginController.logout(~) \n");
	   return mav;
   }
   
   //현재 이 [Controller 클래스] 내의 @RequestMapping이 붙은 메소드 호출 시 예외 발생하면 호출되는 메소드 선언
   		//@ExceptionHandler(Exception.class)를 붙여야하며 리턴되는 문자열은 호출 JSP페이지명이다
   @ExceptionHandler(Exception.class)
   public String handleException(
		   HttpServletRequest request
	 ) {
	   System.out.println("handleException 발생");
	   return "logout.jsp";
   }
}
