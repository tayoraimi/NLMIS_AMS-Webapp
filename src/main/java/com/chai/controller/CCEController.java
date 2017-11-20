package com.chai.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.chai.model.LabelValueBean;
import com.chai.model.CCEBeanForCCEForm;
import com.chai.model.views.AdmUserV;
import com.chai.services.CCEService;

@Controller
public class CCEController {
	JSONArray data;
	CCEService cceService=new CCEService();
	@RequestMapping(value = "/ccepage", method = RequestMethod.GET)
	 public ModelAndView getForm(HttpServletRequest request,HttpServletResponse response,
			 @ModelAttribute("beanForCCE")CCEBeanForCCEForm bean) throws IOException {
			ModelAndView modelAndView = new ModelAndView();
			try {
				System.out.println("in CCEController action ccepage");
				HttpSession session=request.getSession();
				AdmUserV userBean=(AdmUserV)session.getAttribute("userBean");
				modelAndView.setViewName("CCEPage");
				modelAndView.addObject("userBean",userBean);
//				modelAndView.addObject("bean",bean);
				System.out.println("name............"+userBean.getX_WAREHOUSE_NAME());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				response.sendRedirect("loginPage");
			}
			return modelAndView;
	}
	
	@RequestMapping(value = "/getccelist")
	public JSONArray getJsonCCEList(HttpServletRequest request, HttpServletResponse respones) throws IOException {
		System.out.println("list data");
		PrintWriter out = respones.getWriter();
		try{
			AdmUserV userBean=(AdmUserV)request.getSession().getAttribute("userBean");
		 data=cceService.getCCEListPageData(userBean);
			// System.out.println("json ======"+data.toString());
			out.write(data.toString());

		} catch (NullPointerException | org.hibernate.exception.JDBCConnectionException e) {
			out.write(data.toString());
			e.printStackTrace();
		} finally {
			out.close();
		}

		return null;
		
	}
	
        @RequestMapping(value = "/get_cce_detail")
	public JSONArray getDetailOfCCE(HttpServletRequest request,HttpServletResponse respones,
			@RequestParam("model") String model){
		System.out.println("model"+model);
		try{
			data=cceService.getCCEDetail(model);
//			 System.out.println("json ======"+data.toString());
		
			PrintWriter out=respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
		
	}
        
	@RequestMapping(value = "/search_cce_list")
	public JSONArray getSearchCCEList(HttpServletRequest request,HttpServletResponse respones,
			@RequestParam("userTypeId") String userTypeId,
			@RequestParam("roleId") String roleId,
			@RequestParam("warehouseId") String warehouseId){
		System.out.println("user Type id"+userTypeId);
		System.out.println("roleId"+roleId);
		System.out.println("warehouseId"+warehouseId);
		try{
			AdmUserV userBean=(AdmUserV)request.getSession().getAttribute("userBean");
			data=cceService.getSearchCCEListPageData(userTypeId,roleId,warehouseId,userBean);
			// System.out.println("json ======"+data.toString());
		
			PrintWriter out=respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
		
	}
	
	@RequestMapping(value = "/save_addedit_cce")
	public void saveAddEditCCE(@ModelAttribute("beanForCCE")CCEBeanForCCEForm bean,
			HttpServletRequest request,HttpServletResponse respones){
		AdmUserV userBean=(AdmUserV)request.getSession().getAttribute("userBean");
		System.out.println("in CCEController.saveAddEditCCE()");
		String action=request.getParameter("action");
		System.out.println("aciton------"+action);
		int insertUpdateCCEFlag = 0;
		try {
			if(action.equals("add")){
				insertUpdateCCEFlag = cceService.saveCCEAddEdit(bean, action, userBean);
			}else{
//				String cceDataId=request.getParameter("cceId");
//				System.out.println("edit record of cce data"+cceDataId);
//				bean.setX_CCE_DATA_ID(cceDataId);
				insertUpdateCCEFlag = cceService.saveCCEAddEdit(bean, action, userBean);
			}
			System.out.println("\ninsertUpdateCCEFlag " + insertUpdateCCEFlag);
			PrintWriter out = respones.getWriter();
			if (insertUpdateCCEFlag == 1) {
				out.write("succsess");
			}else{
				out.write("fail");
			}
			out.close();
		} catch (Exception e) {
			// TODO: handle exception
		}
	}
		@RequestMapping(value = "/cce_list_export")
	public ModelAndView getCCEListExport(HttpServletRequest request,HttpServletResponse respones){
		System.out.println("in CCEController.getCCEListExport()");
		ModelAndView model=new ModelAndView("CommonExelGenerator");
		ArrayList<LabelValueBean> headerOfTableList=new ArrayList<>();
		headerOfTableList.add(new LabelValueBean("LGA", "LGA"));
		headerOfTableList.add(new LabelValueBean("WARD", "WARD"));
		headerOfTableList.add(new LabelValueBean("LOCATION", "LOCATION"));
		headerOfTableList.add(new LabelValueBean("FACILITY_NAME", "FACILITY NAME"));
		headerOfTableList.add(new LabelValueBean("DESIGNATION", "DESIGNATION"));
		headerOfTableList.add(new LabelValueBean("MAKE", "MAKE"));
		headerOfTableList.add(new LabelValueBean("MODEL", "MODEL"));
		headerOfTableList.add(new LabelValueBean("DEVICE_SERIAL_NO", "DEVICE SERIAL NO"));
		headerOfTableList.add(new LabelValueBean("VOL_NEG", "VOL -"));
		headerOfTableList.add(new LabelValueBean("VOL_POS", "VOL +"));
		headerOfTableList.add(new LabelValueBean("SUMMARY", "SUMMARY"));
		headerOfTableList.add(new LabelValueBean("DATE_NF", "DATE NOT FUNCTIONAL"));
		headerOfTableList.add(new LabelValueBean("YEAR_OF_ACQUISITION", "YEAR  OF ACQUISITION"));
		headerOfTableList.add(new LabelValueBean("SOURCE_OF_CCE", "SOURCE OF CCE"));
		try{
			model.addObject("export_data",data);
			model.addObject("headerOfTable", headerOfTableList);
		} catch (NullPointerException e) {
			e.printStackTrace();
		}
		return model;
	}
	
}
