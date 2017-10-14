/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.chai.controller;

import com.chai.model.LabelValueBean;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.chai.model.views.AdmUserV;
import com.chai.services.AMSChartServices;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.util.LinkedList;
import java.util.List;
import org.json.JSONArray;
import org.springframework.web.bind.annotation.RequestParam;

/**
 *
 * @author Ayobami Akinyinka
 */
@Controller
public class FunctionalPISController {

    List<LabelValueBean> functionalHeaderList = new LinkedList<LabelValueBean>();
    JSONArray griddata = new JSONArray();
    private DecimalFormat df = new DecimalFormat("#.##");
    String sclevel = "LGA";

    @RequestMapping(value = "/functionalpis", method = RequestMethod.GET)
    public ModelAndView showFunctionChart(HttpServletRequest request, HttpServletResponse respones) {
        ModelAndView modelAndView = new ModelAndView("Functionalpis");
        try {
            HttpSession session = request.getSession();
            AdmUserV userBean = (AdmUserV) session.getAttribute("userBean");
            String login_time = (String) session.getAttribute("login_time");
            modelAndView.addObject("userdata", userBean);
            modelAndView.addObject("login_time", login_time);
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            try {
                respones.sendRedirect("loginPage");
            } catch (IOException e1) {
                // TODO Auto-generated catch block
                e1.printStackTrace();
            }
        }
        return modelAndView;
    }

    @RequestMapping(value = "/get_functional_pis_data")
    public JSONArray getFunctionalChartData(HttpServletRequest request, HttpServletResponse respones, @RequestParam("filterLevel") String filterLevel) {
        JSONArray arrayforjsp = new JSONArray();
        sclevel = filterLevel;
//		System.out.println("in FunctionalDashController.FunctionalDashController()");
//		System.out.println("facId :" + facId);
        System.out.println("filterLevel X:" + sclevel);
//		System.out.println("week :" + week);
        try {
            sclevel = (sclevel == null || sclevel.equals("")) ? "LGA" : sclevel.toUpperCase();
            JSONArray data;
            AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
            data = new AMSChartServices().getFunctionalPISData(userBean, sclevel);

            System.out.println("get_functional_chart_data jsonforjsp ======" + data.toString());
            PrintWriter out = respones.getWriter();
            out.write(data.toString());
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    @RequestMapping(value = "/get_functional_domestic_equipment_data")
    public JSONArray getFunctionalDomesticEquipmentData(HttpServletRequest request, HttpServletResponse respones, @RequestParam("filterLevel") String filterLevel) {
        JSONArray arrayforjsp = new JSONArray();
        sclevel = filterLevel;
//		System.out.println("in FunctionalDashController.FunctionalDashController()");
//		System.out.println("facId :" + facId);
        System.out.println("filterLevel X:" + sclevel);
//		System.out.println("week :" + week);
        try {
            sclevel = (sclevel == null || sclevel.equals("")) ? "LGA" : sclevel.toUpperCase();
            JSONArray data;
            AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
            
            //Line to change
            data = new AMSChartServices().getFunctionalPISData(userBean, sclevel);

            System.out.println("get_functional_domestic_equipment_data jsonforjsp ======" + data.toString());
            PrintWriter out = respones.getWriter();
            out.write(data.toString());
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    @RequestMapping(value = "/get_functional_pis_refrigerator_data")
    public JSONArray getFunctionalPISRefrigeratorData(HttpServletRequest request, HttpServletResponse respones, @RequestParam("filterLevel") String filterLevel) {
        JSONArray arrayforjsp = new JSONArray();
        sclevel = filterLevel;
//		System.out.println("in FunctionalDashController.FunctionalDashController()");
//		System.out.println("facId :" + facId);
        System.out.println("filterLevel X:" + sclevel);
//		System.out.println("week :" + week);
        try {
            sclevel = (sclevel == null || sclevel.equals("")) ? "LGA" : sclevel.toUpperCase();
            JSONArray data;
            AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
            
            //Line to change
            data = new AMSChartServices().getFunctionalPISData(userBean, sclevel);

            System.out.println("get_functional_pis_refrigerator jsonforjsp ======" + data.toString());
            PrintWriter out = respones.getWriter();
            out.write(data.toString());
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    @RequestMapping(value = "/get_functional_domestic_refrigerator_data")
    public JSONArray getFunctionalDomesticRefrigeratorData(HttpServletRequest request, HttpServletResponse respones, @RequestParam("filterLevel") String filterLevel) {
        JSONArray arrayforjsp = new JSONArray();
        sclevel = filterLevel;
//		System.out.println("in FunctionalDashController.FunctionalDashController()");
//		System.out.println("facId :" + facId);
        System.out.println("filterLevel X:" + sclevel);
//		System.out.println("week :" + week);
        try {
            sclevel = (sclevel == null || sclevel.equals("")) ? "LGA" : sclevel.toUpperCase();
            JSONArray data;
            AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
            
            //Line to change
            data = new AMSChartServices().getFunctionalPISData(userBean, sclevel);

            System.out.println("get_functional_domestic_refrigerator_data jsonforjsp ======" + data.toString());
            PrintWriter out = respones.getWriter();
            out.write(data.toString());
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    @RequestMapping(value = "/get_functional_pis_freezer_data")
    public JSONArray getFunctionalPISFreezerData(HttpServletRequest request, HttpServletResponse respones, @RequestParam("filterLevel") String filterLevel) {
        JSONArray arrayforjsp = new JSONArray();
        sclevel = filterLevel;
//		System.out.println("in FunctionalDashController.FunctionalDashController()");
//		System.out.println("facId :" + facId);
        System.out.println("filterLevel X:" + sclevel);
//		System.out.println("week :" + week);
        try {
            sclevel = (sclevel == null || sclevel.equals("")) ? "LGA" : sclevel.toUpperCase();
            JSONArray data;
            AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
            
            //Line to change
            data = new AMSChartServices().getFunctionalPISData(userBean, sclevel);

            System.out.println("get_functional_pis_freezer_data jsonforjsp ======" + data.toString());
            PrintWriter out = respones.getWriter();
            out.write(data.toString());
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    @RequestMapping(value = "/get_functional_domestic_freezer_data")
    public JSONArray getFunctionalDomesticFreezerData(HttpServletRequest request, HttpServletResponse respones, @RequestParam("filterLevel") String filterLevel) {
        JSONArray arrayforjsp = new JSONArray();
        sclevel = filterLevel;
//		System.out.println("in FunctionalDashController.FunctionalDashController()");
//		System.out.println("facId :" + facId);
        System.out.println("filterLevel X:" + sclevel);
//		System.out.println("week :" + week);
        try {
            sclevel = (sclevel == null || sclevel.equals("")) ? "LGA" : sclevel.toUpperCase();
            JSONArray data;
            AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
            
            //Line to change
            data = new AMSChartServices().getFunctionalPISData(userBean, sclevel);

            System.out.println("get_functional_domestic_freezer_data jsonforjsp ======" + data.toString());
            PrintWriter out = respones.getWriter();
            out.write(data.toString());
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    @RequestMapping(value = "/get_functional_pis_solar_refrigerator_data")
    public JSONArray getFunctionalPISSolarRefrigeratorData(HttpServletRequest request, HttpServletResponse respones, @RequestParam("filterLevel") String filterLevel) {
        JSONArray arrayforjsp = new JSONArray();
        sclevel = filterLevel;
//		System.out.println("in FunctionalDashController.FunctionalDashController()");
//		System.out.println("facId :" + facId);
        System.out.println("filterLevel X:" + sclevel);
//		System.out.println("week :" + week);
        try {
            sclevel = (sclevel == null || sclevel.equals("")) ? "LGA" : sclevel.toUpperCase();
            JSONArray data;
            AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
            
            //Line to change
            data = new AMSChartServices().getFunctionalPISData(userBean, sclevel);

            System.out.println("get_functional_pis_solar_refrigerator_data jsonforjsp ======" + data.toString());
            PrintWriter out = respones.getWriter();
            out.write(data.toString());
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    @RequestMapping(value = "/get_functional_domestic_solar_refrigerator_data")
    public JSONArray getFunctionalDomesticSolarRefrigeratorData(HttpServletRequest request, HttpServletResponse respones, @RequestParam("filterLevel") String filterLevel) {
        JSONArray arrayforjsp = new JSONArray();
        sclevel = filterLevel;
//		System.out.println("in FunctionalDashController.FunctionalDashController()");
//		System.out.println("facId :" + facId);
        System.out.println("filterLevel X:" + sclevel);
//		System.out.println("week :" + week);
        try {
            sclevel = (sclevel == null || sclevel.equals("")) ? "LGA" : sclevel.toUpperCase();
            JSONArray data;
            AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
            
            //Line to change
            data = new AMSChartServices().getFunctionalPISData(userBean, sclevel);

            System.out.println("get_functional_domestic_solar_refrigerator_data jsonforjsp ======" + data.toString());
            PrintWriter out = respones.getWriter();
            out.write(data.toString());
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
}
