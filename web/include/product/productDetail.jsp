<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
    
    <script>
        $(function () {
            $("div.productReviewDiv").hide();
            $("a.productDetailTopReviewLink").click(function () {
                $("div.productDetailDiv").hide();
                $("div.productReviewDiv").show();
            });
            $("a.productReviewTopPartSelectedLink").click(function(){
                $("div.productReviewDiv").hide();
                $("div.productDetailDiv").show();
            })
        })
    </script>
    
    <div class="productDetailDiv">
        <div class="productDetailTopPart">
            <a href="#nowhere" class="productDetailTopPartSelectedLink selected">商品详情</a>
            <a href="#nowhere" class="productDetailTopReviewLink">
                累计评价<span class="productDetailTopReviewLinkNumber">${reviews.size()}</span>
            </a>
        </div>
        <div class="productParamterPart">
            <div class="productParamter">产品参数：</div>
            <div class="productParamterList">
            
                <c:forEach items="${pvs}" var="pv">
                	<span>${pv.property.name}:  ${fn:substring(pv.value, 0, 10)} </span>
            	</c:forEach>
            	
            </div>
            <div style="clear:both"></div>
        </div>
        <div class="productDetailImagesPart">
            <c:forEach items="${p.productDetailImages}" var="pi">
            	<img src="img/productDetail/${pi.id}.jpg">
            </c:forEach>
        </div>
    </div>