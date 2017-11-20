

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
public class MergedDashController {
	List<LabelValueBean> mergedHeaderList = new LinkedList<LabelValueBean>();
        List<LabelValueBean> mergedHeaderListExport = new LinkedList<>();
	JSONArray griddata = new JSONArray();
        private DecimalFormat df = new DecimalFormat("#.##");
        String sclevel="";
        String agglevel="";
	
	@RequestMapping(value = "/merged_dashboard_page")
	public ModelAndView showMergedDashboardPage(HttpServletRequest request, HttpServletResponse respones) {
//		System.out.println("MergedDashController.showHFStockSummarySheetPage()");
		ModelAndView model = new ModelAndView("MergedDashboardPage");
		return model;
	}

	@RequestMapping(value = "/getheadingTableForCCEMergedDashboard")
	public void getheadingMergedData(HttpServletRequest request, HttpServletResponse respones, @RequestParam("filterLevel") String filterLevel) {
//		AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
//                String filterLevel =request.getParameter("filterLevel");
                sclevel =filterLevel;
                        System.out.println("In getheadingMergedData : sclevel - "+sclevel);
		try {
//			mergedHeaderList = Arrays.asList("State", "LGA", "Ward", "Equipment Location", "RI", "Men A", "Rota", "MR", "HPV", "2020"); 
//			mergedHeaderList.add(0, new LabelValueBean("STATE", "State"));
//                        mergedHeaderList.add(1, new LabelValueBean("LGA", "LGA"));
                        sclevel = (sclevel==null||sclevel.equals(""))?"":sclevel.toUpperCase();
                        mergedHeaderList.add(0, new LabelValueBean(sclevel, sclevel));
                        System.out.println("mergedHeaderList.get(0).getLabel()"+mergedHeaderList.get(0).getLabel());
//                        mergedHeaderList.add(1, new LabelValueBean("LOCATION", "Equipment Location"));
                        mergedHeaderList.add(1, new LabelValueBean("tF", "Functional"));
                        mergedHeaderList.add(2, new LabelValueBean("tNF", "Not Functional"));
                        mergedHeaderList.add(3, new LabelValueBean("tNI","Not Installed"));
                        mergedHeaderList.add(4, new LabelValueBean("tO_F", "Obsolete Functional"));
                        mergedHeaderList.add(5, new LabelValueBean("tO_NF", "Obsolete Not Functional"));
                        mergedHeaderList.add(6, new LabelValueBean("TOTAL", "Total"));
                        mergedHeaderList.add(7, new LabelValueBean("RI", "RI"));
                        mergedHeaderList.add(8, new LabelValueBean("MEN_A", "Men A"));
                        mergedHeaderList.add(9, new LabelValueBean("ROTA", "ROTA"));
                        mergedHeaderList.add(10, new LabelValueBean("MR", "MR"));
                        mergedHeaderList.add(11, new LabelValueBean("HPV", "HPV"));
                        
			JSONArray array = new JSONArray();
			for (LabelValueBean object : mergedHeaderList) {
				array.put(new JSONObject().put("field_header", object.getLabel()));
                                mergedHeaderListExport.add(object);
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

	@RequestMapping(value = "/get_merged_dashboard_data")
	public JSONArray getMergedDashboardData(HttpServletRequest request, HttpServletResponse respones, @RequestParam("filterLevel") String filterLevel, @RequestParam("aggLevel") String aggLevel) {
		JSONArray arrayforjsp = new JSONArray();
                sclevel = filterLevel;
                agglevel = aggLevel;
//		System.out.println("in MergedDashController.MergedDashController()");
//		System.out.println("facId :" + facId);
		System.out.println("filterlevel :" + sclevel+" aggLevel :" +agglevel);
//		System.out.println("week :" + week);
		try {
                        sclevel = (sclevel==null||sclevel.equals(""))?"":sclevel.toUpperCase();
                        agglevel = (agglevel==null||agglevel.equals(""))?"":agglevel.toUpperCase();
			JSONArray data;
                        AdmUserV userBean = (AdmUserV) request.getSession().getAttribute("userBean");
			data = new AMSDashboardServices().getMergedDashboardData(userBean, sclevel, agglevel);
//			System.out.println("lgaId: " + lgaId);
//			System.out.println("get_merged_dashboard_data.toSring(): " + data.toString());
			SortedSet<String> hfNameList = new TreeSet<String>();
			for (Object obj : data) {
				// to generate hf name list
				JSONObject griobject = (JSONObject) obj;
				hfNameList.add(griobject.get(sclevel).toString());
                                System.out.println("SUCCESS RESULT M : " + griobject.get(sclevel));
			}
			int i = 0;
			int j = 0;
//			System.out.println("get_merged_dashboard_data hf name list: " + hfNameList);
			mergedHeaderList.remove(0);// for remove lga from product name field
			for (String hf : hfNameList) {
				JSONObject rowObject = new JSONObject();
				rowObject.put(sclevel, hf);
                                JSONObject colObject;
				for (int k = 0; k < 6; k++) {
					LabelValueBean bean = mergedHeaderList.get(k);
					colObject = new JSONObject();
                                        Double doubleItem = 0.0;
                                        
					for (Object dataresult : data) {
						JSONObject dataobjectresult = (JSONObject) dataresult;
                                                String value;
						if (String.valueOf(dataobjectresult.get(sclevel)).equals(hf)) {
//                                                    System.out.println("HF  : " +hf);
//                                                    System.out.println("Column first : " + dataobjectresult.get(bean.getValue()).toString());
                                                    if (dataobjectresult.get(bean.getValue()) == null || dataobjectresult.get(bean.getValue()).equals("")) {
                                                        colObject.put("FACIITY_STATUS", "");
                                                        colObject.put("LEGEND_COLOR", "");
                                                        } else{
                                                    
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
                                                                    } else if(bean.getValue().equals("tNI")){
                                                                        value = dataobjectresult.get(bean.getValue()).toString();
                                                                        colObject.put("FACIITY_STATUS", value);
                                                                        colObject.put("LEGEND_COLOR", "");
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
//					if (colObject.length() > 0) {
//
//					} else {
////						System.out.println("col" + j++);
//						colObject.put("FACIITY_STATUS", "");
//						colObject.put("LEGEND_COLOR", "");
//					}
					rowObject.put(bean.getLabel(), colObject);
				}
                                for (int k = 6; k < 11; k++) {
					LabelValueBean bean = mergedHeaderList.get(k);
					colObject = new JSONObject();
                                        Double doubleItem=0.0;
                                        String[] itemElement;
//                                        System.out.println("Bean valu on repeat click : " + bean.getValue());
                                                            
					for (Object dataresult : data) {
						JSONObject dataobjectresult = (JSONObject) dataresult;
                                                
						if (String.valueOf(dataobjectresult.get(sclevel)).equals(hf)) {
                                                    if (dataobjectresult.get(bean.getValue()) == null ||
                                                            String.valueOf(dataobjectresult.get(bean.getValue())).equals(""))//||
//                                                            String.valueOf(dataobjectresult.get(bean.getValue())).contains("/")==false)
                                                    {
                                                                colObject.put("FACIITY_STATUS", "");
                                                                colObject.put("LEGEND_COLOR", "");
                                                        } else{
                                                            itemElement = String.valueOf(dataobjectresult.get(bean.getValue())).split("/");
                                                            System.out.println("Column : " + dataobjectresult.get(bean.getValue()).toString());
                                                            if (Double.parseDouble(itemElement[1])==0.0) {
                                                                colObject.put("FACIITY_STATUS", "Cap. required?");
                                                                colObject.put("LEGEND_COLOR", "");
                                                            } else{
                                                                doubleItem = (Double.parseDouble(itemElement[0])/Double.parseDouble(itemElement[1]))*100.0;
        //        							System.out.println("col" + j++);
                                                                        if(doubleItem<70.0){//capacity is less than 70% of required
                                                                        colObject.put("FACIITY_STATUS", df.format(doubleItem));
                                                                        colObject.put("LEGEND_COLOR", "red");
                                                                    } else if(doubleItem>=70.0&&doubleItem<100.0){
        //                                                                System.out.println("col value" + df.format(doubleItem)+"%");
                                                                        colObject.put("FACIITY_STATUS", df.format(doubleItem));
                                                                        colObject.put("LEGEND_COLOR", "orange");
                                                                    } else if(doubleItem>=100.0){
                                                                        colObject.put("FACIITY_STATUS", "");
                                                                        colObject.put("LEGEND_COLOR", "green; color:white");
                                                                    }
                                                    }
                                                }
                                                            break;
                                            }
                                        }
//					if (colObject.length() > 0) {
//
//					} else {
////						System.out.println("col" + j++);
//						colObject.put("FACIITY_CAPACITY", "");
//						colObject.put("LEGEND_COLOR", "red");
//					}
					rowObject.put(bean.getLabel(), colObject);
				}
				arrayforjsp.put(rowObject);
			}

			griddata = arrayforjsp;// for global
			System.out.println("get_merged_dashboard_data jsonforjsp ======" + arrayforjsp.toString());
			PrintWriter out = respones.getWriter();
			out.write(arrayforjsp.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	@RequestMapping(value = "/merged_dashboard_export_data.xls")
	public ModelAndView export_data_grid(HttpServletRequest request, HttpServletResponse respones) throws IOException {
		// String export_data=request.getParameter("export_data");
		System.out.println("export_data_grid in merged dashboard");
		ModelAndView model = new ModelAndView("mergedDashboard");
		model.addObject("mergedlistwithfacilitylevel", mergedHeaderListExport);
		model.addObject("export_data", griddata);
		return model;
	}
}

           
                    