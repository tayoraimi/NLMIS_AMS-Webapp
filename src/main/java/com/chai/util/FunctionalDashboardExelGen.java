package com.chai.util;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.web.servlet.view.document.AbstractExcelView;

import com.chai.model.LabelValueBean;

public class FunctionalDashboardExelGen extends AbstractExcelView {
    

	@Override
	protected void buildExcelDocument(Map<String, Object> model, 
			HSSFWorkbook workbook, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
                        String levelName = "";
		try {
			List<LabelValueBean> functionalHeaderList=(List<LabelValueBean>) model.get("functionalitylistwithfacilitylevel");
			JSONArray data = (JSONArray) model.get("export_data");
			System.out.println("exel data in json" + data);
			System.out.println("level Name in json" + functionalHeaderList.get(0).getValue());
			HSSFSheet worksheet = workbook.createSheet("Dashboard Report");
			HSSFRow rowHeader=worksheet.createRow(0);
			int i=0;
                        if(levelName.equals("")){
                            levelName = functionalHeaderList.get(0).getValue();
//                            functionalHeaderList.remove(0);// for remove lga from product name field
                        }
			for (LabelValueBean functionalHeader : functionalHeaderList) {
				HSSFCell cell=rowHeader.createCell(i);
				cell.setCellValue(functionalHeader.getLabel());
				HSSFCellStyle cellStyle = workbook.createCellStyle();
				cellStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				cellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				cell.setCellStyle(cellStyle);
				i++;
			}
			for (i = 0; i < data.length(); i++) {
				System.out.println("row" + i);
				HSSFRow row = worksheet.createRow(i+1);
				JSONObject rowObject = (JSONObject) data.get(i);
//                                System.out.println("data to be in excel row" + data.toString());
				HSSFCell cell=row.createCell(0);
				cell.setCellValue(rowObject.getString(levelName));
				HSSFCellStyle cellStyle = workbook.createCellStyle();
				cellStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				cellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				cell.setCellStyle(cellStyle);
				int j=0;
                                rowObject.remove(levelName);
				for (LabelValueBean functionalHeader : functionalHeaderList) {
					Iterator<?> keys = rowObject.keys();
			    	while(keys.hasNext()){
			    		String key=(String)keys.next();
			    		if(key.contains(functionalHeader.getLabel())){
			    			HSSFCell cell1=row.createCell(j);
			    			JSONObject obj=(JSONObject) rowObject.get(key);
//                                                System.out.println("Key " + key);
			    			cell1.setCellValue((int)Double.parseDouble(obj.getString("FACIITY_STATUS")));
			    			HSSFCellStyle cellStyle1 = workbook.createCellStyle();
			    			switch (obj.getString("LEGEND_COLOR")) {
							case "green": // for green
								cellStyle1.setFillForegroundColor((short) 17);
								cellStyle1.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
								break;
							case "red":// for red
								cellStyle1.setFillForegroundColor((short) 10);
								cellStyle1.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
								break;
							case "orange": // for yellow
								cellStyle1.setFillForegroundColor(HSSFColor.ORANGE.index);
								cellStyle1.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
								break;
							default:
								cellStyle1.setFillForegroundColor(HSSFColor.WHITE.index);
								cellStyle1.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
								break;
							}
			    			cell1.setCellStyle(cellStyle1);
			    			break;
			    		}
			    	}
			    	j++;
				}
			}
			System.out.println("leaving... excel builder");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}