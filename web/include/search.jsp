<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>

<div>
	<a href="${contextPath }"> <img class="logo" id="logo"
		src="https://how2j.cn/tmall/img/site/logo.gif">
	</a>

	<form action="foresearch" method="post">
		<div class="searchDiv">
			<input type="text" placeholder="时尚男鞋  太阳镜" name="keyword">
			<button type="submit" class="searchButton">搜索</button>
			<div class="searchBelow">
				<c:forEach items="${cs}" var="c" varStatus="st">
					<c:if test="${st.count>=5 and st.count<=8}">
						<span> <a href="forecategory?cid=${c.id}"> ${c.name} </a> <c:if
								test="${st.count!=8}">
								<span>|</span>
							</c:if>
						</span>
					</c:if>
				</c:forEach>
			</div>
		</div>

	</form>
</div>