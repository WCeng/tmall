<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
    
    
    <script>
    	$(function(){
    		$("form.buyForm").submit(function(){
		    	if(!checkEmpty("detailAddress", "详细地址")){
		    		return false;
		    	}
		    	if(!checkEmpty("receiverName", "收货人姓名")){
		    		return false;
		    	}
		    	if(!checkEmpty("mobile", "手机号码")){
		    		return false;
		    	}
    			
    		})
    	})
    </script>
<div class="buyPageDiv">
        <div class="buyFlow">
            <img class="pull-left" src="https://how2j.cn/tmall/img/site/simpleLogo.png">
            <img class="pull-right" src="https://how2j.cn/tmall/img/site/buyflow.png">
            <div style="clear: both;"></div>
        </div>
        <form action="forecreateOrder" method="post" class="buyForm">
        <div class="address">
            <div class="addressTip">输入收货地址</div>
            <div>
                <table border="0" class="addressTable">
                    <tbody>
                        <tr>
                            <td class="firstColumn">详细地址<span class="redStart">*</span></td>
                            <td><textarea id="detailAddress" placeholder="建议您如实填写详细收货地址，例如街道名称，门牌号码，楼层和房间号等信息" name="address"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td>邮政编码</td>
                            <td><input type="text" placeholder="如果您不清楚邮递区号，请填写000000" name="post"></td>
                        </tr>
                        <tr>
                            <td>收货人姓名<span class="redStart">*</span></td>
                            <td><input id="receiverName" type="text" placeholder="长度不超过25个字符" name="receiver"></td>
                        </tr>
                        <tr>
                            <td>手机号码<span class="redStart">*</span></td>
                            <td><input id="mobile" type="text" placeholder="请输入11位手机号码" name="mobile"></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="productList">
            <div class="productListTip">确认订单信息</div>
            <table border="0" class="productListTable">
                <thead>
                    <tr>
                        <th class="productListTableFirstColumn" colspan="2">
                            <img src="https://how2j.cn/tmall/img/site/tmallbuy.png" class="tmallbuy">
                            <a href="#nowhere" class="marketLink">店铺：天猫店铺</a>
                            <a href="#nowhere" class="wangwanglink">
                                <span class="wangwangGif"></span></a>
                        </th>
                        <th>单价</th>
                        <th>数量</th>
                        <th>小计</th>
                        <th>配送方式</th>
                    </tr>
                    <tr class="rowborder">
                        <td colspan="2"></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                </thead>
                <tbody class="productListTableTbody">
                
                	<c:forEach items="${ois}" var="oi" varStatus="st">
                    <tr class="orderItemTR">
                        <td class="orderItemFirstTD"><img class="orderItemImg" width="20px"
                                src="img/productSingle_middle/${oi.product.firstProductImage.id}.jpg"></td>
                        <td class="orderItemProductInfo">
                            <a href="#nowhere" class="orderItemProductLink">
                                ${oi.product.name}
                            </a>
                            <img title="支持信用卡支付" src="https://how2j.cn/tmall/img/site/creditcard.png">
                            <img title="消费者保障服务,承诺7天退货" src="https://how2j.cn/tmall/img/site/7day.png">
                            <img title="消费者保障服务,承诺如实描述" src="https://how2j.cn/tmall/img/site/promise.png">
                        </td>
                        <td>
                            <span class="orderItemProductPrice">￥<fmt:formatNumber type="number" value="${oi.product.promotePrice}" minFractionDigits="2"></fmt:formatNumber></span>
                        </td>
                        <td>
                            <span class="orderItemProductNumber">${oi.number}</span>
                        </td>
                        <td>
                            <span class="orderItemUnitSum">￥
                            <fmt:formatNumber type="number" value="${oi.product.promotePrice*oi.number}" minFractionDigits="2"/></span>
                        </td>
                        <c:if test="${st.count == 1}">
                        <td class="orderItemLastTD" rowspan="20">
                            <label class="orderItemDeliveryLabel">
                                <input type="radio" checked="checked" value="">
                                普通配送
                            </label>
                            <select class="orderItemDeliverySelect">
                                <option>快递 免邮费</option>
                            </select>
                        </td>
                        </c:if>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div class="orderItemSumDiv">
                <div class="pull-left">
                    <span class="leaveMessageText">给卖家留言:</span>
                    <span>
                        <img class="leaveMessageImg" src="https://how2j.cn/tmall/img/site/leaveMessage.png">
                    </span>
                    <span class="leaveMessageTextareaSpan" style="display: none;">
                        <textarea class="leaveMessageTextarea" name="userMessage"
                            style="outline: none; border: 1px solid rgba(178, 178, 0, 0.484)"></textarea>
                        <div>
                            <span>还可以输入200个字符</span>
                        </div>
                    </span>
                </div>
                <span class="pull-right">店铺合计(含运费): ￥<fmt:formatNumber type="number" value="${total}" minFractionDigits="2"/></span>
                <!-- <div style="clear: both;"></div> -->
            </div>
        </div>
        <div class="orderItemTotalSumDiv">
            <div class="pull-right">
                <span>实付款：</span>
                <span class="orderItemTotalSumSpan">￥<fmt:formatNumber type="number" value="${total}" minFractionDigits="2"/></span>
            </div>
        </div>
        <div class="submitOrderDiv">
            <button class="submitOrderButton" type="submit">提交订单</button>
        </div>
        </form>
    </div>

    <script>
        $(function () {
            $("img.leaveMessageImg").click(function () {
                $(this).hide();
                $("span.leaveMessageTextareaSpan").show();
                $("div.orderItemSumDiv").css("height", "100px");
            })
        })
    </script>