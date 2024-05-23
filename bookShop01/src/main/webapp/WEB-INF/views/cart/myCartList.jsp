<%@ page language="java" contentType="text/html; charset=utf-8"
   pageEncoding="utf-8"
   isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 

<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />


<%--장바구니테이블에 저장되어 있는 상품정보를 조회--%>
<c:set var="myCartList"  value="${sessionScope.cartMap.myCartList}"  />

<%--장바구니 테이블에서 조회한 상품번호에 대한 상품을 도서상품 테이블과 도서이미지정보테이블을 조인해서 조회--%>
<c:set var="myGoodsList"  value="${sessionScope.cartMap.myGoodsList}"  />

<%-- 장바구니테이블에 추가된 상품의 총 개수를 저장할 변수 선언  --%>
<c:set  var="totalGoodsNum" value="0" />  

<%-- 장바구니테이블에 추가된 상품의 총 배송비를 저장할 변수 선언 --%>
<c:set  var="totalDeliveryPrice" value="0" />

<head>
<script type="text/javascript">
// 체크박스 체크 유무
function calcGoodsPrice(bookPrice,obj,cart_goods_qty){
   console.log(obj)
   console.log(cart_goods_qty)
   var totalPrice=0;
   var final_total_price=0;
   var totalNum=0;
   var totalSale=0;
  
   //밑의 최종 금액 보여질 태그 가져와서 변수 선언
   var p_buyGoods=document.getElementById("p_buyGoods"); //구매 상품 수량
   var p_totalGoodsPrice=document.getElementById("p_totalGoodsPrice"); //구매 총 정가 금액
   var p_totalSalesPrice=document.getElementById("p_totalSalesPrice"); //구매 총 할인 금액
   var p_final_totalPrice=document.getElementById("p_final_totalPrice"); //구매 총 최종금액
   
   //hidden으로 숨거져있는 총 갯수, 금액 등
   var h_totalGoodsNum=document.getElementById("h_totalGoodsNum"); //장바구니 총 수량
   var h_totalBuyGoodsNum=document.getElementById("h_totalBuyGoodsNum"); //구매 수량
   var h_totalPrice=document.getElementById("h_totalGoodsPrice"); //구매 금액
   var h_totalSalesPrice=document.getElementById("h_totalSalesPrice"); //할인 금액
   var h_final_total_price=document.getElementById("h_final_totalPrice"); //구매 최종금액
   
   if(obj.checked==true){
      totalNum=Number(h_totalBuyGoodsNum.value)+cart_goods_qty;//구매 수량
      totalPrice=Number(h_totalPrice.value)+Number(cart_goods_qty*bookPrice);//총 상품금액
      totalSale=Number(h_totalSalesPrice.value)+Number(cart_goods_qty*bookPrice*0.1);//총 할인금액
      final_total_price=totalPrice-totalSale;//최종결제금액

   }else if(obj.checked==false){
      totalNum=Number(h_totalBuyGoodsNum.value)-cart_goods_qty;//구매 수량
      totalPrice=Number(h_totalPrice.value)-Number(cart_goods_qty*bookPrice);//총 상품금액
      totalSale=Number(h_totalSalesPrice.value)-Number(cart_goods_qty*bookPrice*0.1);//총 할인금액
      final_total_price=totalPrice-totalSale;//최종결제금액
   }
   
   h_totalBuyGoodsNum.value=totalNum;
   h_totalPrice.value=totalPrice;
   h_totalSalesPrice.value=totalSale;
   h_final_total_price.value=final_total_price;
   
   p_buyGoods.innerHTML=totalNum+"개";
   p_totalGoodsPrice.innerHTML = new Intl.NumberFormat('ko-KR').format(totalPrice) + "원";
   p_totalSalesPrice.innerHTML = new Intl.NumberFormat('ko-KR').format(totalSale) + "원";
   p_final_totalPrice.innerHTML = new Intl.NumberFormat('ko-KR').format(final_total_price) + "원";
}


//수량 입력후 [변경] 버튼을 클릭했을때 호출되는 함수 
function modify_cart_qty(goods_id,bookPrice,index){

   var length=document.frm_order_all_cart.cart_goods_qty.length;
   
   var _cart_goods_qty=0;
   
   //장바구니 목록에 주문할 상품이 여러개 인경우
   if(length>1){ 
      //입력한 주문 수량 정보를 얻어 저장 
      _cart_goods_qty=document.frm_order_all_cart.cart_goods_qty[index].value;      
   
   //장바구니 목록에 주문할 상품이 하나인 경우
   }else{
      //입력한 주문 수량 정보를 얻어 저장 
      _cart_goods_qty=document.frm_order_all_cart.cart_goods_qty.value;
   }
      
   //입력한 주문 수량이 문자열 이므로 계산을 위해 숫자로 변경해서 반환 받아 변수에 저장 
   var cart_goods_qty=Number(_cart_goods_qty);
   
   //입력한 주문 수량 정보를 DB에 수정 하기 위해 요청!
   $.ajax({
      type : "post",
      async : false, 
      url : "${contextPath}/cart/modifyCartQty.do",
      data : { 
         //상품 번호 
         goods_id:goods_id,
         //상품번호에 해당하는 상품의 수량 
         cart_goods_qty:cart_goods_qty
      },
      success : function(data, textStatus) {
         if(data.trim()=='modify_success'){
            alert("수량을 변경했습니다!!");   
            location.reload();
         }else{
            alert("다시 시도해 주세요!!");   
         }
         
      },
      error : function(data, textStatus) {
         alert("에러가 발생했습니다."+data);
      },
      complete : function(data, textStatus) {
      }
   }); //end ajax   
}

function delete_cart_goods(cart_id){
   var cart_id=Number(cart_id);
   var formObj=document.createElement("form");
   var i_cart = document.createElement("input");
   i_cart.name="cart_id";
   i_cart.value=cart_id;
   
   formObj.appendChild(i_cart);
    document.body.appendChild(formObj); 
    formObj.method="post";
    formObj.action="${contextPath}/cart/removeCartGoods.do";
    formObj.submit();
}

function fn_order_each_goods(goods_id,goods_title,goods_sales_price,fileName){
   var total_price,final_total_price,_goods_qty;
   var cart_goods_qty=document.getElementById("cart_goods_qty");
   
   _order_goods_qty=cart_goods_qty.value; //장바구니에 담긴 개수 만큼 주문한다.
   var formObj=document.createElement("form");
   var i_goods_id = document.createElement("input"); 
    var i_goods_title = document.createElement("input");
    var i_goods_sales_price=document.createElement("input");
    var i_fileName=document.createElement("input");
    var i_order_goods_qty=document.createElement("input");
    
    i_goods_id.name="goods_id";
    i_goods_title.name="goods_title";
    i_goods_sales_price.name="goods_sales_price";
    i_fileName.name="goods_fileName";
    i_order_goods_qty.name="order_goods_qty";
    
    i_goods_id.value=goods_id;
    i_order_goods_qty.value=_order_goods_qty;
    i_goods_title.value=goods_title;
    i_goods_sales_price.value=goods_sales_price;
    i_fileName.value=fileName;
    
    formObj.appendChild(i_goods_id);
    formObj.appendChild(i_goods_title);
    formObj.appendChild(i_goods_sales_price);
    formObj.appendChild(i_fileName);
    formObj.appendChild(i_order_goods_qty);

    document.body.appendChild(formObj); 
    formObj.method="post";
    formObj.action="${contextPath}/order/orderEachGoods.do";
    formObj.submit();
}

//장바구니 목록 화면의 주문하기
function fn_order_all_cart_goods(){
   var order_goods_qty; //주문 수량
   var order_goods_id; //주문 번호 
   
   var objForm=document.frm_order_all_cart;
   
   var cart_goods_qty=objForm.cart_goods_qty;
   
   var h_order_each_goods_qty=objForm.h_order_each_goods_qty;
   
   var checked_goods=objForm.checked_goods;  //상품 주문 여부를 체크하는 체크박스 들을 checked_goods 배열에 담아  checked_goods배열을 선택 
 
   var length=checked_goods.length; //주문용으로 선택한(체크한) 총 상품 개수

   
   //하나의 상품에 대해 '상품번호:주문수량' 문자열로 만든 후 전체 상품 정보를 배열로 전송 
   //장바구니 목록화면에서 구매할 상품을 체크하는  <input type="checkbox">태그가  여러개 라면?
   if(length>1){
      for(var i=0; i<length;i++){
         
         //구매할 상품 행의  체크 박스에 체크 되어 있으면?
         if(checked_goods[i].checked==true){
            //체크된 구매할 상품의 상품번호값
            order_goods_id=checked_goods[i].value;
            //각 행의 구매할 상품의 구매 수량
            order_goods_qty=cart_goods_qty[i].value;
            //각 행의 구매할 상품의 구매 수량을 입력할수 있는 <input>의 value속성을 ""빈문자열로 설정
            cart_goods_qty[i].value="";
            //각 행의 구매할 상품의 구매 수량을 입력할수 있는 <input>의 value속성에  "구매 상품 번호 : 구매할 상품의 수량" 설정 !
            cart_goods_qty[i].value = order_goods_id+":"+order_goods_qty;
         }
      }
      
   //상품을 하나만 주문할 경우    '상품번호:주문수량' 문자열로 만든 후  문자열로 전송
   }else{
      //체크된 구매할 상품의 상품번호값
      order_goods_id=checked_goods.value;
      //첫번째 행의 구매할 상품의 구매 수량
      order_goods_qty=cart_goods_qty.value;
      //첫번쨰 행의 구매할 상품의 구매 수량을 입력할수 있는 <input>의 value속성에  "구매 상품 번호 : 구매할 상품의 수량" 설정 !
      cart_goods_qty.value=order_goods_id+":"+order_goods_qty;
   }
      
    objForm.method="post";
    objForm.action="${contextPath}/order/orderAllCartGoods.do"; //장바구니 목록화면에서 주문하기 버튼을 눌렀을때 주문요청을 하는 주소가 <form>에 설정 됨 
    
    objForm.submit();
}

</script>
</head>
<body>
   <table class="list_view">
      <tbody align=center >
         <tr style="background:#33ff00" >
            <td class="fixed" >구분</td>
            <td colspan=2 class="fixed">상품명</td>
            <td>정가</td>
            <td>판매가</td>
            <td>수량</td>
            <td>합계</td>
            <td>주문</td>
         </tr>
         
<c:choose>
                <%-- 로그인한 회원 아이디로  조회한 장바구니 테이블의 정보가 없으면? --%>
  <c:when test="${ empty myCartList }">
          <tr>
             <td colspan=8 class="fixed">
               <strong>장바구니에 상품이 없습니다.</strong>
             </td>
           </tr>
   </c:when>
                <%-- 조회한 장바구니 테이블의 정보가 있으면? --%>
  <c:otherwise>   
    <form name="frm_order_all_cart">                
      
          <%-- 장바구니테이블에 저장된 상품번호로  도서상품 테이블과 도서이미지정보 테이블에서 조회한 도서상품 갯수 만큼 반복해서 도서 상품 목록 표시    --%>
         <c:forEach var="item" items="${myGoodsList}" varStatus="cnt">
            <tr>       
               <%--장바구니 테이블에 저장된 도서상품 수량  --%>
                <c:set var="cart_goods_qty" value="${myCartList[cnt.count-1].cart_goods_qty}" />
                
                <%--장바구니 테이블에 저장된 도서상품의 장바구니 번호  --%>
                <c:set var="cart_id" value="${myCartList[cnt.count-1].cart_id}" />
<!--                체크박스 -->
               <td>
                  <input type="checkbox" 
                          name="checked_goods"  
                          value="${item.goods_id}"  
                          checked="checked"
                          onClick="calcGoodsPrice(${item.goods_price},this,${cart_goods_qty})">
                </td>
<!--                도서 이미지 -->
               <td class="goods_image">
                  <a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id }">
                     <img width="75" alt="" src="${contextPath}/thumbnails.do?goods_id=${item.goods_id}&fileName=${item.goods_fileName}"  />
                  </a>
               </td>
<!--                도서 제목 -->
               <td>
                  <h2>
                     <a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id }">${item.goods_title }</a>
                  </h2>
               </td>
<!--                정가 -->
               <td class="price"><span><fmt:formatNumber value="${item.goods_price}" pattern="###,###"/>원</span></td>
<!--                할인가 -->
               <td>
                  <strong>
                     <fmt:formatNumber  value="${item.goods_price*0.9}" type="number" var="discounted_price" />
                        ${discounted_price}원(10%할인)
                     </strong>
               </td>
<!--                수량 -->
               <td>            
                <%-- 주문 수량을 입력하는 <input> --%>
                  <input type="text" id="cart_goods_qty" name="cart_goods_qty" size=3 value="${cart_goods_qty}"><br>
                <%-- 변경 버튼 --%>   
                  <a href="javascript:modify_cart_qty(${item.goods_id },${item.goods_sales_price*0.9 },${cnt.count-1 });" >
                      <img width=25 alt=""  src="${contextPath}/resources/image/btn_modify_qty.jpg">
                  </a>
               </td>
<!--                합계 -->
               <td>
                  <strong id="total_sales_price">
                   <fmt:formatNumber  value="${item.goods_price*0.9*cart_goods_qty}" type="number" var="total_sales_price" />
                     ${total_sales_price}원
                  </strong> 
               </td>

               <td>
<!--                주문하기 버튼 -->
                   <a href="javascript:fn_order_each_goods('${item.goods_id }','${item.goods_title }','${item.goods_sales_price}','${item.goods_fileName}');">
                      <img width="75" alt=""  src="${contextPath}/resources/image/btn_order.jpg">
                  </a><br>
<!--                   삭제 버튼 -->
                  <a href="javascript:delete_cart_goods('${cart_id}');"> 
                     <img width="75" alt=""src="${contextPath}/resources/image/btn_delete.jpg">
                  </a>
               </td>
         </tr>
	     <%-- 누적 총 금액  --%>
         <c:set  var="totalGoodsPrice" value="${totalGoodsPrice+item.goods_price*cart_goods_qty }" />
         <%-- 누적 총 상품 수  --%>
         <c:set  var="totalGoodsNum" value="${totalGoodsNum+cart_goods_qty}" />
         <%-- 장바구니테이블에 추가된 상품의 총 할인 금액을 저장할 변수 선언 --%>
         <c:set  var="totalDiscountedPrice" value="${totalDiscountedPrice+item.goods_price*0.1*cart_goods_qty}" /> 
            </c:forEach>
      </tbody>
   </table>
        
   <div class="clear"></div>
 </c:otherwise>
</c:choose> 
   <br>
   <br>
   
   <table  width=80%   class="list_view" style="background:#cacaff">
   <tbody>
        <tr  align=center  class="fixed" >
          <td class="fixed">총 상품수 </td>
          <td>구매 할 상품수</td>
          <td>총 상품금액</td>
          <td>  </td>
          <td>총 배송비</td>
          <td>  </td>
          <td>총 할인 금액 </td>
          <td>  </td>
          <td>최종 결제금액</td>
        </tr>
      <tr cellpadding=40  align=center >
<!--          장바구니 총 수량 -->
         <td>
           <p id="p_totalGoodsNum">${totalGoodsNum}개 </p>
           <input id="h_totalGoodsNum"type="hidden" value="${totalGoodsNum}"  />
         </td>
<!--          체크된 구매할 상품 총 수량 -->
         <td>
           <p id="p_buyGoods">${totalGoodsNum}개 </p>
           <input id="h_totalBuyGoodsNum"type="hidden" value="${totalGoodsNum}"  />
         </td>
<!--          정가 총 금액 -->
          <td>
             <p id="p_totalGoodsPrice">
             <fmt:formatNumber  value="${totalGoodsPrice}" type="number" var="total_goods_price" />
                     ${total_goods_price}원
             </p>
             <input id="h_totalGoodsPrice"type="hidden" value="${totalGoodsPrice}" />
          </td>
<!--           플러스 이미지 -->
          <td> 
             <img width="25" alt="" src="${contextPath}/resources/image/plus.jpg">  
          </td>
<!--           배송비 -->
          <td>
            <p id="p_totalDeliveryPrice">${totalDeliveryPrice}원  </p>
            <input id="h_totalDeliveryPrice"type="hidden" value="${totalDeliveryPrice}" />
          </td>
<!--           마이너스 이미지 -->
          <td> 
            <img width="25" alt="" src="${contextPath}/resources/image/minus.jpg"> 
          </td>
<!--           총 할인금액 -->
          <td>  
            <p id="p_totalSalesPrice">
            <fmt:formatNumber value="${totalDiscountedPrice}" type="number" var="total_discount"/>
                     ${total_discount}원
            </p>
            <input id="h_totalSalesPrice"type="hidden" value="${totalDiscountedPrice}" />
          </td>
<!--           = 이미지 -->
          <td>  
            <img width="25" alt="" src="${contextPath}/resources/image/equal.jpg">
          </td>
<!--           최종 금액 -->
          <td>
             <p id="p_final_totalPrice">
             <fmt:formatNumber  value="${totalGoodsPrice+totalDeliveryPrice-totalDiscountedPrice}" type="number" var="total_price" />
               ${total_price}원
             </p>
             <input id="h_final_totalPrice" type="hidden" value="${totalGoodsPrice+totalDeliveryPrice-totalDiscountedPrice}" />
          </td>
      </tr>
      </tbody>
   </table>
   <center>
    <br><br>   
       
		<%-- 주문하기 --%>
       <a href="javascript:fn_order_all_cart_goods()">
          <img width="75" alt="" src="${contextPath}/resources/image/btn_order_final.jpg">  
       </a>
           
       <%--쇼핑 계속하기 --%>
       <a href="${contextPath}/main/main.do">
          <img width="75" alt="" src="${contextPath}/resources/image/btn_shoping_continue.jpg">
       </a>
   </center>
</form>   





