<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"
    %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />

<script type="text/javascript">
	var loopSearch=true;
	
	//검색키워드를 입력하면 Ajax기능을 이용해 해당 키워드가 포함된 목록을 조회
	function keywordSearch(){
		//제시된 키워드를 클릭하면 keywordSearch()함수의 실행을 중지 시키고 빠져나감
		if(loopSearch==false){
			return;
		}
		//사용자가 검색창에 입력한 검색키워드를 가져옵니다.
	 	var value=document.frmSearch.searchWord.value;

		$.ajax({
			type : "get",
			async : false, 
			url : "${contextPath}/goods/keywordSearch.do",
			data : {keyword:value},
			success : function(data, textStatus) {
				console.log(data);
			    var jsonInfo = JSON.parse(data);

				displayResult(jsonInfo);
			},
			error : function(data, textStatus) {
				alert("에러가 발생했습니다."+data);
			},
			complete : function(data, textStatus) {
			}
		}); //end ajax	
	}
	
	function displayResult(jsonInfo){	
		
		var count = jsonInfo.keyword.length;//조회된 글제목 문자열의 총갯수 반환
		
		//조회된 글제목 이 있으면?
		if(count > 0) {
			//동적으로 <a>목록을 만들어서 누적해 저장할 변수 선언 
		    var html = '';

		    for(var i in jsonInfo.keyword){
			   html += "<a href=\"javascript:select('"+jsonInfo.keyword[i]+"')\">"+jsonInfo.keyword[i]+"</a><br/>";
		    }
 
		    var listView = document.getElementById("suggestList");
		    listView.innerHTML = html;
		    
		    show('suggest');
		}else{
		    hide('suggest');
		} 
	}
	
	function select(selectedKeyword) {
		 document.frmSearch.searchWord.value=selectedKeyword;
		 loopSearch = false;
		 hide('suggest');
	}
		
	function show(elementId) {
		 var element = document.getElementById(elementId);
		 if(element) {
		  element.style.display = 'block';
		 }
	}
	
	function hide(elementId){
	   var element = document.getElementById(elementId);
	   if(element){
		  element.style.display = 'none';
	   }
	}

</script>
<body>
	<div id="logo">
	<a href="${contextPath}/main/main.do">
		<img width="176" height="80" alt="booktopia" src="${contextPath}/resources/image/Booktopia_Logo.jpg">
		</a>
	</div>
	<div id="head_link">
		<ul>
		   <c:choose>
		   	<%-- 세션에  isLogOn변수 값이 true이고  세션에 조회된 memberVO객체가 저장되어 있으므로 로그인 된 화면을 보여주자. --%>
		     <c:when test="${sessionScope.isLogOn==true and not empty sessionScope.memberInfo }">
			   <li><a href="${contextPath}/member/logout.do">로그아웃</a></li>
			   <li><a href="${contextPath}/mypage/myPageMain.do">마이페이지</a></li>
			   <li><a href="${contextPath}/cart/myCartList.do">장바구니</a></li>
			   <li><a href="${contextPath}/mypage/listMyOrderHistory.do">주문배송</a></li>
			 </c:when>
			 <%--로그아웃된 화면을 보여주자. --%>
			 <c:otherwise>
			   <li><a href="${contextPath}/member/loginForm.do">로그인</a></li>
			   <li><a href="${contextPath}/member/memberForm.do">회원가입</a></li> 
			 </c:otherwise>
			</c:choose>
			   
		      <c:if test="${sessionScope.isLogOn==true and sessionScope.memberInfo.member_id =='admin' }">  
		   	   <li class="no_line"><a href="${contextPath}/admin/goods/adminGoodsMain.do">관리자</a></li>
			  </c:if>
			  
		</ul>
	</div>
	<br>
	
	<div id="search" >
		<form name="frmSearch" action="${contextPath}/goods/searchGoods.do" >
			<input name="searchWord" class="main_input" type="text" value="" onKeyUp="keywordSearch()"> 
			<input type="submit" name="search" class="btn1"  value="검 색" >
		</form>
	</div>
   <div id="suggest">
        <div id="suggestList"></div>
   </div>
</body>
</html>






