<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
    
<div class="aliPayPageDiv">
        <div class="aliPayPageLogo">
            <img src="img/site/simpleLogo.png" class="pull-left">
            <div style="clear: both;"></div>
        </div>
        <div>
            <span class="confirmMoneyText">扫一扫付款 (元)</span>
            <span class="confirmMoney">￥
            <fmt:formatNumber type="number" value="${param.total}" minFractionDigits="2"/>
            </span>
        </div>
        <div>
            <img src="img/site/alipay2wei.png" class="aliPayImg">
        </div>
        <div>
            <a href="forepayed?oid=${param.oid}&total=${param.total}"><button class="confirmPay">确认支付</button></a>
        </div>
    </div>