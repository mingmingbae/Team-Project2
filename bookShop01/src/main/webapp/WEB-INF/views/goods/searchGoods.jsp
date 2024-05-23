<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"
    %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<%
     //치환 변수 선언합니다.
      pageContext.setAttribute("crcn", "\r\n"); //Space, Enter
      pageContext.setAttribute("br", "<br/>"); //br 태그
%> 
<head>
    <title>검색 도서 목록 페이지</title>
<script type="text/javascript">
    //장바구니 버튼 추가
   function add_cart(goods_id,selectedValue) {
      $.ajax({
         type : "post",
         async : false, 
         url : "${contextPath}/cart/addGoodsInCart.do",
         data : { goods_id:goods_id,
                cart_goods_qty:selectedValue
               },
         success : function(data, textStatus) {
            if(data.trim()=='add_success'){ //장바구니 테이블에 새상품을 추가하고 메세지를 받으면?
                  alert('장바구니에 담았습니다');
            }else if(data.trim()=='already_existed'){
               alert("이미 카트에 등록된 상품입니다.");   
            }
         },
         error : function(data, textStatus) {
            alert("로그인이 필요한 서비스입니다. 로그인 하시겠습니까?");
            location.href = '${contextPath}/member/loginForm.do';
         },
         complete : function(data, textStatus) {
            //alert("작업을완료 했습니다");
         }
      }); //end ajax   
   }
    
   //구매요청   
   function fn_order_each_goods(goods_id,goods_title,goods_sales_price,fileName){

      var _isLogOn=document.getElementById("isLogOn");
      var isLogOn=_isLogOn.value;  //"false" 또는 "true"
      
       if(isLogOn == "false" || isLogOn == '' ){
         alert("로그인 후 주문이 가능합니다!!!");
      } 
      
      var total_price,final_total_price;
      
         //<form></form>
      var formObj=document.createElement("form");
      var i_goods_id = document.createElement("input"); 
       i_goods_id.name="goods_id";
       i_goods_id.value=goods_id;
       
       var i_goods_title = document.createElement("input");
       i_goods_title.name="goods_title";
       i_goods_title.value=goods_title;
       
       var i_goods_sales_price=document.createElement("input");
       i_goods_sales_price.name="goods_sales_price";
       i_goods_sales_price.value=parseInt(goods_sales_price);
       
       var i_fileName=document.createElement("input");
       i_fileName.name="goods_fileName";
       i_fileName.value=fileName;
       
       var i_order_goods_qty=document.createElement("input");
       i_order_goods_qty.name="order_goods_qty";
       i_order_goods_qty.value = "1";
     
       formObj.appendChild(i_goods_id);
       formObj.appendChild(i_goods_title);
       formObj.appendChild(i_goods_sales_price);
       formObj.appendChild(i_fileName);
       formObj.appendChild(i_order_goods_qty);

       document.body.appendChild(formObj); 
       
       formObj.method="post";
       formObj.action="${contextPath}/order/orderEachGoods.do";
       formObj.submit();//구매 요청!
   }
</script>
</head>
<body>
   <hgroup>
      <h1>오늘의 책</h1>
   </hgroup>
   <section id="new_book">
      <h3>새로나온 책</h3>
      <div id="left_scroll">
         <a href='javascript:slide("left");'><img src="${contextPath}/resources/image/left.gif"></a>
      </div>
      <div id="carousel_inner">
         <ul id="carousel_ul">
         <c:choose>
            <c:when test="${ empty goodsList}" >
                 <li>
               <div id="book">
                  <a><h1>제품이없습니다.</h1></a>
                 </div>
            </li> 
            </c:when>
            <c:otherwise>
             <c:forEach var="item" items="${goodsList }" >
              <li>
               <div id="book">
                  <a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id}">
                  <img width="75" alt="" src="${contextPath}/thumbnails.do?goods_id=${item.goods_id}&fileName=${item.goods_fileName}">
                  </a>
                  <div class="sort">${item.goods_sort}</div>
                  <div class="title">
                     <a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id }">
                       ${item.goods_title}
                     </a>
                  </div>
                  <div class="writer">${item.goods_writer} | ${item.goods_publisher}</div>
                  <div class="price">
                     <span>
                       <fmt:formatNumber  value="${item.goods_price}" type="number" var="goods_price" />
                               ${goods_price}원
                     </span> <br>
                      <fmt:formatNumber  value="${item.goods_price*0.9}" type="number" var="discounted_price" />
                           ${discounted_price}원(10%할인)
                  </div>
               </div>
            </li>
            </c:forEach> 
            <li>
            </li> 
            </c:otherwise>
          </c:choose>
          
         </ul>
      </div>
      <div id="right_scroll">
         <a href='javascript:slide("right");'><img  src="${contextPath}/resources/image/right.gif"></a>
      </div>
      <input id="hidden_auto_slide_seconds" type="hidden" value="0">

      <div class="clear"></div>
   </section>
   <div class="clear"></div>
   <table id="list_view">
      <tbody>
        <c:forEach var="item" items="${goodsList }"> 
         <tr>
               <td class="goods_image">
                  <a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id}">
                        <img width="75" alt="" src="${contextPath}/thumbnails.do?goods_id=${item.goods_id}&fileName=${item.goods_fileName}">
                  </a>
               </td>
               <td class="goods_description">
                  <h2>
                     <a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id }">${item.goods_title }</a>
                  </h2>
                  <c:set var="goods_pub_date" value="${item.goods_published_date }" />
                  <c:set var="arr" value="${fn:split(goods_pub_date,' ')}" />
                  <div class="writer_press"  >${item.goods_writer }저
                     |${item.goods_publisher }|<c:out value="${arr[0]}" />
                  </div>
               </td>
               <td class="price"><span><fmt:formatNumber  value="${item.goods_price}" type="number" var="goods_price" />
                               ${goods_price}원</span><br>
                  <strong>
                   <fmt:formatNumber  value="${item.goods_price*0.9}" type="number" var="discounted_price" />
                           ${discounted_price}원
                  </strong><br>(10% 할인)
               </td>
               <td class="buy_btns">
                  <UL>
                     <c:set var="selectedValue" value="1"/>
                     <li><a class="cart" href="javascript:add_cart('${item.goods_id }',${selectedValue})">장바구니</a></li>
                     <c:set var="goods_sales_price" value="${item.goods_price*0.9}"/>   
                     <li><a class="buy" href="javascript:fn_order_each_goods('${item.goods_id }','${item.goods_title }','${goods_sales_price}','${item.goods_fileName}');">구매하기 </a></li>
                  </UL>
               </td>
         </tr>
         </c:forEach>
      </tbody>
   </table>
   <div class="clear"></div>
   <div id="page_wrap">
      <ul id="page_control">
         <li><a class="no_border" href="#">Prev</a></li>
         <c:set var="page_num" value="0" />
         <c:forEach var="count" begin="1" end="10" step="1">
            <c:choose>
               <c:when test="${count==1 }">
                  <li><a class="page_contrl_active" href="#">${count+page_num*10}</a></li>
               </c:when>
               <c:otherwise>
                  <li><a href="#">${count+page_num*10 }</a></li>
               </c:otherwise>
            </c:choose>
         </c:forEach>
         <li><a class="no_border" href="#">Next</a></li>
      </ul>
   </div>
   <input type="hidden" name="isLogOn" id="isLogOn" value="${isLogOn}"/>