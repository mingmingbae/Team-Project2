<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" 	isELIgnored="false"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />

<%-- GoodsControllerImpl클래스의 goodsDetail메소드 내부에서 ModelAndView에 저장했던  도서상품 정보와 이미지 정보 얻기 --%>
<c:set var="goods"  value="${goodsMap.goodsVO}"  />
<c:set var="imageList"  value="${goodsMap.imageList }"  />
<c:set var="memberInfo" value="${sessionScope.memberInfo}" />
<c:set var="member_id" value="${memberInfo.getMember_id()}" />
<c:set var="reviewList" value="${listReview}" />
 <%
     //치환 변수 선언
      pageContext.setAttribute("crcn", "\r\n"); //개행문자
      pageContext.setAttribute("br", "<br/>"); //br 태그
%>  
<html>
<head>
<style>

#layer {
	z-index: 2;
	position: absolute;
	top: 0px;
	left: 0px;
	width: 100%;
}


#popup {
	z-index: 3;
	position: fixed;
	text-align: center;
	left: 50%;
	top: 45%;
	width: 300px;
	height: 200px;
	background-color: #ccffff;
	border: 3px solid #87cb42;
}


#close {
	z-index: 4;
	float: right;
}

/* 리뷰 테이블 스타일 */
.reviewTable {
	border: 1px solid #ddd;
	border-radius: 5px;
	padding: 20px;
	margin-bottom: 20px;
}

.reviewHead {
	margin-bottom: 20px;
}

.reviewTitle {
	font-weight: bold;
	font-size: 25px;
}

.reviewContent table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px;
}

.reviewContent th, .reviewContent td {
	border: 1px solid #ddd;
	padding: 8px;
}

.reviewContent tr:nth-child(even) {
	background-color: #f2f2f2;
}

.reviewContent tr:hover {
	background-color: #ddd;
}

.noReviewMessage {
	font-weight: bold;
	font-style: italic;
	color: #888;
}

/* 모달 스타일 */
.modal {
	display: none;
	position: fixed;
	z-index: 999;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	overflow: auto;
	background-color: rgba(0, 0, 0, 0.4);
}

.modal-dialog {
	margin: 30px auto;
	max-width: 600px;
}

.modal-content {
	background-color: #fefefe;
	border: 1px solid #888;
	border-radius: 5px;
}

.modal-header, .modal-footer {
	padding: 10px 20px;
	border-bottom: 1px solid #ddd;
}

.modal-body {
	padding: 20px;
}

.btnReview {
	text-align: right;
	margin-bottom: 20px;
}
</style>

<script type="text/javascript">
    //장바구니 버튼을 클릭하면 호출
	function add_cart(goods_id, selectedValue) {
    	
		var selectElement = document.getElementById("order_goods_qty");
		var selectedValue = parseInt(selectElement.value, 10); // 숫자로 변환
    	
		$.ajax({
			type : "post",
			async : false, 
			
			//Ajax를 이용해 장바구니에 추가할 상품 번호를 전송 하여 장바구니에 상품 추가 요청 
			url : "${contextPath}/cart/addGoodsInCart.do",
			data : { goods_id:goods_id,
					 cart_goods_qty:selectedValue	
				   },
			success : function(data, textStatus) {
				if(data.trim()=='add_success'){ //장바구니 테이블에 새상품을 추가하고 메세지를 받으면?
						imagePopup('open', '.layer01');	
				}else if(data.trim()=='already_existed'){//장바구니 테이블에 사이트 이용자가 추가할 상품이 이미 저장되어 있으면?
					alert("이미 카트에 등록된 상품입니다.");	
				}
			},
			error : function(data, textStatus) {
				alert("로그인이 필요한 서비스입니다. 로그인 하시겠습니까?");
				location.href = '${contextPath}/member/loginForm.do';
			},
			complete : function(data, textStatus) {
			}
		}); //end ajax	
	}

	// 팝업창의 x 이미지 클랙했을때 호출
	function imagePopup(type) {
		
		if (type == 'open') {
			$('#layer').attr('style', 'visibility:visible');
			$('#layer').height(jQuery(document).height());
		}
		else if (type == 'close') {
			$('#layer').attr('style', 'visibility:hidden');
		}
	}

//구매하기
function fn_order_each_goods(goods_id,goods_title,goods_sales_price,fileName){
	
	var _isLogOn=document.getElementById("isLogOn");
	
	var isLogOn=_isLogOn.value;  //"false" 또는 "true"
	
	 if(isLogOn == "false" || isLogOn == '' ){
		alert("로그인 후 주문이 가능합니다!!!");
	} 
	
	var total_price,final_total_price;

	var order_goods_qty=document.getElementById("order_goods_qty");
	
	var formObj=document.createElement("form");
	
	var i_goods_id = document.createElement("input"); 
    i_goods_id.name="goods_id";
    i_goods_id.value=goods_id;
    
    var i_goods_title = document.createElement("input");
    i_goods_title.name="goods_title";
    i_goods_title.value=goods_title;
    
    var i_goods_sales_price=document.createElement("input");
    i_goods_sales_price.name="goods_sales_price";
    i_goods_sales_price.value=goods_sales_price;
    
    var i_fileName=document.createElement("input");
    i_fileName.name="goods_fileName";
    i_fileName.value=fileName;
    

    var i_order_goods_qty=document.createElement("input");
    i_order_goods_qty.name="order_goods_qty";
    i_order_goods_qty.value = order_goods_qty.value;
  
    
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
	
<%-- 리뷰 상세 조회 기능 --%>
function reviewListGo(review_idx) {

	$.ajax({
		type : "post",
		async : true,
		url : "${contextPath}/review/detailReview.do",
		data : {
			review_idx : review_idx
		},
		dataType : "json",
		success : function(data) {
			
			if (data == "조회실패") {
				
				alert('조회 실패');

			} else {
				//JSON 데이터에서 각 속성의 값을 추출하여 변수에 저장
				var review_mem_id = data.review_mem_id;
				var review_title = data.review_title;
				var review_content = data.review_content;
				var review_date = data.review_date;
				
				// 추출한 값들을 각각의 HTML 요소에 할당
				$("#openr_title").val(review_title);
				$("#openr_mid").val(review_mem_id);
				$("#openr_content").val(review_content);
				$("#openr_date").text(review_date);
				$("#openr_idxx").val(review_idx);
				$("#reviewDelete").attr("onclick","javascript:deletePro('"+review_idx+"')");
				
				 // 모달 창 열기
				 $('#reviewModal').modal('show');
			}
		},
		error : function() {
			alert("비동기 통신 장애");
		}
	});
}

<%-- 리뷰 삭제하기 기능 --%>
function deletePro(review_idx) {

	var result = window.confirm("정말로 글을 삭제하시겠습니까?");

	if (result == true) {//확인 버튼 클릭

		//비동기방식으로 글삭제 요청!
		$.ajax({
			type : "post",
			async : true,
			url : "${contextPath}/review/deleteReview.do",
			data : {
				review_idx : review_idx
			},
			dataType : "json",
			success : function(data) {
				if (data.status === "success") {
					
					alert(data.message);
					location.reload();
					
				} else {
					alert('삭제 실패');
					location.reload();
				}
			},
			error : function() {
				alert("비동기 통신 장애");
			}
		});
	} else {//취소 버튼을 눌렀을때
		return false;
	}
}

//리뷰 작성
function reviewWrite() {

	let formData = $('.form-data').serialize();

	$.ajax({
		type : "post",
		async : true,
		url : "${contextPath}/review/write.do",
			data : formData,
		dataType : "json",
		success : function(data) {

			if (data.code === "OK") {
				alert(data.message);
				location.reload();
				
			} else {
				alert('작성실패');
				location.reload();
			}
		},
		error : function() {
			alert("비동기 통신 장애");
			location.reload();
		}
	});
}


function writeClose() {
var writeModal = document.getElementById("exampleModal");
writeModal.style.display = "none";
}

function closeModal() {
var reviewModal = document.getElementById("reviewModal");
reviewModal.style.display = "none";
location.reload(); //close버튼이 한번밖에 작동이 안돼서 reload추가
}		
	
window.onload = function() {
	//리뷰작성 모달창
	var writeModal = document.getElementById("exampleModal");
	// 리뷰 상세 조회
	var reviewOpen = document.getElementById("reviewOpen");
	//작성하기 버튼
	var writeBtn = document.getElementById("write__");

	//리뷰조회 모달창
	var reviewModal = document.getElementById("reviewModal");

	//작성하기 버튼 클릭 이벤트
	writeBtn.addEventListener("click", function() {
		writeModal.style.display = "block";
	});

	//리뷰 게시글 클릭했을때 뜨는 모달창
	reviewOpen.addEventListener("click", function() {
		reviewModal.style.display = "block";
	});
	
	// 모달 외부 클릭 시 닫기
	window.addEventListener("click", function(event) {
		if (event.target == writeModal) {
			writeModal.style.display = "none";
		}
	});

	window.addEventListener("click", function(event) {
		if (event.target == reviewModal) {
			reviewModal.style.display = "none";
		}
	});
};	
</script>

</head>
<body>
	<hgroup>
		<h1>${goods.goods_sort }</h1>
		<h3>${goods.goods_title }</h3>
		<h4>${goods.goods_writer} &nbsp; 저| ${goods.goods_publisher}</h4>
	</hgroup>
	<div id="goods_image">
		<figure>
			<img alt="HTML5 &amp; CSS3"
				src="${contextPath}/thumbnails.do?goods_id=${goods.goods_id}&fileName=${goods.goods_fileName}">
		</figure>
	</div>
	<div id="detail_table">
		<table>
			<tbody>
				<tr>
					<td class="fixed">정가</td>
					<td class="active"><span >
					   <fmt:formatNumber  value="${goods.goods_price}" type="number" var="goods_price" />
				         ${goods_price}원
					</span></td>
				</tr>
				<tr class="dot_line">
					<td class="fixed">판매가</td>
					<td class="active"><span >
					   <fmt:formatNumber  value="${goods.goods_price*0.9}" type="number" var="discounted_price" />
				         ${discounted_price}원(10%할인)</span></td>
				</tr>
				<tr>
					<td class="fixed">발행일</td>
					<td class="fixed">
					   <c:set var="pub_date" value="${goods.goods_published_date}" />
					   <c:set var="arr" value="${fn:split(pub_date,' ')}" />
					   <c:out value="${arr[0]}" />
					</td>
				</tr>
				<tr>
					<td class="fixed">페이지 수</td>
					<td class="fixed">${goods.goods_total_page}쪽</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed">ISBN</td>
					<td class="fixed">${goods.goods_isbn}</td>
				</tr>
				<tr>
					<td class="fixed">배송료</td>
					<td class="fixed"><strong>무료</strong></td>
				</tr>
				<tr>
					<td class="fixed">배송안내</td>
					<td class="fixed">
						<strong>[당일배송]</strong> 당일배송 서비스 시작!<br> 
						<strong>[휴일배송]</strong>
						휴일에도 배송받는 Bookshop
					</td>
				</tr>
				<tr>
					<td class="fixed">도착예정일</td>
					<td class="fixed">지금 주문 시 내일 도착 예정</td>
				</tr>
				<tr>
					<td class="fixed">수량</td>
					<td class="fixed">
					      <select style="width: 60px;" id="order_goods_qty">
				      		<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
					     </select>
					 </td>
				</tr>
			</tbody>
		</table>
		<ul>
			<li><a class="buy" href="javascript:fn_order_each_goods('${goods.goods_id }','${goods.goods_title }','${goods.goods_sales_price}','${goods.goods_fileName}');">구매하기 </a></li>
			<li><a class="cart" href="javascript:add_cart('${goods.goods_id }',${selectedValue})">장바구니</a></li>
		</ul>
	</div>
	<div class="clear"></div>
	<!-- 내용 들어 가는 곳 -->
	<div id="container">
		<ul class="tabs">
			<li><a href="#tab1">책소개</a></li>
			<li><a href="#tab2">저자소개</a></li>
			<li><a href="#tab3">책목차</a></li>
			<li><a href="#tab4">출판사서평</a></li>
			<li><a href="#tab5">추천사</a></li>
			<li><a href="#tab6">리뷰</a></li>
		</ul>
		<div class="tab_container">
			<div class="tab_content" id="tab1">
				<h4>책소개</h4>
				<p>${fn:replace(goods.goods_intro,crcn,br)}</p>
				<c:forEach var="image" items="${imageList }">
					<img src="${contextPath}/download.do?goods_id=${goods.goods_id}&fileName=${image.fileName}">
				</c:forEach>
			</div>
			<div class="tab_content" id="tab2">
				<h4>저자소개</h4>
				<p>
				<div class="writer">저자 : ${goods.goods_writer}</div>
				
				 <p>${fn:replace(goods.goods_writer_intro,crcn,br) }</p> 
				
			</div>
			<div class="tab_content" id="tab3">
				<h4>책목차</h4>
				<p>${fn:replace(goods.goods_contents_order,crcn,br)}</p> 
			</div>
			<div class="tab_content" id="tab4">
				<h4>출판사서평</h4>
				 <p>${fn:replace(goods.goods_publisher_comment ,crcn,br)}</p> 
			</div>
			<div class="tab_content" id="tab5">
				<h4>추천사</h4>
				<p>${fn:replace(goods.goods_recommendation,crcn,br) }</p>
			</div>
			<div class="tab_content" id="tab6">
				<h4>리뷰</h4>
				<div class="reviewTable">
					<div class="reviewHead">
						<span style="font-weight: bold; font-size: 25px;">상품 리뷰</span>
						<c:out value="${reviewList.size()}" />
					</div>
					<c:choose>
						<c:when test="${reviewList.size() == 0}">
							<div class="reviewContent">
								<table>
									<thead>
										<tr>
											<th>ID</th>
											<th>날짜</th>
											<th>제목</th>
											<th>내용</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<th colspan="4">등록된 리뷰가 없습니다.</th>
										</tr>
									</tbody>
								</table>
							</div>
						</c:when>
						<c:otherwise>
							<div class="reviewContent">
								<table>
									<tbody>
										<tr>
											<th>ID</th>
											<th>날짜</th>
											<th>제목</th>
											<th>내용</th>
										</tr>
										<c:forEach items="${reviewList}" var="review" varStatus="loop">
										    <tr id="reviewOpen${loop.index}" class="reviewOpen" onclick="javascript:reviewListGo('${review.review_idx}');" data-bs-toggle="modal" data-review-id="${review.review_idx}">
										        <td>${review.review_member_id}</td>
										        <td>${review.review_date}</td>
										        <td>${review.review_title}</td>
										        <td>${review.review_content}</td>
										    </tr>
										</c:forEach>
									</tbody>
								</table>
							</div>
						</c:otherwise>
					</c:choose>
				</div>

				<div class="modal" id="reviewModal">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="reviewModalLabel">리뷰 조회</h5>
								<button class="btn-close" data-bs-dismiss="modal"
									aria-label="Close" id="reviewClose" onclick="closeModal()" >close</button>
							</div>
							<div class="modal-body">
								<div class="form-wrapper">
									<input class="form-control mb-3" type="text"
										name="review_member_id" id="openr_mid" value="" disabled><br>
									<input class="form-control mb-3" type="text"
										name="review_title" id="openr_title" value="" disabled><br>
									<textarea class="form-control" id="openr_content"
										name="r_content" style="height: 300px; resize: none" disabled></textarea>
								</div>
							</div>
							<div class="modal-footer">
								<c:choose>
									<c:when test="${buyMem_ || member_id=='admin'}">
										<button type="submit" id="reviewDelete"
											class="btn btn-secondary" data-bs-dismiss="modal"
											style="display: block; visibility: visible;"
											onclick="javascript:deletePro();">삭제하기</button>
									</c:when>
								</c:choose>	
							</div>
						</div>
					</div>
				</div>

				<div class="row m-2">
					<c:choose>
						<c:when test="${buyMem_}">
							<div class="btnReview">
								<button type="button" class="btn btn-success"
									data-bs-toggle="modal" data-bs-target="#exampleModal"
									id="write__">작성하기</button>
							</div>
							<div class="modal" id="exampleModal">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<h5 class="modal-title" id="exampleModalLabel">리뷰 작성</h5>
											<button class="btn btn-secondary"
												data-bs-dismiss="modal" id="wrReviewClose" onclick="writeClose();">Close</button>
										</div>

										<div class="modal-body">
											<form id="reviewForm" class="form-data" method="post"
												enctype="application/x-www-form-urlencoded">
												<input type="hidden" name="review_goods_id"
													id="review_goods_id" value="${goods.goods_id}">
												<input class="form-control" type="text"
													name="review_member_id" id="review_member_id"
													value="${member_id}" readonly="readonly"><br>
												<input class="form-control" type="text" name="review_title"
													id="review_title" placeholder="제목을 입력해주세요."><br>
												<div class="mb-3">
													<textarea class="form-control" placeholder="내용을 입력해주세요."
														id="review_content" name="review_content"
														style="height: 300px; resize: none"></textarea>
												</div>
												<div class="modal-footer">
													<button type="submit" class="btn btn-primary"
														id="btnReview" onclick="javascript:reviewWrite();">작성완료</button>
												</div>
											</form>
										</div>

									</div>
								</div>
							</div>
						</c:when>
					</c:choose>
				</div>
			</div>
		</div>
	</div>
	<div class="clear"></div>
	<div id="layer" style="visibility: hidden">
		<!-- visibility:hidden 으로 설정하여 해당 div안의 모든것들을 가려둔다. -->
		<div id="popup">
			<!-- 팝업창 닫기  X 이미지 버튼 -->
			<a href="javascript:" onClick="javascript:imagePopup('close', '.layer01');"> 
				<img src="${contextPath}/resources/image/close.png" id="close" />
			</a> 
			<br /> 
			<font size="12" id="contents">장바구니에 담았습니다.</font>
			<br>
			<%-- 장바구니 테이블에 저장된 상품목록 조회 요청! --%>
			<form   action='${contextPath}/cart/myCartList.do'  >				
					<input  type="submit" value="장바구니 보기">
			</form>			
		</div>
	</div>	
</body>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>	
</html>
<input type="hidden" name="isLogOn" id="isLogOn" value="${isLogOn}"/>











