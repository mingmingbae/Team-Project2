<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>




<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />

<!DOCTYPE html >
<html>
    <head>
    
    <!-- 최신 jQuery 버전 로드 -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    
    
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <title></title>
        <script type="text/javascript">
            $(document).ready(function(){
            	
            	//--페이지 셋팅
            	var totalPage = ${totalPage}; //전체 페이지
            	var startPage = ${startPage}; //현재 페이지
            	
            	var pagination = "";
            	
            	//--페이지네이션에 항상 10개가 보이도록 조절
            	var forStart = 0;
            	var forEnd = 0;
            	
            	if((startPage-5) < 1){
            		forStart = 1;
            	}else{
            		forStart = startPage-5;
            	}
            	
            	if(forStart == 1){
            		
            		if(totalPage>9){
            			forEnd = 10;
            		}else{
            			forEnd = totalPage;
            		}
            		
            	}else{
            		
            		if((startPage+4) > totalPage){
                		
            			forEnd = totalPage;
                		
                		if(forEnd>9){
                			forStart = forEnd-9
                		}
                		
                	}else{
                		forEnd = startPage+4;
                	}
            	}
            	//--페이지네이션에 항상 10개가 보이도록 조절
            	
            	//전체 페이지 수를 받아 돌린다.
            	for(var i = forStart ; i<= forEnd ; i++){
            		if(startPage == i){
            			pagination += ' <button name="page_move" start_page="'+i+'" disabled>'+i+'</button>';
            		}else{
            			pagination += ' <button name="page_move" start_page="'+i+'" style="cursor:pointer;" >'+i+'</button>';
            		}
            	}
					

            	//하단 페이지 부분에 붙인다.
            	$("#pagination").append(pagination);
            	//--페이지 셋팅

            	$(document).on("click", "button[name='page_move']", function() {
            	    $("#visiblePages").val();
            	    var startPage = $(this).attr("start_page"); // 클릭된 페이지 버튼의 값
            	    $("#startPage").val(startPage); // 보고 싶은 페이지로 설정
            	    $("#frmSearch").submit();
            	});

            	
            	$("a[name='subject']").click(function(){
            		var news_idx = $(this).closest("tr").find("td[name='news_idx']").text();
				    var content_id = $(this).attr("content_id");
				    var news_title = $(this).text(); //제목 가져오기
				    var member_id = "${member_id}";
				    location.href = "${contextPath}/news/newsView.do?news_idx="+news_idx+"&content_id=" + content_id + "&news_title=" + news_title + "&member_id=" + member_id;
				});

            	
            	$("#write").click(function(){
            		location.href = "${contextPath}/news/editView.do?news_member_id=${member_id}";
            	});
            });
        </script>
        
        <style>
        	.mouseOverHighlight {
				   cursor: pointer !important;
				   pointer-events: auto;
				}

			/* 열 제목 진한 핑크로 설정 */
			th {
			    background-color: #FFD9EC;  /* 연한 핑크 */
			}
			
			/* 짝수 행의 배경색을 벚꽃 핑크로 설정 */
			tr:nth-child(even) {
			    background-color: #FFB6C1; /* 벚꽃 핑크 */
			}
				
        </style>
    </head>
    <body>
    
    
    	<h1>공지사항 게시판</h1>
    	<form class="form-inline" id="frmSearch" action="/news/newsList.do">
	    	<input type="hidden" id="startPage" name="startPage" value=""><!-- 페이징을 위한 hidden타입 추가 -->
	        <input type="hidden" id="visiblePages" name="visiblePages" value="3"><!-- 페이징을 위한 hidden타입 추가 -->
	    	<div id="detail_table">
	    		<table> 
	    			<tr>
	    				<td class="fixed" align="right">
	    					<button type="button" id="write" name="write" style="visibility: hidden;">글 작성</button>
	    					
	    					
	    					<c:choose>
							    <c:when test="${member_id != 'admin'}">
							        <!-- memberId가 비어있는 경우 아무 작업도 하지 않음 -->
							    </c:when>
							    <c:when test="${member_id eq 'admin'}">
							        <script>
							            $("#write").css("visibility","visible");
							        </script>
							    </c:when>
							</c:choose>
	    					
	    					
	    				</td>
	    			</tr>
	    		</table>
	    		<table>
	    			<tr>
	    				<th>
	    					No
	    				</th>
	    				<th>
	    					제목
	    				</th>
	    				<th>
	    					작성자
	    				</th>
	    				<th>
	    					조회수
	    				</th>
	    				<th>
	    					작성일
	    				</th>
	    			</tr>
	    			<c:choose>
			        	<c:when test="${fn:length(newsList) == 0}">
			            	<tr class="dot_line">
			            		<td class="fixed" colspan="5">
			            			조회결과가 없습니다.
			            		</td>
			            	</tr>
			           	</c:when>
			           	<c:otherwise>
			            	<c:forEach var="newsList" items="${newsList}" varStatus="status">
								<tr class="dot_line">
						    		<td class="fixed" align="center" name="news_idx">${newsList.news_idx}</td>
						    		<td class="fixed" align="center">
						    			<a name="subject" class="mouseOverHighlight" content_id="${newsList.news_member_id}">${newsList.news_title}</a>
						    		</td>
						    		<td class="fixed" align="center" id="news_member_id">${newsList.news_member_id}</td>
						    		<td class="fixed" align="center">${newsList.news_cnt}</td>
						    		<td class="fixed" align="center">${newsList.news_date}</td>
						    	</tr>
						    </c:forEach>
			           	</c:otherwise> 
			    	</c:choose>
	    		</table>
	    		<br>
	    		<div id="pagination"></div>
	    	</div>
    	</form>
    </body>
</html>