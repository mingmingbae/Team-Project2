<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />

<!DOCTYPE html >
<html>
<head>
<meta charset="utf-8">
        <title>공지사항 게시판</title>
        <script src="//cdn.ckeditor.com/4.7.1/standard/ckeditor.js"></script>
        <script type="text/javascript">
            
        	$(document).ready(function(){
            	
            	CKEDITOR.replace( 'content' );
            	CKEDITOR.config.height = 300;
            	
            	$("#list").click(function(){
            		location.href = "${contextPath}/news/newsList.do";
            	});
            	
            	$("#save").click(function(){
            		
            		//에디터 내용 가져옴
            		var content = CKEDITOR.instances.content.getData().trim();
            		
            		//null 검사
                    if($("#subject").val().trim() == ""){
                    	alert("제목을 입력하세요.");
                    	$("#subject").focus();
                    	return false;
                    }
            		
                 	// CKEditor의 내용이 비었는지 확인
                    if (content === "") {
                        alert("내용을 입력하세요.");
                        $("#content").focus();
                        return false;
                    }
                    
					//FormData 객체 생성
					var formData = new FormData();
					var textContent = $(content).text(); // HTML 태그를 제외한 텍스트만 추출
					
					// 파일 추가
					var fileInput = document.getElementById('news_sfile');
					var file = fileInput.files[0];
					var fileName = file.name; // 파일 이름은 기본값으로 설정
					// 파일을 formData에 추가할 때 파일명을 변경하여 추가
					formData.append('news_sfile', file, fileName);
					
					// 나머지 데이터 추가
					<c:if test="${newsView.news_idx != null}"> //있으면 수정 없으면 등록
            			formData.append('news_idx', $("#news_idx").val());
            		</c:if>
					formData.append('news_title', $("#subject").val());
					formData.append('news_member_id', $("#writer").val());
					formData.append('news_content', textContent);
					
					// AJAX 호출
					$.ajax({
					    url: "${contextPath}/news/newsSave.do",
					    type: "POST",
					    data: formData,
					    processData: false,
					    contentType: false,
					    success: function(retVal) {
					        if (retVal.code == "OK") {
					            alert(retVal.message);
					            location.href = "${contextPath}/news/newsList.do?member_id="+retVal.news_member_id;
					        } else {
					            alert(retVal.message);
					        }
					    },
					    error: function(request, status, error) {
					        console.log("AJAX_ERROR");
					    }
					});
            		
            	});
            	
            });
      </script>
</head>
<body>
    	<h1>게시글 작성</h1>
    	<br><br>
    	<input type="hidden" id="news_idx" name="news_idx" value="${newsView.news_idx}" />
    	<div id="detail_tabel">
   			<table>
   				<tbody>
   				<tr class="dot_line">
   					<td class="fixed">
   						제목	 
   						<input type="text" id="subject" name="subject" placeholder="제목" value="${newsView.news_title}"/>
   					</td>
   					<td	class="fixed" align="right">
   						작성자 
   						<input type="text" id="writer" name="writer" maxlength="10" value="${news_member_id}" readonly/>
   					</td>
   				</tr>
   				<tr class="dot_line">
   					<td class="fixed" colspan="2">
   						<textarea name="content" id="content" rows="10" cols="80">${newsView.news_content}</textarea>
   					</td>
   				</tr>
   				
   				<tr class="dot_line">
					<td class="fixed">파일 첨부</td>
		            <td class="fixed">
			            <div id="sfile">
			            	<input type="file" name="news_sfile" id="news_sfile">
			            </div>
		            </td>
				</tr>
				</tbody>
			</table>
			</div>	
			<div class="clear">
			<br><br>
			<table>
   				<tr class="dot_line">
   					<td class="fixed" align="right">
   						<button id="save" name="save">저장</button>
   						<button id="list" name="list">공지사항 게시판</button>
   					</td>
   				</tr>
   			</table>
   			</div>	
   			
    	
    </body>
</html>