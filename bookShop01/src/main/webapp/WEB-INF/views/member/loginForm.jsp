<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	 isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />

<c:set var="redirectURI" value="리다이렉트주소"/>

<c:set var="clientId" value="클라이언트아이디"/>

<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<c:if test='${not empty message }'>
	<script>
	window.onload=function()
	{
	  result();
	}
	
	function result(){
		alert("아이디나  비밀번호가 틀립니다. 다시 로그인해주세요");
	}
	</script>
</c:if>
</head>
<body>
	<H3>회원 로그인 창</H3>
	<DIV id="detail_table">
	<form action="${contextPath}/member/login.do" method="post">
		<TABLE>
			<TBODY>
				<TR class="dot_line">
					<TD class="fixed_join">아이디</TD>
					<TD><input name="member_id" type="text" size="20" /></TD>
				</TR>
				<TR class="solid_line">
					<TD class="fixed_join">비밀번호</TD>
					<TD><input name="member_pw" type="password" size="20" /></TD>
				</TR>
			</TBODY>
		</TABLE> 
		<br><br>
		<INPUT	type="submit" value="로그인"> 
		<INPUT type="button" value="초기화">
		<br><br>
		 <!-- 카카오 로그인 -->
         <a href="https://kauth.kakao.com/oauth/authorize?client_id=${clientId }&redirect_uri=${redirectURI}&response_type=code">
 			<img class="login-frm-btn" src="${contextPath }/resources/image/kakaoimage/KakaoTalk_20240422_151321263.png" />
		 </a>
		 
		<Br><br>
		   <a href="${contextPath}/member/searchIdForm.do">아이디 찾기</a>  | 
		   <a href="${contextPath}/member/searchPwdForm.do">비밀번호 찾기</a> | 
		   <a href="${contextPath}/member/memberForm.do">회원가입</a>    | 
					   
	</form>	
</body>
</html>