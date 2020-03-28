<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- JSP 기술의 한 종류인 [Page Directive]를 이용하여 현 JSP페이지 처리 방식 선언하기 -->
<!-- 현재 이 JSP페이지 실행 후 생성되는 문서는 HTML이고, 이 문서는 UTF-8 방식으로 인코딩한다 라고 설정함 / 현재 이 JSP페이지는 UTF-8방식으로 인코딩 한다 -->
<!-- UTF-8 인코딩 방식은 한글을 포함 전 세계 모든 문자열을 부호화할수 있는 방법이다. -->


<!-- ================================================================== -->
<!-- JSP 페이지에서 사용할 [사용자 정의 태그]인 [JSTL 의 C 코어 태그] 선언 -->
<!-- ================================================================== -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- JSP 페이지에서 사용할 [사용자 정의 태그]인 [spring 폼 태그]선언 -->
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>


<!-- JSTL의 C코어 태그를 사용하여 변수들을 선언하기 -->
<!-- 변수 thColor1 선언하고 문자열 "#eaeaea" 저장하기 -->
<c:set var="thColor1" value="#eaeaea"/>
<!-- 변수 headerColor 선언하고 문자열 "#cecece" 저장하기 -->
<c:set var="headerColor" value="#cecece"/>

<!-- 변수 oddTrColor 선언하고 문자열 "white" 저장하기 -->
<c:set var="oddTrColor" value="white"/>
<!-- 변수 evenColor 선언하고 문자열 "#EBF0F4" 저장하기 -->
<c:set var="evenColor" value="#EBF0F4"/>
<!-- 변수 mouseOverColor 선언하고 문자열 "#CCE1FF" 저장하기 -->
<c:set var="mouseOverColor" value="#CCE1FF"/>

<c:set var="bodyBgColor1" value="lightblue"/>
<c:set var="bodyBgColor1" value="#f6f6f6"/>
<c:set var="bodyBgColor1" value="#F9F9FF"/>

<c:set var="ctRoot" value="/z_spring"/>

<!-- CSS, JQuery 라이브러리 파일 수입 -->
<link href="${ctRoot}/resources/common.css" rel="stylesheet" type="text/css">
<script src="${ctRoot}/resources/jquery-1.11.0.min.js"></script>
<script src="${ctRoot}/resources/common.js?a=<%=Math.random()%>"></script>   <!-- math함수를 써서 새로운 URL주소 처럼 보이게 편법을 쓴다. -->

<script>
$(document).ready(function(){
	if( location.href.indexOf("loginForm.do")<0 )
	$("body").prepend("<center><input type=button value='로그아웃' onclick=\"location.replace('/z_spring/logout.do')\"></center>");
	
	//웹브라우저 화면의 배경색을 지정하기
	$("body").attr("bgcolor", "${bodyBgColor1}");
});
function clickUpDelContact(){
	
}
</script>