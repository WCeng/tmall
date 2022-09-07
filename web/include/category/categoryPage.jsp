<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>

<div class="categoryPageDiv">

	<img src="https://how2j.cn/tmall/img/category/${c.id}.jpg">
	
	<%@include file="categorySortBar.jsp"%>
	<%@include file="productsByCategory.jsp"%>

</div>