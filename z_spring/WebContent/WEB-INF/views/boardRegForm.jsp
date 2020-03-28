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


<c:if test="${param.b_no>0}">
	<title>답글쓰기</title>
</c:if>
<c:if test="${empty param.b_no}">
	<title>새글쓰기</title>
</c:if>

<script>

	//[게시판 등록 화면]에 입력된 데이터의 유효성 체크 함수 선언
	function checkBoardRegForm(){
		
		if( is_empty('[name=writer]') ){
			alert("이름을 입력해주세요.");
			$("[name=writer]").focus();
			return;
		}
		if( is_empty('[name=subject]') ){
			alert("제목을 입력해주세요.");
			$("[name=subject]").focus();
			return;
		}
		if( is_empty('[name=email]') ){
			alert("이메일을 입력해주세요.");
			$("[name=email]").focus();
			return;
		}
		if( is_empty('[name=content]') ){
			alert("내용을 입력해주세요.");
			$("[name=content]").focus();
			return;
		}
		if( is_empty('[name=pwd]') ){
			alert("암호를 입력해주세요.");
			$("[name=pwd]").focus();
			return;
		}
		
		if( is_valid_email("[name=email]")==false ){
			alert("이메일 형식을 벗어납니다.");
			return;
		}
		
		if( is_valid_pattern("[name=pwd]", /^[0-9]{4}$/)==false ){
			alert("암호는 숫자 4개를 입력해주세요");
			return;
		}
		if(confirm("정말 저장하시겠습니까?")==false){return;}
		
		//alert("${(param.b_no)?0:param.b_no}")
		//var str = $('[name=boardRegForm]').serialize()+"&b_no="+${param.b_no};
		
		//현재 화면에서 페이지 이동 없이 서버쪽 "/z_spring/boardRegProc.do"를 호출하여 게시판 글을 입력하고 [게시판 입력 행 적용 개수]를 받기
		$.ajax({
			//접속할 서버쪽 URL 주소 설정
			url : "/z_spring/boardRegProc.do"
			//전송 방법 설정
			, type : "post"
			//서버로 보낼 파라미터명과 파라미터값을 설정
			, data : $('[name=boardRegForm]').serialize()
			//서버의 응답을 성공적으로 받았을 경우 실행할 익명함수 설정.
			//매개변수 boardRegCnt에는 입력 행의 개수가 들어온다.
			, success : function(boardRegCnt){
				//[게시판 입력 행 적용 개수]가 1개면(=insert가 한번 성공했다는 뜻)
				if(boardRegCnt==1){
					alert("게시판 글 등록 성공!");
					//location.replace();
				}
				//[게시판 새 글 입력 행 적용 개수]가 1개가 아니면 경고하기
				else{
					alert("게시판 글 등록 실패! 관리자에게 문의 바람.");
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
	<form method="post" name="boardRegForm" action="/z_spring/boardRegProc.do">
		
		<!-- 파라미터명이 b_no인 파라미터값을 저장할 hidden태그 선언 -->
		<!-- 댓글 쓸경우 b_no라는 파라미터명에는 엄마글의 글번호가 들어온다. -->
		<input type="hidden" name="b_no" value="${(empty param.b_no)?0:param.b_no}">
		
		<!-- 커스텀태그의 일종인 JSTL C코어 태그를 사용하여 파라미터명이 b_no인 파라미터값이 비어있으면 새글쓰기 값이 있으면 댓글쓰기 출력하기 -->
		<c:if test="${param.b_no>0}">
			<b>답글쓰기</b>
		</c:if>
		<c:if test="${empty param.b_no}">
			<b>새글쓰기</b>
		</c:if>
		<%--  위 코딩과 동일한 효과를 내는 C코어 태그의 조건식이다.
		<c:choose>
			<c:when test="${param.b_no eq 0}">
				<b>[새글쓰기]</b><br>
			</c:when>
			<c:otherwise>
				<b>[답글쓰기]</b><br>
			</c:otherwise>
		</c:choose>
		--%>
		<br>
		<table class="tbcss1" border=1 bordercolor=gray cellspacing=0 cellpadding=5 align=center>
			<tr>
				<th bgcolor="gray">이 름
				<td><input type="text" size="10" maxlength="10" name="writer">
			<tr>
				<th bgcolor="gray">제 목
				<td><input type="text" size="40" maxlength="50" name="subject">
			<tr>
				<th bgcolor="gray">이메일
				<td><input type="text" size="40" maxlength="30" name="email">
			<tr>
				<th bgcolor="gray">내용
				<td><textarea name="content" rows="13" cols="40" maxlength="500" ></textarea>
			<tr>
				<th bgcolor="gray">비밀번호
				<td><input type="password" size="8" maxlength="4" name="pwd">
		</table>
		<input type="button" value="저장" onclick="checkBoardRegForm()">
		<input type="reset" value="다시작성">
		<input type="button" value="목록보기" onclick="location.replace('/z_spring/boardListForm.do')">
	</form>
</body>
</html>