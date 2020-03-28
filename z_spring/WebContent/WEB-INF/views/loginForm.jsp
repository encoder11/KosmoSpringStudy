<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- JSP 기술의 한 종류인 [Page Directive]를 이용하여 현 JSP페이지 처리 방식 선언하기 -->

<!-- 현재 이 JSP페이지 실행 후 생성되는 문서는 HTML이고, 이 문서는 UTF-8 방식으로 인코딩한다 라고 설정함 / 현재 이 JSP페이지는 UTF-8방식으로 인코딩 한다 -->
<!-- UTF-8 인코딩 방식은 한글을 포함 전 세계 모든 문자열을 부호화할수 있는 방법이다. -->

<!-- JSP 기술의 한 종류인 [Page Directive]를 이용하여 common.jsp파일 내의 소스를 삽입하기-->
<%@ include file="/WEB-INF/views/common.jsp" %>
<c:if test="${!empty msg}">
	<script>
		alert("${msg}");
	</script>
	<c:remove var="msg" scope="session"/>
</c:if>
<!DOCTYPE html>
<!-- 로그인 화면 구성하는 HTML태그 코딩하기 -->
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<script>
	//body태그 안의 소스를 모두 실행한 후에 실행할 자스 코드 설정
	$(document).ready(function(){
		
		//개발상 편의를 위해 id, pwd입력. 개발 완료 후 삭제해야한다.
		//$(".admin_id").val("abc");
		//$(".pwd").val("123");
		
		//클라이언트가 보낸 쿠키를 관리하는 Cookies 객체에서 쿠키명 admin_id로 저장된 쿠키값을 꺼내어 name=admin_id를 가진 입력양식에 넣어주기
		inputData("[name=admin_id]", '${cookie.admin_id.value}');
		//클라이언트가 보낸 쿠키를 관리하는 Cookies 객체에서 쿠키명 pwd로 저장된 쿠키값을 꺼내어 name=pwd를 가진 입력양식에 넣어주기
		inputData("[name=pwd]", '${cookie.pwd.value}');
		
		//클라이언트가 보낸 쿠키를 관리하는 Cookies객체에 쿠키명 admin_id로 저장된 쿠키값이 있으면 [name=is_login]을 가진 입력 양식에 체크를 넣어주기
		<c:if test='${!empty cookie.admin_id.value}'>
			$("[name=is_login]").prop("checked", true);
		</c:if>
		
		//name=loginForm 가진 폼태그 안의 class=login 가진 태그에 click 이벤트 발생 시 실행할 코드 설정하기
		$("[name=loginForm] .login").click(function(){
			//아이디와 암호의 유효성 체크 할 함수 checkLoginForm()호출
			checkLoginForm();
		});
		
	});
	//로그인 정보 유효성 체크하고 비동기 방식으로 서버와 통신하여 로그인 정보와 암호의 존재 여부에 따른 자스 코딩 실행하기
	function checkLoginForm(){
		//alert("공부 열심히 해서 차사자~");
		
		/*
		//입력된 [아이디]를 가져와 변수에 저장
		var admin_id = $('.admin_id').val();
		//아이디를 입력 안했거나 공백이 있으면 아이디 입력란을 비우고 경고한 후 함수 중단
		if(admin_id.split(" ").join("")==""){
			alert("관리자 아이디 입력 요망");
			$('.admin_id').val("");
			return;
		}
		//입력된 [암호]를 가져와 변수 저장
		var pwd = $('.pwd').val();
		//암호를 입력 안했거나 공백이 있으면 암호 입력란을 비우고 경고하고 함수 중단
		if(pwd.split(" ").join("")==""){
			alert("관리자 암호 입력 요망");
			$('.pwd').val("");
			return;
		}
		*/
		//아이디를 입력 안했거나 공백이 있으면 아이디 입력란을 비우고 경고한 후 함수 중단
		if(is_empty(".admin_id")){
			alert("관리자 아이디 입력 요망");
			//class=admin_id를 가진 태그의 value값을 ""로 입력하기 - 공백이 있을 경우 공백을 제거하라는 의미이다.
			$('.admin_id').val("");
			return;
		}
		//암호를 입력 안했거나 공백이 있으면 암호 입력란을 비우고 경고하고 함수 중단
		if(is_empty(".pwd")){
			alert("관리자 암호 입력 요망");
			//class=pwd를 가진 태그의 value값을 ""로 입력하기 - 공백이 있을 경우 공백을 제거하라는 의미이다.
			$('.pwd').val("");
			return;
		}
		//alert( $("[name=loginForm]").serialize() );return; //-- 모든 파라미터명=파라미터값 으로 보여주는 메소드이다.
		
		//현재 화면에서 페이지 이동 없이(=비동기 방식으로) 서버쪽 loginnProc.do로 접속하여 아이디, 암호의 존재 개수를 얻기
		$.ajax({
			//서버 쪽 호출 URL 주소 지정
			url : "/z_spring/loginProc.do"
			//form 태그 안의 데이터 즉, 파라미터값을 보내는 방법 지정
			, type : "post"
			//서버로 보낼 파라미터명과 파라미터값을 설정
			, data : $("[name=loginForm]").serialize()
				//위는 아래 코딩처럼 가능
				//,data : {'admin_id':damin_id, 'pwd':pwd}
				//,data : "admin_id="+damin_id+"&pwd="+pwd}
			
			//서버의 응답을 성공적으로 받았을 경우 실행할 익명함수 설정
			//익명함수의 매개변수 data에는 서버가 응답한 데이터가 들어온다.
			//현재 data라는 매개변수에는 아이디,암호의 존재 개수가 들어온다.
			, success : function(admin_idCnt){
				//아이디 존재 개수가 1개면 /z_spring/boardList.do 로 이동
				if(admin_idCnt==1){
					//alert("로그인성공");
					//location.replace("/z_spring/boardListForm.do");
					location.replace("/z_spring/contactListForm.do");
				}
				else if(admin_idCnt==0){ alert("아이디, 암호가 존재하지 않습니다! 재입력 바랍니다."); }
				else{ alert("서버 오류 발생! 관리자에게 문의 바람!"); }
			}
			, error : function(){ alert("서버 접속 실패! 관리자에게 문의 바람!"); }
		});
	}
</script>
</head>
<body><center>
	<!-- [로그인 정보 입력 양식] 내포한 form 태그 선언 -->
	<form name="loginForm" method="post" action="/z_spring/boardListForm.do">
		<b>[로그인]</b>
		<div style="height:6"></div>
		<table class="tbcss1" boder=1 cellpadding=5>
			<tr>
				<th bgcolor="gray">아이디
				<td><input type="text" name="admin_id" class="admin_id" size="20">
			<tr>
				<th bgcolor="gray">암호
				<td><input type="password" name="pwd" class="pwd" size="20">
		</table>
		<div style="height:6"></div>
		<table><tr>
			<td><input type="button" value="로그인" class="login">
			<td><input type="checkbox" name="is_login" value="y">아이디,암호 기억
		</table>
	</form>
	<input type="button" value="    test    " onclick="location.replace('/z_spring/boardListForm.do')">
</body>
</html>