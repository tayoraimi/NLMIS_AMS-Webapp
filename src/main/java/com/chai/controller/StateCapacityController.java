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
public class StateCapacityController {
    
    List<LabelValueBean> functionalHeaderList = new LinkedList<LabelValueBean>();
    JSONArray griddata = new JSONArray();
    private DecimalFormat df = new DecimalFormat("#.##");
    String sclevel = "LGA";
    
    @RequestMapping(value = "/statecapacity", method = RequestMethod.GET)
    public ModelAndView showFunctionChart(HttpServletRequest request, HttpServletResponse respones) {
		ModelAndView modelAndView= new ModelAndView("StateCapacity");
		try {
			HttpSession session=request.getSession();
			AdmUserV userBean=(AdmUserV)session.getAttribute("userBean");
			String login_time=(String)session.getAttribute("login_time");
			modelAndView.addObject("userdata",userBean);
			modelAndView.addObject("login_time",login_time);
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
    
   @RequestMapping(value = "/get_state_capacity_data")
    public JSONArray getStateCapacityData(HttpServletRequest request, HttpServletResponse respones, @RequestParam("filterLevel") String filterLevel) {
        JSONArray arrayforjsp = new JSONArray();
        sclevel = filterLevel;

        System.out.println("filterLevel X:" + sclevel);
//		System.out.println("week :" + week);
        try {
            sclevel = (sclevel == null || sclevel.equals("")) ? "LGA" : sclevel.toUpperCase();
            JSONArray data;
            AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
            data = new AMSChartServices().getStateCapacityData(userBean, sclevel);
            
            System.out.println("get_state_capacity_data jsonforjsp ======" + data.toString());

            PrintWriter out = respones.getWriter();
            out.write(data.toString());
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
}
