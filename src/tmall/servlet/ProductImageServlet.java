package tmall.servlet;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import tmall.bean.Product;
import tmall.bean.ProductImage;
import tmall.dao.ProductImageDAO;
import tmall.util.ImageUtil;
import tmall.util.Page;

public class ProductImageServlet extends BaseBackServlet{

	@Override
	public String add(HttpServletRequest request, HttpServletResponse response, Page page) {
		// TODO Auto-generated method stub
		
		Map<String, String> params = new HashMap<String, String>();
		InputStream is = super.parseUpload(request, params);
		
		String filePath = request.getParameter("filePath");
		String type = params.get("type");
		int pid = Integer.parseInt(params.get("pid")); 
		
		Product p = productDAO.get(pid);
		
		ProductImage pi = new ProductImage();
		pi.setType(type);
		pi.setProduct(p);
		productImageDAO.add(pi);
		
		String fileName = pi.getId()+".jpg";
		String imageFolder;
		String imageFolder_small = null;
		String imageFolder_middle = null;

		if(ProductImageDAO.type_single.equals(pi.getType())) {
			imageFolder = request.getSession().getServletContext().getRealPath("img/productSingle");
			imageFolder_small = request.getSession().getServletContext().getRealPath("img/productSingle_small");
			imageFolder_middle = request.getSession().getServletContext().getRealPath("img/productSingle_middle");
		}else {
			imageFolder= request.getSession().getServletContext().getRealPath("img/productDetail");
		}
		
		File file = new File(imageFolder, fileName);
		System.out.println(file.getAbsolutePath());
		file.getParentFile().mkdirs();
	    
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
	                
	                if(ProductImageDAO.type_single.equals(pi.getType())){
                        File f_small = new File(imageFolder_small, fileName);
                        File f_middle = new File(imageFolder_middle, fileName);
                        f_small.getParentFile().mkdirs();
                        f_middle.getParentFile().mkdirs();
 
                        ImageUtil.resizeImage(file, 56, 56, f_small);
                        ImageUtil.resizeImage(file, 217, 190, f_middle);
                    }
	    		}catch (Exception e) {
					// TODO: handle exception
	    			e.printStackTrace();
				}
	    	}
	    }catch (IOException e) {
			// TODO: handle exception
	    	e.printStackTrace();
		}
		
		return "@admin_productImage_list?pid=" + pid;
	}

	@Override
	public String delete(HttpServletRequest request, HttpServletResponse response, Page page) {
		// TODO Auto-generated method stub
		int id = Integer.parseInt(request.getParameter("id"));
		ProductImage pi = productImageDAO.get(id);
		productImageDAO.delete(id);
		
		if(pi.getType().equals(productImageDAO.type_single)) {
			String imageFolder_single= request.getSession().getServletContext().getRealPath("img/productSingle");
			String imageFolder_small = request.getSession().getServletContext().getRealPath("img/productSingle_small");
			String imageFolder_middle = request.getSession().getServletContext().getRealPath("img/productSingle_middle");
			
			File f_single = new File(imageFolder_single, pi.getId() + ".jpg");
			File f_small = new File(imageFolder_small, pi.getId() + ".jpg");
			File f_middle = new File(imageFolder_middle, pi.getId() + ".jpg");
			f_single.delete();
			f_small.delete();
			f_middle.delete();
			
		}else {
			String imageFolder = request.getSession().getServletContext().getRealPath("img/productDetail");
			File f = new File(imageFolder, pi.getId() + ".jpg");
			f.delete();
		}
		
		return "@admin_productImage_list?pid=" + pi.getProduct().getId();
	}

	@Override
	public String edit(HttpServletRequest request, HttpServletResponse response, Page page) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String update(HttpServletRequest request, HttpServletResponse response, Page page) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String list(HttpServletRequest request, HttpServletResponse response, Page page) {
		// TODO Auto-generated method stub
		int pid = Integer.parseInt(request.getParameter("pid"));
		Product p = productDAO.get(pid);
		List<ProductImage> piSingle = productImageDAO.list(p, ProductImageDAO.type_single);
		List<ProductImage> piDetail = productImageDAO.list(p, ProductImageDAO.type_detail);
		
		request.setAttribute("p", p);
		request.setAttribute("pisSingle", piSingle);
		request.setAttribute("pisDetail", piDetail);
		
		return "admin/listProductImage.jsp";
	}

}
