<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>

<script>
	$(function () {
		$("li.disabled a").click(function () {
			return false;
		})	
	})
	
</script>

<nav>
	<ul class="pagination">

		<li <c:if test="${!page.isHasPreviouse()}">class="disabled"</c:if>>
		<a href="?page.start=0${page.param}" aria-label="Previous"> 
			<span aria-hidden="true">«</span>
		</a>
		</li>
		
		<li <c:if test="${!page.isHasPreviouse()}">class="disabled"</c:if> >
			<a href="?page.start=${page.start-page.count}${page.param}"
				aria-label="Previous">
				<span aria-hidden="true">‹</span>	
			</a>
		</li>
		
		<%--varStatus:  表示集合中每个元素的相关信息,有4种状态:index(所在位置，即索引).count(总共已迭代的次数)
		.first(是否为第一个位置),last(是否为最后一个位置) --%>
		
		<c:forEach begin="0" end="${page.totalPage-1}" varStatus="status">
     
        <c:if test="${status.count*page.count-page.start<=20 && status.count*page.count-page.start>=-10}">
            <li <c:if test="${status.index*page.count==page.start}">class="disabled"</c:if>>
                <a 
                href="?page.start=${status.index*page.count}${page.param}"
                <c:if test="${status.index*page.count==page.start}">class="current"</c:if>
                >${status.count}</a>
            </li>
        </c:if>
    </c:forEach>
    
    <li <c:if test="${!page.hasNext}">class="disabled"</c:if>>
      <a href="?page.start=${page.start+page.count}${page.param}" aria-label="Next">
        <span aria-hidden="true">›</span>
      </a>
    </li>
    <li <c:if test="${!page.hasNext}">class="disabled"</c:if>>
      <a href="?page.start=${page.last}${page.param}" aria-label="Next">
        <span aria-hidden="true">»</span>
      </a>
    </li>



	</ul>
</nav>