package tmall.servlet;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.RandomUtils;
import org.springframework.web.util.HtmlUtils;

import tmall.bean.Category;
import tmall.bean.Order;
import tmall.bean.OrderItem;
import tmall.bean.Product;
import tmall.bean.ProductImage;
import tmall.bean.PropertyValue;
import tmall.bean.Review;
import tmall.bean.User;
import tmall.comparator.ProductAllComparator;
import tmall.comparator.ProductDateComparator;
import tmall.comparator.ProductPriceComparator;
import tmall.comparator.ProductReviewComparator;
import tmall.comparator.ProductSaleCountComparator;
import tmall.dao.OrderDAO;
import tmall.dao.OrderItemDAO;
import tmall.dao.ProductDAO;
import tmall.dao.ProductImageDAO;
import tmall.util.Page;

public class ForeServlet extends BaseForeServlet {
	
	public String home(HttpServletRequest request, HttpServletResponse response, Page page) {
		List<Category> cs = categoryDAO.list();
		System.out.println("首页   cs-total: "   + cs.size());
		productDAO.fill(cs);
		productDAO.fillByRow(cs);
		
		request.setAttribute("cs", cs);
		
		return "home.jsp";
	}
	
	public String register(HttpServletRequest request, HttpServletResponse response, Page page) {
		String name = request.getParameter("name");
		String password = request.getParameter("password");
		name = HtmlUtils.htmlEscape(name);
		System.out.println(name);
		boolean exist = userDAO.isExist(name);
		
		if(exist) {
			request.setAttribute("msg",  "用户名已经被使用,不能使用");
			return "register.jsp";
		}
		
		User user = new User();
		user.setName(name);
		user.setPassword(password);
		System.out.println(user.getName());
		System.out.println(user.getPassword());
		userDAO.add(user);
		
		return "@registerSuccess.jsp";
	}
	
	public String login(HttpServletRequest request, HttpServletResponse response, Page page) {
		String name = request.getParameter("name");
		name = HtmlUtils.htmlEscape(name);
		String password = request.getParameter("password");
		System.out.println(name + "已登录");
		
		User u = userDAO.get(name, password);
		if(u == null) {
			request.setAttribute("msg", "账号密码错误");
			return "login.jsp";
		}
		
		request.getSession().setAttribute("user", u);
		
		return "@forehome";
	}
	
	public String logout(HttpServletRequest request, HttpServletResponse response, Page page) {
	    request.getSession().removeAttribute("user");
	    return "@forehome";
	}  
	
	public String product(HttpServletRequest request, HttpServletResponse response, Page page ) {
		int pid = Integer.parseInt(request.getParameter("pid"));
		Product p = productDAO.get(pid);
		
		List<ProductImage> productSingleImages = productImageDAO.list(p, ProductImageDAO.type_single);
	    List<ProductImage> productDetailImages = productImageDAO.list(p, ProductImageDAO.type_detail);
	    
	    p.setProductSingleImages(productSingleImages);
	    p.setProductDetailImages(productDetailImages);
	    
	    List<PropertyValue> pvs = propertyValueDAO.list(p.getId());
	    
	    List<Review> reviews = reviewDAO.list(p.getId());
	    
	    productDAO.setSaleAndReviewNumber(p);
	    
	    request.setAttribute("reviews", reviews);
	    request.setAttribute("p", p);
	    request.setAttribute("pvs", pvs);
	    
	    return "product.jsp";
	}
	
	public String checkLogin(HttpServletRequest request, HttpServletResponse response, Page page) {
		User user = (User) request.getSession().getAttribute("user");
		
		if(null == user) {
			return "%false";
		}
		
		return "%success";
	}
	
	public String loginAjax(HttpServletRequest request, HttpServletResponse response, Page page) {
		String name = request.getParameter("name");
		String password = request.getParameter("password");		
		User user = userDAO.get(name,password);
		
		if(null==user){
			return "%fail";	
		}
		request.getSession().setAttribute("user", user);
		return "%success";	
	}
	
	public String category(HttpServletRequest request, HttpServletResponse response, Page page) {
		int cid = Integer.parseInt(request.getParameter("cid"));
		
		Category c = categoryDAO.get(cid);
		productDAO.fill(c);
		productDAO.setSaleAndReviewNumber(c.getProducts());
		
		String sort = request.getParameter("sort");
		
		if(null != sort) {
			switch(sort) {
			case "review":
				Collections.sort(c.getProducts(), new ProductReviewComparator());
				break;
			case "date" :
	            Collections.sort(c.getProducts(),new ProductDateComparator());
	            break;
	             
	        case "saleCount" :
	            Collections.sort(c.getProducts(),new ProductSaleCountComparator());
	            break;
	             
	        case "price":
	            Collections.sort(c.getProducts(),new ProductPriceComparator());
	            break;
	             
	        case "all":
	            Collections.sort(c.getProducts(),new ProductAllComparator());
	            break;
			}
			
		}
		
		request.setAttribute("c", c);
		
		return "category.jsp";
		
	}
	
	public String search(HttpServletRequest request, HttpServletResponse response, Page page){
	    String keyword = request.getParameter("keyword");
	    List<Product> ps= productDAO.search(keyword,0,20);
	    productDAO.setSaleAndReviewNumber(ps);
	    request.setAttribute("ps",ps);
	    return "searchResult.jsp";
	}  
	
	public String buyone(HttpServletRequest request, HttpServletResponse response, Page page) {
		int pid = Integer.parseInt(request.getParameter("pid"));
		int num = Integer.parseInt(request.getParameter("num"));
		
		Product p = productDAO.get(pid);
		User u  = (User) request.getSession().getAttribute("user");
		
		boolean found = false;
		int oiid =0;
		
		List<OrderItem> ois = orderItemDAO.listByUser(u.getId());
		for(OrderItem oi : ois) {
			if(oi.getProduct().getId() == p.getId()) {
				oi.setNumber(oi.getNumber() + num);
				orderItemDAO.update(oi);
				found = !found;
				oiid = oi.getId();
				break;
			}
		}
		
		if(!found) {
			OrderItem orderItem = new OrderItem();
			orderItem.setProduct(p);
			orderItem.setUser(u);
			orderItem.setNumber(num);
			orderItemDAO.add(orderItem);
			oiid=orderItem.getId();
			System.out.println("用户"+u.getName()+"生成一条订单项 id="+oiid);
		}
		return "@forebuy?oiid=" + oiid;
	}
	
	public String buy(HttpServletRequest request, HttpServletResponse response, Page page) {
		String[] oiids = request.getParameterValues("oiid");
		List<OrderItem> ois = new ArrayList<OrderItem>();
		float total = 0;
		
		for(String strid : oiids) {
			int oiid =  Integer.parseInt(strid);
			OrderItem oi = orderItemDAO.get(oiid);
			total += oi.getProduct().getPromotePrice()*oi.getNumber();
			ois.add(oi);
		}
		
		request.getSession().setAttribute("ois", ois);
		request.setAttribute("total", total);
		return "buy.jsp";
	}
	
	public String addCart(HttpServletRequest request, HttpServletResponse response, Page page) {
		int pid = Integer.parseInt(request.getParameter("pid"));
		int num = Integer.parseInt(request.getParameter("num"));
		
		Product p = productDAO.get(pid);
		User u = (User) request.getSession().getAttribute("user");
		
		boolean found = false;
		
		List<OrderItem> ois = orderItemDAO.listByUser(u.getId());
		
		for(OrderItem oi : ois) {
			if(oi.getProduct().getId() == pid) {
				oi.setNumber(oi.getNumber()+ num);
				orderItemDAO.update(oi);
				found = !found;
				break;
			}
		}
		
		if(!found) {
			OrderItem oi = new OrderItem();
			oi.setProduct(p);
			oi.setUser(u);
			oi.setNumber(num);
			orderItemDAO.add(oi);
			System.out.println("用户"+u.getName()+"生成一条订单项 id="+oi.getId());

		}
		
		return "%success";
	}
	
	public String cart(HttpServletRequest request, HttpServletResponse response, Page page) {
		
		User u = (User) request.getSession().getAttribute("user");
		if(null == u) {
			return "login.jsp";
		}
		
		List<OrderItem> ois = orderItemDAO.listByUser(u.getId());
		System.out.println("用户" + u.getName() + "对应订单项共" + ois.size() + "条");
		
		request.setAttribute("ois", ois);
		
		return "cart.jsp";
	}
	
	public String deleteOrderItem(HttpServletRequest request, HttpServletResponse response, Page page) {
		User u = (User) request.getSession().getAttribute("user");
		if(null == u) {
			return "%fail";
		}
		int oiid = Integer.parseInt(request.getParameter("oiid")); 
		orderItemDAO.delete(oiid);
		return "%success";
		
	}
	
	public String changeOrderItem(HttpServletRequest request, HttpServletResponse response, Page page) {
		User u = (User) request.getSession().getAttribute("user");
		if(null == u) {
			return "%fail";
		}
		
		int pid = Integer.parseInt(request.getParameter("pid"));
		int num = Integer.parseInt(request.getParameter("num"));
		
		List<OrderItem> ois = orderItemDAO.listByUser(u.getId());
		
		for(OrderItem oi : ois) {
			if(oi.getProduct().getId() == pid) {
				oi.setNumber(num);
				orderItemDAO.update(oi);
				break;
			}
		}
		
		return "%success";
		
	}
	
	public String createOrder(HttpServletRequest request, HttpServletResponse response, Page page) {
		User user = (User) request.getSession().getAttribute("user");
		List<OrderItem> ois = (List<OrderItem>) request.getSession().getAttribute("ois");
		
		if(null == ois) {
			return "@login.jsp";
		}
		
		String address = request.getParameter("address");
	    String post = request.getParameter("post");
	    String receiver = request.getParameter("receiver");
	    String mobile = request.getParameter("mobile");
	    String userMessage = request.getParameter("userMessage");
	    
	    Order order = new Order();
	    String orderCode = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date()) + RandomUtils.nextInt(10000);
	    
	    order.setOrderCode(orderCode);
	    order.setAddress(address);
	    order.setPost(post);
	    order.setReceiver(receiver);
	    order.setMobile(mobile);
	    order.setUserMessage(userMessage);
	    order.setCreateDate(new Date());
	    order.setUser(user);
	    order.setStatus(orderDAO.waitPay);
	    
	    orderDAO.add(order);
	    float total = 0;
	    for(OrderItem oi : ois) {
	    	oi.setOrder(order);
	    	orderItemDAO.update(oi);
	    	total += oi.getProduct().getPromotePrice()*oi.getNumber();
	    }
	    System.out.println("生成一条订单 id="+order.getId()+"  total="+total+" status=" + orderDAO.waitPay);
	    
	    return "@forealipay?oid=" + order.getId() + "&total=" + total;
		
	}
	
	public String alipay(HttpServletRequest request, HttpServletResponse response, Page page) {
		return "alipay.jsp";
	}
	
	public String payed(HttpServletRequest request, HttpServletResponse response, Page page) {
		int oid = Integer.parseInt(request.getParameter("oid"));
		Order order = orderDAO.get(oid);
		
		order.setStatus(orderDAO.waitDelivery);
		order.setPayDate(new Date());
		orderDAO.update(order);
		System.out.println("订单 id="+order.getId()+" status已改为"+orderDAO.waitDelivery);
		
		Calendar c = Calendar.getInstance();
		c.setTime(c.getTime());
		c.add(Calendar.DATE, 3);
		String preDate = new SimpleDateFormat("MM月dd日").format(c.getTime());
		
		request.setAttribute("order", order);
		request.setAttribute("date", preDate);
		
		
		return "payed.jsp";
	}
	
	public String bought(HttpServletRequest request, HttpServletResponse response, Page page) {
		User user = (User) request.getSession().getAttribute("user");
		
		List<Order> os = orderDAO.list(user.getId(), orderDAO.delete);
		
		orderItemDAO.fill(os);
		System.out.println("该用户" +user.getName() + "共有" + os.size() + "条订单");
		
		request.setAttribute("os", os);
		
		return "bought.jsp";
	}
	
	public String confirmPay(HttpServletRequest request, HttpServletResponse response, Page page) {
		int oid = Integer.parseInt(request.getParameter("oid"));
		
		Order o = orderDAO.get(oid);
		orderItemDAO.fill(o);
		
		request.setAttribute("o", o);
		
		return "confirmPay.jsp";
	}
	
	public String orderConfirmed(HttpServletRequest request, HttpServletResponse response, Page page) {
		int oid = Integer.parseInt(request.getParameter("oid"));
		
		Order o = orderDAO.get(oid);
		o.setStatus(orderDAO.waitReview);
		o.setConfirmDate(new Date());
		
		orderDAO.update(o);
		System.out.println("订单 id="+o.getId()+" status已改为"+orderDAO.waitReview);
		
		return "orderConfirmed.jsp";
	}
	
	public String deleteOrder(HttpServletRequest request, HttpServletResponse response, Page page) {
		User user = (User) request.getSession().getAttribute("user");
		if(null == user) {
			return "%fail";
		}
		int oid = Integer.parseInt(request.getParameter("oid"));
		Order o = orderDAO.get(oid);
		o.setStatus(orderDAO.delete);
		orderDAO.update(o);
		System.out.println("订单 id="+o.getId()+" status已改为"+orderDAO.delete);
		
		return "%success";
	}
	
	public String review(HttpServletRequest request, HttpServletResponse response, Page page) {
		int oid = Integer.parseInt(request.getParameter("oid"));
		Order o = orderDAO.get(oid);
		orderItemDAO.fill(o);
		
		Product p = o.getOrderItems().get(0).getProduct();
		List<Review> reviews = reviewDAO.list(p.getId());
		
		productDAO.setSaleAndReviewNumber(p);
		
		request.setAttribute("p", p);
		request.setAttribute("o", o);
		request.setAttribute("reviews", reviews);
		
		return "review.jsp";
	}
	
	public String doreview(HttpServletRequest request, HttpServletResponse response, Page page) {
		int oid = Integer.parseInt(request.getParameter("oid"));
		Order o = orderDAO.get(oid);
		o.setStatus(orderDAO.finish);
		orderDAO.update(o);
		System.out.println("订单 id="+o.getId()+" status已改为"+orderDAO.finish);
		
		int pid = Integer.parseInt(request.getParameter("pid"));
		Product p = productDAO.get(pid);
		
		String content = request.getParameter("content");
		
		content = HtmlUtils.htmlEscape(content);
		
		User user = (User) request.getSession().getAttribute("user");
		Review review = new Review();
		review.setContent(content);
		review.setProduct(p);
		review.setUser(user);
		review.setCreateDate(new Date());
		reviewDAO.add(review);
		
		return "@forereview?oid=" + oid + "&showonly=true";
		
	}
}
