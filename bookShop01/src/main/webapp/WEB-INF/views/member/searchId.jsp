<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<%-- <c:set var="result"  value="${searchId}"  /> --%>
<!DOCTYPE html >
<html>
<head>
<meta charset="utf-8">

</head>
<body>
	    <h3>아이디 찾기 결과</h3>
		<br>
		<br>
		
    <c:choose>
        <c:when test="${!searchId.equals('일치하는 회원의 정보가 없습니다.')}">
            <div>
                <h4> <b style="font-size: 1.5em; color: blue; text-decoration: underline;">아이디의 값은 "${searchId}" 입니다.</b></h4>
            </div>
            <br>
			<br>
            <button onclick="location.href = '${contextPath}/member/loginForm.do';">로그인</button>
            <button onclick="location.href = '${contextPath}/member/searchPwdForm.do';">비밀번호 찾기</button>
        </c:when>
        <c:otherwise>
            <div>
                <h4><b style="font-size: 1.5em; color: red; text-decoration: underline;">${searchId}</b></h4>
            </div>
            <br>
			<br>
            <button onclick="location.href = '${contextPath}/member/searchIdForm.do';">아이디 찾기</button>
            <button onclick="location.href = '${contextPath}/member/searchPwdForm.do';">비밀번호 찾기</button>
        </c:otherwise>
    </c:choose>
    
</body>
</html>