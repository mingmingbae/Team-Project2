<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />	


<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>

<html>
    <head>
        <title>공지사항 게시글 상세</title>
        <script type="text/javascript">
            $(document).ready(function(){
            	
            	var status = false; //수정과 대댓글을 동시에 적용 못하도록
            	
            	$("#list").click(function(){
            		location.href = "${contextPath}/news/newsList.do";
            	});
            	
            	
            	//글수정
            	$("#modify").click(function(){
            		            		
            		var news_idx = $("#news_idx").val();
            		var news_title = $("#news_title").val();
            		var news_member_id = $("#news_member_id").val();
    		
            		location.href = "${contextPath}/news/editView.do?news_idx="+news_idx+"&news_title="+news_title+"&news_member_id="+news_member_id;
            	
            	});
            	
            	//글 삭제
				$("#delete").click(function(){
            		
            		//ajax로 수정 페이지로 포워딩
            		//값 셋팅
            		var news_idx = $("#news_idx").val();
            		            		
            		//ajax 호출
            		$.ajax({
            			url			:	"${contextPath}/news/newsDel.do",
            			contentType :	"application/x-www-form-urlencoded; charset=UTF-8",
            			type 		:	"post",
            			async		: 	true, //동기: false, 비동기: ture
            			data		:	{"news_idx" : news_idx},
            			success 	:	function(retVal){
            				if(retVal.code == "OK") {
            					alert(retVal.message);
            					location.href = "${contextPath}/news/newsList.do";
            				}else{
            					alert(retVal.message);
            					location.reload();
            				}
            			},
            			error		:	function(request, status, error){
            				console.log("AJAX_ERROR");
            			}
            		});
            	});

            });
            
        </script>
    </head>
    <style>
    	textarea{
              width:100%;
            }

		table{
			background-color: #FAF0E6;
		}
            
        td[name="pink"]{
        	background-color: #FFDAB9;
        }
        
       
    </style>
    <body>
    	<h1>게시글</h1>
    	<input type="hidden" id="news_idx" name="news_idx" value="${newsView.news_idx}" />
    	<input type="hidden" id="news_title" name="news_title" value="${newsView.news_title}" />
    	<input type="hidden" id="news_member_id" name="news_member_id" value="${newsView.news_member_id}" />
    	<div id="detail_table">
    		</br>
    		</br>
   			<table>
   				<tr class="dot_line">
   					<td class="fixed" colspan="2" align="right">
   						<button id="modify" name="modify" style="visibility: hidden;">글 수정</button>
   						<button id="delete" name="delete" style="visibility: hidden;">글 삭제</button>
   						
   						
   						<c:choose>
						    <c:when test="${news_member_id ne 'admin'}">
						        <!-- memberId가 비어있는 경우 아무 작업도 하지 않음 -->
						    </c:when>
						    <c:when test="${news_member_id eq 'admin'}">
						        <script>
						            $("#modify").css("visibility","visible");
						            $("#delete").css("visibility","visible");
						        </script>
						    </c:when>
						</c:choose>
   						
   						
   					</td>
   				</tr>
   				<tr class="dot_line">
   					<td class="fixed" name="pink">
						제목
					</td>
					<td>
						${newsView.news_title }
					</td>
   				</tr>
   				<tr class="dot_line">
   					<td class="fixed" name="pink">
						작성자
					</td>
					<td>
						${newsView.news_member_id }
					</td>
   				</tr>
   				<tr class="dot_line" height="500px">
   					<td class="fixed" colspan="2" name="content">
   						${newsView.news_content}
   					</td>
   				</tr>
   			</table>
   			
   			
   			<table>
   				<tr class="dot_line">
   					<td class="fixed" align="right">
   						<button id="list" name="list">공지사항 게시판</button>
   					</td>
   				</tr>
   			</table>
    	</div>
    </body>
</html>