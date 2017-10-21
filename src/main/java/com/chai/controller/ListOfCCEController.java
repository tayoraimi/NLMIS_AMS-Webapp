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
import com.chai.model.ListOfCCEBeanForListOfCCEForm;
import com.chai.model.views.AdmUserV;
import com.chai.services.ListOfCCEService;

@Controller
public class ListOfCCEController {
	JSONArray data;
	ListOfCCEService listOfCCEService=new ListOfCCEService();
	@RequestMapping(value = "/listOfCCEPage", method = RequestMethod.GET)
	 public ModelAndView getForm(HttpServletRequest request,HttpServletResponse response,
			 @ModelAttribute("beanForListOfCCE")ListOfCCEBeanForListOfCCEForm bean) throws IOException {
			ModelAndView modelAndView = new ModelAndView();
			try {
				System.out.println("in ListOfCCEController action listOfCCEPage");
				HttpSession session=request.getSession();
				AdmUserV userBean=(AdmUserV)session.getAttribute("userBean");
				modelAndView.setViewName("ListOfCCEPage");
				modelAndView.addObject("userBean",userBean);
//				List<AdmUserV> list=listOfCCEService.getListOfCCEListPageData();
//				System.out.println("user list sizse"+list.size());
//				modelAndView.addObject("userListtableData",list);
				System.out.println("name............"+userBean.getX_WAREHOUSE_NAME());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				response.sendRedirect("loginPage");
			}
			return modelAndView;
	}
	
	@RequestMapping(value = "/getlistOfCCElist")
	public JSONArray getJsonListOfCCEList(HttpServletRequest request, HttpServletResponse respones) throws IOException {
		System.out.println("list data");
		PrintWriter out = respones.getWriter();
		try{
			AdmUserV userBean=(AdmUserV)request.getSession().getAttribute("userBean");
		 data=listOfCCEService.getListOfCCEListPageData(userBean);
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
	
	@RequestMapping(value = "/search_listOfCCE_list")
	public JSONArray getSearchListOfCCEList(HttpServletRequest request,HttpServletResponse respones,
			@RequestParam("userTypeId") String userTypeId,
			@RequestParam("roleId") String roleId,
			@RequestParam("warehouseId") String warehouseId){
		System.out.println("user Type id"+userTypeId);
		System.out.println("roleId"+roleId);
		System.out.println("warehouseId"+warehouseId);
		try{
			AdmUserV userBean=(AdmUserV)request.getSession().getAttribute("userBean");
//			data=listOfCCEService.getSearchListOfCCEListPageData(userTypeId,roleId,warehouseId,userBean);
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
//	
	@RequestMapping(value = "/save_addedit_listOfCCE")
	public void saveAddEditListOfCCE(@ModelAttribute("beanForListOfCCE")ListOfCCEBeanForListOfCCEForm bean,
			HttpServletRequest request,HttpServletResponse respones){
		AdmUserV userBean=(AdmUserV)request.getSession().getAttribute("userBean");
		System.out.println("in ListOfCCEController.saveAddEditListOfCCE()");
		String action=request.getParameter("action");
		System.err.println("aciton------"+action);
		int insertUpdateListOfCCEFlag = 0;
		try {
			if(action.equals("add")){
				insertUpdateListOfCCEFlag = listOfCCEService.saveListOfCCEAddEdit(bean, action, userBean);
//                                insertUpdateListOfCCEFlag = 1;
			}else{
				String listOfCCEId=request.getParameter("listOfCCEId");
				System.out.println("edit record of user"+listOfCCEId);
				bean.setX_ListOfCCE_CCE_ID(listOfCCEId);
				insertUpdateListOfCCEFlag = listOfCCEService.saveListOfCCEAddEdit(bean, action, userBean);
			}
			System.out.println("\ninsertUpdateListOfCCEFlag " + insertUpdateListOfCCEFlag);
			PrintWriter out = respones.getWriter();
			if (insertUpdateListOfCCEFlag == 1) {
				out.write("succsess");
			}else{
				out.write("fail");
			}
			out.close();
		} catch (Exception e) {
			// TODO: handle exception
		}
	}
		
	
}
