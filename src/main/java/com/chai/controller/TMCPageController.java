/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.chai.controller;

import com.chai.model.CCEBeanForCCEForm;
import com.chai.model.TMCBeanForTMCForm;
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
import com.chai.services.TMCService;
import java.io.PrintWriter;
import org.json.JSONArray;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;

/**
 *
 * @author S3-Developer
 */
@Controller
public class TMCPageController {

    public TMCPageController() {
    }

    JSONArray data;
    TMCService tmcService = new TMCService();

    @RequestMapping(value = "/tmcpage", method = RequestMethod.GET)
    public ModelAndView getForm(HttpServletRequest request, HttpServletResponse response,
            @ModelAttribute("beanForTMC") TMCBeanForTMCForm bean) throws IOException {
        ModelAndView modelAndView = new ModelAndView();
        try {
            System.out.println("in TMCController action tmcpage");
            HttpSession session = request.getSession();
            AdmUserV userBean = (AdmUserV) session.getAttribute("userBean");
            modelAndView.setViewName("TMCPage");
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

    @RequestMapping(value = "/gettmclist")
    public JSONArray getJsonTMCList(HttpServletRequest request, HttpServletResponse respones) throws IOException {
        System.out.println("list data");
        PrintWriter out = respones.getWriter();
        try {
            AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
            data = tmcService.getTMCListPageData(userBean);
            // System.out.println("json ======"+data.toString());
            System.out.println("list data");
            out.write(data.toString());

        } catch (NullPointerException | org.hibernate.exception.JDBCConnectionException e) {
            System.out.println("error!");
            out.write(data.toString());
            e.printStackTrace();
        } finally {
            out.close();
        }

        return null;

    }
/*
    @RequestMapping(value = "/search_cce_listtt")
    public JSONArray getSearchCCEList(HttpServletRequest request, HttpServletResponse respones,
            @RequestParam("userTypeId") String userTypeId,
            @RequestParam("roleId") String roleId,
            @RequestParam("warehouseId") String warehouseId) {
        System.out.println("user Type id" + userTypeId);
        System.out.println("roleId" + roleId);
        System.out.println("warehouseId" + warehouseId);
        try {
            AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
            data = cceService.getSearchCCEListPageData(userTypeId, roleId, warehouseId, userBean);
            // System.out.println("json ======"+data.toString());

            PrintWriter out = respones.getWriter();
            out.write(data.toString());
            out.close();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return null;

    }
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
*/

    @RequestMapping(value = "/save_addedit_tmc")
    public void saveAddEditTMC(@ModelAttribute("beanForTMC") TMCBeanForTMCForm bean,
            HttpServletRequest request, HttpServletResponse respones) {
        AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
        System.out.println("in TMCController.saveAddEditTMC()");
        String action = request.getParameter("action");
        System.out.println("action------" + action);
        
        System.out.println("edit record of category: " + bean.getX_TMC_STATE_ID());
        System.out.println("edit record of category: " + bean.getX_TMC_LGA_ID());
        
        System.out.println("FACILITY ID: " + bean.getX_TMC_FACILITY_ID());
        System.out.println("FACILITY ID: " + bean.getX_TMC_DEVICE_LOCATION());
        System.out.println("FACILITY ID: " + bean.getX_TMC_LOCATION_HAS_ELECTRICITY());
        System.out.println("FACILITY ID: " + bean.getX_TMC_HOURS_OF_ELECTRICITY());
        System.out.println("FACILITY ID: " + bean.getX_TMC_TEMPERATURE_MONITORING_DEVICE_AVAILABLE());
        System.out.println("FACILITY ID: " + bean.getX_TMC_TYPE_OF_DEVICE());
       
       int insertUpdateTMCFlag = 0;
        try {
            if (action.equals("add")) {
                insertUpdateTMCFlag = tmcService.saveTMCAddEdit(bean, action, userBean);
            } else {
                String tmcId = request.getParameter("tmcId");
                System.out.println("edit record of category: " + tmcId);
                bean.setX_TMC_DATA_ID(tmcId);
                insertUpdateTMCFlag = tmcService.saveTMCAddEdit(bean, action, userBean);
            }
            System.out.println("\ninsertUpdateTMCFlag " + insertUpdateTMCFlag);
            PrintWriter out = respones.getWriter();
            if (insertUpdateTMCFlag == 1) {
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
