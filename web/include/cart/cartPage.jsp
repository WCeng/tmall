<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>

<script>
	function formatMoney(num) {
		num = num.toString().replace(/\$|\,/g, '');
		if (isNaN(num))
			num = "0";
		sign = (num == (num = Math.abs(num)));
		num = Math.floor(num * 100 + 0.50000000001);
		cents = num % 100;
		num = Math.floor(num / 100).toString();
		if (cents < 10)
			cents = "0" + cents;
		for (var i = 0; i < Math.floor((num.length - (1 + i)) / 3); i++)
			num = num.substring(0, num.length - (4 * i + 3)) + ','
					+ num.substring(num.length - (4 * i + 3));
		return (((sign) ? '' : '-') + num + '.' + cents);
	};

	function syncCreateOrderButton() {
		var selectAny = false;
		$(".cartProductItemIfSelected").each(function() {
			if ("selectit" == $(this).attr("selectit")) {
				selectAny = true;
			}
		});
		if (selectAny) {
			$(".createOrderButton").css("background-color", "#c40000");
			$(".createOrderButton").removeAttr("disabled");
		} else {
			$(".createOrderButton").css("background-color", "#aaaaaa");
			$(".createOrderButton").attr("disabled", "disabled");
		}
	}

	function syncSelect() {
		var selectAll = true;
		$(".cartProductItemIfSelected").each(function() {
			if ("false" == $(this).attr("selectit")) {
				selectAll = false;
			}
		})
		if (selectAll) {
			$("img.selectAllItem").attr("src",
					"img/site/cartSelected.png")
			$("img.selectAllItem").attr("selectit", "selectit");
		} else {
			$("img.selectAllItem").attr("src",
					"img/site/cartNotSelected.png")
			$("img.selectAllItem").attr("selectit", "false");
		}
	}

	function calcCartSumPriceAndNumber() {
		var sum = 0;
		var totalNumber = 0;
		$("img.cartProductItemIfSelected[selectit='selectit']").each(
				function() {
					var oiid = $(this).attr("oiid");
					var price = $(
							".cartProductItemSmallSumPrice[oiid=" + oiid + "]")
							.text();
					price = price.replace(/,/g, "");
					price = price.replace(/￥/g, "");
					sum += new Number(price);
					var num = $(".orderItemNumberSetting[oiid=" + oiid + "]")
							.val();
					totalNumber += new Number(num);
				});
		$("span.cartSumPrice").html("￥" + formatMoney(sum));
		$("span.cartTitlePrice").html("￥" + formatMoney(sum));
		$("span.cartSumNumber").html(totalNumber);
	}

	function syncPrice(pid, num, price) {
		$(".orderItemNumberSetting[pid=" + pid + "]").val(num);
		var totalPrice = price*num;
		var cartProductItemSmallSumPrice = formatMoney(totalPrice);
		$(".cartProductItemSmallSumPrice[pid=" + pid + "]").html(
				"￥" + cartProductItemSmallSumPrice);
		calcCartSumPriceAndNumber();
		
		var page = "forechangeOrderItem";
		$.post(
			page,
			{"pid":pid, "num":num},
			function(result){
				if(result != "success"){
					location.href="login.jsp";
				}
			}
		)
		
	}

	$(function() {
		$("img.cartProductItemIfSelected")
				.click(
						function() {
							var selectit = $(this).attr("selectit");
							if ("selectit" == selectit) {
								$(this)
										.attr("src",
												"img/site/cartNotSelected.png");
								$(this).attr("selectit", "false");
								$(this).parents("tr.cartProductItemTR").css(
										"background-color", "#fff");
							} else {
								$(this)
										.attr("src",
												"img/site/cartSelected.png");
								$(this).attr("selectit", "selectit");
								$(this).parents("tr.cartProductItemTR").css(
										"background-color", "#FFF8E1")
							}
							syncSelect();
							syncCreateOrderButton();
							calcCartSumPriceAndNumber();
						});

		$("img.selectAllItem")
				.click(
						function() {
							var selectit = $(this).attr("selectit");
							if (selectit == "selectit") {
								$("img.selectAllItem")
										.attr("src",
												"img/site/cartNotSelected.png");
								$("img.selectAllItem")
										.attr("selectit", "false");
								$("img.cartProductItemIfSelected")
										.each(
												function() {
													$(this)
															.attr("src",
																	"img/site/cartNotSelected.png")
													$(this).attr("selectit",
															"false");
													$(this)
															.parents(
																	"tr.cartProductItemTR")
															.css(
																	"background-color",
																	"#fff");
												})
							} else {
								$("img.selectAllItem")
										.attr("src",
												"img/site/cartSelected.png");
								$("img.selectAllItem").attr("selectit",
										"selectit");
								$("img.cartProductItemIfSelected")
										.each(
												function() {
													$(this)
															.attr("src",
																	"img/site/cartSelected.png");
													$(this).attr("selectit",
															"selectit");
													$(this)
															.parents(
																	"tr.cartProductItemTR")
															.css(
																	"background-color",
																	"#fff8e1");
												});
							}
							syncCreateOrderButton();
							calcCartSumPriceAndNumber();
						});

		$(".numberPlus")
				.click(
						function() {
							var pid = $(this).attr("pid");
							var num = $(
									".orderItemNumberSetting[pid=" + pid + "]")
									.val();
							var stock = $(".orderItemStock[pid=" + pid + "]")
									.text();
							var price = $(
									"span.orderItemPromotePrice[pid=" + pid
											+ "]").text();
							num++;
							if (num > stock) {
								num = stock;
							}
							syncPrice(pid, num, price);
						})

		$(".numberMinus")
				.click(
						function() {
							var pid = $(this).attr("pid");
							var price = $(
									"span.orderItemPromotePrice[pid=" + pid
											+ "]").text();
							var num = $(
									".orderItemNumberSetting[pid=" + pid + "]")
									.val();
							num--;
							if (num < 1) {
								num = 1;
							}
							syncPrice(pid, num, price);
						})

		$("input.orderItemNumberSetting")
				.keyup(
						function() {
							var pid = $(this).attr("pid");
							var stock = $(
									"span.orderItemStock[pid=" + pid + "]")
									.text();
							var price = $(
									"span.orderItemPromotePrice[pid=" + pid
											+ "]").text();
							var num = $(this).val();
							num = parseInt(num);
							if (isNaN(num)) {
								num = 1;
							}
							if (num > stock) {
								num = stock;
							}
							if (num <= 0) {
								num = 1;
							}
							syncPrice(pid, num, price);
						})
						
						
		var deleteOrderItem  = false;
		var deleteOrderItemid = 0;
		
		$("a.DeleteOrderItem").click(function (){
			deleteOrderItem = false;	
			var oiid = $(this).attr("oiid");
			deleteOrderItemid = oiid;
			$("#deleteConfirmModal").modal('show');
		})
		$("button.deleteConfirmButton").click(function(){
			deleteOrderItem = true;
			$("#deleteConfirmModal").modal('hide');
			
		});
		$("#deleteConfirmModal").on('hidden.bs.modal', function(){
			if(deleteOrderItem){
				var page = "foredeleteOrderItem";
				$.post(
					page,
					{"oiid":deleteOrderItemid},
					function(result){
						if(result == "success"){
							$("tr.cartProductItemTR[oiid="+deleteOrderItemid+"]").hide();
							$("img.cartProductItemIfSelected[oiid="+deleteOrderItemid +"]").removeAttr("selectit");
							calcCartSumPriceAndNumber();
						}else{
							location.href="login.jsp";
						}
					}
				)
				
			}
		})
		
		$("button.createOrderButton").click(function (){
			var params = "";
			$("img.cartProductItemIfSelected[selectit=selectit]").each(function(){
				var oiid = $(this).attr("oiid");
				params += "&oiid=" + oiid; 
				
			})
			
			params = params.substring(1);
			location.href="forebuy?" + params;
		})
		
	})
</script>
<div class="cartDiv">
	<div class="cartTitle pull-right">
		<span>已选商品 (不含运费)</span> <span class="cartTitlePrice">￥0.00</span>
		<button class="createOrderButton"
			style="background-color: rgb(170, 170, 170);" disabled="disabled">结
			算</button>
	</div>

	<div class="cartProductList">
		<table class="cartProductTable">
			<thead>
				<tr>
					<th class="selectAndImage"><img
						src="img/site/cartNotSelected.png"
						class="selectAllItem" selectit="false"> 全选</th>
					<th>商品信息</th>
					<th>单价</th>
					<th>数量</th>
					<th class="jine">金额</th>
					<th class="operation">操作</th>
				</tr>
			</thead>
			<tbody>

				<c:forEach items="${ois}" var="oi">

					<tr class="cartProductItemTR" oiid="${oi.id}">
						<td><img src="img/site/cartNotSelected.png" class="cartProductItemIfSelected" oiid="${oi.id}" selectit="false"> 
							<a href="#nowhere" style="display: none;">
							<img src="img/site/cartSelected.png">
						</a> <img width="40px" class="cartProductImg"
							src="img/productSingle_middle/${oi.product.firstProductImage.id}.jpg">
						</td>
						<td>
							<div class="cartProductLinkOutDiv">
								<a class="cartProductLink"
									href="foreproduct?pid=${oi.product.id}"> ${oi.product.name}</a>
								<div class="cartProductLinkInnerDiv">
                                    <img src="img/site/creditcard.png" title="支持信用卡支付">
                                    <img src="img/site/7day.png" title="消费者保障服务,承诺7天退货">
                                    <img src="img/site/promise.png" title="消费者保障服务,承诺如实描述">
                                </div>
							</div>
						</td>
						<td><span class="cartProductItemOringalPrice">￥${oi.product.orignalPrice}</span> 
							<span class="cartProductItemPromotionPrice">￥${oi.product.promotePrice}</span></td>
						<td>
							<div class="cartProductChangeNumberDiv">
								<span pid="${oi.product.id}" class="hidden orderItemStock">${oi.product.stock}</span>
								<span pid="${oi.product.id}"
									class="hidden orderItemPromotePrice "> ${oi.product.promotePrice}
									</span> 
								<a href="#nowhere" class="numberMinus" pid="${oi.product.id}">-</a>
								<input value="${oi.number}" autocomplete="off"
									class="orderItemNumberSetting" oiid="${oi.id}"
									pid="${oi.product.id}"> 
								<a href="#nowhere"
									class="numberPlus" pid="${oi.product.id}"
									stock="${oi.product.stock}">+</a>
							</div>
						</td>
						<td><span pid="${oi.product.id}" oiid="${oi.id}"
							class="cartProductItemSmallSumPrice">￥<fmt:formatNumber
									type="number" value="${oi.product.promotePrice*oi.number}"
									minFractionDigits="2" /></span></td>
						<td><a href="#nowhere" oiid="${oi.id}"
							class="DeleteOrderItem">删除</a></td>
					</tr>
				</c:forEach>

			</tbody>
		</table>
	</div>

	<!-- <div style="text-align: center; color: gray; line-height: 100px;">hihao</div> -->
	<div class="cartFoot">
		<img src="img/site/cartNotSelected.png"
			class="selectAllItem" selectit="false"> 
		<span>全选</span>
		<div class="pull-right">
			<span>已选商品<span class="cartSumNumber">0</span>件
			</span> <span>合计 (不含运费):</span> <span class="cartSumPrice">￥0.00</span>
			<button class="createOrderButton"
				style="background-color: rgb(170, 170, 170);" disabled="disabled">结
				算</button>
		</div>
	</div>
</div>