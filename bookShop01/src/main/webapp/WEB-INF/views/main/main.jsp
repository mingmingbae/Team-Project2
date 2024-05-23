<%@ page language="java" contentType="text/html; charset=utf-8"
   pageEncoding="utf-8"   isELIgnored="false"
   %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<c:set var="memberInfo" value="${sessionScope.memberInfo}" />
<c:set var="member_id" value="${memberInfo.getMember_id()}" />
<c:set var="bookList" value="${bookList}" />

<% request.setCharacterEncoding("UTF-8");%>  

<script>
function showAlert(message) {
    alert(message);
}
</script>

<c:if test="${not empty message}">
    <%-- 메시지가 존재할 경우 JavaScript 함수를 호출하여 경고창을 표시 --%>
    <script>
        showAlert("${message}");
    </script>
</c:if>

<div class="main_book">
<h3>신간도서</h3>
<div id="ad_main_banner">
    <ul class="bjqs" style="display: flex; list-style-type: none; padding: 0; ">
        <c:forEach var="book" items="${bookList}">
            <li style="display: flex; align-items: center; margin-right: 20px;">
            <img src="${book.book_img}" style="float: left; margin-right: 20px; width: 140px; height: 180px;">
            <div style="overflow: hidden;">
                <p>책 제목: ${book.book_title}</p><br>
                <p>저자: ${book.book_author}</p><br>
                <p>출판사: ${book.book_publisher}</p><br>
                <p>가격: ${book.book_price}</p><br>
                <p>출판일: ${book.book_date}</p>
                <a href="${book.book_link}" style="color: blue; text-decoration: underline; font-weight: bold;">click! 판매 사이트로 이동</a>         
                 </div>
            </li>
        </c:forEach>
    </ul>
</div>
</div>

<div class="main_book">
   <c:set  var="goods_count" value="0" />
   <h3>베스트셀러</h3>
   
   <!-- 조회된 베스트 셀러 15개를 메인화면 중앙에 표시-->
   <c:forEach var="item" items="${goodsMap.bestseller }">  
   
      <c:set  var="goods_count" value="${goods_count+1 }" />
      
      <div class="book">
      
         <!-- 이미지 클릭시 상품 상세페이지를 요청-->
         <a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id}">
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
<div class="clear"></div>
<div id="ad_sub_banner">
   <a href="${contextPath}/goods/goodsDetail.do?goods_id=356"><img width="775" height="145" src="${contextPath}/resources/image/main_banner01.jpg"></a>
</div>
<div class="main_book" >
   <c:set  var="goods_count" value="0" />
   <h3>새로 출판된 책</h3>
   <c:forEach var="item" items="${goodsMap.newbook}" >
      <c:set  var="goods_count" value="${goods_count+1}" />
      <div class="book">
        <a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id}&member_id=${member_id}">
          <img class="link"  src="${contextPath}/resources/image/1px.gif"> 
         </a>
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

<div class="clear"></div>
<div id="ad_sub_banner">
   <a href="${contextPath}/goods/goodsDetail.do?goods_id=354"><img width="775" height="145" src="${contextPath}/resources/image/main_banner02.jpg"></a>
</div>


<div class="main_book" >
<c:set  var="goods_count" value="0" />
   <h3>스테디셀러</h3>
   <c:forEach var="item" items="${goodsMap.steadyseller }" >
      <c:set  var="goods_count" value="${goods_count+1 }" />
      <div class="book">
        <a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id }&member_id=${member_id}">
          <img class="link"  src="${contextPath}/resources/image/1px.gif"> 
         </a>
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

   
   