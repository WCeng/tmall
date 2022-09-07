<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>


<script>
	$(function() {
		$("input#name")[0].focus();
		
		<c:if test="${!empty msg}">
	    $("span.errorMessage").html("${msg}");
	    $("div.loginErrorMessageDiv").show();      
	    </c:if>
		
		$(".loginForm").submit(function() {			
			
			if(0==$("#name").val().length||0==$("#password").val().length){
	            $("span.errorMessage").html("请输入账号密码");
	            $("div.loginErrorMessageDiv").show();          
	            if(0==$("#name").val().length){
	            	$("#name")[0].focus();
	            	return false;
	            }
	            if($("#password").val().length == 0){
					$("#password")[0].focus();
	            	return false;
				}
	            
	        }
	        return true;
		})
	})
</script>

<style>
	div#loginDiv div.loginErrorMessageDiv {
		position: absolute;
		width: 290px;
	}
</style>

<div id="loginDiv">
	<div class="simpleLogo">
		<img src="https://how2j.cn/tmall/img/site/simpleLogo.png">
	</div>
	<img class="loginBackgroundImg hidden" id="loginBackgroundImg"
		src="https://how2j.cn/tmall/img/site/loginBackground.png">
	<img class="loginBackgroundImg " id="loginBackgroundImg"
		src="https://gw.alicdn.com/imgextra/i3/O1CN01iyYdem1GQd1yGgA0a_!!6000000000617-0-tps-2500-600.jpg">

	<div class="loginSmallDivOutDiv">
		<form action="forelogin" method="post" class="loginForm">
			<div class="loginSmallDiv" id="loginSmallDiv">

				<div class="loginErrorMessageDiv ">
					<div class="alert alert-danger">
						<button type="button" class="close" data-dismiss="alert"
							aria-label="Close"></button>
						<span class="errorMessage"></span>
					</div>
				</div>

				<div class="login_acount_text">账户登录</div>
				<div class="loginInput">
					<span class="loginInputIcon"> <span
						class="glyphicon glyphicon-user"></span>
					</span> <input type="text" placeholder="手机/会员名/邮箱" name="name" id="name">
				</div>
				<div class="loginInput">
					<span class="loginInputIcon"> <span
						class=" glyphicon glyphicon-lock"></span>
					</span> <input type="password" placeholder="密码" name="password"
						id="password">
				</div>
				<div>
					<a href="#nowhere" class="notImplementLink">忘记登录密码</a> <a
						href="register.jsp" class="pull-right">免费注册</a>
				</div>

				<div style="margin-top: 20px">
					<button type="submit" class="btn btn-block redButton">登录</button>
				</div>
			</div>
		</form>
	</div>
</div>