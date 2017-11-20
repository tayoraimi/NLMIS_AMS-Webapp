package com.chai.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.LinkedList;
import java.util.List;
import java.util.SortedSet;
import java.util.TreeSet;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.chai.model.LabelValueBean;
import com.chai.model.views.AdmUserV;
import com.chai.services.ComboBoxListServices;
import com.chai.services.AMSDashboardServices;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;

@Controller
public class CapacityDashController {
	List<LabelValueBean> capacityHeaderList = new LinkedList<LabelValueBean>();
        List<LabelValueBean> capacityHeaderListExport = new LinkedList<>();
	JSONArray griddata = new JSONArray();
        private DecimalFormat df = new DecimalFormat("#.##");
        String sclevel="LGA";
	
	@RequestMapping(value = "/capacity_dashboard_page")
	public ModelAndView showCapacityDashboardPage(HttpServletRequest request, HttpServletResponse respones) {
//		System.out.println("CapacityDashController.showHFStockSummarySheetPage()");
		ModelAndView model = new ModelAndView("CapacityDashboardPage");
		return model;
	}

	@RequestMapping(value = "/getheadingTableForCCECapacityDashboard")
	public void getheadingData(HttpServletRequest request, HttpServletResponse respones, @RequestParam("filterLevel") String filterLevel) {
//		AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
            sclevel =filterLevel;
		try {
                        sclevel = (sclevel==null||sclevel.equals(""))?"LGA":sclevel.toUpperCase();
//			capacityHeaderList = Arrays.asList("State", "LGA", "Ward", "Equipment Location", "RI", "Men A", "Rota", "MR", "HPV", "2020"); 
//			capacityHeaderList.add(0, new LabelValueBean("STATE", "State"));
//                        capacityHeaderList.add(1, new LabelValueBean("LGA", "LGA"));
                        capacityHeaderList.add(0, new LabelValueBean(sclevel, sclevel));
//                        capacityHeaderList.add(1, new LabelValueBean("LOCATION", "Equipment Location"));
                        capacityHeaderList.add(1, new LabelValueBean("RI", "RI"));
                        capacityHeaderList.add(2, new LabelValueBean("MEN_A", "Men A"));
                        capacityHeaderList.add(3, new LabelValueBean("ROTA", "ROTA"));
                        capacityHeaderList.add(4, new LabelValueBean("MR", "MR"));
                        capacityHeaderList.add(5, new LabelValueBean("HPV", "HPV"));
			JSONArray array = new JSONArray();
			for (LabelValueBean object : capacityHeaderList) {
				array.put(new JSONObject().put("field_header", object.getLabel()));
                                capacityHeaderListExport.add(object);
			}
//			System.out.println("heading data:" + array.toString());
			PrintWriter out = respones.getWriter();
			out.write(array.toString());
			out.close();
		} catch (JSONException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@RequestMapping(value = "/get_capacity_dashboard_data")
	public JSONArray getCapacityDashboardData(HttpServletRequest request, HttpServletResponse respones,
                @RequestParam("filterLevel") String filterLevel,
                @RequestParam("aggLevel") String aggLevel) {
		JSONArray arrayforjsp = new JSONArray();
                AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
                
//		System.out.println("in CapacityDashController.CapacityDashController()");
//		System.out.println("facId :" + facId);
		System.out.println("filterLevel :" + filterLevel);
                sclevel = filterLevel;
//		System.out.println("week :" + week);
		try {
                        sclevel = (sclevel==null||sclevel.equals(""))?"LGA":sclevel.toUpperCase();
			JSONArray data;
			data = new AMSDashboardServices().getCapacityDashboardData(userBean, sclevel, aggLevel);
//			System.out.println("lgaId: " + lgaId);
//			System.out.println("get_capacity_dashboard_data.toSring(): " + data.toString());
			SortedSet<String> hfNameList = new TreeSet<String>();
			for (Object obj : data) {
				// to generate hf name list
				JSONObject griobject = (JSONObject) obj;
				hfNameList.add(griobject.get(sclevel).toString());
//                                System.out.println("SUCCESS RESULT : " + griobject.get("MEN_A"));
			}
			int i = 0;
			int j = 0;
//			System.out.println("get_capacity_dashboard_data hf name list: " + hfNameList.toString());
			capacityHeaderList.remove(0);// for remove lga from product name field
			for (String hf : hfNameList) {
				JSONObject rowObject = new JSONObject();
				rowObject.put(sclevel, hf);
				for (int k = 0; k < capacityHeaderList.size(); k++) {
					LabelValueBean bean = capacityHeaderList.get(k);
					JSONObject colObject = new JSONObject();
                                        Double doubleItem = 0.0;
                                        String[] itemElement=null;
					for (Object dataresult : data) {
						JSONObject dataobjectresult = (JSONObject) dataresult;
                                                
						if (String.valueOf(dataobjectresult.get(sclevel)).equals(hf)) {
                                                    
                                                    itemElement = String.valueOf(dataobjectresult.get(bean.getValue())).split("/");
//                                                    System.out.println("Column : " + dataobjectresult.get(bean.getValue()).toString());
                                                    if (Double.parseDouble(itemElement[1])==0.0) {
                                                        colObject.put("FACIITY_CAPACITY", "Cap. required not specified");
                                                        colObject.put("LEGEND_COLOR", "");
                                                    } else{
                                                        doubleItem = (Double.parseDouble(itemElement[0])/Double.parseDouble(itemElement[1]))*100.0;
//        							System.out.println("col" + j++);
                                                                if(doubleItem<70.0){//capacity is less than 70% of required
                                                                colObject.put("FACIITY_CAPACITY", df.format(doubleItem));
                                                                colObject.put("LEGEND_COLOR", "red");
                                                            } else if(doubleItem>=70.0&&doubleItem<100.0){
//                                                                System.out.println("col value" + df.format(doubleItem)+"%");
                                                                colObject.put("FACIITY_CAPACITY", df.format(doubleItem));
                                                                colObject.put("LEGEND_COLOR", "orange");
                                                            } else if(doubleItem>=100.0){
                                                                colObject.put("FACIITY_CAPACITY", "");
                                                                colObject.put("LEGEND_COLOR", "green; color:white");
                                                            }
                                            }
                                                            break;
                                            }
                                        }
					if (colObject.length() > 0) {

					} else {
//						System.out.println("col" + j++);
						colObject.put("FACIITY_CAPACITY", "");
						colObject.put("LEGEND_COLOR", "red");
					}
					rowObject.put(bean.getLabel(), colObject);
				}
				arrayforjsp.put(rowObject);
			}

			griddata = arrayforjsp;// for global
//			System.out.println("get_capacity_dashboard_data jsonforjsp ======" + arrayforjsp.toString());
			PrintWriter out = respones.getWriter();
			out.write(arrayforjsp.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	@RequestMapping(value = "/capacity_dashboard_export_data.xls")
	public ModelAndView export_data_grid(HttpServletRequest request, HttpServletResponse respones) throws IOException {
		// String export_data=request.getParameter("export_data");
		System.out.println("export_data_grid in capacity dashboard");
		ModelAndView model = new ModelAndView("capacityDashboard");
		model.addObject("capacitylistwithfacilitylevel", capacityHeaderListExport);
		model.addObject("export_data", griddata);
		return model;
	}
}
