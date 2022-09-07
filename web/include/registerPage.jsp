<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>

<style>
div.registerDiv {
	margin: 10px 20px;
}

table.registerTable {
	margin: 50px auto;
	font-size: 16px;
}

table.registerTable td {
	padding: 10px 30px;
	width: 300px;
}

td.registerTip {
	color: #333333;
	font-weight: bold;
}

td.registerTableLeftTD {
	text-align: right;
	/* padding-right: 30px !important; */
}

td.registerTableRightTD {
	/* padding-left: 30px !important; */
	
}

td.registerTableRightTD input {
	border: 1px solid lightgray;
	width: 213px;
	height: 36px;
	font-size: 14px;
	outline: none;
}

td.registerButtonTD {
	text-align: center;
}

td.registerButtonTD button {
	background-color: #c40000;
	border-width: 0px;
	width: 170px;
	height: 37px;
	color: #fff;
}
div.registerDiv div.registerErrorMessageDiv{
	visibility: hidden;
	width: 400px;
	margin-left: 570px;
	height: 0px;
}
</style>

<script>
	$(function() {
		
		<c:if test="${!empty msg}">
	    $("span.errorMessage").html("${msg}");
	    $("div.registerErrorMessageDiv").css("visibility","visible");      
	    </c:if>
		
		$("form.registerForm").submit(function() {
			if (0 == $("#name").val().length) {
				$("span.errorMessage").html("请输入用户名");
	            $("div.registerErrorMessageDiv").css("visibility","visible");          
	            return false;
			}
			if(0==$("#password").val().length){
	            $("span.errorMessage").html("请输入密码");
	            $("div.registerErrorMessageDiv").css("visibility","visible");          
	            return false;
	        }
			if(0==$("#repeatpassword").val().length){
	            $("span.errorMessage").html("请输入重复密码");
	            $("div.registerErrorMessageDiv").css("visibility","visible");          
	            return false;
	        }    
			if($("#password").val() !=$("#repeatpassword").val()){
	            $("span.errorMessage").html("重复密码不一致");
	            $("div.registerErrorMessageDiv").css("visibility","visible");          
	            return false;
	        }      
			return true;
		})

	})
</script>

<style>
	div.nihao{
		/*border: 1px solid red;*/

	}
</style>

<div class="registerDiv">

	<form action="foreregister" method="post" class="registerForm">
		<div class="nihao">
		<div class="registerErrorMessageDiv">
			<div class="alert alert-danger" role="alert">
				<button type="button" class="close" data-dismiss="alert"
					aria-label="Close"></button>
				<span class="errorMessage"></span>
			</div>
		</div>
		</div>
		<table border="0" class="registerTable">
			<tr>
				<td class="registerTip registerTableLeftTD">设置会员名</td>
				<td></td>
			</tr>
			<tr>
				<td class="registerTableLeftTD">登陆名</td>
				<td class="registerTableRightTD"><input
					placeholder="会员名一旦设置成功，无法修改" type="text" name="name" id="name">
				</td>
			</tr>
			<tr>
				<td class="registerTip registerTableLeftTD">设置登陆密码</td>
				<td class="registerTableRightTD">登陆时验证，保护账号信息</td>
			</tr>
			<tr>
				<td class="registerTableLeftTD">登陆密码</td>
				<td class="registerTableRightTD"><input type="password"
					placeholder="设置你的登陆密码" name="password" id="password"></td>
			</tr>
			<tr>
				<td class="registerTableLeftTD">密码确认</td>
				<td class="registerTableRightTD"><input type="password"
					placeholder="请再次输入你的密码" id="repeatpassword"></td>
			</tr>
			<tr>
				<td class="registerButtonTD" colspan="2"><a href="#nowhere"><button
							type="submit">提 交</button></a></td>
			</tr>
		</table>
	</form>
</div>