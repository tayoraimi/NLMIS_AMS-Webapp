

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
public class FunctionalDashController {
	List<LabelValueBean> functionalHeaderList = new LinkedList<LabelValueBean>();
	List<LabelValueBean> functionalHeaderListExport = new LinkedList<>();
	JSONArray griddata = new JSONArray();
        private DecimalFormat df = new DecimalFormat("#.##");
        String sclevel="";
        String sclevelAdjust="";
	
	@RequestMapping(value = "/functional_dashboard_page")
	public ModelAndView showFunctionalDashboardPage(HttpServletRequest request, HttpServletResponse respones) {
//		System.out.println("FunctionalDashController.showHFStockSummarySheetPage()");
		ModelAndView model = new ModelAndView("FunctionalDashboardPage");
		return model;
	}

	@RequestMapping(value = "/getheadingTableForCCEFunctionalDashboard")
	public void getheadingData(HttpServletRequest request, HttpServletResponse respones, @RequestParam("filterLevel") String filterLevel) {
//		AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
//                String filterLevel =request.getParameter("filterLevel");
                sclevel =filterLevel;
                        System.out.println("sclevel - "+sclevel);
		try {
//			functionalHeaderList = Arrays.asList("State", "LGA", "Ward", "Equipment Location", "RI", "Men A", "Rota", "MR", "HPV", "2020"); 
//			functionalHeaderList.add(0, new LabelValueBean("STATE", "State"));
//                        functionalHeaderList.add(1, new LabelValueBean("LGA", "LGA"));
                        sclevel = sclevel.toUpperCase();
                        sclevelAdjust = (sclevel.equalsIgnoreCase("National"))?"STATE":sclevel;
                        functionalHeaderList.add(0, new LabelValueBean(sclevelAdjust, sclevel));
//                        System.out.println("functionalHeaderList.get(0).getLabel()"+functionalHeaderList.get(0).getLabel());
//                        functionalHeaderList.add(1, new LabelValueBean("LOCATION", "Equipment Location"));
                        functionalHeaderList.add(1, new LabelValueBean("tF", "Functional"));
                        functionalHeaderList.add(2, new LabelValueBean("tNF", "Not Functional"));
                        functionalHeaderList.add(3, new LabelValueBean("tNI","Not Installed"));
                        functionalHeaderList.add(4, new LabelValueBean("tO_F", "Obsolete Functional"));
                        functionalHeaderList.add(5, new LabelValueBean("tO_NF", "Obsolete Not Functional"));
                        functionalHeaderList.add(6, new LabelValueBean("TOTAL", "Total"));
                        
			JSONArray array = new JSONArray();
			for (LabelValueBean object : functionalHeaderList) {
				array.put(new JSONObject().put("field_header", object.getLabel()));
                                functionalHeaderListExport.add(object);
			}
			System.out.println("heading data:" + array.toString());
			PrintWriter out = respones.getWriter();
			out.write(array.toString());
			out.close();
		} catch (JSONException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@RequestMapping(value = "/get_functional_dashboard_data")
	public JSONArray getFunctionalDashboardData(HttpServletRequest request, HttpServletResponse respones,
                @RequestParam("filterLevel") String filterLevel,
                @RequestParam("aggLevel") String aggLevel) {
		JSONArray arrayforjsp = new JSONArray();
                sclevel = filterLevel;
//		System.out.println("in FunctionalDashController.FunctionalDashController()");
//		System.out.println("facId :" + facId);
		System.out.println("filterLevel X:" + sclevel);
//		System.out.println("week :" + week);
		try {
                        sclevel = sclevel.toUpperCase();
                        sclevelAdjust = (sclevel.equalsIgnoreCase("National"))?"STATE":sclevel;
			JSONArray data;
                        AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
			data = new AMSDashboardServices().getFunctionalDashboardData(userBean, sclevel, aggLevel);
//			System.out.println("reached here ");
//			System.out.println("get_functional_dashboard_data.toSring(): " + data.toString());
			SortedSet<String> hfNameList = new TreeSet<String>();
			for (Object obj : data) {
				// to generate hf name list
				JSONObject griobject = (JSONObject) obj;
                                //add list of facilities
				hfNameList.add(griobject.get(sclevelAdjust).toString());
                                System.out.println("SUCCESS RESULT : " + griobject.get(sclevelAdjust));
			}
			int i = 0;
			int j = 0;
//			System.out.println("get_functional_dashboard_data hf name list: " + hfNameList);
//                        functionalHeaderListExport=functionalHeaderList;
			functionalHeaderList.remove(0);// for remove lga from product name field
			for (String hf : hfNameList) {
				JSONObject rowObject = new JSONObject();
				rowObject.put(sclevelAdjust, hf);
//                                System.out.println("Printing hf "+hf);
				for (int k = 0; k < functionalHeaderList.size(); k++) {
                                    //get the column header properties
					LabelValueBean bean = functionalHeaderList.get(k);
					JSONObject colObject = new JSONObject();
                                        Double doubleItem = 0.0;
                                        
					for (Object dataresult : data) {
						JSONObject dataobjectresult = (JSONObject) dataresult;
                                                String value="";
						if (String.valueOf(dataobjectresult.get(sclevelAdjust)).equals(hf)) {
                                                    
                                                    if (dataobjectresult.get(bean.getValue()) == null || dataobjectresult.get(bean.getValue()).equals("")) {
                                                        colObject.put("FACIITY_STATUS", "");
                                                        colObject.put("LEGEND_COLOR", "");
                                                        } else{
                                                    
                                                                //value = Integer.valueOf(dataobjectresult.get(bean.getValue()));
                                                                
                                                                //System.out.println("Column : " + value);
                                                                   
            //        							System.out.println("col" + j++);
                                                                    if(bean.getValue().equals("tF")){
//                                                                        String[] itemElement = String.valueOf(dataobjectresult.get(bean.getValue())).split("/");
                                                                         String tF = dataobjectresult.get(bean.getValue()).toString();
                                                                         String total = dataobjectresult.get("TOTAL").toString();
                                                                         colObject.put("FACIITY_STATUS", tF);
                                                                         doubleItem = (Double.parseDouble(tF)*100.0)/((Double.parseDouble(total)==0.0)?1.0:Double.parseDouble(total));
                                                                            if(doubleItem<50.0){//functional is less than 70% of required
                                                                                colObject.put("LEGEND_COLOR", "red");
                                                                        } else if(doubleItem>=50.0&&doubleItem<=90.0){
            //                                                                System.out.println("col value" + df.format(doubleItem)+"%");
                                                                            colObject.put("LEGEND_COLOR", "orange");
                                                                        } else if(doubleItem>90.0){
                                                                            colObject.put("LEGEND_COLOR", "green; color:white");
                                                                        }
                                                                    } else if(bean.getValue().equals("tNF")){
                                                                        value = dataobjectresult.get(bean.getValue()).toString();
                                                                        colObject.put("FACIITY_STATUS", value);
                                                                        colObject.put("LEGEND_COLOR", "");
//                                                                            if(Integer.valueOf(value)==0){//functional is less than 70% of required
//                                                                            colObject.put("LEGEND_COLOR", "red");
//                                                                        } else if(Integer.valueOf(value)>=1){
//                                                                            colObject.put("LEGEND_COLOR", "green");
//                                                                        }
                                                                    } else if(bean.getValue().equals("tNI")){
                                                                        value = dataobjectresult.get(bean.getValue()).toString();
                                                                        colObject.put("FACIITY_STATUS", value);
                                                                        colObject.put("LEGEND_COLOR", "");
//                                                                            if(Integer.valueOf(value)==0){//functional is less than 70% of required
//                                                                            colObject.put("LEGEND_COLOR", "red");
//                                                                        } else if(Integer.valueOf(value)>=1){
//                                                                            colObject.put("LEGEND_COLOR", "green");
//                                                                        }
                                                                    } else if(bean.getValue().equals("tO_F")){
                                                                        value = dataobjectresult.get(bean.getValue()).toString();
                                                                        colObject.put("FACIITY_STATUS", value);
                                                                        colObject.put("LEGEND_COLOR", "");
                                                                    } else if(bean.getValue().equals("tO_NF")){
                                                                        value = dataobjectresult.get(bean.getValue()).toString();
                                                                        colObject.put("FACIITY_STATUS", value);
                                                                        colObject.put("LEGEND_COLOR", "");
                                                                    } else if(bean.getValue().equals("TOTAL")){
                                                                        value = dataobjectresult.get(bean.getValue()).toString();
                                                                        colObject.put("FACIITY_STATUS", value);
                                                                        colObject.put("LEGEND_COLOR", "");
                                                                    }else{
                                                                        value = dataobjectresult.get(bean.getValue()).toString();
                                                                        colObject.put("FACIITY_STATUS", value);
                                                                        colObject.put("LEGEND_COLOR", "");
                                                                    }
                                                                            
                                                        
                                                    }
                                                                break;
                                                }
                                        }
					if (colObject.length() > 0) {

					} else {
//						System.out.println("col" + j++);
						colObject.put("FACIITY_STATUS", "");
						colObject.put("LEGEND_COLOR", "");
					}
//                                        System.out.println("col bean label " + bean.getLabel());
					rowObject.put(bean.getLabel(), colObject);
				}
				arrayforjsp.put(rowObject);
			}

			griddata = arrayforjsp;// for global
			System.out.println("get_functional_dashboard_data jsonforjsp ======" + arrayforjsp.toString());
			PrintWriter out = respones.getWriter();
			out.write(arrayforjsp.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	@RequestMapping(value = "/functional_dashboard_export_data.xls")
	public ModelAndView export_data_grid(HttpServletRequest request, HttpServletResponse respones) throws IOException {
		// String export_data=request.getParameter("export_data");
		System.out.println("export_data_grid in functional dashboard");
		ModelAndView model = new ModelAndView("functionalDashboard");
		model.addObject("functionalitylistwithfacilitylevel", functionalHeaderListExport);
		model.addObject("export_data", griddata);
		return model;
	}
}

           
                    