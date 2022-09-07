package tmall.servlet;

import java.util.Date;
import java.util.List;

import javax.print.attribute.standard.ReferenceUriSchemesSupported;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import tmall.bean.Category;
import tmall.bean.Product;
import tmall.bean.Property;
import tmall.bean.PropertyValue;
import tmall.dao.CategoryDAO;
import tmall.util.Page;

public class ProductServlet extends BaseBackServlet{

	@Override
	public String add(HttpServletRequest request, HttpServletResponse response, Page page) {
		// TODO Auto-generated method stub
		int cid = Integer.parseInt(request.getParameter("cid"));
		Category c = new CategoryDAO().get(cid);
		
		String name = request.getParameter("name");
		String subTitle = request.getParameter("subTitle");
		float orignalPrice = Float.parseFloat(request.getParameter("orignalPrice"));
		float promotePrice = Float.parseFloat(request.getParameter("promotePrice"));
		int stock = Integer.parseInt(request.getParameter("stock"));
		
		Product p = new Product();
		p.setName(name);
		p.setSubTitle(subTitle);
		p.setOrignalPrice(orignalPrice);
		p.setPromotePrice(promotePrice);
		p.setStock(stock);
		p.setCategory(c);
		p.setCreateDate(new Date());
		
		productDAO.add(p);
		
		return "@admin_product_list?cid=" + cid;
	}

	@Override
	public String delete(HttpServletRequest request, HttpServletResponse response, Page page) {
		// TODO Auto-generated method stub
		int id = Integer.parseInt(request.getParameter("id"));
		Product p = productDAO.get(id);
		
		productDAO.delete(id);
		return "@admin_product_list?cid=" + p.getCategory().getId();
	}

	@Override
	public String edit(HttpServletRequest request, HttpServletResponse response, Page page) {
		// TODO Auto-generated method stub
		int id = Integer.parseInt(request.getParameter("id"));
		Product p = productDAO.get(id);
		
		request.setAttribute("p", p);
		
		return "admin/editProduct.jsp";
	}

	@Override
	public String update(HttpServletRequest request, HttpServletResponse response, Page page) {
		// TODO Auto-generated method stub
		int id = Integer.parseInt(request.getParameter("id"));
		int cid = Integer.parseInt(request.getParameter("cid"));
		Category c = new CategoryDAO().get(cid);
		
		String name = request.getParameter("name");
		String subTitle = request.getParameter("subTitle");
		float orignalPrice = Float.parseFloat(request.getParameter("orignalPrice"));
		float promotePrice = Float.parseFloat(request.getParameter("promotePrice"));
		int stock = Integer.parseInt(request.getParameter("stock"));
		
		Product p = new  Product();
		p.setId(id);
		p.setName(name);
		p.setSubTitle(subTitle);
		p.setOrignalPrice(orignalPrice);
		p.setPromotePrice(promotePrice);
		p.setStock(stock);
		p.setCategory(c);
		
		productDAO.update(p);
		
		return "@admin_product_list?cid=" + cid;
	}
	
	public String editPropertyValue(HttpServletRequest request, HttpServletResponse response, Page page) {
		int pid = Integer.parseInt(request.getParameter("id"));
		Product p = productDAO.get(pid);
		
		List<Property> pts = propertyDAO.list(p.getCategory().getId());		
		
		propertyValueDAO.init(p);
		
		List<PropertyValue> pvs = propertyValueDAO.list(p.getId());
		
		request.setAttribute("p", p);
		request.setAttribute("pvs", pvs);
		
		return "admin/editProductValue.jsp";
	}
	
	public String updatePropertyValue(HttpServletRequest request, HttpServletResponse response, Page page) {
		int pvid = Integer.parseInt(request.getParameter("pvid"));
		String value = request.getParameter("value");
		
		PropertyValue pv = propertyValueDAO.get(pvid);
		pv.setValue(value);
		propertyValueDAO.update(pv);
		
		return "%success";
	}

	@Override
	public String list(HttpServletRequest request, HttpServletResponse response, Page page) {
		// TODO Auto-generated method stub
		int cid = Integer.parseInt(request.getParameter("cid"));
		Category c = new CategoryDAO().get(cid);
		
		List<Product> ps = productDAO.list(cid, page.getStart(), page.getCount());
		
		int total = productDAO.getTotal(cid);
		page.setTotal(total);
		page.setParam("&cid="+c.getId());
		
		request.setAttribute("ps", ps);
		request.setAttribute("c", c);
		request.setAttribute("page", page);
		return "admin/listProduct.jsp";
	}

}
