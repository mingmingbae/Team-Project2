<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<!DOCTYPE html >
<html>
<head>
    <meta charset="utf-8">
    <title>Password Reset</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    
    <style>
        .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
        }

        .mb-3 {
            margin-bottom: 20px;
        }

        .form-label {
            margin-bottom: 5px;
        }

        .form-control {
            display: block;
            width: 100%;
            height: calc(1.5em + 0.75rem + 2px);
            padding: 0.375rem 0.75rem;
            font-size: 1rem;
            font-weight: 400;
            line-height: 1.5;
            color: #495057;
            background-color: #fff;
            background-clip: padding-box;
            border: 1px solid #ced4da;
            border-radius: 0.25rem;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }

        .btn {
            display: inline-block;
            font-weight: 400;
            color: #212529;
            text-align: center;
            vertical-align: middle;
            user-select: none;
            background-color: transparent;
            border: 1px solid transparent;
            padding: 0.375rem 0.75rem;
            font-size: 1rem;
            line-height: 1.5;
            border-radius: 0.25rem;
            transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out,
                border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
            cursor: pointer;
        }

        .btn-primary {
            color: #fff;
            background-color: #007bff;
            border-color: #007bff;
        }

        .btn-primary:hover {
            color: #fff;
            background-color: #0069d9;
            border-color: #0062cc;
        }
    </style>
    
    <script type="text/javascript">
        // 이메일 작성 후 인증하기 버튼을 눌렀을 때 동작
        function sendMail() {
            let emailData = $("#email").val();
            console.log(emailData)
            $.ajax({
                url: '${contextPath}/member/sendPwdMail.do',
                type: 'POST',
                data: { email: emailData }, 
                dataType : 'json',
                success: function (data) {
                    if (data != null && data!=0) {
                        alert("인증메일이 전송되었습니다.");
                        $('#confirm').css('display', 'block');
                    } else {
                        alert("인증메일 전송에 실패했습니다.")
                    }
                },
                error: function () {
                    alert("오류가 발생했습니다. 관리자에게 문의하세요.");
                }
            });
        }
        
        // 이메일 인증번호 입력 후 확인 요청
        function check(){
            let checknum = $("#checknum").val();
            $.ajax({
                url: '${contextPath}/member/checkRandomPass.do',
                type: 'POST',
                data: {checknum2: checknum},
                dataType : 'text',
                success: function(data){
                    if(data==="일치"){
                        alert("인증에 성공했습니다.");
                        $('#resetpsw').css('display','block');
                    } else {
                        alert("인증에 실패했습니다. 다시 확인해주세요!");
                    }
                }, 
                error: function(){
                    alert("오류가 발생했습니다. 관리자에게 문의하세요.");
                }
            });
        }
        
     // 비밀번호 수정 요청
        function updatePass(){
            let user_psw = $("#user_psw").val();
            let user_psw_confirm = $("#user_psw_confirm").val();
            let mem_id = "${memberInfo.getMember_id()}";
            
            if(user_psw==user_psw_confirm){
            	$.ajax({
                    url: '${contextPath}/member/updatePass.do',
                    type: 'POST',
                    data: {user_psw_confirm : user_psw_confirm,mem_id:mem_id},
                    dataType : 'text',
                    success: function(data){
                        if(data==="성공"){
                            alert("비밀번호 수정에 성공했습니다.");
                            location.href='${contextPath}/member/loginForm.do';
                        } else {
                            alert("비밀번호 수정에 실패했습니다. 다시 시도해주세요!");
                        }
                    }, 
                    error: function(){
                        alert("오류가 발생했습니다. 관리자에게 문의하세요.");
                    }
                });
            }else{
            	alert("비밀번호가 일치하지 않습니다. 다시 작성해주세요.");
            }
        }
    </script>
</head>
<body>
    <h3>이메일 인증</h3>
   <div class="container">
            <div class="mb-3">
                <label for="email" class="form-label">이메일</label>
                <input type="email" class="form-control" name="email" id="email" placeholder="인증번호를 받을 이메일 주소를 입력하세요.">
            </div>
            <button type="button" class="btn btn-primary" onclick="sendMail()">인증하기</button>

            <div id="confirm" style="display: none; margin-top: 20px;">
                <input type="text" class="form-control" id="checknum" placeholder="인증번호 입력하세요">
                <button type="button" class="btn btn-primary" style="margin-top: 10px;" onclick="check()">확인</button>
            </div>

            <div id="resetpsw" style="display: none; margin-top: 20px;">
                <div class="mb-3">
                    <label for="user_psw" class="form-label">새로운 비밀번호</label>
                    <input type="password" class="form-control" name="user_psw" id="user_psw">
                </div>
                <div class="mb-3">
                    <label for="user_psw_confirm" class="form-label">새로운 비밀번호 확인</label>
                    <input type="password" class="form-control" name="user_psw_confirm" id="user_psw_confirm">
                </div>
                <button type="button" class="btn btn-primary" onclick="updatePass()">비밀번호 수정하기</button> 
            </div>
    </div>
</body>
</html>