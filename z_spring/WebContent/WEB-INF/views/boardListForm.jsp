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
<style>
</style>
<script>
	//body태그 안의 모든 태그를 읽어들인 후 실행할 자스 코딩 설정
	$(document).ready(function(){
		//inputBgColor();
		
		//name="rowCntPerPage"에 change이벤트가 발생하면 시행할 코드 설정하기
		$('[name=rowCntPerPage]').change(function(){
			goSearch();
		});
		$('[name=orAnd]').change(function(){
			goSearch();
		});
		
		//페이징 처리 관련 HTML 소스를 class=pagingNumber 가진 태그 안에 삽입하기
		$(".pagingNumber").html(
			getPagingNumber(
				"${boardListAllCnt}"						//검색 결과 총 행 개수
				,"${boardSearchDTO.selectPageNo}"			//선택된 현재 페이지 번호
				,"${boardSearchDTO.rowCntPerPage}"			//페이지 당 출력행의 개수
				,"15"										//페이지 당 보여줄 페이지번호 개수
				,"goSearch();"								//페이지 번호 클릭 후 실행할 자스코드
			)
		);
		
		//게시판 목록을 보여주는 table의 해더행, 짝수행, 홀수행, 마우스온 일때 배경색 설정하기
		setTableBgColor(
				"boardTable"								//테이블 class값
				, "${headerColor}"									//해더 tr 배경색
				, "${oddTrColor}"									//홀수행 배경색
				, "${evenColor}"									//짝수행 배경색
				, "${mouseOverColor}"								//마우스 온 시 배경색
		);
		
		/*
		//클라이언트가 보낸 검색 조건을 입력 양식에 넣어주기
		$('[name=rowCntPerPage]').val("${boardSearchDTO.rowCntPerPage}");
		$('[name=orAnd]').val("${boardSearchDTO.orAnd}");
		$('[name=keyword1]').val("${boardSearchDTO.keyword1}");
		$('[name=keyword2]').val("${boardSearchDTO.keyword2}");
		$('[name=selectPageNo]').val("${boardSearchDTO.selectPageNo}");
		<c:forEach items="${boardSearchDTO.date}" var="date">
			$('[name=date]').filter("[value=${date}]").prop("checked", true);
		</c:forEach>
		<c:forEach items="${boardSearchDTO.readcnt}" var="readcnt">
				$('[name=readcnt]').filter("[value=${readcnt}]").prop("checked", true);
		</c:forEach>
		*/
		//위 코딩은 공용함수를 써서 아래 코딩으로 대체 가능하다.
		//클라이언트가 보낸 검색 조건을 입력 양식에 넣어주기
		inputData('[name=rowCntPerPage]',"${boardSearchDTO.rowCntPerPage}");
		inputData('[name=selectPageNo]',"${boardSearchDTO.selectPageNo}");
		inputData('[name=keyword1]',"${boardSearchDTO.keyword1}");
		inputData('[name=keyword2]',"${boardSearchDTO.keyword2}");
		inputData('[name=orAnd]',"${boardSearchDTO.orAnd}");
		<c:forEach items="${boardSearchDTO.date}" var="date">
			inputData('[name=date]',"${date}");
		</c:forEach>
		<c:forEach items="${boardSearchDTO.readcnt}" var="readcnt">
			inputData('[name=readcnt]',"${readcnt}");
		</c:forEach>
	});
	
	//게시판 목록 화면으로 이동하는 함수 선언
	function goSearch(){
		
		//만약 키워드가 공백 또는 길이가 없다면 길이없는 데이터로 세팅하기
		//공백 상태에서 서버로 전송되면 정말로 공백을 가지고 DB를 검색한다. 이 현상을 막기위해 공백 or 길이가 없는 데이터로 통일해서 세팅한다.
		
		if( is_empty('[name=boardListForm] [name=keyword1]') ){
			$('[name=boardListForm] [name=keyword1]').val("");
		}
		if( is_empty('[name=boardListForm] [name=keyword2]') ){
			$('[name=boardListForm] [name=keyword2]').val("");
		}
		//키워드 앞뒤에 공백이 있으면 제거하고 다시 넣어주기
		var keyword1 = $('[name=boardListForm] [name=keyword1]').val();
		keyword1 = $.trim(keyword1);
		$('[name=boardListForm] [name=keyword1]').val(keyword1);
		var keyword2 = $('[name=boardListForm] [name=keyword2]').val();
		keyword2 = $.trim(keyword2);
		$('[name=boardListForm] [name=keyword2]').val(keyword2);
		
		//name=boardListForm을 가진 form 태그의 action값의 URL로 웹서버에 접속하기
		document.boardListForm.submit();
		
		
	}
	
	//[모두 검색] 버튼 누르면 호출되는 함수 선언
	function goSearchAll(){
		
		//name=boardListForm을 가진 form 태그 내부의 모든 입력양식에 value값을 비우거나 체크를 푼다.
		document.boardListForm.reset();
		
		//선택페이지 번호와 페이지당 보여지는 행의 개수는 비우면 안되므로 기본값을 넣어준다.
		//이게 없으면 DB연동을 할 수 없다.
		$('[name=boardListForm] [name=rowCntPerPage]').val('10');
		$('[name=boardListForm] [name=selectPageNo]').val('1');
		goSearch();
	}
	
	//[게시판 입력 화면]으로 이동하는 함수 선언
	function goBoardRegForm(){
		//URL주소로 들어가 서버가 주는 HTML소스를 화면에 띄운다(페이지 이동)
		location.replace("${ctRoot}/boardRegForm.do");
	}
	
	//[1개의 게시판 내용물]을 보여주는 [게시판 상세 보기 화면]으로 이동하는 함수 선언
	function goBoardContentForm(b_no){
		//var selectPageNo = $('[name=boardListForm] [name=selectPageNo]').val();
		//var rowCntPerPage = $('[name=boardListForm] [name=rowCntPerPage]').val();
		//location.replace("/z_spring/boardContentForm.do?b_no="+b_no+"&selectPageNo="+selectPageNo+"&rowCntPerPage="+rowCntPerPage)
		//위 코딩과 아래 코딩은 동일한 값을 넘긴다.
		//상세보기 화면으로 이동할때 가져갈 파라미터값을 만든다.
		var str = "b_no="+b_no+"&"+$('[name=boardListForm]').serialize();
		/*
		$(".xxx").remove();
		$("body").prepend("<div class=xxx><hr>"+str+"<hr></div>");
		return;
		*/
		location.replace("${ctRoot}/boardContentForm.do?"+str )
	}
	/* 
	function inputBgColor(){
		var trsObj = $(".boardTable tr");
		trsObj.filter(":visible").filter(":gt(0)").filter(":even").css("background", "white");
		trsObj.filter(":visible").filter(":gt(0)").filter(":odd").css("background", "#C9C9C9");
		//위 코딩은 아래 코딩으로 대체 가능
			//$(".sungjuk tbody tr").filter(":not(:hidden)").filter(":even").css("background", "white");
			//$(".sungjuk tbody tr").filter(":not(:hidden)").filter(":odd").css("background", "gray");
		
	} */
</script>
</head>
<body><center><br><br><br>

   
   <!-- 게시판 검색 조건 관련 입력 양식 삽입된 form 태그 선언하기 -->
   <form name="boardListForm" method="post" action="${ctRoot}/boardListForm.do">
      <div style="width:800">
      
        <!-- 키워드 검색 입력 양식 표현하기 -->
         [키워드] : <input type="text" name="keyword1" class="keyword1">&nbsp;&nbsp;&nbsp;
         
         <select name="orAnd">
         	<option value="or">or
         	<option value="and">and
         </select>
         
         <input type="text" name="keyword2" class="keyword2">&nbsp;&nbsp;&nbsp;
        <!-- 어제 또는 오늘 게시판 글을 검색하는 조건 표현하기 -->
        [등록일] : 
         <input type="checkbox" name="date" class="date" value="오늘">오늘
         <input type="checkbox" name="date" class="date" value="어제">어제
         <input type="checkbox" name="date" class="date" value="이번달">이번달
         <input type="checkbox" name="date" class="date" value="이번달이외">이번달이외&nbsp;&nbsp;&nbsp;
         [조회수] : 
         <input type="checkbox" name="readcnt" class="readcnt" value="조회수100이상">조회수100이상&nbsp;&nbsp;&nbsp;
        <!-- 버튼 표현하기 -->
         <input type="button" value="   검색   " class="contactSearch" onclick="goSearch();">&nbsp;
         <input type="button" value=" 모두검색 " onclick="goSearchAll();">&nbsp;
         <a href="javascript:goBoardRegForm();">새글쓰기</a>&nbsp;&nbsp;
         
        <!-- 선택한 페이지 번호가 저장되는 입력양식 표현하기 -->
        <!-- 선택한 페이지 번호는 DB 연동시 아주 중요한 역활을 한다-->
        <!-- 히든태그는 반드시 보내야하나 보이면 안되는 데이터를 보낼때 사용한다.-->
        <!-- TYPE 을 TEXT 로 바꿔놓을시 값이 보이기 때문에 작업시 편안하다. -->
        
        <!-- 
        	disabled - 눈에 보이지만 수정 불가 및 서버로 데이터가 넘어가지 않는다
        	readonly - 눈에 보이며 수정이 불가능하다. 읽기만 가능
         -->
      </div><br>
      
      <table border=0 width=700>
         <tr>
            <td align=right>
        <!-- EL 문법으로 게시판 검색 총 개수 출력하기 -->
        <!-- ($){boardListAllCnt}은 -->
        <!-- 컨트롤러 클래스 내부에 -->
        <!-- ModelAndView 객체에 boardListAllCnt 라는 키값으로 저장된 -->
        <!-- 데이터를 EL 로 표현하여 삽입하라는 뜻이다. -->
               [총 개수] : ${boardListAllCnt}&nbsp;&nbsp;&nbsp;&nbsp;
               <!-- 한 페이지에서 보이는 행의 명수가 저장되는 입력양식 표현하기
               		행의 개수는 DB연동시 아주 중요한 역할을 한다. -->
               <select name="rowCntPerPage">
                  <option value="10">10</option>
                  <option value="15">15</option>
                  <option value="20">20</option>
                  <option value="25">25</option>
                  <option value="30">30</option>
               </select> 행보기
      </table>

   </form>
         <input type="hidden" name="selectPageNo">
   <!-- 페이징 번호를 삽입할 span 태그 선언하기 -->
   <div>&nbsp;<span class="pagingNumber"></span>&nbsp;</div>
   
   <table><tr height=10><td></table>
   
   <!-- 게시판 검색 목록 출력하기 -->
   <table class="boardTable tbcss2" border=0 cellspacing=0 cellpadding=5 width=700>
      <tr bgcolor="${headerColor}"><th>번호<th>제목<th>글쓴이<th>등록일<th>조회수
      
      
      
      <!-- 사용자 정의 태그인 JSTL C코어 태그중 <forEach> 태그를 사용하여 -->
      <!-- ModelAndView 객체에 "boardList" 라는 키값으로 저장된 -->
      <!-- List<Map<String,String>> 객체의 데이터를 -->
      <%-- <c:forEach> 태그의 속성 설명 --%>
      <%-- 
         <c:forEach 
         items="${ModelView 객체에 저장한 객체의 키값명 으로 주로 List 객체의 키값명이 삽입된다.}"(EL 문법) 
         var="items 속성에 설저한 List 객체 안의 i번쨰 데이터가 저장될 지역변수명 "(form 문 안에서 사용할 지역변수이다.) 
         varStatus="loopTagStatus" 루프 테그 스테이터스에 객체를 담을 인데스 ㅇ
         >
       --%>
       <c:forEach items="${requestScope.boardList}" var="board" varStatus="loopTagStatus">
            <tr style="cursor:pointer"
            	<%-- bgcolor="${loopTagStatus.index%2==0?'white':'#E6E6E6'}" --%>
            	onClick="goBoardContentForm(${board.b_no});">			<!-- EL문 안에서 삼항연산자를 쓸수있다. -->
               <td align=center>
                    
                <!-- 게시판 검색 목록 중에 각 행의 역순 일련번호 출력 -->
                  <!-- 역순번호 출력-->
                  ${boardListAllCnt-
                  (boardSearchDTO.selectPageNo*boardSearchDTO.rowCntPerPage-boardSearchDTO.rowCntPerPage+1+loopTagStatus.index)
                  +1}
                  
                  <%-- 정순 번호 출력 시 아래 코드로 대체 할 것 
                  ${boardSearchDTO.selectPageNo*boardSearchDTO.rowCntPerPage-boardSearchDTO.rowCntPerPage+1+loopTagStatus.index} --%>
               <td>
               		<!-- 만약 pring_level>0면 print_level만큼 &nbsp;를 삽입해라 -->
                     <c:if test="${board.print_level>0}">
                        <c:forEach begin="0" end="${board.print_level}">
                             &nbsp;&nbsp;
                        </c:forEach>
                        ㄴ
                     </c:if>
                   <!-- 게시판 검색 목록 중에 각 행의 제목 출력 -->
                     ${board.subject}
             <!-- 게시판 검색 목록 중에 각 행의 글쓴이 출력 -->
               <td align=center>${board.writer}
             <!-- 게시판 검색 목록 중에 각 행의 등록일 출력 -->
               <td align=center>${board.reg_date}
             <!-- 게시판 검색 목록 중에 각 행의 조회수 출력 -->
               <td align=center>${board.readcount}
               
               
               
               
               
               <!-- 
               한화면에 보여줄 행의 개수 => rowCntPerPage
               
               선택한 페이지 번호 => selectPageNo
               
               시작행의 번호 => beginRowNo
               
               끝 행의 번호 => endRowNo
               --------------------------------------------------------------------------
               문제>rowCntPerPage 가 10이고 ,selectPageNo 가 1이면 beginRowNo? endRowNo?
               --------------------------------------------------------------------------
               beginRowNo = selectPageNo * rowCntPerPage - rowCntPerPage + 1;
               endRowNo = selectPageNo * rowCntPerPage;
               --------------------------------------------------------------------------
               endRowNo = selectPageNo * rowCntPerPage;
               beginRowNo = endRowNo - rowCntPerPage +1;
                -->
               
               
               
               
         </c:forEach>
         
         
         <% 
         	/*
            List<Map<String,String>>
               list = (List<Map<String,String>>)request.getAttribute("boardList");
            for(int i=0 ; i<list.size() ; i++){
               Map<String,String> map= list.get(i);
               out.print("<tr>");
               out.print("<td>"+map.get("b_no"));
               out.print("<td>"+map.get("subject"));
               out.print("<td>"+map.get("writer"));
               out.print("<td>"+map.get("reg_form"));
               out.print("<td>"+map.get("readcount"));
               out.print("<td>"+map.get("readcount"));
            }
            */
         %>
   
   </table><br>
   
   <c:if test=" ${boardListAllCnt==0}">
   		검색 결과가 없습니다...2
   </c:if>
   <!-- 위 코딩은 아래 코딩으로 대체 가능하다. -->
   <!-- 만약에 검색된 게시판 총 개수가 0개면 "검색 결과가 없습니다"출력 -->
   <%--  
   <c:if test="${empty boardList}">
   		검색 결과가 없습니다...3
   </c:if>
   ${boardListAllCnt==0?'검색 결과가 없습니다...1':''} 
   --%>
</body>
</html>