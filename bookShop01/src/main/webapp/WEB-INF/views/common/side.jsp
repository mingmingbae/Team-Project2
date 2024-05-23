<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"
    %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<c:set var="member_id"  value="${sessionScope.memberInfo.member_id}"  />

<body>
<nav>
<ul>
<c:choose>
	<%-- admin계정으로 로그인 했을 경우 메인화면의 왼쪽 사이드 영역 !! 관리자 메뉴 디자인 표시  --%>
	<c:when test="${sessionScope.side_menu=='admin_mode' }">
	   <li>
			<H3>주요기능</H3>
			<ul>
				<li><a href="${contextPath}/admin/goods/adminGoodsMain.do">상품관리</a></li>
				<li><a href="${contextPath}/admin/order/adminOrderMain.do">주문관리</a></li>
				<li><a href="${contextPath}/news/newsList.do?member_id=${member_id}">게시판관리</a></li> 
			</ul>
		</li>
	</c:when>
	<%-- 일반 계정으로 로그인 했을 경우 메인화면의 왼쪽 사이드 영역!! 일반 사용자를 위한 메뉴 항목 표시 --%>
	<c:when test="${sessionScope.side_menu=='my_page' }">
		<li>
			<h3>주문내역</h3>
			<ul>
				<li><a href="${contextPath}/mypage/listMyOrderHistory.do">주문내역/배송 조회</a></li>
				
			</ul>
		</li>
		<li>
			<h3>정보내역</h3>
			<ul>
				<li><a href="${contextPath}/mypage/myDetailInfo.do">회원정보관리</a></li>
			</ul>
		</li>
	</c:when>
	
	<%-- 그외 사용자 메뉴 표시 --%>	
	<c:otherwise>
		<li>
			<h3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;국내외 도서</h3>
			<ul>
				<li><a href="${contextPath}/goods/goodsSort.do?goodsSort=IT/인터넷">IT/인터넷</a></li>
				<li><a href="${contextPath}/goods/goodsSort.do?goodsSort=자기계발">자기계발</a></li>
				<li><a href="${contextPath}/goods/goodsSort.do?goodsSort=국내소설">국내소설</a></li>
			</ul>
		</li>
	 </c:otherwise>
</c:choose>	
</ul>
</nav>
<div class="clear"></div>
<div id="notice">
	<h2>오늘의 영상 추천!</h2>
		<c:forEach var="sel" items="${sessionScope.seleniumList}">
				<iframe width="190" height="150" src="${sel.youUrl}" style="padding-top: 10px;" frameborder="0" allowfullscreen></iframe>
		</c:forEach>
	</div>
<DIV id="notice">
    <H2>공지사항<button type="button" style="float: right;" onclick="window.location.href='${contextPath}/news/newsList.do?member_id=${member_id }'">전체보기</button></H2>
    
    <UL>
	<c:forEach  var="notice" items="${sessionScope.newsList}" varStatus="status">
	    <c:if test="${status.index < 3}">
	        <li><a href="${contextPath}/news/newsView.do?news_idx=${notice.news_idx}&news_member_id=${notice.news_member_id}&news_title=${notice.news_title}">${notice.news_title}</a></li>
	    </c:if>
	</c:forEach>
	</UL>
</DIV>
<div id="notice">
	<h2>찾아오시는 길</h2>
	<a href="#"><img width="190" height="362" src="${contextPath}/resources/image/찾아오는길.png" style="padding-top: 10px;"></a>
	<ul style="list-style-type:circle;">
		<li>
			주소 : <br>
			부산시 부산진구 신천대로50번길 79, 5층(부전동, 부전빌딩)		
		</li>
		<li>
			지하철 : <br>
			1,2호선 서면역 하차 후<br>
			서면지하상가쪽으로 오셔서 서면몰(지하상가) 12번 출구로 나옵니다.		
		</li>
	</ul>
</div>
</html>