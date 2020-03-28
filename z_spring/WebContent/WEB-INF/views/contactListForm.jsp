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
<title>게시판목록</title>
<script>

$(document).ready(function(){
	
	headerSort("contactTable", 0);
	
	//짝수행 마우스오버시 홀수행 보임
	var tableObj = $(".contactTable");
	//id="movieList" 를 가진 태그 내부(=후손)에 모든 tr을 관리하는 JQuery 객체 메위주를 변수 trObj에 저장
	var trObj = tableObj.find("tbody tr");
	//홀수 tr을 관리하는 JQuery 객체 메위주를 변수 trOddObj에 저장
	var trOddObj = trObj.filter(":even");
	//짝수 tr을 관리하는 JQuery 객체 메위주를 변수 trEvenObj에 저장
	var trEvenObj = trObj.filter(":odd");
	trEvenObj.hide( );
	trOddObj.click(function(){
		//짝수 tr감추기 -> 기존에 보여진 짝수 tr을 감추기 위함이다
		trEvenObj.hide( );
		//마우스를 댄 홀수 tr의 다음 짝수 tr보이기
		$(this).next().show();
		
		$('[name=update]').click(function(){
				
			$(".contactTable [name=contactUpDelProc] [name=upDel]").val("up");

			if(confirm("정말 수정하시겠습니까?")==false){return;}	
			
			alert( $('[name=contactUpDelProc]').serialize()); return;
			
			contactUpDelProc(updel);
			
		});
		$('[name=delete]').click(function(){
				
			$(".contactTable [name=contactUpDelProc] [name=upDel]").val("del");

			if(confirm("정말 삭제하시겠습니까?")==false){return;}	
			
		});
		
		
		
	});
	//table 영역에서 마우스 빼면 짝수 tr 안보이기
	tableObj.hover(
		function(){
		},
		function(){
			trEvenObj.hide();
		}
	);
	
	
	
	$('[name=rowCntPerPage]').change(function(){
		goContactSearch();
	});
	
	$(".pagingNumber").html(
		getPagingNumber(
			"${contactListAllCnt}"						//검색 결과 총 행 개수
			,"${contactSearchDTO.selectPageNo}"			//선택된 현재 페이지 번호
			,"${contactSearchDTO.rowCntPerPage}"		//페이지 당 출력행의 개수
			,"10"										//페이지 당 보여줄 페이지번호 개수
			,"goContactSearch();"						//페이지 번호 클릭 후 실행할 자스코드
		)
	);

	inputData('[name=rowCntPerPage]',"${contactSearchDTO.rowCntPerPage}");
	inputData('[name=selectPageNo]',"${contactSearchDTO.selectPageNo}");
	inputData('[name=keyword1]',"${contactSearchDTO.keyword1}");
	inputData('[name=keyword2]',"${contactSearchDTO.keyword2}");
	inputData('[name=orAnd]',"${contactSearchDTO.orAnd}");
	inputData('[name=front_year]',"${contactSearchDTO.front_year}");
	inputData('[name=front_month]',"${contactSearchDTO.front_month}");
	inputData('[name=back_year]',"${contactSearchDTO.back_year}");
	inputData('[name=back_month]',"${contactSearchDTO.back_month}");
	<c:forEach items="${contactSearchDTO.searchSkills}" var="skills">
		inputData('[name=searchSkills]',"${skills}");
	</c:forEach>
});


function goContactContentForm(contact_no){
	
	var str = "contact_no="+contact_no+$('[name=contactListForm]').serialize();
	
	location.replace("/z_spring/contactContentForm.do?"+str);
	
}

//null nudefind length>0
function goContactSearch(){
	//alert("검색 시작");
	//alert($('[name=contactListForm]').serialize()); return;
	document.contactListForm.submit();
	
	/*
	var str = $('[name=contactListForm]').serialize();
	location.replace("/z_spring/contactListForm.do?"+str)
	*/
}


function contactUpDelProc(updel){
	
	$.ajax({
		//호출할 서버쪽 URL주소 설정
		url : "/z_spring/contactUpDelProc.do"
		//전송 방법 설정
		, type : "post"
		//서버로 보낼 파라미터명과 파라미터값을 설정
		, data : $('[name=contactUpDelProc]').serialize()
		//서버의 응답을 성공적으로 받았을 경우 실행할 익명함수 설정.
		//매개변수 upDelCnt에는 입력 행의 개수가 들어온다.
		, success : function(upDelCnt){
			if(upDel=='up'){
				if(upDelCnt==1){
					alert("수정 성공!");
				}
			}
			if(upDel=='del'){
				if(upDelCnt==1){
					alert("삭제 성공!");
				}
			}
		}
		, error : function(){
			alert("서버 접속 실패");
		}
	});
}	


function deleteRegForm(){
	//alert($('[name=front_year]').val());
	$('[name=keyword1]').val('');
	$('[name=keyword2]').val('');
}

function goContactSearchAll(){
	
	document.contactListForm.reset();
	goContactSearch();
}

function goContactDeleteAll(){
	document.contactListForm.reset();
}

function appendYear(idVal){
    var date = new Date();
    var year = date.getFullYear();
    var selectValue = document.getElementById(idVal);
    var optionIndex = 0;
    selectValue.add(new Option("------",''),optionIndex++);
    for(var i=year-10; i<=year; i++){
          selectValue.add(new Option(i,i),optionIndex++);                        
    } 
}
function appendMonth(idVal){
    var selectValue = document.getElementById(idVal); 
    var optionIndex = 0;
    selectValue.add(new Option("------",''),optionIndex++);
    for(var i=1;i<=12;i++){
          selectValue.add(new Option(i,i),optionIndex++);
    }
} 


</script>
</head>
<body><center><br><br><br>
	<form name="contactListForm" method="post" action="/z_spring/contactListForm.do" >
	 <!-- <input type="hidden" name="selectPageNo" value="${contactSearchDTO.selectPageNo}">  -->
	<table class="tbcss1" width="500" border=1 bordercolor="#000000" cellpadding=5 align=center>
		<tr>
		<td>종사분야
		<td>
			<input type="checkbox" name="searchSkills" value="IT">IT
			<input type="checkbox" name="searchSkills" value="통신">통신
			<input type="checkbox" name="searchSkills" value="금융">금융
			<input type="checkbox" name="searchSkills" value="건설">건설
			<input type="checkbox" name="searchSkills" value="유통">유통
			<input type="checkbox" name="searchSkills" value="전자">전자
			<input type="checkbox" name="searchSkills" value="전기">전기
			<input type="checkbox" name="searchSkills" value="기타">기타
		<tr>
		<td>등록일
		<td>
		
			<select id="front_year" name="front_year">
                  <script>appendYear("front_year");</script>
            </select>년&nbsp;
            
            <select id="front_month" name="front_month">
                  <script>appendMonth("front_month");</script>
            </select>월&nbsp;~&nbsp;
            
            <select id="back_year" name="back_year">
 				<script>appendYear("back_year");</script>
            </select>년&nbsp;
            <select id="back_month" name="back_month">
                  <script>appendMonth("back_month");</script>
            </select>월
		<tr>
		<td>키워드
		<td><input type="text" name="keyword1" class="keyword1">&nbsp;&nbsp;&nbsp;
		 <select name="orAnd">
         	<option value="or">or
         	<option value="and">and
         </select>
         &nbsp;&nbsp;&nbsp;
          <input type="text" name="keyword2" class="keyword2">&nbsp;&nbsp;&nbsp;
          <a href="javascript:deleteRegForm();">비움</a>
	</table>
	
		<input type="button" value="검색" onClick="goContactSearch();">
         <!-- <input type="button" value="   검색   " onclick="goContactSearch();"> -->&nbsp;
         <input type="button" value=" 모두검색 " onclick="goContactSearchAll();">&nbsp;
         <input type="button" value=" 초기화 " onclick="goContactDeleteAll();">&nbsp;
		  <a href="javascript:goContactRegForm();">새글쓰기</a>&nbsp;&nbsp;
		  
			   <table border=0 width=700>
	        	 <tr>
	            <td align=right>
	               [총 개수] : ${contactListAllCnt}&nbsp;&nbsp;&nbsp;&nbsp;
	               <select name="rowCntPerPage">
	                  <option value="10">10</option>
	                  <option value="15">15</option>
	                  <option value="20">20</option>
	                  <option value="25">25</option>
	                  <option value="30">30</option>
	               </select> 행보기
      </table>
     
	<input type="hidden" name="selectPageNo">
	</form>
	
  	<div>&nbsp;<span class="pagingNumber"></span>&nbsp;</div>
  	
	<table class="contactTable tbcss2" border=0 cellspacing=0 cellpadding=5 width=700>
	<thead>
      <tr bgcolor="${headerColor}"><th style="cursor:pointer">번호<th style="cursor:pointer">이름<th>핸드폰<th>종사분야<th style="cursor:pointer">등록일
     </thead>
      
  	<tbody>
       <c:forEach items="${requestScope.contactList}" var="board" varStatus="loopTagStatus">
            <tr style="cursor:pointer">
               <td align=center>
                  <!-- 
                  <c:if test="${(contactListAllCnt-(contactSearchDTO.selectPageNo*contactSearchDTO.rowCntPerPage-contactSearchDTO.rowCntPerPage+1+loopTagStatus.index)+1) < 10}" >
                  ${contactListAllCnt-
                  (contactSearchDTO.selectPageNo*contactSearchDTO.rowCntPerPage-contactSearchDTO.rowCntPerPage+1+loopTagStatus.index)
                  +1+contactSearchDTO.zero}
                  </c:if>
                   -->
                  ${contactListAllCnt-
                  (contactSearchDTO.selectPageNo*contactSearchDTO.rowCntPerPage-contactSearchDTO.rowCntPerPage+1+loopTagStatus.index)
                  +1}
                  
               <td>
                   <!-- 게시판 검색 목록 중에 각 행의 제목 출력 -->
                     ${board.contact_name}
             <!-- 게시판 검색 목록 중에 각 행의 글쓴이 출력 -->
               <td align=center>${board.phone}
               <td align=center>${board.using_skill}
               <td align=center>${board.reg_date}
            <tr align=center>
               <td colspan=5>
               	<form name="contactUpDelProc" method="post" action="/z_spring/contactUpDelProc.do">
               		<input type="text" size="10" maxlength="10" name="contact_name" value="${board.contact_name}"><br>
               		<input type="text" size="20" maxlength="20" name="phone" value="${board.phone}"><br>
               		
					<input type="checkbox" name="skills" value="IT">IT
					<input type="checkbox" name="skills" value="통신">통신
					<input type="checkbox" name="skills" value="금융">금융
					<input type="checkbox" name="skills" value="건설">건설
					<input type="checkbox" name="skills" value="유통">유통
					<input type="checkbox" name="skills" value="전자">전자
					<input type="checkbox" name="skills" value="전기">전기
					<input type="checkbox" name="skills" value="기타">기타
					<br>
					
					<input type="hidden" name="upDel" value="up">
					<input type="hidden" name="b_no" value="${board.contact_no}">
               		<input type="button" name="update" value="  수정  ">
               		<input type="button" name="delete" value="  삭제  ">
               </form>
         </c:forEach>
   </tbody>
   </table><br>
   <c:if test=" ${contactListAllCnt==0}">
   		검색 결과가 없습니다...2
   </c:if>
   <!-- 
   <div width:200; heigth:100; padding:10; position:absolute; top:100; left:100;>
   		<table>
   			<tr>
   				<th bgcolor="gray">연락처명
				<td><input type="text" size="10" maxlength="10" name="contact_name" value="달러{contactList.contact_name}">
			<tr>
				<th bgcolor="gray">전화번호
				<td><input type="text" size="40" maxlength="50" name="phone" value="달러{contactList.phone}">
   		</table>
   </div>
    -->
</body>
</html>