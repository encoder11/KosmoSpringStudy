<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*"%>
<!-- JSP 기술의 한 종류인 [Page Directive]를 이용하여 현 JSP페이지 처리 방식 선언하기 -->

<!-- 현재 이 JSP페이지 실행 후 생성되는 문서는 HTML이고, 이 문서는 UTF-8 방식으로 인코딩한다 라고 설정함 / 현재 이 JSP페이지는 UTF-8방식으로 인코딩 한다 -->
<!-- UTF-8 인코딩 방식은 한글을 포함 전 세계 모든 문자열을 부호화할수 있는 방법이다. -->
<!DOCTYPE html>
<!-- JSP기술의 한 종류인 [Include Directive]를 이용하여 common.jsp 파일 내의 소스를 삽입하기 -->
<!-- 유일하게 WEB-INF 루트 경로를 쓸수 있다. -->
<%@ include file="/WEB-INF/views/common.jsp" %>


<!-- 로그인 화면 구성하는 HTML태그 코딩하기 -->
<html>
<head>
<meta charset="UTF-8">

	<title>새글쓰기</title>


<script>
	
	function checkContactRegForm(){
		
		//alert($('[name=contactRegForm]').serialize()); return;
		
		$.ajax({
			//접속할 서버쪽 URL 주소 설정
			url : "/z_spring/contactRegProc.do"
			//전송 방법 설정
			, type : "post"
			//서버로 보낼 파라미터명과 파라미터값을 설정
			, data : $('[name=contactRegForm]').serialize()
			//서버의 응답을 성공적으로 받았을 경우 실행할 익명함수 설정.
			//매개변수 boardRegCnt에는 입력 행의 개수가 들어온다.
			, success : function(contactRegCnt){
				//[게시판 입력 행 적용 개수]가 1개면(=insert가 한번 성공했다는 뜻)
				if(contactRegCnt==1){
					alert("연락처 등록 성공!");
					//location.replace();
				}
				//[게시판 새 글 입력 행 적용 개수]가 1개가 아니면 경고하기
				else{
					alert("연락처 등록 실패! 관리자에게 문의 바람.");
				}
			}
			//서버의 응답을 못 받았을 경우 실행할 익명함수 설정
			, error : function(){
				alert("서버 접속 실패");
			}
		});
	}
	
</script>
</head>
<body><center><br><br><br>
	<form method="post" name="contactRegForm" action="/z_spring/contactRegProc.do">

		<b>새글쓰기</b>

		<br>
		<table class="tbcss1" border=1 bordercolor=gray cellspacing=0 cellpadding=5 align=center>
			<tr>
				<th bgcolor="gray">연락처명
				<td><input type="text" size="10" maxlength="10" name="contact_name">
			<tr>
				<th bgcolor="gray">전화번호
				<td><input type="text" size="40" maxlength="50" name="phone">
			<tr>
				<th bgcolor="gray">사업분야
				<td>
					<input type="checkbox" name="skills" value="IT">IT
					<input type="checkbox" name="skills" value="통신">통신
					<input type="checkbox" name="skills" value="금융">금융
					<input type="checkbox" name="skills" value="건설">건설
					<input type="checkbox" name="skills" value="유통">유통
					<input type="checkbox" name="skills" value="전자">전자
					<input type="checkbox" name="skills" value="전기">전기
					<input type="checkbox" name="skills" value="기타">기타
		</table>
		<input type="button" value="저장" onclick="checkContactRegForm()">
		<input type="reset" value="다시작성">
		<input type="button" value="목록보기" onclick="location.replace('/z_spring/contactListForm.do')">
	</form>
</body>
</html>