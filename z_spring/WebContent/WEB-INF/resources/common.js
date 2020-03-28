
// 입력양식이 비어 있거나 미체크 시 true 리턴 함수 선언
function is_empty(selector){
   try{
      var flag =true;
      var obj = $(selector);
      if( obj.is(":checkbox") || obj.is(":radio")){
         if(obj.filter(":checked").length>0){flag = false;}
      }else{
         var tmp = obj.val()
         tmp = $.trim(tmp);
         obj.val(tmp);
         tmp =tmp.split(" ").join("");
         if(tmp!=""){
            flag=false;
         }
      }
      return flag;
   }catch(e){
      alert("is_empty('"+selector+"') 함수에서 에러 발생!");
      return false;
   }
}

//검색화면에서 검색 결과물의 페이징 번호 출력 소스 리턴
function getPagingNumber(
	totRowCnt               // 검색 결과 총 행 개수
	, selectPageNo_str         // 선택된 현재 페이지 번호
	, rowCntPerPage_str     // 페이지 당 출력행의 개수
	, pageNoCntPerPage_str  // 페이지 당 출력번호 개수
	, jsCodeAfterClick      // 페이지 번호 클릭후 실행할 자스 코드
) {
	//--------------------------------------------------------------
	// name=nowPage을 가진 hidden 태그없으면 경고하고 중지하는 자바스크립트 소스 생성해 저장
	//--------------------------------------------------------------
	if( $('[name=selectPageNo]').length==0 ){
		alert("name=selectPageNo 을 가진 hidden 태그가 있어야 getPagingNumber(~) 함수 호출이 가능함.');" );
		return;
	}
	var arr = [];
	try{
		if( totRowCnt==0 ){	return ""; }	
		if( jsCodeAfterClick==null || jsCodeAfterClick.length==0){
			alert("getPagingNumber(~) 함수의 5번째 인자는 존재하는 함수명이 와야 합니다");
			return "";
		}			
		//--------------------------------------------------------------
		// 페이징 처리 관련 데이터 얻기
		//--------------------------------------------------------------
		if( selectPageNo_str==null || selectPageNo_str.length==0 ) { 
			selectPageNo_str="1";  // 선택한 현재 페이지 번호 저장
		} 
		if( rowCntPerPage_str==null || rowCntPerPage_str.length==0 ) { 
			rowCntPerPage_str="10";  // 선택한 현재 페이지 번호 저장
		}
		if( pageNoCntPerPage_str==null || pageNoCntPerPage_str.length==0 ) { 
			pageNoCntPerPage_str="10";  // 선택한 현재 페이지 번호 저장
		}
		//---
		var selectPageNo = parseInt(selectPageNo_str, 10);
		var rowCntPerPage = parseInt(rowCntPerPage_str,10);
		var pageNoCntPerPage = parseInt(pageNoCntPerPage_str,10);
		if( rowCntPerPage<=0 || pageNoCntPerPage<=0 ) { return; }
		//--------------------------------------------------------------
		//최대 페이지 번호 얻기
		//--------------------------------------------------------------
		var maxPageNo=Math.ceil( totRowCnt/rowCntPerPage );   
			if( maxPageNo<selectPageNo ) { selectPageNo = 1; }

		//--------------------------------------------------------------
		// 선택된 페이지번호에 따라 출력할 [시작 페이지 번호], [끝 페이지 번호] 얻기
		//--------------------------------------------------------------
		var startPageNo = Math.floor((selectPageNo-1)/pageNoCntPerPage)*pageNoCntPerPage+1;  // 시작 페이지 번호
		var endPageNo = startPageNo+pageNoCntPerPage-1;                                      // 끝 페이지 번호
			if( endPageNo>maxPageNo ) { endPageNo=maxPageNo; }
			/*//--------------------------------------------------------------
			// <참고>위 코딩은 아래 코딩으로 대체 가능
			//--------------------------------------------------------------
			var startPageNo = 1;
			var endPageNo = pageNoCntPerPage;
			while( true ){
				if( selectPageNo <= endPageNo ){ startPageNo = endPageNo - pageNoCntPerPage + 1; break; }
				endPageNo = endPageNo + pageNoCntPerPage;
			}*/

		//---
		var cursor = " style='cursor:pointer' ";
		//arr.push( "<table border=0 cellpadding=3 style='font-size:13'  align=center> <tr>" );
		//--------------------------------------------------------------
		// [처음] [이전] 출력하는 자바스크립트 소스 생성해 저장
		//--------------------------------------------------------------
		//arr.push( "<td align=right width=110> " );
		if( startPageNo>pageNoCntPerPage ) {
			arr.push( "<span "+cursor+" onclick=\"$('[name=selectPageNo]').val('1');"
							+jsCodeAfterClick+";\">[처음]</span>" );
			arr.push( "<span "+cursor+" onclick=\"$('[name=selectPageNo]').val('"
				+(startPageNo-1)+"');"+jsCodeAfterClick+";\">[이전]</span>   " );
		}
		//--------------------------------------------------------------
		// 페이지 번호 출력하는 자바스크립트 소스 생성해 저장
		//--------------------------------------------------------------
		//arr.push( "<td align=center>  " );
		for( var i=startPageNo ; i<=endPageNo; ++i ){
			if(i>maxPageNo) {break;}
			if(i==selectPageNo || maxPageNo==1 ) {
				arr.push( "<b>"+i +"</b> " );
			}else{
				arr.push( "<span "+cursor+" onclick=\"$('[name=selectPageNo]').val('"
							+(i)+"');"+jsCodeAfterClick+";\">["+i+"]</span> " );
			}
		}
		//--------------------------------------------------------------
		// [다음] [마지막] 출력하는 자바스크립트 소스 생성해 저장
		//--------------------------------------------------------------
		//arr.push( "<td align=left width=110>  " );
		if( endPageNo<maxPageNo ) {
			arr.push( "   <span "+cursor+" onclick=\"$('[name=selectPageNo]').val('"
						+(endPageNo+1)+"');"+jsCodeAfterClick+";\">[다음]</span>" );
			arr.push( "<span "+cursor+" onclick=\"$('[name=selectPageNo]').val('"
						+(maxPageNo)+"');"+jsCodeAfterClick+";\">[마지막]</span>" );
		}
		//arr.push( "</table>" );
		return arr.join( "" );
	}catch(ex){
		alert("getPagingNumber(~) 메소드 호출 시 예외발생!");
		return "";
	}
}

//테이블 색깔 지정 함수 선언
function setTableBgColor(
		tableClassV
		, headerColor
		, oddBgColor
		, evenBgColor
		, mouseOnBgColor
){
	try{
		//첫 쨰 tr 즉 헤더가 되는 tr 태그를 관리하는 JQuery 객체 생성하기
		var firstTrObj = $("."+tableClassV+" tr:eq(0)");
		//첫 쨰 tr 태그 이후 tr태그를 관리하는 JQuery 객체 생성하기
		var trObjs = firstTrObj.siblings("tr");
		
		//첫쨰 tr, 짝수 tr, 홀수 tr 배경색 지정하기
		firstTrObj.css("background",headerColor);
		trObjs.filter(":odd").css("background",evenBgColor);
		trObjs.filter(":even").css("background",oddBgColor);
		
		//첫재 tr 태그 이후 tr 태그에 마우스 대거나 뗄 때 배경색 지정하기
		trObjs.hover(
			function(){
				$(this).css("background",mouseOnBgColor);
			},
			function(){
				if($(this).index()%2==0) {$(this).css("background",evenBgColor);}
				else {$(this).css("background",oddBgColor);}
			}
		);
		
	}catch(e){
		alert("setTableTrBgColor( ~ ) 함수에서 에러 발생!");
	}
	
}

//문자열의 패턴을 검사하여 true 또는 false를 리턴하는 함수 선언
//매개변수로 입력양식의 이름과 RegExp객체가 들어온다
function is_valid_pattern(selector, regExpObj){
	try{
		//선택자가 가르키는 입력양식을 관리하는 JQuery 객체 생성하기
		var obj = $(selector);
		//입력양식이 checkbox 또는 radio 또는 select면 경고하고 함수 중단하기
		if(obj.is(":checkbox")||obj.is(":radio")||obj.is("select")){
			alert("checkbox or radio or select는 is_valid_pattern 함수의 호출 대상이 아닙니다.")
			return;
		}
		//입력양식의 value값 얻기
		var value = obj.val();
		
		//입력양식의 value 값이 패턴에서 벗어나면 false, 아니면 true 리턴하기
		return regExpObj.test(value);
	}catch(e){
		alert("is_valid_pattern( " + selector + ", ~ ) 함수에서 에러 발생!");
	}
}
//email을 검사하여 true or false를 리턴하는 함수 선언
function is_valid_email(selector){
	return is_valid_pattern(selector, /^([0-9a-zA-Z_-]+)@([0-9a-zA-Z_-]+)(\.[0-9a-zA-Z_-]+){1,2}$/)
}
	
//입력양식에 value값을 삽입하거나 체크해주는 함수 선언. 매개변수로 선택자가 들어온다
function inputData(selector, data){
	try{
		//selector가 가르키는 입력 양식을 관리하는 JQuery객체 생성하기
		var obj = $(selector);
		//selector가 가르키는 입력 양식이 없으면 경고하고 함수 중단
		if(obj.length==0){
			alert("inputData2( "+selector+" , "+data+" )함수 호출시 ["+selector+"]란 선택자가 없습니다.!");
			return;
		}
		
		//만약 입력양식이 checkbox or radio면 value값으로 변수 data안의 데이터를 가진 놈을 체크하기
		if(obj.is(":checkbox") || obj.is(":radio") ){
			obj.filter("[value='"+data+"']").prop("checked", true);
		}
		//만약 입력양식이 checkbox or radio가 아니면 selector가 가르키는 입력양식의 value값으로 매개변수 data안의 데이터를 삽입하기
		else{
			obj.val(data);
		}
	}catch(e){
		alert("inputData( '"+selector+"','"+data+"' )함수 호출 시 에러 발생!");
	}
}
function headerSort(selector, idx){

	//첫번째 tr 태그 내부의 th 태그를 클릭하면 발생할 일을 설정
	$("."+selector+" thead:eq(0) tr:eq(0) th").click(function(){
		//클릭한 th 태그를 관리하는 JQuery 객체 메위주를 얻어 변수에 저장
		var thisThObj = $(this);
		//내림차순, 오름차순 여부를 저장할 변수선언
		var ascDesc = "";
		//클릭한 th 형제의 th 태그 안의 문자열에 ▲, ▼제거
		thisThObj.siblings().each(function(){
			//i번째 th 태그 안의 문자열을 받자
			var str = $(this).text();
			//앞,뒤 공백 제거
			txt = $.trim(str);
			//▲ 제거하기
			txt = txt.replace("▲","")
			//▼ 제거하기
			txt = txt.replace("▼","")
			//i번째 th 태그 안에 ▲, ▼제거한 문자열 넣기
			$(this).text( txt );
		});
		//클릭한 th안의 문자열 뒤에 ▲, ▼붙이기
		//클릭한 th 안의 문자열을 얻어 변수 txt 저장
		var txt = thisThObj.text();
		//txt 변수 안의 문자열에 ▲가 있으면 ▼ 로 바꾸고 ascDesc 변수에 "desc"저장하기
		if(txt.indexOf("▲")>=0) {
			txt = txt.replace("▲", "▼");
			ascDesc = "desc";
		}
		//txt 변수 안의 문자열에 ▼가 있으면 ▲ 로 바꾸고 ascDesc 변수에 "asc"저장하기
		else if(txt.indexOf("▼")>=0) {
			txt = txt.replace("▼", "▲");
			ascDesc = "asc";
		}
		//txt 변수 안의 문자열에 ▼, ▲ 둘다 없을 경우 ▲ 로 넣어주고 ascDesc 변수에 "asc"저장하기
		else {
			txt = txt+"▲";
			ascDesc = "asc";
		}
		//txt안의 데이터를 클릭한 th 안의 문자열로 갱신
		thisThObj.text( txt );
		//Array 객체에 각각의 tr을 관리하는 JQuery 객체들을 생성해서 저장. 원하는 정렬 기준 따라 JQuery 객체의 위치를 바꾼다.
		//정렬 대상이 되는 모든 tr 태그를 관리하는 JQuery 객체 생성해 저장
		var allTrObj = $('.'+selector+' tbody:eq(0)').children();
		//각각의 tr을 관리하는 JQuery객체들을 생성하여 Array 객체에 저장
		var trObjs = [];
		allTrObj.each(function(){
			trObjs.push( $(this) );
		});
		//클릭한 th 태그의 인덱스 번호 저장.
		var thIndex = thisThObj.index();
		//반복문을 사용하여 클릭한 th 열과 동이한 열의 데이터를 오름 또는 내림 정렬에 맞추어 Array 객체에 저장된 tr 태그 관리 JQuery 객체를 재 배치
		for( j=0 ; j<trObjs.length-1 ; j++){
			for( k=j+1 ; k<trObjs.length ; k++){
				//j 번쨰 JQuery 객체의 관리 tr 의 x 번째 열의 문자얻고 소문자로 바꾸기
				var td1Text = trObjs[j].children("td").eq(thIndex).text();
				td1Text = ($.trim(td1Text)).toLowerCase();
				if( thIndex==idx ) { td1Text = parseInt(td1Text,10); }
				//k 번쨰 JQuery 객체의 관리 tr 의 x 번째 열의 문자얻고 소문자로 바꾸기
				var td2Text = trObjs[k].children("td").eq(thIndex).text();
				td2Text = ($.trim(td2Text)).toLowerCase();
				if( thIndex==idx ) { td2Text = parseInt(td2Text,10); }
				//만약 내림차순 의도가 있고[j 번쨰 x 번째 열의 문자] < [k 번쨰 x 번째 열의 문자] 면 j 번쨰 JQuery 객체와 k 번째 JQuery 객체의 위치 바꾸기
				if( (ascDesc=="desc" && td1Text<td2Text)){
					var tmp = trObjs[j];
					trObjs[j] = trObjs[k];
					trObjs[k] = tmp;
				}
				//만약 내림차순 의도가 있고[j 번쨰 x 번째 열의 문자] > [k 번쨰 x 번째 열의 문자] 면 j 번쨰 JQuery 객체와 k 번째 JQuery 객체의 위치 바꾸기
				else if( (ascDesc=="asc" && td1Text>td2Text) ){
					var tmp = trObjs[j];
					trObjs[j] = trObjs[k];
					trObjs[k] = tmp;
				}
			}
		}
		//기존 tr 태그를 지우기
		$('.'+selector+' tbody:eq(0)').empty();
		//Array 객체에 저장된 JQuery 객체가 관리하는 tr 태그를 삽입하기
		for(var j=0 ; j<trObjs.length ; j++){
			$('.'+selector+' tbody:eq(0)').append( trObjs[j] );
		}
	});
	
}





