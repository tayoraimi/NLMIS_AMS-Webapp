/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.chai.controller;

import com.chai.model.CCEBeanForCCEForm;
import com.chai.model.REBeanForREForm;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.chai.model.views.AdmUserV;
import com.chai.services.CCEService;
import com.chai.services.REService;
import java.io.PrintWriter;
import org.json.JSONArray;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;

/**
 *
 * @author Ayobami Akinyinka
 */
@Controller
public class REPageController {

    public REPageController() {
    }

    JSONArray data;
    REService reService = new REService();

    @RequestMapping(value = "/repage", method = RequestMethod.GET)
    public ModelAndView getForm(HttpServletRequest request, HttpServletResponse response,
            @ModelAttribute("beanForRE") REBeanForREForm bean) throws IOException {
        ModelAndView modelAndView = new ModelAndView();
        try {
            System.out.println("in REController action repage");
            HttpSession session = request.getSession();
            AdmUserV userBean = (AdmUserV) session.getAttribute("userBean");
            modelAndView.setViewName("REPage");
            modelAndView.addObject("userBean", userBean);
//				List<AdmUserV> list=cceService.getCCEListPageData();
//				System.out.println("user list sizse"+list.size());
//				modelAndView.addObject("userListtableData",list);
            System.out.println("name............" + userBean.getX_WAREHOUSE_NAME());
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            response.sendRedirect("loginPage");
        }
        return modelAndView;
    }

    @RequestMapping(value = "/getrelist")
    public JSONArray getJsonCCEList(HttpServletRequest request, HttpServletResponse respones) throws IOException {
        System.out.println("list data");
        PrintWriter out = respones.getWriter();
        try {
            AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
            data = reService.getREListPageData(userBean);
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

    /*@RequestMapping(value = "/search_cce_listt")
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
		
	}*/
//	@RequestMapping(value = "/get_history_user")
//	public void getHistoryOfUser(HttpServletRequest request,HttpServletResponse respones,
//			@RequestParam("user_id") String user_id){
//		System.out.println("in CCEController.getHistoryOfCCE()");
//		try {
//			PrintWriter out = respones.getWriter();
//			JSONArray historyOfCCE=cceService.getCCEHistory(user_id);
//			// System.out.println("history of user
//			// json"+historyOfCCE.toString());
//			out.write(historyOfCCE.toString());
//			out.close();
//		} catch (IOException e) {
//			e.printStackTrace();
//		}
//	}
//	@RequestMapping(value = "/change_user_password")
//	public void changeUserPassword(HttpServletRequest request,HttpServletResponse respones,
//			@RequestParam("user_id") String user_id,
//			@RequestParam("newPassword") String newPassword,
//			@RequestParam("oldPassword") String oldPassword){
//		System.out.println("in CCEController.changeCCEPassword()");
//		try {
//			PrintWriter out = respones.getWriter();
//			int result=cceService.passwordChange(user_id,newPassword,oldPassword);
//			if(result==1){
//				out.write("succsess");
//			}else{
//				out.write("fail");
//			}
//			out.close();
//		} catch (IOException e) {
//			e.printStackTrace();
//		}
//	}
    @RequestMapping(value = "/save_addedit_re")
    public void saveAddEditRE(@ModelAttribute("beanForRE") REBeanForREForm bean,
            HttpServletRequest request, HttpServletResponse respones) {
        AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
        System.out.println("in REController.saveAddEditCCE()");
        String action = request.getParameter("action");
        System.out.println("aciton------" + action);

        int insertUpdateREFlag = 0;
        try {
            if (action.equals("add")) {
                //
                bean.setX_GENERATOR_LOCATION_HAS_ELECTRICITY(request.getParameter("x11"));
                bean.setX_GENERATOR_PLANNED_REPAIRS(request.getParameter("x22"));
                bean.setX_GENERATOR_FUEL_AVAILABLE(request.getParameter("x33"));
                bean.setX_GENERATOR_PPM(request.getParameter("x44"));
                if(request.getParameter("x111").equals("")){
                    bean.setX_GENERATOR_ELECTRICITY_HRS("0");
                }else{
                bean.setX_GENERATOR_ELECTRICITY_HRS(request.getParameter("x111"));
                }
               // System.out.println("bean.getX_GENERATOR_LOCATION_HAS_ELECTRICITY " + bean.getX_GENERATOR_LOCATION_HAS_ELECTRICITY());
              //  System.out.println("bean.getX_GENERATOR_PLANNED_REPAIRS() " + bean.getX_GENERATOR_PLANNED_REPAIRS());
              //  System.out.println("bean.getX_GENERATOR_FUEL_AVAILABLE() " + bean.getX_GENERATOR_FUEL_AVAILABLE());
              //  System.out.println("bean.getX_GENERATOR_PPM() " + bean.getX_GENERATOR_PPM());

                //
                insertUpdateREFlag = reService.saveREAddEdit(bean, action, userBean);
            } else {
                String reId = request.getParameter("reId");
                System.out.println("edit record of gen data" + reId);
                bean.setX_GEN_DATA_ID(reId);
                insertUpdateREFlag = reService.saveREAddEdit(bean, action, userBean);
            }
            System.out.println("\ninsertUpdateCCEFlag " + insertUpdateREFlag);
            PrintWriter out = respones.getWriter();
            if (insertUpdateREFlag == 1) {
                out.write("success");
            } else {
                out.write("fail");
            }
            out.close();
        } catch (Exception e) {
            // TODO: handle exception
        }
    }
}
