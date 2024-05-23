<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<script>
	//"quickMenu.jsp"페이지에서 최근 본 도서상품을 표시
	var array_index = 0; //현재 표시 중인 상품의 배열 인덱스위치
	
	var SERVER_URL = "${contextPath}/thumbnails.do";//FileDownLoadController에서 썸네일이미지 URL을 설정

	//다음 을 클릭
	function fn_show_next_goods() {
		
		var img_sticky = document.getElementById("img_sticky");
		
		var cur_goods_num = document.getElementById("cur_goods_num");
		
		var _h_goods_id = document.frm_sticky.h_goods_id;

		var _h_goods_fileName = document.frm_sticky.h_goods_fileName;

		console.log("array_index : " + array_index);
		console.log(_h_goods_id.length -1);

		if (array_index < _h_goods_id.length - 1){
			
			array_index++; 
		}
	
	 console.log("array_index : " + array_index );
	 console.log( _h_goods_id.length -1 );
	 

	//1증가된 인덱스 위치에 대한 그다음 상품번호와 이미지명을 가져와 표시합
		var goods_id = _h_goods_id[array_index].value;
		var fileName = _h_goods_fileName[array_index].value;
		

	    img_sticky.src = SERVER_URL + "?goods_id=" + goods_id + "&fileName="+ fileName;
		
	    cur_goods_num.innerHTML = array_index + 1;
	
		console.log(cur_goods_num);
	}
	
	
	
	//빠른 퀵 메뉴 하단의 이전을 클릭
	function fn_show_previous_goods() {
		
		var img_sticky = document.getElementById("img_sticky");
		var cur_goods_num = document.getElementById("cur_goods_num");
		var _h_goods_id = document.frm_sticky.h_goods_id;
		var _h_goods_fileName = document.frm_sticky.h_goods_fileName;

		if (array_index > 0)
			array_index--;

		var goods_id = _h_goods_id[array_index].value;
		var fileName = _h_goods_fileName[array_index].value;
		
		img_sticky.src = SERVER_URL + "?goods_id=" + goods_id + "&fileName=" + fileName;
		
		cur_goods_num.innerHTML = array_index + 1;
		
	}

	
	//상품 이미지 클릭했을때
	function goodsDetail() {
		
		var cur_goods_num = document.getElementById("cur_goods_num");
		
		arrIdx = cur_goods_num.innerHTML - 1;
	
		var img_sticky = document.getElementById("img_sticky");

		var h_goods_id = document.frm_sticky.h_goods_id;


		var len = h_goods_id.length; //4
		
		//최근본 상품 번호가 설정된 <input type="hidden">의 갯수 4가 1보다 크면
		if (len > 1) {
			//상품번호 얻기 
			goods_id = h_goods_id[arrIdx].value;
		} else {
			//상품번호 얻기 
			goods_id = h_goods_id.value;
		}

		var formObj = document.createElement("form");
		var i_goods_id = document.createElement("input");

		i_goods_id.name = "goods_id";
		i_goods_id.value = goods_id;
		
		formObj.appendChild(i_goods_id);
		document.body.appendChild(formObj);
		formObj.method = "get";
		formObj.action = "${contextPath}/goods/goodsDetail.do";
		
		formObj.submit();
	}
</script>

<body>
	<div id="sticky">
		<ul>
			<li>
				<a href="#"> 
					<img width="24" height="24" src="${contextPath}/resources/image/facebook_icon.png"> 페이스북
				</a>
			</li>
			<li>
				<a href="#"> 
					<img width="24" height="24" src="${contextPath}/resources/image/twitter_icon.png"> 트위터
				</a>
			</li>
			<li>
				<a href="#"> 
					<img width="24" height="24" src="${contextPath}/resources/image/rss_icon.png"> RSS 피드
				</a>
			</li>
		</ul>
		<div class="recent">
			<h3>최근 본 상품</h3>
			<ul>
				<c:choose>
					<%-- 최근 본 도서상품 은 상품목록에서 상품정보(GoodsVO객체들이)들이 없을 경우  --%>
					<c:when test="${ empty sessionScope.quickGoodsList }">
						<strong>최근본 상품이 없습니다.</strong>
					</c:when>
					
					<%-- 최근 본 도서상품 은 상품목록에서 상품정보(GoodsVO객체들이)들이 하나라도 있을 경우 --%>
					<c:otherwise>
						<form name="frm_sticky">
							
							<%-- 세션영역에 저장된 빠른 퀵 메뉴 디자인에 보여줄 이미지정보를 저장 --%>
							<c:forEach var="item" items="${sessionScope.quickGoodsList }" varStatus="itemNum">
								<c:choose>
									<%-- 한번 반복 할때의 첫번쨰 이미지만 퀵메뉴영역에 표시하고  --%>
									<c:when test="${itemNum.count==1 }">
										<a href="javascript:goodsDetail();"> 
											<img width="75"
												 height="95" id="img_sticky"
											     src="${contextPath}/thumbnails.do?goods_id=${item.goods_id}&fileName=${item.goods_fileName}">
										</a>
										<input type="hidden" name="h_goods_id" value="${item.goods_id}" />
										<input type="hidden" name="h_goods_fileName" value="${item.goods_fileName}" />
										<br>
									</c:when>
									<c:otherwise>
										<input type="hidden" name="h_goods_id" value="${item.goods_id}" />
										<input type="hidden" name="h_goods_fileName" value="${item.goods_fileName}" />
									</c:otherwise>
								</c:choose>
							</c:forEach>
					</c:otherwise>
				</c:choose>
			</ul>
			</form>
		</div>
		<div>
			<c:choose>
				<%--  최근본 도서상품이 하나라도 없다면? --%>
				<c:when test="${ empty sessionScope.quickGoodsList }">
					<h5>&nbsp; &nbsp; &nbsp; &nbsp; 0/0 &nbsp;</h5>
				</c:when>
				<%-- 최근본 도서상품이 ArrayList배열에 하나라도 있으면? --%>
				<c:otherwise>
					<h5>
						<a href='javascript:fn_show_previous_goods();'> 이전 </a> &nbsp; 
						
						<span id="cur_goods_num">1</span>/${sessionScope.quickGoodsListNum} &nbsp; 
						
						<a href='javascript:fn_show_next_goods();'> 다음 </a>
					</h5>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
</body>
</html>

