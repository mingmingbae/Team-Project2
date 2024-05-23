<%@ page language="java" contentType="text/html; charset=utf-8"
   pageEncoding="utf-8"
    isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>

<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />

<!-- 주문자 휴대폰 번호 -->
<c:set  var="orderer_hp" value=""/>
<!-- 최종 결제 금액 -->
<c:set var="final_total_order_price" value="0" />
<!-- 총주문 금액 -->
<c:set var="total_order_price" value="0" />
<!-- 총 상품수 -->
<c:set var="total_order_goods_qty" value="0" />
<!-- 총할인금액 -->
<c:set var="total_discount_price" value="0" />
<!-- 총 배송비 -->
<c:set var="total_delivery_price" value="0" />


<head>
<style>

#layer {
   z-index: 2;
   position: absolute;
   top: 0px;
   left: 0px;
   width: 100%;

}

#popup_order_detail {
   z-index: 3;
   position: fixed;
    text-align: center; 
   left: 10%;
   top: 0%;
   width: 60%;
   height: 100%;
   background-color:#ccff99; /* 팝업창의 배경색 설정*/
   border: 2px solid  #0000ff;
}

 
 #close {
   z-index: 4;
   float: right;
}
</style>

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
//    배송주소 입력
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
                var extraRoadAddr = ''; // 도로명 조합형 주소 변수

                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraRoadAddr !== ''){
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }
                // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
                if(fullRoadAddr !== ''){
                    fullRoadAddr += extraRoadAddr;
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('zipcode').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('roadAddress').value = fullRoadAddr;
                document.getElementById('jibunAddress').value = data.jibunAddress;

                // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
                if(data.autoRoadAddress) {
                    //예상되는 도로명 주소에 조합형 주소를 추가한다.
                    var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                    document.getElementById('guide').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';

                } else if(data.autoJibunAddress) {
                    var expJibunAddr = data.autoJibunAddress;
                    document.getElementById('guide').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';

                } else {
                    document.getElementById('guide').innerHTML = '';
                }
            }
        }).open();
    }

//2. 배송지 정보 화면
  window.onload=function()
  {
    init();
  }
  function init(){
     var form_order=document.form_order;

   //로그인 한 주문자의 유선전화번호 중 지역번호를 option태그가 선택되도록 설정 하는 부분     
        var h_tel1=form_order.h_tel1;
       var tel1=h_tel1.value;    
       var select_tel1=form_order.tel1;
        select_tel1.value=tel1;
     
   //로그인 한 주문자의 휴대폰번호 중  앞 010, 011, 017, 018 중  option태그가 선택되도록 설정 하는 부분
        var h_hp1=form_order.h_hp1;
      var hp1=h_hp1.value; 
        var select_hp1=form_order.hp1;
        select_hp1.value=hp1; 
     
  }    
//-----------------------------------------------------------------------    
  
  //2. 배송지 정보_리셋         
   function reset_all() {
      var e_receiver_name = document.getElementById("receiver_name");
      var e_hp1 = document.getElementById("hp1");
      var e_hp2 = document.getElementById("hp2");
      var e_hp3 = document.getElementById("hp3");

      var e_tel1 = document.getElementById("tel1");
      var e_tel2 = document.getElementById("tel2");
      var e_tel3 = document.getElementById("tel3");

      var e_zipcode = document.getElementById("zipcode");
      var e_roadAddress = document.getElementById("roadAddress");
      var e_jibunAddress = document.getElementById("jibunAddress");
      var e_namujiAddress = document.getElementById("namujiAddress");

      e_receiver_name.value = "";
      e_hp1.value = 0;
      e_hp2.value = "";
      e_hp3.value = "";
      e_tel1.value = "";
      e_tel2.value = "";
      e_tel3.value = "";
      e_zipcode.value = "";
      e_roadAddress.value = "";
      e_jibunAddress.value = "";
      e_namujiAddress.value = "";
   }

  
//2. 배송지 정보      
   function restore_all() {
      var e_receiver_name = document.getElementById("receiver_name");
      var e_hp1 = document.getElementById("hp1");
      var e_hp2 = document.getElementById("hp2");
      var e_hp3 = document.getElementById("hp3");

      var e_tel1 = document.getElementById("tel1");
      var e_tel2 = document.getElementById("tel2");
      var e_tel3 = document.getElementById("tel3");

      var e_zipcode = document.getElementById("zipcode");
      var e_roadAddress = document.getElementById("roadAddress");
      var e_jibunAddress = document.getElementById("jibunAddress");
      var e_namujiAddress = document.getElementById("namujiAddress");

      var h_receiver_name = document.getElementById("h_receiver_name");
      var h_hp1 = document.getElementById("h_hp1");
      var h_hp2 = document.getElementById("h_hp2");
      var h_hp3 = document.getElementById("h_hp3");

      var h_tel1 = document.getElementById("h_tel1");
      var h_tel2 = document.getElementById("h_tel2");
      var h_tel3 = document.getElementById("h_tel3");

      var h_zipcode = document.getElementById("h_zipcode");
      var h_roadAddress = document.getElementById("h_roadAddress");
      var h_jibunAddress = document.getElementById("h_jibunAddress");
      var h_namujiAddress = document.getElementById("h_namujiAddress");
      
      e_receiver_name.value = h_receiver_name.value;
      e_hp1.value = h_hp1.value;
      e_hp2.value = h_hp2.value;
      e_hp3.value = h_hp3.value;

      e_tel1.value = h_tel1.value;
      e_tel2.value = h_tel2.value;
      e_tel3.value = h_tel3.value;
      e_zipcode.value = h_zipcode.value;
      e_roadAddress.value = h_roadAddress.value;
      e_jibunAddress.value = h_jibunAddress.value;
      e_namujiAddress.value = h_namujiAddress.value;

   }
   
//-----------------------------------------------------------------------   


//최종 결제하기 팝업화면 띄우기
function imagePopup(type) {
   if (type == 'open') {
      jQuery('#layer').attr('style', 'visibility:visible');
      jQuery('#layer').height(jQuery(document).height());
   }
   else if (type == 'close') {
      jQuery('#layer').attr('style', 'visibility:hidden');
   }
}

//-----------------------------------------------------------------------   

/** 입력된 결제정보를 다시 저장할 변수 선언**/
var goods_id=""; //구매 상품 번호들이 저장되는 변수
var goods_title="";//구매 상품 제목들이 저장되는 변수
var goods_fileName="";//구매 도서상품 이미지명 들이 저장되는 변수

var order_goods_qty //구매 상품 수량
var each_goods_price;
var total_order_goods_price;
var total_order_goods_qty;

var orderer_name  //회원 이름(받으실분 이름)
var receiver_name //로그인된 구매자 이름(받으실분 이름)

//로그인된 구매자의 휴대폰 번호
var hp1;  // 010
var hp2;  // 1234
var hp3;  // 5678

//로그인된 구매자의 유선전화 번호
var tel1;  // 051
var tel2;  // 1234
var tel3;  // 5678

var receiver_hp_num; //로그인된 구매자의 휴대폰 번호
var receiver_tel_num; //로그인된 구매자의 휴대폰 번호
var delivery_address;    //주소
var delivery_message; //배송 메세지
var delivery_method; //배송 방법
var gift_wrapping; //선물 포장 여부
var pay_method; //결제정보

//----------------------------------------------------------------------- 

//결제하기 버튼 클릭
function fn_show_order_detail(){
   
   goods_id=""; //구매 상품 번호들이 저장되는 변수
   goods_title=""; //구매 상품 제목들이 저장되는 변수
   
   //입력된 결제정보
   var frm=document.form_order;
   var h_goods_id=frm.h_goods_id;   //주문 한 상품 번호
   var h_goods_title=frm.h_goods_title; //주문 한 상품 명
   var h_goods_fileName=frm.h_goods_fileName; //주문 한 상품 이미지명
   var r_delivery_method  =  frm.delivery_method; //배송방법
   var h_order_goods_qty=document.getElementById("h_order_goods_qty"); //주문 한 상품 수량
   var h_total_order_goods_qty=document.getElementById("h_total_order_goods_qty"); //구매할 총 상품 수량
   var h_final_total_Price=document.getElementById("h_final_total_Price"); //최종 결제 금액
   var h_orderer_name=document.getElementById("h_orderer_name"); //로그인된 구매자(받으실분) 이름
   var i_receiver_name=document.getElementById("receiver_name"); //로그인된 구매자(받으실분) 이름
   
   // h_goods_id 변수의 길이가 2보다 작거나 null인 경우, 
   //즉 주문할 상품의 개수가 1개인 경우, 주문 할 상품 번호를 goods_id 변수에 추가
   if(h_goods_id.length <2 ||h_goods_id.length==null){      
      goods_id+=h_goods_id.value;   
   }else{
      for(var i=0; i<h_goods_id.length;i++){
         goods_id+=h_goods_id[i].value+"<br>";
      }   
   }
   
   //상품의 제목을 h_goods_title
    if(h_goods_title.length <2 ||h_goods_title.length==null){
      goods_title+=h_goods_title.value;
   }else{
      for(var i=0; i<h_goods_title.length;i++){
         goods_title+=h_goods_title[i].value+"<br>";
      }   
   }
   
     //주문한 상품 이미지명
   if(h_goods_fileName.length <2 ||h_goods_fileName.length==null){
      goods_fileName+=h_goods_fileName.value;
   }else{
      for(var i=0; i<h_goods_fileName.length;i++){
         goods_fileName+=h_goods_fileName[i].value+"<br>";
      }   
   }
   
   total_order_goods_price=h_final_total_Price.value; //최종 결제 금액
   total_order_goods_qty=h_total_order_goods_qty.value; //구매할 총 상품 수량
   
   //for문을 이용하여, 배송 방법(일반택배,편의점택배)
   for(var i=0; i<r_delivery_method.length;i++){
     if(r_delivery_method[i].checked==true){
       delivery_method=r_delivery_method[i].value
       break;
     }
   } 
   
   //r_gift_wrapping 변수에는 선물 포장 여부
   var r_gift_wrapping  =  frm.gift_wrapping;
   for(var i=0; i<r_gift_wrapping.length;i++){
     if(r_gift_wrapping[i].checked==true){
        gift_wrapping=r_gift_wrapping[i].value
       break;
     }
   }
   
   //결제 방법(pay_method)   
    pay_method= frm.pay_method.value;
   
/*   입력된  2.배송지 정보 중에서... 휴대폰번호 선택 요소들 얻기 */   
   var i_hp1=document.getElementById("hp1");
   var i_hp2=document.getElementById("hp2");
   var i_hp3=document.getElementById("hp3");
 
      
/*   입력된  2.배송지 정보 중에서... 유선전화(선택)요소들 얻기 */   
   var i_tel1=document.getElementById("tel1");
   var i_tel2=document.getElementById("tel2");
   var i_tel3=document.getElementById("tel3");

//입력된  2.배송지 정보
   var i_zipcode=document.getElementById("zipcode");
   var i_roadAddress=document.getElementById("roadAddress");
   var i_jibunAddress=document.getElementById("jibunAddress");
   var i_namujiAddress=document.getElementById("namujiAddress");
   
//배송 메세지(delivery_message)
   var i_delivery_message=document.getElementById("delivery_message");
   
//입력된  4. 결제정보 영역
//    var i_pay_method=document.getElementById("pay_method");

    //주문한 상품 수량(구매 상품 수량)
   order_goods_qty=h_order_goods_qty.value;

   //로그인된 구매자 이름(받으실분 이름)
   orderer_name=h_orderer_name.value;
   
   //로그인된 구매자 이름(받으실분 이름)
   receiver_name=i_receiver_name.value;
   
   //로그인된 구매자의 휴대폰 번호를 hp1 ~ hp3 변수에 저장
   hp1=i_hp1.value;
   hp2=i_hp2.value;
   hp3=i_hp3.value;
   
   //로그인된 구매자의 유선 전화 번호를 tel1 ~ tel3 변수에 저장
   tel1=i_tel1.value;
   tel2=i_tel2.value;
   tel3=i_tel3.value;
   
   //로그인된 구매자의 휴대폰 번호
   receiver_hp_num=hp1+"-"+hp2+"-"+hp3;
   //로그인된 구매자의 유선 전화 번호
   receiver_tel_num=tel1+"-"+tel2+"-"+tel3;
   
   //주소
   delivery_address="우편번호:"+i_zipcode.value+"<br>"+
                  "도로명 주소:"+i_roadAddress.value+"<br>"+
                  "[지번 주소:"+i_jibunAddress.value+"]<br>"+
                          i_namujiAddress.value;
   
   //배송 메세지
   delivery_message=i_delivery_message.value;

//-----------------------------------------------------------------------    
   
//    최종 결제 팝업창 정보들
   var p_order_goods_id=document.getElementById("p_order_goods_id");
   var p_order_goods_title=document.getElementById("p_order_goods_title");
   var p_order_goods_qty=document.getElementById("p_order_goods_qty");
   var p_total_order_goods_qty=document.getElementById("p_total_order_goods_qty");
   var p_total_order_goods_price=document.getElementById("p_total_order_goods_price");
   var p_orderer_name=document.getElementById("p_orderer_name");
   var p_receiver_name=document.getElementById("p_receiver_name");
   var p_delivery_method=document.getElementById("p_delivery_method");
   var p_receiver_hp_num=document.getElementById("p_receiver_hp_num");
   var p_receiver_tel_num=document.getElementById("p_receiver_tel_num");
   var p_delivery_address=document.getElementById("p_delivery_address");
   var p_delivery_message=document.getElementById("p_delivery_message");
   var p_gift_wrapping=document.getElementById("p_gift_wrapping");   
   var p_pay_method=document.getElementById("p_pay_method");
   
   p_order_goods_id.innerHTML=goods_id;
   p_order_goods_title.innerHTML=goods_title;
   p_total_order_goods_qty.innerHTML=total_order_goods_qty+"개";
   p_total_order_goods_price.innerHTML=Math.floor(total_order_goods_price).toLocaleString() + "원";
   p_orderer_name.innerHTML=orderer_name;
   p_receiver_name.innerHTML=receiver_name;
   p_delivery_method.innerHTML=delivery_method;
   p_receiver_hp_num.innerHTML=receiver_hp_num;
   p_receiver_tel_num.innerHTML=receiver_tel_num;
   p_delivery_address.innerHTML=delivery_address;
   p_delivery_message.innerHTML=delivery_message;
   p_gift_wrapping.innerHTML=gift_wrapping;
   p_pay_method.innerHTML=pay_method;
   imagePopup('open');
}

//----------------------------------------------------------------------- 

//최종 결제하기를 클릭
function fn_process_pay_order() {
    alert("최종 결제하기");

    var order_email = document.getElementById("order_email").value; // 구매자 이메일 주소
    console.log(order_email);
    var order_name = document.getElementById("order_name").value; // 구매자명
    console.log(order_name);
    var user_hp = document.getElementById("user_hp").value; // 구매자 연락처
    console.log(user_hp);

    var uid = '';
    IMP.init('imp23446354');
    IMP.request_pay({
        pg: 'kakaopay',
        pay_method: "card",
        merchant_uid: createOrderNum(), // 가맹점 주문번호
        name: goods_title, // 상품명
        amount: total_order_goods_price, // 결제금액
        buyer_email: order_email,
        buyer_name: order_name,
        buyer_tel: user_hp,
    }, function (rsp) { // callback
        if (rsp.success) { // 결제 성공 시
            uid = rsp.imp_uid;
            // 결제검증
            $.ajax({
                url: '${contextPath}/order/verify_iamport.do/' + rsp.imp_uid,
                type: 'post'
            }).done(function(data) {
                // 결제된 금액과 요청한 금액이 같으면 주문정보를 서버로 전송
                if (total_order_goods_price == data.response.amount) {
                    // 주문정보를 담은 객체
                    var receiverMap = {
                        "receiver_name": receiver_name, // 수령인 명
                        "receiver_hp1": hp1, // 수령인 연락처
                        "receiver_hp2": hp2,
                        "receiver_hp3": hp3,
                        "receiver_tel1": tel1,
                        "receiver_tel2": tel2,
                        "receiver_tel3": tel3,
                        "delivery_address": delivery_address, // 배송주소
                        "delivery_message": delivery_message, // 배송메세지
                        "delivery_method": delivery_method, // 배송방법
                        "gift_wrapping": gift_wrapping, // 포장여부
                        "pay_method": pay_method // 결제수단
                    };
                    // 서버로 주문정보 전송
                    jQuery.ajax({
                        url: "${contextPath}/order/payToOrderGoods.do",
                        type: "POST",
                        data: receiverMap,
                        async: false, 
                        dataType: "text"// JSON 형식이 아닌 Map 형식으로 직접 전송
                    }).done(function(res) {
                       console.log(res)
                        if (res === "성공") {
                            alert('결재가 완료되었습니다.');
                            imagePopup('close');
                            window.location.href = "${contextPath}/order/confirmOrderGoods.do";
                        }
                        else {
                            alert('결재가 실패되었습니다. 다시 시도해주세요.');
                        }
                    })//done종료
                }
                else {
                    alert('결제 실패');
                }
            })
        } else {
            alert("결제에 실패하였습니다.","에러 내용: " +  rsp.error_msg,"error");
        }
    });
}
       
// 랜덤 가맹점 주문번호 생성
function createOrderNum(){
   const date = new Date();
   const year = date.getFullYear();
   const month = String(date.getMonth() + 1).padStart(2, "0");
   const day = String(date.getDate()).padStart(2, "0");
   
   let orderNum = year + month + day;
   for(let i=0;i<10;i++) {
      orderNum += Math.floor(Math.random() * 8);   
   }
   return orderNum;
}
</script>
</head>

<body>
   <H1>1.주문확인</H1>
<form  name="form_order">   
   <table class="list_view">
      <tbody align=center>
         <tr style="background: #33ff00">
            <td colspan=2 class="fixed">주문상품</td>
            <td>수량</td>
            <td>주문금액</td>
            <td>배송비</td>
            <td>할인금액</td>
            <td>주문금액합계</td>
         </tr>
                  
      <c:forEach var="item" items="${sessionScope.myOrderList}">
         <tr>   
            <td class="goods_image" colspan="2">
               
              <%-- 주문 상품 상세화면을 요청 --%>   
              <a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id }">
               
                <%--주문 상품 이미지 표시--%>
                <img width="75" alt=""  src="${contextPath}/thumbnails.do?goods_id=${item.goods_id}&fileName=${item.goods_fileName}">
                
                <%-- 나중에  결제하기를 눌렀을때 요청하는 값들 (주문 한 상품 번호 , 주문 한 상품 이미지명, 주문 상품명, 주문 수량, 주문금액 합계)  --%>
                <input   type="hidden" id="h_goods_id" name="h_goods_id" value="${item.goods_id}" />
                <input   type="hidden" id="h_goods_fileName" name="h_goods_fileName" value="${item.goods_fileName}" />
                 <input   type="hidden" id="h_goods_title" name="h_goods_title" value="${item.goods_title}" />
                  <input   type="hidden" id="h_order_goods_qty" name="h_order_goods_qty" value="${item.order_goods_qty}" />
                   <input  type="hidden" id="h_each_goods_price"  name="h_each_goods_price" value="${item.goods_sales_price}" />
              </a>
              
            </td>
            
            <%-- 수량  --%>  
            <td>        
              <h2>${item.order_goods_qty}개<h2>   
            </td>
            
            <%-- 주문금액/정가 --%>
            <td><h2><span><fmt:formatNumber value="${(item.goods_sales_price/0.9)*item.order_goods_qty}" pattern="###,###" var="goods_price"/>${goods_price}원</span></h2></td>
            
            <%-- 배송비 --%>
            <td><h2>0원</h2></td>
            
            <%-- 할인금액/10% 할인 --%>
            <td class="active"><span><fmt:formatNumber value="${(item.goods_sales_price/0.9)*0.1}" pattern="###,###" var="discounted_price"/>-${discounted_price}원</span></td>
            
            <%-- 주문금액 합계 --%>
            <td>
              <h2><span><fmt:formatNumber value="${item.goods_sales_price * item.order_goods_qty}" pattern="###,###" var="total_price"/>${total_price}원</span></h2>
            </td>
         </tr>
              <%-- 최종 결제 금액 ( 주문 금액 합계 금액을 누적) --%>
               <c:set var="final_total_order_price"
                  value="${final_total_order_price+ item.goods_sales_price* item.order_goods_qty}" />
                  
              <%-- 총주문 금액 ( 주문 수량 누적 ) --%>      
               <c:set var="total_order_price"
                  value="${total_order_price+ item.goods_sales_price* item.order_goods_qty}" />
               
              <%--  총 상품 수 ( 주문 수 누적 )--%>   
               <c:set var="total_order_goods_qty"
                  value="${total_order_goods_qty+item.order_goods_qty }" />
         </c:forEach>
      </tbody>
   </table>
   <div class="clear"></div>

   <br>
   <br>
   <H1>2.배송지 정보</H1>
   <DIV class="detail_table">
   
      <table>
         <tbody>
            <tr class="dot_line">
               <td class="fixed_join">배송방법</td>
               <td>
                   <input type="radio" id="delivery_method" name="delivery_method" value="일반택배" checked>일반택배 &nbsp;&nbsp;&nbsp; 
                  <input type="radio" id="delivery_method" name="delivery_method" value="편의점택배">편의점택배 &nbsp;&nbsp;&nbsp; 
                </td>
            </tr>
            <tr class="dot_line">
               <td class="fixed_join">배송지 선택</td>
               <td><input type="radio" name="delivery_place"
                  onClick="restore_all()" value="기본배송지" checked>기본배송지 &nbsp;&nbsp;&nbsp; 
                  <input type="radio" name="delivery_place" value="새로입력" onClick="reset_all()">새로입력 &nbsp;&nbsp;&nbsp;
                  <input type="radio" name="delivery_place" value="최근배송지">최근배송지 &nbsp;&nbsp;&nbsp;
                </td>
            </tr>
            <tr class="dot_line">
               <td class="fixed_join">받으실 분</td>
               <td><input id="receiver_name" name="receiver_name" type="text" size="40" value="${orderer.member_name }" />
                  <input type="hidden" id="h_orderer_name" name="h_orderer_name"  value="${orderer.member_name }" /> 
                  <input type="hidden" id="h_receiver_name" name="h_receiver_name"  value="${orderer.member_name }" />
               </td>
            </tr>
            <tr class="dot_line">
               <td class="fixed_join">휴대폰번호</td>
               <td><select id="hp1" name="hp1">
                     <option>없음</option>
                     <option value="010" selected>010</option>
                     <option value="011">011</option>
                     <option value="016">016</option>
                     <option value="017">017</option>
                     <option value="018">018</option>
                     <option value="019">019</option>
               </select> 
                - <input size="10px" type="text" id="hp2" name="hp2" value="${orderer.hp2 }"> 
                - <input size="10px" type="text" id="hp3" name="hp3" value="${orderer.hp3 }"><br><br> 
                 <input type="hidden" id="h_hp1" name="h_hp1" value="${orderer.hp1 }" /> 
                 <input type="hidden" id="h_hp2" name="h_hp2" value="${orderer.hp2 }" /> 
                 <input type="hidden" id="h_hp3" name="h_hp3"  value="${orderer.hp3 }" />
                 <c:set  var="orderer_hp" value="${orderer.hp1}-${orderer.hp2}-${orderer.hp3 }"/>
                                             
                        
              </tr>
            <tr class="dot_line">
               <td class="fixed_join">유선전화(선택)</td>
               <td>
                     <select id="tel1" name="tel1">
                        <option value="02">02</option>
                        <option value="031">031</option>
                        <option value="032">032</option>
                        <option value="033">033</option>
                        <option value="041">041</option>
                        <option value="042">042</option>
                        <option value="043">043</option>
                        <option value="044">044</option>
                        <option value="051">051</option>
                        <option value="052">052</option>
                        <option value="053">053</option>
                        <option value="054">054</option>
                        <option value="055">055</option>
                        <option value="061">061</option>
                        <option value="062">062</option>
                        <option value="063">063</option>
                        <option value="064">064</option>
                        <option value="0502">0502</option>
                        <option value="0503">0503</option>
                        <option value="0505">0505</option>
                        <option value="0506">0506</option>
                        <option value="0507">0507</option>
                        <option value="0508">0508</option>
                        <option value="070">070</option>
                  </select> - 
                  <input size="10px" type="text" id="tel2" name="tel2" value="${sessionScope.orderer.tel2 }"> -
                   <input size="10px" type="text" id="tel3" name="tel3" value="${orderer.tel3 }">
               </td>
               
               <input type="hidden" id="h_tel1" name="h_tel1" value="${sessionScope.orderer.tel1 }" />
               <input type="hidden" id="h_tel2" name="h_tel2"   value="${sessionScope.orderer.tel2 }" />
               <input type="hidden" id="h_tel3" name="h_tel3"value="${sessionScope.orderer.tel3 }" />
            </tr>
            <tr class="dot_line">
               <td class="fixed_join">주소</td>
               <td><input type="text" id="zipcode" name="zipcode" size="5"
                  value="${orderer.zipcode }"> 
                  <a href="javascript:execDaumPostcode()">우편번호검색</a> <br>
                  <p>
                     지번 주소:<br>
                     <input type="text" id="roadAddress" name="roadAddress" size="50" value="${orderer.roadAddress }" /><br>
                     <br> 도로명 주소: 
                        <input type="text" id="jibunAddress" name="jibunAddress" size="50"
                                      value="${orderer.jibunAddress }" /><br>
                     <br> 나머지 주소: 
                        <input type="text" id="namujiAddress"  name="namujiAddress" size="50"
                             value="${orderer.namujiAddress }" /> 
                  </p> 
                   <input type="hidden" id="h_zipcode" name="h_zipcode" value="${orderer.zipcode }" /> 
                   <input type="hidden"  id="h_roadAddress" name="h_roadAddress"  value="${orderer.roadAddress }" /> 
                   <input type="hidden"  id="h_jibunAddress" name="h_jibunAddress" value="${orderer.jibunAddress }" /> 
                   <input type="hidden"  id="h_namujiAddress" name="h_namujiAddress" value="${orderer.namujiAddress }" />
               </td>
            </tr>
            <tr class="dot_line">
               <td class="fixed_join">배송 메시지</td>
               <td>
                  <input id="delivery_message" name="delivery_message" type="text" size="50"
                                     placeholder="택배 기사님께 전달할 메시지를 남겨주세요." />
                 </td>
            </tr>
            <tr class="dot_line">
               <td class="fixed_join">선물 포장</td>
               <td><input type="radio" id="gift_wrapping" name="gift_wrapping" value="yes">예
                  &nbsp;&nbsp;&nbsp; <input type="radio"  id="gift_wrapping" name="gift_wrapping" checked value="no">아니요</td>
            </td>
         </tboby>
      </table>
   </div>
   <div >
     <br><br>
      <h2>주문고객</h2>
       <table>
         <tbody>
          <tr class="dot_line">
            <td ><h2>이름</h2></td>
            <td>
             <input  type="text" value="${orderer.member_name}" size="15" id="order_name" />
            </td>
           </tr>
           <tr class="dot_line">
            <td ><h2>핸드폰</h2></td>
            <td>
             <input type="text" value="${orderer.hp1}-${orderer.hp2}-${orderer.hp3}" size="15" id="user_hp" />
            </td>
           </tr>
           <tr class="dot_line">
            <td ><h2>이메일</h2></td>
            <td>
             <input  type="text" value="${orderer.email1}@${orderer.email2}" size="15" id="order_email" name="order_email"/>
            </td>
           </tr>
         </tbody>
      </table>
   </div>
   <div class="clear"></div>
   <br>
   <br>
   <br>

   <br>
   <table width=80% class="list_view" style="background: #ccffff">
      <tbody>
         <tr align=center class="fixed">
            <td class="fixed">총 상품수</td>
            <td>총 상품금액</td>
            <td></td>
            <td>총 배송비</td>
            <td></td>
            <td>최종 결제금액</td>
         </tr>
         <tr cellpadding=40 align=center>
            <td id="">
               <p id="p_totalNum">${total_order_goods_qty}개</p> 
               <input id="h_total_order_goods_qty" type="hidden" value="${total_order_goods_qty}" />
            </td>
            <td>
               <p id="p_totalPrice"><fmt:formatNumber value="${total_order_price}" pattern="###,###" />원</p> 
               <input id="h_totalPrice" type="hidden" value="${total_order_price}" />
            </td>
            <td><IMG width="25" alt="" src="${pageContext.request.contextPath}/resources/image/plus.jpg"></td>
            <td>
               <p id="p_totalDelivery">${total_delivery_price}원</p> 
               <input id="h_totalDelivery" type="hidden" value="${total_delivery_price}" />
            </td>
            <td><img width="25" alt="" src="${pageContext.request.contextPath}/resources/image/equal.jpg"></td>
            <td>
               <p id="p_final_totalPrice">
                  <font size="15"><fmt:formatNumber value="${final_total_order_price}" pattern="###,###" />원</font>
               </p> 
               <input id="h_final_total_Price" type="hidden" value="${final_total_order_price}" />
            </td>
         </tr>
      </tbody>
   </table>
   <div class="clear"></div>
   <br>
   <br>
   <br>
   <h1>4.결제정보</h1>
   <div class="detail_table">
      <table>
         <tbody>
            <tr >
               <td>
                  <input type="radio" id="pay_method" name="pay_method" value="카카오페이(간편결제)" checked>카카오페이(간편결제) &nbsp;&nbsp;&nbsp; 
               </td>
            </tr>
         </tbody>
      </table>
   </div>
</form>
    <div class="clear"></div>
   <br>
   <br>
   <br>
   <center>
      <br>
      <br> 
       <%-- 결제하기  --%>
      <a href="javascript:fn_show_order_detail();"> 
         <img width="125" alt="" src="${contextPath}/resources/image/btn_gulje.jpg"> 
      </a> 
       <%-- 쇼핑 계속 하기 --%>
      <a href="${contextPath}/main/main.do"> 
         <img width="75" alt="" src="${contextPath}/resources/image/btn_shoping_continue.jpg">  
      </a>
   
<div class="clear"></div>

<%--  --------------------------   팝업 창   시작 ------------------------------------  --%>
   <div id="layer" style="visibility:hidden">
      <!-- visibility:hidden 으로 설정하여 해당 div안의 모든것들을 가려둔다. -->
      <div id="popup_order_detail">
         <!-- 팝업창 닫기  X 버튼 -->
         <a href="javascript:" onClick="javascript:imagePopup('close', '.layer01');">
          <img  src="${contextPath}/resources/image/close.png" id="close" />
         </a> 
         <br/> 
           <div class="detail_table">
           <h1>최종 주문 사항</h1>
         <table>
            <tbody align=left>
                <tr>
                 <td width=200px>
                     주문상품번호:
                </td>
                <td>
                   <p id="p_order_goods_id"> 주문번호 </p>    
                </td>
               </tr>
               <tr>
                 <td width=200px>
                     주문상품명:
                </td>
                <td>
                    <p id="p_order_goods_title"> 주문 상품명 </p>    
                </td>
               </tr>
               <tr>
                 <td width=200px>
                     주문상품개수:
                </td>
                <td>
                    <p id="p_total_order_goods_qty"> 주문 상품개수 </p>    
                </td>
               </tr>
               <tr>
                 <td width=200px>
                    주문금액합계:
                </td>
                <td >
                     <p id="p_total_order_goods_price">주문금액합계</p>
                </td>
               </tr>
               <tr>
                 <td width=200px>
                    주문자:
                </td>
                <td>
                     <p id="p_orderer_name"> 주문자 이름</p>
                </td>
               </tr>
               <tr>
                 <td width=200px>
                    받는사람:
                </td>
                <td>
                     <p id="p_receiver_name">받는사람이름</p>
                </td>
               </tr>
               <tr>
                 <td width=200px>
                    배송방법:
                </td>
                <td>
                     <p id="p_delivery_method">배송방법</p>
                </td>
               </tr>
               <tr>
                 <td width=200px>
                    받는사람 휴대폰번호:
                </td>
                <td>
                     <p id="p_receiver_hp_num"></p>
                </td>
               </tr>
               <tr>
                 <td width=200px>
                    받는사람 유선번화번호:
                </td>
                <td>
                     <p id="p_receiver_tel_num">배송방법</p>
                </td>
               </tr>
               <tr>
                 <td width=200px>
                    배송주소:
                </td>
                <td align=left>
                     <p id="p_delivery_address">배송주소</p>
                </td>
               </tr>
                <tr>
                 <td width=200px>
                    배송메시지:
                </td>
                <td align=left>
                     <p id="p_delivery_message">배송메시지</p>
                </td>
               </tr>
               <tr>
                 <td width=200px>
                    선물포장 여부:
                </td>
                <td align=left>
                     <p id="p_gift_wrapping">선물포장</p>
                </td>
               </tr>
               <tr>
                 <td width=200px>
                    결제방법:
                </td>
                <td align=left>
                     <p id="p_pay_method">결제방법</p>
                </td>
               </tr>
               <tr>
                <td colspan=2 align=center>
                
                <%-- 팝업창에서 최종결제하기 클릭시 함수호출 !  함수 내부에서는  팝업창에서 수량정보를 확인후   컨트롤러로 결제 요청을함 --%>
                
                <input  name="btn_process_pay_order" type="button" 
                       onClick="fn_process_pay_order()" value="최종결제하기">
                </td>
               </tr>
            </tbody>
            </table>
         </div>
<%--  --------------------------   팝업 창  끝  ------------------------------------  --%>         
         
         <div class="clear"></div>   
         <br> 
</body>
         
         