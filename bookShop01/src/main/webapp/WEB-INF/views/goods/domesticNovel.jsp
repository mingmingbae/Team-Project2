<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"	isELIgnored="false"
	%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<%
  request.setCharacterEncoding("UTF-8");
%>  

<div id="ad_main_banner">
	<ul class="bjqs">	 	
	  <li><a href="${contextPath}/goods/goodsDetail.do?goods_id=356"><img width="775" height="145" src="${contextPath}/resources/image/main_banner01.jpg"></a></li>
	  <li><a href="${contextPath}/goods/goodsDetail.do?goods_id=354"><img width="775" height="145" src="${contextPath}/resources/image/main_banner02.jpg"></a></li>
	  <li><a href="${contextPath}/goods/goodsDetail.do?goods_id=398"><img width="775" height="145" src="${contextPath}/resources/image/sub_banner02.jpg"></a></li>
	</ul>
</div>

<div class="main_book">
   <c:set  var="goods_count" value="0" />
	<h3>국내 소설</h3>
	
	<c:forEach var="item" items="${goodsMap.goodsList }">  
	
	   <c:set  var="goods_count" value="${goods_count+1 }" />
	   
		<div class="book">
		
			<!-- 이미지 클릭시 상품 상세페이지를 요청 -->
			<a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id }">
				<img class="link"  src="${contextPath}/resources/image/1px.gif"> 
			</a> 
				<!-- 원본이미지를 썸네일 이미지로 보여 주기 위해  서버페이지 요청시  상품번호와 상품이미지명 전달  -->
				<img width="121" height="154" 
				     src="${contextPath}/thumbnails.do?goods_id=${item.goods_id}&fileName=${item.goods_fileName}">

			<div class="title">${item.goods_title }</div>
			<div class="price">
		  	   <fmt:formatNumber  value="${item.goods_price}" type="number" var="goods_price" />
		          ${goods_price}원
			</div>
		</div>
  </c:forEach>
</div>
