<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- JSP 기술의 한 종류인 [Page Directive]를 이용하여 현 JSP페이지 처리 방식 선언하기 -->

<!-- 현재 이 JSP페이지 실행 후 생성되는 문서는 HTML이고, 이 문서는 UTF-8 방식으로 인코딩한다 라고 설정함 / 현재 이 JSP페이지는 UTF-8방식으로 인코딩 한다 -->
<!-- UTF-8 인코딩 방식은 한글을 포함 전 세계 모든 문자열을 부호화할수 있는 방법이다. -->
<%@ include file="/WEB-INF/views/common.jsp" %>
<!DOCTYPE html>
<!-- 로그인 화면 구성하는 HTML태그 코딩하기 -->
<html>	<!-- math함수를 써서 새로운 URL주소 처럼 보이게 편법을 쓴다. -->
<head>
<meta charset="UTF-8">
<title>로그인</title>
<script>
	alert("로그인 화면으로 이동합니다!!!");
	location.replace("${ctRoot}/loginForm.do");
</script>
</head>
<body>

</body>
</html>