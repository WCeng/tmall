<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
    
    <script>
        $(function () {
            $("div.smallImageDiv img").mouseenter(function () {
                var bigImageURL = $(this).attr("bigImageURL");
                $("img.bigImg").attr("src", bigImageURL);
            });
            $("img.bigImg").load(function () {
                $("img.smallImage").each(function () {
                    var bigImageURL = $(this).attr("bigImageURL");
                    img = new Image();
                    img.src = bigImageURL;
                    img.onload = function () {
                        $("div.img4load").append($(img));
                    }
                })
            });
        })
        $(function () {
            var stock = ${p.stock};
            $(".productNumberSetting").keyup(function () {
                var num = $(this).val();
                num = parseInt(num);
                if (isNaN(num)) {
                    num = 1;
                }
                if (num <= 0) {
                    num = 1;
                }
                if (num > stock) {
                    num = stock;
                }
                $(this).val(num);
            });
            $(".increaseNumber").click(function () {
                var num = $(".productNumberSetting").val();
                num++;
                if (num > stock) {
                    num = stock;
                }
                $(".productNumberSetting").val(num);
            });
            $(".decreaseNumber").click(function () {
                var num = $(".productNumberSetting").val();
                num--;
                if (num < 1) {
                    num = 1;
                }
                $(".productNumberSetting").val(num);
            })
            
            $(".addCartLink").click(function(){
            	var page = "forecheckLogin";
            	$.get(
            		page,
            		function(result){
            			if(result == "success"){
            				var pid = ${p.id};
            				var num = $(".productNumberSetting").val();
            				var addCartPage = "foreaddCart";
            				$.get(
            					addCartPage,
            					{"pid":pid,"num":num},
                                function(result){
                                    if("success"==result){
                                        $(".addCartButton").html("??????????????????");
                                        $(".addCartButton").attr("disabled","disabled");
                                        $(".addCartButton").css("background-color","lightgray")
                                        $(".addCartButton").css("border-color","lightgray")
                                        $(".addCartButton").css("color","black")
                                         
                                    }
                                    else{
                                         
                                    }
                                }
            				)
            				
            			}else{
            				$("#loginModal").modal('show');
            			}
            		}
            	)
            })
            $("button.loginSubmitButton").click(function(){
                var name = $("#name").val();
                var password = $("#password").val();
                 
                if(0==name.length||0==password.length){
                    $("span.errorMessage").html("?????????????????????");
                    $("div.loginErrorMessageDiv").show();          
                    return false;
                }
                 
                var page = "foreloginAjax";
                $.get(
                        page,
                        {"name":name,"password":password},
                        function(result){
                            if("success"==result){
                                location.reload();
                            }
                            else{
                                $("span.errorMessage").html("??????????????????");
                                $("div.loginErrorMessageDiv").show();                      
                            }
                        }
                );         
                 
                return true;
            });
            $(".buyLink").click(function(){
                var page = "forecheckLogin";
                $.get(
                        page,
                        function(result){
                            if("success"==result){
                                var num = $(".productNumberSetting").val();
                                location.href= $(".buyLink").attr("href")+"&num="+num;
                            }
                            else{
                                $("#loginModal").modal('show');                    
                            }
                        }
                );     
                return false;
            });
        })
    </script>
    
    <img class="smallSearchBellowImg" src="img/category/${p.category.id}.jpg">

    <div class="imgAndInfo">

        <div class="imgInimgAndInfo">
            <img width="100px" class="bigImg" src="img/productSingle/${p.firstProductImage.id}.jpg">
            <div class="smallImageDiv">
                <c:forEach items="${p.productSingleImages}" var="pi">
                	<img src="img/productSingle_small/${pi.id}.jpg" 
                	bigImageURL="img/productSingle/${pi.id}.jpg" class="smallImage">
                </c:forEach>
            </div>
            <div class="img4load hidden"></div>
        </div>
        <!-- <div style="clear: both;"></div> -->

        <div class="infoInimgAndInfo">
            <div class="productTitle">
                ${p.name}
            </div>
            <div class="productSubTitle">
                ${p.subTitle}
            </div>
            <div class="productPrice">
                <div class="juhuasuan">
                    <span class="juhuasuanBig">?????????</span>
                    <span>?????????????????????????????????<span class="juhuasuanTime">1???19??????</span>????????????</span>

                </div>
                <div class="productPriceDiv">
                    <div class="gouwujuanDiv">
                        <img height="16px" src="https://how2j.cn/tmall/img/site/gouwujuan.png">
                        <span>???????????????????????????</span>
                    </div>
                    <div class="originalDiv">
                        <span class="originalPriceDesc">??????</span>
                        <span class="originalPriceYuan">???</span>
                        <span class="originalPrice">
                        	<fmt:formatNumber type="number" value="${p.orignalPrice}" minFractionDigits="2"/>
                        </span>
                    </div>
                    <div class="promotionDiv">
                        <span class="promotionPriceDesc">?????????</span>
                        <span class="promotionPriceYuan">???</span>
                        <span class="promotionPrice">
                        	<fmt:formatNumber type="number" value="${p.promotePrice}" minFractionDigits="2"/>
                        </span>
                    </div>
                </div>
            </div>
            <div class="productSaleAndReviewNumber">
                <div>??????<span class="redColor boldword">
                        ${p.saleCount }</span></div>
                <div>????????????<span class="redColor boldword">
                        ${p.reviewCount}</span></div>
            </div>
            <div class="productNumber">
                <span>??????</span>
                <span>
                    <span class="productNumberSettingSpan">
                        <input type="text" value="1" class="productNumberSetting">
                    </span>
                    <span class="arrow">
                        <a class="increaseNumber" href="#nowhere">
                            <span class="updown">
                                <img src="https://how2j.cn/tmall/img/site/increase.png">
                            </span>
                        </a>
                        <span class="updownMiddle"></span>
                        <a class="decreaseNumber" href="#nowhere">
                            <span class="updown">
                                <img src="https://how2j.cn/tmall/img/site/decrease.png">
                            </span>
                        </a>
                    </span>
                    ???
                </span>
                <span>??????${p.stock}???</span>
            </div>
            <div class="serviceCommitment">
                <span class="serviceCommitmentDesc">????????????</span>
                <span class="serviceCommitmentLink">
                    <a href="#nowhere">????????????</a>
                    <a href="#nowhere">????????????</a>
                    <a href="#nowhere">????????????</a>
                    <a href="#nowhere">?????????????????????</a>
                </span>
            </div>
            <div class="buyDiv">
                <a href="forebuyone?pid=${p.id}" class="buyLink">
                    <button class="buyButton">????????????</button>
                </a>
                <a href="#nowhere" class="addCartLink">
                    <button class="addCartButton">
                        <span class="glyphicon glyphicon-shopping-cart"></span>
                        ???????????????
                    </button>
                </a>
            </div>
        </div>
        <div style="clear: both;"></div>
    </div>