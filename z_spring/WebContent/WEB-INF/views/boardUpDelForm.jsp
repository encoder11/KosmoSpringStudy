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
<title>
글 수정/삭제
</title>
<script>

	//[게시판 등록 화면]에 입력된 데이터의 유효성 체크 함수 선언
	function checkBoardUpDelForm(upDel){
		
		//매개변수로 들어온 upDel에 "del"이 저장되어있으면 즉, 삭제 버튼을 눌렀으면 암호 확인하고 삭제 여부를 물어보기
		if(upDel=='del'){
			//var pwd=$("[name=pwd]").val();
			//if(pwd.split(" ").join("")==""){
			if(is_empty("[name=pwd]")){
				alert("암호를 입력해 주세요");
				$("[name=pwd]").focus();
				return;
			}
			
			//name=upDel을 가진 양식에 "del" 저장하기
				/*
					<주의> 아래 코드를 생략하면 일어나는 일
					-수정버튼을 누르고 취소하게 되면 name=upDel에 "up"이 들어간다. 그리고 삭제 버튼을 누르면 name=upDel에
					 "up"이 들어간 상태에세 삭제가 진행되므로 올바른 삭제가 진행되지 않는다.
				*/
			$("[name=upDel]").val("del");
					
			//alert($('[name=boardUpDelForm]').serialize());		
			
			if(confirm("정말 삭제 하시겠습니까?")==false) return;
			/* 
			//현재 화면에서 페이지 이동 없이 서버쪽 "/z_spring/boardRegProc.do"를 호출하여 게시판 글을 입력하고 [게시판 입력 행 적용 개수]를 받기
			$.ajax({
				//접속할 서버쪽 URL 주소 설정
				url : "/z_spring/boardUpDelProc.do"
				//전송 방법 설정
				, type : "post"
				//서버로 보낼 파라미터명과 파라미터값을 설정
				, data : $('[name=boardUpDelForm]').serialize()//+"&b_no="+${param.b_no}
				//서버의 응답을 성공적으로 받았을 경우 실행할 익명함수 설정.
				//매개변수 boardRegCnt에는 입력 행의 개수가 들어온다.
				, success : function(boardRegCnt){
					//[게시판 입력 행 적용 개수]가 1개면(=insert가 한번 성공했다는 뜻)
					if(boardRegCnt==1){
						alert("게시판 글 삭제 성공!");
						//location.replace();
					}
					//[게시판 새 글 입력 행 적용 개수]가 1개가 아니면 경고하기
					else{
						alert("게시판 글 삭제 실패! 관리자에게 문의 바람.");
					}
				}
				//서버의 응답을 못 받았을 경우 실행할 익명함수 설정
				, error : function(){
					alert("서버 접속 실패");
				}
			}); 
			*/
		}
		//매개변수로 들어온 upDel에 "up"이 저장되어있으면 즉, 수정 버튼을 눌렀으면 각 입력양식의 유효성 체크하고 수정 여부 물어보기
		else if(upDel=='up'){
			
			//name=upDel을 가진 양식에 "up" 저장하기
			$("[name=upDel]").val("up");
			
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
			if(confirm("정말 수정하시겠습니까?")==false){return;}	
			
		}
		
		//현재 화면에서 페이지 이동 없이 서버쪽 "/z_spring/boardUpDelProc.do"를 호출하여 [게시판 수정 또는 삭제 적용 개수]를 받는다.
		$.ajax({
			//호출할 서버쪽 URL주소 설정
			url : "${ctRoot}/boardUpDelProc.do"
			//전송 방법 설정
			, type : "post"
			//서버로 보낼 파라미터명과 파라미터값을 설정
			, data : $('[name=boardUpDelForm]').serialize()
			//서버의 응답을 성공적으로 받았을 경우 실행할 익명함수 설정.
			//매개변수 upDelCnt에는 입력 행의 개수가 들어온다.
			, success : function(upDelCnt){
				if(upDel=='up'){
					if(upDelCnt==1){
						alert("수정 성공!");
						document.boardListForm.submit();
					}
					else if(upDelCnt==-1) alert("게시물이 삭제되어 수정할 수 없습니다!");
					else if(upDelCnt==-2) alert("비밀번호가 잘못 입력 되었습니다!");
					else alert("서버쪽 DB연동 실패!");
				}else if(upDel=='del'){
					if(upDelCnt==1) alert("삭제 성공!");
					else if(upDelCnt==-1) alert("이미 삭제된 게시물입니다!");
					else if(upDelCnt==-2) alert("비밀번호가 잘못 입력 되었습니다!");
					else if(upDelCnt==-3) alert("댓글이 있어 삭제 불가능합니다!");
					else alert("서버쪽 DB연동 실패!");
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
<%--
	<form method="post" name="boardUpDel" action="/z_spring/boardUpDelProc.do">
		
		
		
		<c:if test="${param.b_no>0}">
			<b>답글쓰기</b>
		</c:if>
		<c:if test="${param.b_no eq 0}">
			<b>새글쓰기</b>
		</c:if>
		<br>
		<table class="tbcss1" border=1 bordercolor=gray cellspacing=0 cellpadding=5 align=center>
			<tr>
				<th bgcolor="gray">이 름
				<td><input type="text" size="10" maxlength="10" name="writer" value="${boardDTO.writer}">
			<tr>
				<th bgcolor="gray">제 목
				<td><input type="text" size="40" maxlength="50" name="subject" value="${boardDTO.subject}">
			<tr>
				<th bgcolor="gray">이메일
				<td><input type="text" size="40" maxlength="30" name="email" value="${boardDTO.email}">
			<tr>
				<th bgcolor="gray">내용
				<td><textarea name="content" rows="13" cols="40" maxlength="500" >${boardDTO.content}</textarea>
			<tr>
				<th bgcolor="gray">비밀번호
				<td><input type="password" size="8" maxlength="4" name="pwd" value="${boardDTO.pwd}">
		</table>
		<table><tr heigth=4><td></table>
		<input type="hidden" name="upDel" value="up">
		<input type="hidden" name="b_no" value="${boardDTO.b_no}">
		<input type="button" value="수정" onclick="checkBoardUpDelForm()">
		<input type="button" value="삭제" onclick="checkBoardUpDelForm()">
		<input type="button" value="목록보기" onclick="location.replace('/z_spring/boardListForm.do')">
	</form>
	 --%>
	 <!-- spring 폼태그를 사용하여 HTML의 form태그와 입력양식관련 태그를 출력한다. -->
	 <!-- 이때 DTO객체나 Map객체등과 연결하면 이 객체 안의 데이터가 자동으로 입력양식에 삽입된다.-->
	 <c:if test="${!empty boardDTO}">
	 <form:form name="boardUpDelForm" method="post" commandName="boardDTO" action="${ctRoot}/boardUpDelProc.do">
	 <!-- 위 Spring 폼태그는 아래처럼 변환되어 실행된다 -->
	 <%-- <formname="boardUpDelForm"  id="boardDTO" action="/z_spring/boardUpDelProc.do" method="post"> --%>
	 	<b>[글 수정/삭제]</b>
	 	<table class="tbcss1" border=1 bordercolor=gray cellspacing=0 cellpadding=5 align=center>
	 		<tr>
	 			<th bgcolor="gray">이 름
	 			<td><form:input path="writer" className="writer"/>
	 			<!-- 위 스프링폼태그는 아래처럼 변환된다 -->
	 			<%-- <input  type="text" id="writer" name="writer" className="writer" value="${boardDTO.writer}"/> --%>
	 			<!-- 아래 태그들도 똑같이 변환된다. -->
	 		<tr>
	 			<th bgcolor="gray">제 목
	 			<td><form:input path="subject" className="subject"/>
	 		<tr>
	 			<th bgcolor="gray">이메일
	 			<td><form:input path="email" className="email"/>
	 		<tr>
	 			<th bgcolor="gray">내 용
	 			<td><form:textarea path="content" className="content" rows="13" cols="40"/>
	 		<tr>
	 			<th bgcolor="gray">비밀번호
	 			<td><form:password path="pwd" className="pwd"/>
	 	</table>
		<table><tr heigth=4><td></table>
		<input type="hidden" name="upDel" value="up">
		<input type="hidden" name="b_no" value="${boardDTO.b_no}">
		<input type="button" value="수정" onclick="checkBoardUpDelForm('up')">
		<input type="button" value="삭제" onclick="checkBoardUpDelForm('del')">
		<input type="button" value="목록보기" onclick="document.boardListForm.submit();">
	 </form:form>
	 </c:if>
	 <form name="boardListForm" method="post" action="${ctRoot}/boardListForm.do">
		<!-- 게시판 상세보기 화면을 구성하는 글의 고유번호를 hidden 태그에 저장 -->
		<!-- 수정/삭제를 하려면 현재 글의 고유번호를 알아야하기 때문 -->
		<input type="hidden" name="b_no" value="${boardDTO.b_no}">	
		<input type="hidden" name="selectPageNo" value="${param.selectPageNo}">
		<input type="hidden" name="rowCntPerPage" value="${param.rowCntPerPage}">
	</form>
</body>
</html>