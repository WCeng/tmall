package tmall.servlet;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import tmall.bean.Category;
import tmall.bean.Property;
import tmall.dao.CategoryDAO;
import tmall.dao.PropertyDAO;
import tmall.util.Page;

public class PropertyServlet extends BaseBackServlet{

	@Override
	public String add(HttpServletRequest request, HttpServletResponse response, Page page) {
		// TODO Auto-generated method stub
		
		int cid = Integer.parseInt(request.getParameter("cid"));
		String name = request.getParameter("name");
//		System.out.println(name);
		Category c = new CategoryDAO().get(cid);
		
		Property p = new Property();
		p.setCategory(c);
		p.setName(name);
		propertyDAO.add(p);
		
		return "@admin_property_list?cid=" + c.getId();
	}

	@Override
	public String delete(HttpServletRequest request, HttpServletResponse response, Page page) {
		// TODO Auto-generated method stub
		int id = Integer.parseInt(request.getParameter("id"));
		Property p = propertyDAO.get(id);
		int cid = p.getCategory().getId();
		
		propertyDAO.delete(id);
		return "@admin_property_list?cid=" + cid;
	}

	@Override
	public String edit(HttpServletRequest request, HttpServletResponse response, Page page) {
		// TODO Auto-generated method stub
		int id = Integer.parseInt(request.getParameter("id"));
		Property p = propertyDAO.get(id);
		String name = p.getName();
		request.setAttribute("p", p);
		
		return "admin/editProperty.jsp";
	}

	@Override
	public String update(HttpServletRequest request, HttpServletResponse response, Page page) {
		// TODO Auto-generated method stub
		int cid = Integer.parseInt(request.getParameter("cid"));
		int id = Integer.parseInt(request.getParameter("id"));
		String name = request.getParameter("name");
		
		Category c = new CategoryDAO().get(cid);
		
		Property p = new Property();
		p.setId(id);
		p.setName(name);
		p.setCategory(c);
		
		propertyDAO.update(p);
		return "@admin_property_list?cid=" + c.getId();
	}

	@Override
	public String list(HttpServletRequest request, HttpServletResponse response, Page page) {
		// TODO Auto-generated method stub
		int cid = Integer.parseInt(request.getParameter("cid"));
		Category c = new CategoryDAO().get(cid);
		
		page.setTotal(propertyDAO.getTotal(cid));
		page.setParam("&cid=" + c.getId());
		
		List<Property> ps = propertyDAO.list(cid, page.getStart(), page.getCount());
		
		request.setAttribute("c", c);
		request.setAttribute("page", page);
		request.setAttribute("ps", ps);
		return "admin/listProperty.jsp";
	}

}
