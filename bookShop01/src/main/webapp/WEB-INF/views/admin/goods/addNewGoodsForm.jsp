<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />	
<!DOCTYPE html>

<meta charset="utf-8">
<head>
<script type="text/javascript">
  
  var cnt=0; // 상세 이미지의 첨부 순서
  
  //아래의 파일추가 버튼을 클릭하면 호출되는 함수로  첨부할 파일을 선택할 <input>들을 동적으로 생성하여  id속성값이 d_file인 <div id="d_file"></div>요소 내부에 추가시키는 함수 
  function fn_addFile(){
	  if(cnt == 0){
		  //첫번째 파일업로드는 메인 이미지를 첨부하므로 name속성값을 main_image로 설정 
		  $("#d_file").append("<br>"+"<input  type='file' name='main_image' id='f_main_image' />");	  
	  }else{
		  //그외의 업로드하는 파일 이미지들은  name속성값들을 detail_image+cnt 로 설정 
		  $("#d_file").append("<br>"+"<input  type='file' name='detail_image"+cnt+"' />");
	  }
  	cnt++;
  }
  
  //새 상품 등록
  function fn_add_new_goods(obj){
		 fileName = $('#f_main_image').val();
		 if(fileName != null && fileName != undefined){
			 obj.submit();
		 }else{
			 alert("메인 이미지는 반드시 첨부해야 합니다.");
			 return;
		 } 
	}
  
//입력한 금액 천단위로 나누는 함수
  function formatPrice(price) {
      return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  }
  
 //정가 입력했을때 판매가격 10% 자동할인
  function discount() {
        var goodsPriceInput = document.getElementsByName("goods_price")[0];
        var goodsSalesPriceInput = document.getElementsByName("goods_sales_price")[0];
        var goodsPrice = parseInt(goodsPriceInput.value.replace(/,/g, ""));
        var formattedPrice = formatPrice(goodsPrice);
        goodsPriceInput.value = formattedPrice; // 천 단위 구분자 추가

        // 제품 판매 가격 설정
        var discountedPrice = goodsPrice * 0.9; // 예시: 10% 할인
        var formattedDiscountedPrice = formatPrice(discountedPrice);
        goodsSalesPriceInput.value = formattedDiscountedPrice; // 천 단위 구분자 추가 
 }
 
 //아래로부터 상품 등록 유효성 검사
  function ss() {
	    var nameInput = document.getElementsByName("goods_title")[0];
	    var errorMessage = document.getElementsByClassName("error-message")[0];
	    
	    var name = nameInput.value;
	    if (name == "") {
	        errorMessage.innerText = "제품이름을 입력해주세요";
	        return false;
	    } else {
	        errorMessage.innerText = ""; 
	        return true;
	    }
	}
  
  function ss1() {
	    var writerInput = document.getElementsByName("goods_writer")[0];
	    var errorMessage = document.getElementsByClassName("error-message")[1];
	    
	    var writer = writerInput.value;
	    if (writer == "") {
	        errorMessage.innerText = "저자명을 입력해주세요.";
	        return false;
	    } else {
	        errorMessage.innerText = ""; 
	        return true;
	    }
	}
  
  function ss2() {
	    var publisherInput = document.getElementsByName("goods_publisher")[0];
	    var errorMessage = document.getElementsByClassName("error-message")[2];
	    
	    var publisher = publisherInput.value;
	    if (publisher == "") {
	        errorMessage.innerText = "출판사명을 입력해주세요.";
	        return false;
	    } else {
	        errorMessage.innerText = ""; 
	        return true;
	    }
	}
  
  function ss3() {
	    var pageInput = document.getElementsByName("goods_total_page")[0];
	    var errorMessage = document.getElementsByClassName("error-message")[3];
	    
	    var page = pageInput.value;
	    if (page == "") {
	        errorMessage.innerText = "페이지수를 입력해주세요.";
	        return false;
	    } else {
	        errorMessage.innerText = ""; 
	        return true;
	    }
	}
  
  function ss4() {
	    var isbnInput = document.getElementsByName("goods_isbn")[0];
	    var errorMessage = document.getElementsByClassName("error-message")[4];
	    
	    var isbn = isbnInput.value;
	    if (isbn == "") {
	        errorMessage.innerText = "isbn를 입력해주세요.";
	        return false;
	    } else {
	        errorMessage.innerText = ""; 
	        return true;
	    }
	}
</script>    
</head>

<BODY>
<form action="${contextPath}/admin/goods/addNewGoods.do" method="post"  enctype="multipart/form-data">
		<h1>새상품 등록창</h1>
<div class="tab_container">
	<!-- 내용 들어 가는 곳 -->
	<div class="tab_container" id="container">
		<ul class="tabs">
			<li><a href="#tab1">상품정보</a></li>
			<li><a href="#tab2">상품목차</a></li>
			<li><a href="#tab3">상품저자소개</a></li>
			<li><a href="#tab4">상품소개</a></li>
			<li><a href="#tab5">출판사 상품 평가</a></li>
			<li><a href="#tab6">추천사</a></li>
			<li><a href="#tab7">상품이미지</a></li>
		</ul>
		<div class="tab_container">
			<div class="tab_content" id="tab1">
				<table >
			<tr >
				<td width=200 >제품분류</td>
				<td width=500><select name="goods_sort">
						<option value="IT/인터넷" selected>IT/인터넷
						<option value="자기계발">자기계발
						<option value="국내소설">국내소설
					</select>
				</td>
			</tr>
			<tr >
				<td >제품이름</td>
				<td>
					<input name="goods_title" type="text" size="40" onkeyup="ss()"/>
					<div class="error-message" style="color: red; display: inline;" ></div>
				</td>
				
			</tr>
			
			<tr>
				<td >저자</td>
				<td>
					<input name="goods_writer" type="text" size="40" onkeyup="ss1()" />
					<div class="error-message" style="color: red; display: inline;" ></div>	
				</td>
			</tr>
			<tr>
				<td >출판사</td>
				<td>
					<input name="goods_publisher" type="text" size="40" onkeyup="ss2()"/>
					<div class="error-message" style="color: red; display: inline;" ></div>	
				</td>
			</tr>
			<tr>
				<td >제품정가</td>
				<td>
					<input name="goods_price" type="text" size="40" onkeyup="discount()" />
				</td>
			</tr>
			
			<tr>
				<td >제품판매가격</td>
				<td><input name="goods_sales_price" type="text" size="40" readonly /></td>
			</tr>
			
			<tr>
				<td >제품 구매 포인트</td>
				<td><input name="goods_point" type="text" size="40" value="0" readonly /></td>
			</tr>
			
			<tr>
				<td >제품출판일</td>
				<td><input  name="goods_published_date"  type="date" size="40" /></td>
			</tr>
			
			<tr>
				<td >제품 총 페이지수</td>
				<td>
					<input name="goods_total_page" type="text" size="40" onkeyup="ss3()" />
					<div class="error-message" style="color: red; display: inline;" ></div>	
				</td>
			</tr>
			
			<tr>
				<td >ISBN</td>
				<td>
					<input name="goods_isbn" type="text" size="40" onkeyup="ss4()"/>
					<div class="error-message" style="color: red; display: inline;" ></div>	
				</td>
			</tr>
			<tr>
				<td >제품 배송비</td>
				<td><input name="goods_delivery_price" type="text" size="40" value="0" readonly/></td>
			</tr>
			<tr>
				<td >제품 도착 예정일</td>
				<td><input name="goods_delivery_date"  type="date" size="40" /></td>
			</tr>
			
			<tr>
				<td >제품종류</td>
				<td>
				<select name="goods_status">
				  <option value="bestseller"  >베스트셀러</option>
				  <option value="steadyseller" >스테디셀러</option>
				  <option value="newbook" selected >신간</option>
				  <option value="on_sale" >판매중</option>
				  <option value="buy_out" >품절</option>
				  <option value="out_of_print" >절판</option>
				</select>
				</td>
			</tr>
			<tr>
			 <td>
			   <br>
			 </td>
			</tr>
				</table>	
			</div>
			<div class="tab_content" id="tab2">
				<H4>책목차</H4>
				<table>	
				 <tr>
					<td >책목차</td>
					<td><textarea  rows="100" cols="80" name="goods_contents_order"></textarea></td>
				</tr>
				</table>	
			</div>
			<div class="tab_content" id="tab3">
				<H4>제품 저자 소개</H4>
				 <table>
  				 <tr>
					<td>제품 저자 소개</td>
					<td><textarea  rows="100" cols="80" name="goods_writer_intro"></textarea></td>
			    </tr>
			   </table>
			</div>
			<div class="tab_content" id="tab4">
				<H4>제품소개</H4>
				<table>
					<tr>
						<td >제품소개</td>
						<td><textarea  rows="100" cols="80" name="goods_intro"></textarea></td>
				    </tr>
			    </table>
			</div>
			<div class="tab_content" id="tab5">
				<H4>출판사 제품 평가</H4>
				<table>
				 <tr>
					<td>출판사 제품 평가</td>
					<td><textarea  rows="100" cols="80" name="goods_publisher_comment"></textarea></td>
			    </tr>
			</table>
			</div>
			<div class="tab_content" id="tab6">
				<H4>추천사</H4>
				 <table>
					 <tr>
					   <td>추천사</td>
					    <td><textarea  rows="100" cols="80" name="goods_recommendation"></textarea></td>
				    </tr>
			    </table>
			</div>

			<div class="tab_content" id="tab7">
				<h4>상품이미지</h4>
				<table >
					<tr>
						<td align="right">이미지파일 첨부</td>
			            
			            <td  align="left"> <input type="button"  value="파일 추가" onClick="fn_addFile()"/></td>
			            <td>
				            <div id="d_file">
				            </div>
			            </td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	<div class="clear"></div>
<center>	
	 <table>
	 <tr>
			  <td align=center>
				<!--   <input  type="submit" value="상품 등록하기"> --> 
				  <input  type="button" value="상품 등록하기"  onClick="fn_add_new_goods(this.form)">
			  </td>
			</tr>
	 </table>
</center>	 
</div>
</form>	 