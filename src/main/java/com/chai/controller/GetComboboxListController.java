package com.chai.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.chai.model.views.AdmUserV;
import com.chai.services.ComboBoxListServices;
import com.chai.services.UserService;
import com.chai.util.CalendarUtil;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.json.JSONObject;

@Controller
public class GetComboboxListController {

	@Autowired
	private ComboBoxListServices comboboxServices;

	@RequestMapping(value = "/getlgalist")
	public void getJsonLgaList(HttpServletRequest request, HttpServletResponse respones) {
		System.out.println("in GetComboboxListController.getJsonLgaList()");
		try {
			PrintWriter out = respones.getWriter();
			JSONArray data = new JSONArray();
			String allOption = request.getParameter("option");
			AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
			if (userBean == null) {
				out.write("sessionOut");
			} else {
				if (allOption != null && allOption.equals("All")) {
					data = comboboxServices.getComboboxList("lgalistBasedonstate",
							String.valueOf(userBean.getX_WAREHOUSE_ID()), "All");
				} else {
					data = comboboxServices.getComboboxList("lgalistBasedonstate",
							String.valueOf(userBean.getX_WAREHOUSE_ID()));
				}
				out.write(data.toString());

			}

			// System.out.println("json LGA_List: "+data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@RequestMapping(value = "/getlgalistBasedOnStateId")
	public void getJsonLgaListBasedonStateId(HttpServletRequest request, HttpServletResponse respones,
			@RequestParam("option") String option, @RequestParam("stateId") String stateId) {
		System.out.println("in GetComboboxListController.getJsonLgaListBasedonStateId()");
		try {
			String allOption = option;
			AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
			JSONArray data;
			if (allOption != null && allOption.equals("All")) {
				data = comboboxServices.getComboboxList("lgalistBasedonstate", stateId, "All");
			} else {
				data = comboboxServices.getComboboxList("lgalistBasedonstate", stateId);
			}

			// System.out.println("json LGA_List: "+data.toString());
			PrintWriter out = respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
			try {
				respones.sendRedirect("loginPage");
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}
	}

	@RequestMapping(value = "/getUserTypelist")
	public void getUserTypelist(HttpServletRequest request, HttpServletResponse respones) {
		System.out.println("in GetComboboxListController.getUserTypelist()");
		try {
			JSONArray data;
			data = comboboxServices.getComboboxList("USER_TYPE", null);

			// System.out.println("json user Type _List: "+data.toString());
			PrintWriter out = respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@RequestMapping(value = "/get_rolename_list")
	public void getRoleNameList(HttpServletRequest request, HttpServletResponse respones,
			@RequestParam("userType") String userType) {
		System.out.println("in GetComboboxListController.getRoleNameList()");
		try {
			AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
			JSONArray data;
			data = comboboxServices.getComboboxList("USER_ROLE_NAME", userType, userBean.getX_ROLE_NAME());
			// System.out.println("json user Type _List: "+data.toString());
			PrintWriter out = respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@RequestMapping(value = "/get_assignlga_list")
	public void getAssignedlgaList(HttpServletRequest request, HttpServletResponse respones,
			@RequestParam("userTypeId") String userTypeId, @RequestParam("roleId") String roleId) {
		System.out.println("in GetComboboxListController.getAssignedlgaList()");
		try {
			JSONArray data;
			AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
			data = new UserService().getAssignedLgaAccoToRole(roleId, userTypeId, userBean);

			// System.out.println("json user Type _List: "+data.toString());
			PrintWriter out = respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@RequestMapping(value = "/get_assignlga_list_forform")
	public void getAssignedlgaListForForm(HttpServletRequest request, HttpServletResponse respones,
			@RequestParam("userTypeId") String userTypeId, @RequestParam("roleId") String roleId) {
		System.out.println("in GetComboboxListController.getAssignedlgaList()");
		try {
			JSONArray data;
			AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
			data = new UserService().getAssignedLgaAccoToRoleForForm(roleId, userTypeId, userBean);

			// System.out.println("json user Type _List: "+data.toString());
			PrintWriter out = respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@RequestMapping(value = "/getproductlist")
	public void getJsonProductList(HttpServletRequest request, HttpServletResponse respones,
			@RequestParam("option") String option, @RequestParam("lgaid") String lgaid) {
		System.out.println("in GetComboboxListController.getJsonProductList()");
		try {
			JSONArray data;
			AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
			if (option.equals("All")) {
				data = comboboxServices.getProductList("productlistbassedonlga", lgaid, "true");
			} else {
				data = comboboxServices.getProductList("productlistbassedonlga", lgaid, "false");
			}

			// System.out.println("json product_list: "+data.toString());
			PrintWriter out = respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();

		}
	}

	@RequestMapping(value = "/get_year_list")
	public void getJsonYearList(HttpServletRequest request, HttpServletResponse respones) {
		try {
			JSONArray data = new CalendarUtil().getYear();
			// System.out.println("json year_list: "+data.toString());
			PrintWriter out = respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
			try {
				respones.sendRedirect("loginPage");
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}
	}
	@RequestMapping(value = "/get_last_20_years_list")
	public void getJson20YearList(HttpServletRequest request,HttpServletResponse respones){
		try{
			JSONArray data=new CalendarUtil().get20Years();
			// System.out.println("json year_list: "+data.toString());
			PrintWriter out=respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
			try {
				respones.sendRedirect("loginPage");
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}
	}
        @RequestMapping(value = "/get_month_number_list")
	public void getJsonMonthList(HttpServletRequest request,HttpServletResponse respones){
		try{
			JSONArray data=new CalendarUtil().getMonthAndNumber("short_month_inyear");
			// System.out.println("json year_list: "+data.toString());
			PrintWriter out=respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
			try {
				respones.sendRedirect("loginPage");
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}
	}

	@RequestMapping(value = "/get_week_list/{weekOrMonth}")
	public void getJsonWeekList(@PathVariable("weekOrMonth") String weekOrMonth,
			@RequestParam("yearParam") String yearParam, HttpServletRequest request, HttpServletResponse respones) {
		System.out.println("path/action hit --> /get_week_list/" + weekOrMonth);
		try {
			JSONArray data = null;
			if (weekOrMonth.equals("month")) {
				System.out.println("yearParam: " + yearParam);
				data = new CalendarUtil().getMonth(Integer.parseInt(yearParam));
			} else if (weekOrMonth.equals("week")) {
				data = new CalendarUtil().getWeek(Integer.parseInt(yearParam));
			}
			// System.out.println("list:"+data.toString());
			// System.out.println("json month/week_list: "+data.toString());
			PrintWriter out = respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
			try {
				respones.sendRedirect("loginPage");
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}
	}

	@RequestMapping(value = "/get_quarter_list")
	public void getJsonQuaerterList(@RequestParam("yearParam") String yearParam, HttpServletRequest request,
			HttpServletResponse respones) {
		try {
			JSONArray data = null;
			data = CalendarUtil.getQuarter(Integer.parseInt(yearParam));
			PrintWriter out = respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
			try {
				respones.sendRedirect("loginPage");
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}
	}

	@RequestMapping(value = "/get_state_store_list")
	public JSONArray getJsonStateStoreList(HttpServletRequest request, HttpServletResponse respones) {
		System.out.println("in GetDataListController.getJsonStateStoreList()");
		try {
			String allOption = request.getParameter("option");
			AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
			JSONArray data;
			if (allOption != null && allOption.equals("All")) {
				data = comboboxServices.getComboboxList("STATE_STORE", String.valueOf(userBean.getX_WAREHOUSE_ID()),
						"All");
			} else {
				data = comboboxServices.getComboboxList("STATE_STORE", String.valueOf(userBean.getX_WAREHOUSE_ID()));
			}

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

	@RequestMapping(value = "/getHflist")
	public void getHfList(@RequestParam("lgaid") String lgaid, @RequestParam("option") String option,
			HttpServletRequest request, HttpServletResponse respones) {
		try {
			JSONArray data = null;
			if (option.equals("All")) {
				System.out.println("option ALL");
				data = comboboxServices.getComboboxList("hfListLgaBased", lgaid, option);
			} else {
				System.out.println("option NOT ALL");
				data = comboboxServices.getComboboxList("hfListLgaBased", lgaid, "null");
			}
			// System.out.println("hflist: "+data.toString());
			PrintWriter out = respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();

		}
	}
        
        @RequestMapping(value = "/getHfListWardBased")
	public void getHfListWardBased(@RequestParam("wardid") String wardid, @RequestParam("option") String option,
			HttpServletRequest request,HttpServletResponse respones){
		try{
			JSONArray data = null;
			if(option.equals("All")){
				data=comboboxServices.getComboboxList("hfListWardBased",wardid,option);
			}else{
				data=comboboxServices.getComboboxList("hfListWardBased",wardid,"null");
			}
			// System.out.println("hflist: "+data.toString());
			PrintWriter out=respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();

		}
	}
        
        @RequestMapping(value = "/get_cce_specification_list")
	public void getCCESpecificationList(@RequestParam("arg0") String arg0, 
                @RequestParam("arg1") String arg1, @RequestParam("arg2") String arg2, 
                @RequestParam("arg3") String arg3,
			HttpServletRequest request,HttpServletResponse respones){
		try{
			JSONArray data = null;
                        if(arg1.equals("")&&arg2.equals("")&&arg3.equals("")){
				data=comboboxServices.getComboboxList(arg0,null,null,null);
			}else if(arg2.equals("")&&arg3.equals("")){
				data=comboboxServices.getComboboxList(arg0,arg1,null,null);
			}else if(arg3.equals("")){
				data=comboboxServices.getComboboxList(arg0,arg1,arg2,null);
			}else{
				data=comboboxServices.getComboboxList(arg0,arg1,arg2,arg3);
			}
			
			
			// System.out.println("hflist: "+data.toString());
			PrintWriter out=respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();

		}
	}
        
        @RequestMapping(value = "/get_cce_summary_list")
	public void getCCESummaryList(@RequestParam("arg0") String arg0, @RequestParam("arg1") String arg1,
                HttpServletRequest request,HttpServletResponse respones){
		try{
			JSONArray data = null;
                        if(arg1.equals("")){
				data=comboboxServices.getComboboxList(arg0,null);
			}else{
				data=comboboxServices.getComboboxList(arg0,arg1);
			}
			 System.out.println("hflist: "+data.toString());
			PrintWriter out=respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();

		}
	}
        
        @RequestMapping(value = "/get_sclevel_list")
	public void getSclevelList(HttpServletRequest request,HttpServletResponse respones){
		System.out.println("in GetComboboxListController.getRoleNameList()");
		try{
			AdmUserV userBean=(AdmUserV)request.getSession().getAttribute("userBean");
                        PrintWriter out = respones.getWriter();
			JSONArray data=new JSONArray();
			String userType=request.getParameter("userType");
//                        List<Map<String, Object>> filters = new ArrayList<Map<String, Object>>();
//                        Map<String, Object> filter = new LinkedHashMap<String, Object>();
                        if(userType.equals("NTO")){
                            JSONObject obj=new JSONObject();
                            obj.put("value","National");
                            obj.put("label","National");
                            data.put(obj);
                            JSONObject obj1=new JSONObject();
                            obj1.put("value","STATE");
                            obj1.put("label","STATE");
                            data.put(obj1);
                        }else if(userType.equals("SCCO")){
                            JSONObject obj=new JSONObject();
                            obj.put("value","STATE");
                            obj.put("label","STATE");
                            data.put(obj);
                            JSONObject obj1=new JSONObject();
                            obj1.put("value","LGA");
                            obj1.put("label","LGA");
                            data.put(obj1);
                        }else if(userType.equals("LIO")){
                            JSONObject obj=new JSONObject();
                            obj.put("value","LGA");
                            obj.put("label","LGA");
                            data.put(obj);
                        }else{
                            JSONObject obj=new JSONObject();
                            obj.put("value","");
                            obj.put("label","");
                            data.put(obj);
                        }
//			 data=comboboxServices.getComboboxList("USER_ROLE_NAME",userType,userBean.getX_ROLE_NAME());
			// System.out.println("json user Type _List: "+data.toString());
//			PrintWriter out=respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}	
	}
        
        @RequestMapping(value = "/get_aggby_list")
	public void getAggbyList(HttpServletRequest request,HttpServletResponse respones){
		System.out.println("in GetComboboxListController.getRoleNameList()");
		try{
			AdmUserV userBean=(AdmUserV)request.getSession().getAttribute("userBean");
                        PrintWriter out = respones.getWriter();
			JSONArray data=new JSONArray();
			String levelSelected=request.getParameter("levelSelected");
                        List<Map<String, Object>> filters = new ArrayList<Map<String, Object>>();
                        Map<String, Object> filter = new LinkedHashMap<String, Object>();
		
                        if(levelSelected.equals("National")){
                            JSONObject obj=new JSONObject();
                            obj.put("value","National");
                            obj.put("label","National Store");
                            data.put(obj);
                            JSONObject obj1=new JSONObject();
                            obj1.put("value","STATE");
                            obj1.put("label","State Store");
                            data.put(obj1);
                        }else if(levelSelected.equals("STATE")){
                            JSONObject obj=new JSONObject();
                            obj.put("value","STATE");
                            obj.put("label","State Store");
                            data.put(obj);
                            JSONObject obj1=new JSONObject();
                            obj1.put("value","LGA");
                            obj1.put("label","LGA Store");
                            data.put(obj1);
                        }else if(levelSelected.equals("LGA")){
                            JSONObject obj=new JSONObject();
                            obj.put("value","LGA");
                            obj.put("label","LGA Store");
                            data.put(obj);
//                            JSONObject obj1=new JSONObject();
//                            obj1.put("value","HF");
//                            obj1.put("label","WARD");
//                            data.put(obj1);
                        }else{
                            JSONObject obj=new JSONObject();
                            obj.put("value","");
                            obj.put("label","");
                            data.put(obj);
                        }
//			 data=comboboxServices.getComboboxList("USER_ROLE_NAME",userType,userBean.getX_ROLE_NAME());
			// System.out.println("json user Type _List: "+data.toString());
//			PrintWriter out=respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}	
	}
        @RequestMapping(value = "/getWardList")
	public void getWardList(@RequestParam("lgaid") String lgaid, @RequestParam("option") String option,
			HttpServletRequest request,HttpServletResponse respones){
		try{
			JSONArray data = null;
			if(option.equals("All")){
				data=comboboxServices.getComboboxList("wardListLgaBased",lgaid,option);
			}else{
				data=comboboxServices.getComboboxList("wardListLgaBased",lgaid,"null");
			}
			// System.out.println("hflist: "+data.toString());
			PrintWriter out=respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();

		}
	}

	@RequestMapping(value = "/getTransactionlist")
	public void getTransactionlist(@RequestParam("option") String option, HttpServletRequest request,
			HttpServletResponse respones) {
		try {
			System.out.println("getComboBoxListController.getTransactionList()");
			JSONArray data = null;
			data = comboboxServices.getComboboxList("TRANSACTION_TYPE", null, option);
			// System.out.println("Transaction list: "+data.toString());
			PrintWriter out = respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();

		}
	}

	@RequestMapping(value = "/getReasonTypelist")
	public void getReasonTypelist(@RequestParam("option") String option, HttpServletRequest request,
			HttpServletResponse respones) {
		try {
			System.out.println("getComboBoxListController.getReasonTypelist()");
			JSONArray data = null;
			data = comboboxServices.getComboboxList("REASON_TYPE", null, option);
			// System.out.println("Transaction list: "+data.toString());
			PrintWriter out = respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();

		}
	}

	@RequestMapping(value = "/getCountrylist")
	public void getCountrylist(HttpServletRequest request, HttpServletResponse respones) {
		try {
			System.out.println("getComboBoxListController.getCountrylist()");
			JSONArray data = null;
			data = comboboxServices.getComboboxList("COUNTRY_LIST", null, null);
			// System.out.println("Transaction list: " + data.toString());
			PrintWriter out = respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();

		}
	}
        
        @RequestMapping(value = "/getCCEInfoDetails")
	public void getCCEInfoDetails(@RequestParam("option") String option,
			HttpServletRequest request,HttpServletResponse respones){
		try{
			JSONArray data = null;
				data=comboboxServices.getComboboxList(option);
			// System.out.println("hflist: "+data.toString());
			PrintWriter out=respones.getWriter();
			out.write(data.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();

		}
	}
}