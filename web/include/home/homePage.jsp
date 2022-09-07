<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
	
	<div class="categoryWithCarousel">

        <img class="catear" id="catear" src="img/site/catear.png">

        <div class="headbar">
            <div class="head">
                <span class="glyphicon glyphicon-th-list" style="margin-left: 10px"></span>
                <span style="margin-left: 10px;">商品分类</span>
            </div>

            <div class="rightMenu">
                <span>
                    <a href="https://chaoshi.tmall.com/?spm=875.7931836.0.0.66144265XrzJZe"><img src="img/site/chaoshi.png"></a>
                </span>
                <span>
                    <a href="https://www.tmall.hk/?spm=875.7931836.0.0.661442654Os7fH"><img src="img/site/guoji.png"></a>
                </span>
                <c:forEach items="${cs}" var="c" varStatus="st">
                <c:if test="${st.count<=4}">
                <span><a href="forecategory?cid=${c.id}">${c.name}</a></span>
                </c:if>
                </c:forEach>
            </div>
        </div>


        <div id="carousel-example-generic" class="carousel-of-product carousel slide" data-ride="carousel"
            data-interval="3000">
            <!-- Indicators -->
            <ol class="carousel-indicators">
                <li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
                <li data-target="#carousel-example-generic" data-slide-to="1"></li>
                <li data-target="#carousel-example-generic" data-slide-to="2"></li>
                <li data-target="#carousel-example-generic" data-slide-to="3"></li>
            </ol>
            <!-- Wrapper for slides -->
            <div class="carousel-inner" role="listbox">
                <div class="item active">
                    <img src="img/lunbo/1.jpg" class="carouselImage">
                </div>
                <div class="item ">
                    <img src="img/lunbo/2.jpg" class="carouselImage">
                </div>
                <div class="item">
                    <img src="img/lunbo/3.jpg" class="carouselImage">
                </div>
                <div class="item">
                    <img src="img/lunbo/4.jpg" class="carouselImage">
                </div>
            </div>
        </div>
        <div class="carouselBackgroundDiv"></div>

        <div style="position: absolute; top: 36px">
            <div class="categoryMenu">
            	<c:forEach items="${cs}" var="c" >
                <div class="eachCategory" cid="${c.id}">
                    <span class="glyphicon glyphicon-link"></span>
                    <a href="forecategory?cid=${c.id}">${c.name}</a>
                </div>
                </c:forEach>
            </div>
        </div>

        <div style="position: absolute; left: 0px; top: 36px;">
        	<c:forEach items="${cs}" var="c">
            <div class="productsAsideCategorys" cid="${c.id}" style="display: none;">
            	<c:forEach items="${c.productsByRow}" var="ps">
                <div class="row">
                	<c:forEach items="${ps}" var="p">
                    <a href="foreproduct?pid=${p.id}">
                    	<c:forEach items="${fn:split(p.subTitle, ' ')}" var="title" varStatus="st">
                    		<c:if test="${st.index==0}">
                    			${title}
                    		</c:if>
                    	</c:forEach>
					</a>
                    </c:forEach>
                    <div class="seperator"></div>
                </div>
                </c:forEach>
                

            </div>
            </c:forEach>

            

        </div>
    </div>
    <script>
$(function(){
    $("div.productsAsideCategorys div.row a").each(function(){
        var v = Math.round(Math.random() *6);
        if(v == 1)
            $(this).css("color","#87CEFA");
    });
});
 
</script>

    <script>
        $(function () {
            $("div.rightMenu span").mouseenter(function () {
                var left = $(this).position().left;
                var top = $(this).position().top;
                var width = $(this).css("width");
                var earLeft = parseInt(left) + parseInt(width) / 2;
                $("img#catear").css("left", earLeft);
                $("img#catear").css("top", "-8px");
                $("img#catear").fadeIn(500);
            }),
                $("div.rightMenu span").mouseout(function () {
                    $("img#catear").hide();
                })
        })
        function showProductsAsideCategorys(cid) {
            $("div.eachCategory[cid=" + cid + "]").css("background-color", "white");
            $("div.eachCategory[cid=" + cid + "] a").css("color", "#87CEFA");
            $("div.productsAsideCategorys[cid=" + cid + "]").show();
        }
        function hideProductsAsideCategorys(cid) {
            $("div.eachCategory[cid=" + cid + "]").css("background-color", "#e2e2e3");
            $("div.eachCategory[cid=" + cid + "] a").css("color", "#000");
            $("div.productsAsideCategorys[cid=" + cid + "]").hide();
        }

        $(function () {
            $("div.eachCategory").mouseenter(function () {
                var cid = $(this).attr("cid");
                showProductsAsideCategorys(cid);
            })
        })
        $(function () {
            $("div.eachCategory").mouseleave(function () {
                var cid = $(this).attr("cid");
                hideProductsAsideCategorys(cid);
            })
        })
        $(function () {
            $("div.productsAsideCategorys").mouseenter(function () {
                var cid = $(this).attr("cid");
                showProductsAsideCategorys(cid);
            })
        })
        $(function () {
            $("div.productsAsideCategorys").mouseleave(function () {
                var cid = $(this).attr("cid");
                hideProductsAsideCategorys(cid);
            })
        })
    </script>

    <!-- --------------------------------------------------------------------------- -->
    <div class="homepageCategoryProducts">
        <!-- 第一类产品 -->
        <c:forEach items="${cs}" var="c">
        <div class="eachHomepageCategoryProducts">
            <div class="left-mark"></div>
            <span class="categoryTitle">${c.name}</span>
            <br>
            <c:forEach items="${c.products}" var="p" varStatus="st">
            <c:if test="${st.count<=5}">
            <div class="productItem">
                <a href="foreproduct?pid=${p.id}">
                    <img width="100px" src="img/productSingle_middle/${p.firstProductImage.id}.jpg">
                </a>
                <a href="foreproduct?pid=${p.id}" class="productItemDescLink"> 
                    <span class="productItemDesc">
                        [热销]
                        ${fn:substring(p.name, 0, 20)}
                    </span>
                </a>
                <span class="productPrice"><fmt:formatNumber type="number" value="${p.promotePrice}" minFractionDigits="2"/></span>
            </div>
            </c:if>
            </c:forEach>
            
            <!-- 清除浮动 -->
            <div style="clear: both;"></div>
        </div>
        </c:forEach>
        <!-- 第二类产品 -->
        
        <img src="img/site/end.png" class="endpng" id="endpng">
    </div>