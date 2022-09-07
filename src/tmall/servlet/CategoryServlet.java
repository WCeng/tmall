package tmall.servlet;

import java.awt.image.BufferedImage;
import java.awt.image.PackedColorModel;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.print.attribute.PrintJobAttribute;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import tmall.bean.Category;
import tmall.bean.User;
import tmall.dao.CategoryDAO;
import tmall.dao.UserDAO;
import tmall.util.ImageUtil;
import tmall.util.Page;

public class CategoryServlet extends BaseBackServlet{

	@Override
	public String add(HttpServletRequest request, HttpServletResponse response, Page page) {
		// TODO Auto-generated method stub
		Map<String, String> params = new HashMap<>();
		InputStream is = super.parseUpload(request, params);
		
		String name = params.get("name");
		Category c = new Category();
		c.setName(name);
		new CategoryDAO().add(c);
		
		File  imageFolder= new File(request.getSession().getServletContext().getRealPath("img/category"));
	    File file = new File(imageFolder,c.getId()+".jpg");
	    
	    try {
	    	if(null!=is && 0!=is.available()) {
	    		try(FileOutputStream fos = new FileOutputStream(file)){
	    			byte b[] = new byte[1024*1024];
	    			int length = 0;
	    			while(-1 != (length = is.read(b))) {
	    				fos.write(b, 0, length);
	    			}
	    			fos.flush();
	    			
	    			//通过如下代码，把文件保存为jpg格式
	                BufferedImage img = ImageUtil.change2jpg(file);
	                ImageIO.write(img, "jpg", file);
	    		}catch (Exception e) {
					// TODO: handle exception
	    			e.printStackTrace();
				}
	    	}
	    }catch (IOException e) {
			// TODO: handle exception
	    	e.printStackTrace();
		}
		return "@admin_category_list";
	}

	@Override
	public String delete(HttpServletRequest request, HttpServletResponse response, Page page) {
		// TODO Auto-generated method stub
		int id = Integer.parseInt(request.getParameter("id"));
		new CategoryDAO().delete(id);
		
		return "@admin_category_list";
	}

	@Override
	public String edit(HttpServletRequest request, HttpServletResponse response, Page page) {
		// TODO Auto-generated method stub
		int id = Integer.parseInt(request.getParameter("id"));
		Category c = new CategoryDAO().get(id);
		request.setAttribute("c", c);
		
		return "admin/editCategory.jsp";
	}

	@Override
	public String update(HttpServletRequest request, HttpServletResponse response, Page page) {
		// TODO Auto-generated method stub
		Map<String, String> params = new HashMap<String, String>();
		InputStream is = super.parseUpload(request, params);
		System.out.println(params);
		
		int id = Integer.parseInt(params.get("id"));
		String name = (String)params.get("name");
		Category c = new Category();
		c.setId(id);
		c.setName(name);
		new CategoryDAO().update(c);
		
		File  imageFolder= new File(request.getSession().getServletContext().getRealPath("img/category"));
	    File file = new File(imageFolder,c.getId()+".jpg");
	    System.out.println(imageFolder);
	    
	    try {
	    	if(null!=is && 0!=is.available()) {
	    		try(FileOutputStream fos = new FileOutputStream(file)){
	    			byte b[] = new byte[1024*1024];
	    			int length = 0;
	    			while(-1 != (length = is.read(b))) {
	    				fos.write(b, 0, length);
	    			}
	    			fos.flush();
	    			
	    			//通过如下代码，把文件保存为jpg格式
	                BufferedImage img = ImageUtil.change2jpg(file);
	                ImageIO.write(img, "jpg", file);
	    		}catch (Exception e) {
					// TODO: handle exception
	    			e.printStackTrace();
				}
	    	}
	    }catch (IOException e) {
			// TODO: handle exception
	    	e.printStackTrace();
		}
		
		return "@admin_category_list";
	}

	@Override
	public String list(HttpServletRequest request, HttpServletResponse response, Page page) {
		// TODO Auto-generated method stub
		User user = (User) request.getSession().getAttribute("user");
		if(null == user) {
			return "login.jsp";
		}
		String name= user.getName();
		
		if(name.equals("root")) {
			
			List<Category> cs = new CategoryDAO().list(page.getStart(), page.getCount());
			int total = new CategoryDAO().getTotal();
			System.out.println("category-total: "+total);
			page.setTotal(total);
			
			request.setAttribute("thecs", cs);
			request.setAttribute("page", page);
			
			return "admin/listCategory.jsp";
		}else {
			System.out.println("用户" + name + "正试图访问后台管理 已拦截");
			return "%该账号无权限访问后台管理";
		}
	}
	
	
}
