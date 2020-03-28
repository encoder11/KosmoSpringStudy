<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*"%>
<!-- JSP 기술의 한 종류인 [Page Directive]를 이용하여 현 JSP페이지 처리 방식 선언하기 -->

<!-- 현재 이 JSP페이지 실행 후 생성되는 문서는 HTML이고, 이 문서는 UTF-8 방식으로 인코딩한다 라고 설정함 / 현재 이 JSP페이지는 UTF-8방식으로 인코딩 한다 -->
<!-- UTF-8 인코딩 방식은 한글을 포함 전 세계 모든 문자열을 부호화할수 있는 방법이다. -->
<!DOCTYPE html>
<!-- JSP기술의 한 종류인 [Include Directive]를 이용하여 common.jsp 파일 내의 소스를 삽입하기 -->
<!-- 유일하게 WEB-INF 루트 경로를 쓸수 있다. -->
<%@ include file="/WEB-INF/views/common.jsp" %>


<!-- 만약에 상세보기할 게시판 글이 없으면 경고하고 이전 화면으로 이동하기 -->
<c:if test="${empty boardDTO}">
	<script>
		alert("게시글이 삭제되어있습니다!");
		location.replace("/z_spring/boardListForm.do");
	</script>
</c:if>

<!-- 로그인 화면 구성하는 HTML태그 코딩하기 -->
<html>
<head>
<meta charset="UTF-8">
<title>게시판상세보기</title>
<script>


	//게시판 댓글 화면으로 이동하는 함수 선언
	function goBoardRegForm(){
		/*
		var str = "b_no="+${boardDTO.b_no};
		//alert(str)
		location.replace("/z_spring/boardRegForm.do?"+str);
		*/
		document.boardRegForm.submit();
	}
	
	//게시판 수정 화면으로 이동하는 함수 선언
	function goBoardUpDelForm(){
		//name=boardUpDelForm을 가진 form 태그의 action 값의 URL로 서버에 접속하라
		document.boardUpDelForm.submit();
		
	}
	
	
</script>
</head>
<body><center><br><br><br>
	
	<!-- [1개의 게시판 내용]을 출력하고 게시판 등록 화면으로 이동하는 form 태그 선언 -->
	<!-- ModelAndView 객체에 boardDTO라는 키값으로 저장된 BoardDTO 객체의 속성변수 안의 데이터를 꺼내어 출력한다. -->
	<!-- 꺼내는 방법은 EL문법으로 달러{boardDTO.속성변수명} 이다. -->
	<form class="boardContentForm" method="post" name="boardContentForm" action="${ctRoot}/boardRegProc.do">
		<input type="hidden" name="b_no" value="${boardDTO.b_no}">
		<b>[글 상세 보기]</b><br>
		<table class="tbcss1" width="500" border=1 bordercolor="#000000" cellpadding=5 align=center>
			<tr align=center>
				<th bgcolor="gray" width=60>글번호
				<td width=150>${boardDTO.b_no}
				<th bgcolor="gray" width=60>조회수
				<td width=150>${boardDTO.readcount}
			<tr align=center>
				<th bgcolor="gray" width=60>작성자
				<td width=150>${boardDTO.writer}
				<th bgcolor="gray" width=60>작성일
				<td width=150>${boardDTO.reg_date}
			<tr>
				<th bgcolor="gray">글제목
				<td width=150 colspan=3>${boardDTO.subject}
			<tr>
				<th bgcolor="gray">글내용
				<td width=150 colspan=3>
					<textarea name="content" rows="13" cols="45" style="boder:0" readonly>${boardDTO.content}
					</textarea>
		</table>
		<table><tr heigth=3><td></table>
		<input type="button" value="댓글쓰기" onclick="goBoardRegForm()">&nbsp;
		<input type="button" value="수정/삭제" onclick="goBoardUpDelForm()">&nbsp;
		<input type="button" value="글 목록 보기" onclick="document.boardListForm.submit();">
		<!-- <input type="button" value="목록보기" onclick="location.replace('/z_spring/boardListForm.do')"> -->
	</form>
	<!-- [게시판목록] 화면으로 이동하는 form 태그 선언 -->
	<!-- form 태그 내부에는 클라이언트가 보낸 파라미터값을 입력양식에 저장하고 있다. -->
	<!-- 파라미터값을 꺼내는 방법은 EL문법을 이용한다. 달러{param.파라미터명} or 
	{paramValues.파라미터명}이다(Values는 배열로서 checkbox가 파라미터값으로 들어올때 사용한다.-->
	<form name="boardListForm" method="post" action="${ctRoot}/boardListForm.do">

	</form>
	
	<!-- 수정/삭제 화면으로 이동하기 위한 form 태그 선언 -->
	<form name="boardUpDelForm" method="post" action="${ctRoot}/boardUpDelForm.do">
		<!-- 게시판 상세보기 화면을 구성하는 글의 고유번호를 hidden 태그에 저장 -->
		<!-- 수정/삭제를 하려면 현재 글의 고유번호를 알아야하기 때문 -->
		<input type="hidden" name="b_no" value="${boardDTO.b_no}">
		<input type="hidden" name="selectPageNo" value="${param.selectPageNo}">
		<input type="hidden" name="rowCntPerPage" value="${param.rowCntPerPage}">
	</form>
	
	<!-- 이전 페이지에서 온 게시판 선택 페이지 번호를 지정한 hidden태그 출력하고 [게시판 목록]화면으로 이동하는 form태그 선언 -->
	<form name="boardRegForm" method="post" action="${ctRoot}/boardRegForm.do">
		<input type="hidden" name="b_no" value="${param.b_no}">
	</form>
		
</body>
</html>