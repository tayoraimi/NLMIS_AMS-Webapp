package com.chai.services;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.json.JSONArray;

import com.chai.hibernartesessionfactory.HibernateSessionFactoryClass;
import com.chai.model.CCEBeanForCCEForm;
import com.chai.model.views.AdmUserV;
import com.chai.util.CalendarUtil;
import com.chai.util.GetJsonResultSet;

public class CCEService {
	private static Logger logger = Logger.getLogger(CCEService.class);
	String lastInsertCCEId="";
	SessionFactory sf1 = HibernateSessionFactoryClass.getSessionAnnotationFactory();
	public  JSONArray getCCEListPageData(AdmUserV userBean) {
		System.out.println("-- CCEService.getCCEListPageData mehtod called: -- ");
		Session session = sf1.openSession();
		String warehoseRole=userBean.getX_ROLE_NAME();
		String x_query="";
		if(warehoseRole.equals("SIO")
				|| warehoseRole.equals("SIFP")
				|| warehoseRole.equals("SCCO")){
		 x_query="SELECT CCE_DATA_ID, STATE_ID, STATE, LGA_ID, LGA, FACILITY_ID, FACILITY_NAME, WARD, "
                                + "WAREHOUSE_TYPE_ID, LOCATION, DEFAULT_ORDERING_WAREHOUSE_ID, "
                                + "CCE_ID, DESIGNATION, MAKE, MODEL, DEVICE_SERIAL_NO, REFRIGERANT, CONCAT(CATEGORY,'-',STATUS,'-', DECISION) AS SUMMARY, "
                                + "VOL_NEG, VOL_POS, DATE_FORMAT(DATE_NF, '%d-%b-%Y') DATE_NF, CATEGORY, "
                                + "TYPE, STATUS, DECISION, ENERGY, substring_index(YEAR_OF_ACQUISITION,'/',1) AS MONTH_OF_ACQUISITION, "
                                + "DATE_FORMAT(CONCAT('2014-',substring_index(YEAR_OF_ACQUISITION,'/',1),'-03'),'%b') AS MONTH_OF_ACQUISITION_STR, "
                                + "substring_index(YEAR_OF_ACQUISITION,'/',-1) AS YR_OF_ACQUISITION, YEAR_OF_ACQUISITION, SOURCE_OF_CCE FROM VIEW_E003 "
                                +" WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()
                                + " OR FACILITY_ID = "+userBean.getX_WAREHOUSE_ID()
                                +" OR DEFAULT_ORDERING_WAREHOUSE_ID IN ( SELECT FACILITY_ID FROM view_all_facilities WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()+") ORDER BY CCE_DATA_ID DESC";
                         
                                
		}
                else if(warehoseRole.equals("LIO")
				|| warehoseRole.equals("MOH")
				|| warehoseRole.equals("CCO")){
			x_query="SELECT CCE_DATA_ID, STATE_ID, STATE, LGA_ID, LGA, FACILITY_ID, FACILITY_NAME, WARD, "
                                + "WAREHOUSE_TYPE_ID, LOCATION, DEFAULT_ORDERING_WAREHOUSE_ID, "
                                + "CCE_ID, DESIGNATION, MAKE, MODEL, DEVICE_SERIAL_NO, REFRIGERANT, CONCAT(CATEGORY,'-',STATUS,'-', DECISION) AS SUMMARY, "
                                + "VOL_NEG, VOL_POS, DATE_FORMAT(DATE_NF, '%d-%b-%Y') DATE_NF, CATEGORY, "
                                + "TYPE, STATUS, DECISION, ENERGY, substring_index(YEAR_OF_ACQUISITION,'/',1) AS MONTH_OF_ACQUISITION, "
                                + "DATE_FORMAT(CONCAT('2014-',substring_index(YEAR_OF_ACQUISITION,'/',1),'-03'),'%b') AS MONTH_OF_ACQUISITION_STR, "
                                + "substring_index(YEAR_OF_ACQUISITION,'/',-1) AS YR_OF_ACQUISITION, YEAR_OF_ACQUISITION, SOURCE_OF_CCE FROM VIEW_E003 "
                                +" WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()
                                + " OR FACILITY_ID = "+userBean.getX_WAREHOUSE_ID()+" ORDER BY CCE_DATA_ID DESC";
		}
                else if(warehoseRole.equals("NTO")){
			 x_query="SELECT CCE_DATA_ID, STATE_ID, STATE, LGA_ID, LGA, FACILITY_ID, FACILITY_NAME, WARD, "
                                + "WAREHOUSE_TYPE_ID, LOCATION, DEFAULT_ORDERING_WAREHOUSE_ID, "
                                + "CCE_ID, DESIGNATION, MAKE, MODEL, DEVICE_SERIAL_NO, REFRIGERANT, CONCAT(CATEGORY,'-',STATUS,'-', DECISION) AS SUMMARY, "
                                + "VOL_NEG, VOL_POS, DATE_FORMAT(DATE_NF, '%d-%b-%Y') DATE_NF, CATEGORY, "
                                + "TYPE, STATUS, DECISION, ENERGY, substring_index(YEAR_OF_ACQUISITION,'/',1) AS MONTH_OF_ACQUISITION, "
                                + "DATE_FORMAT(CONCAT('2014-',substring_index(YEAR_OF_ACQUISITION,'/',1),'-03'),'%b') AS MONTH_OF_ACQUISITION_STR, "
                                + "substring_index(YEAR_OF_ACQUISITION,'/',-1) AS YR_OF_ACQUISITION, YEAR_OF_ACQUISITION, SOURCE_OF_CCE FROM VIEW_E003  ORDER BY CCE_DATA_ID DESC";
		}
		JSONArray array = null;
		try {
			SQLQuery query = session.createSQLQuery(x_query);
			query.setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP);
			List resultlist = query.list();
			array = GetJsonResultSet.getjson(resultlist);
		} catch (org.hibernate.exception.JDBCConnectionException e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
//		System.out.println("result list size"+resultlist.size());

		return array;
		}
	public  JSONArray getSearchCCEListPageData(String userTypeId,String roleId,
								String warehouseId,AdmUserV userBean) {
		System.out.println("-- CCEService.getSearchCCEListPageData mehtod called: -- ");
		Session session = sf1.openSession();
		String x_query="";
		String whereCondition="";
		x_query="SELECT USER_ID,	COMPANY_ID,  	FIRST_NAME,	LAST_NAME,	"
				+ "WAREHOUSE_NAME,	WAREHOUSE_ID,	LOGIN_NAME,	PASSWORD,	ACTIVATED,"
				+ "	DATE_FORMAT(ACTIVATED_ON, '%d-%b-%Y') ACTIVATED_ON,	USER_TYPE_NAME,	"
				+ "USER_TYPE_ID,	STATUS,	ROLE_ID, 	ROLE_NAME,	ROLE_DETAILS, "
				+ "	DATE_FORMAT(START_DATE, '%d-%b-%Y') START_DATE, 	"
				+ "DATE_FORMAT(END_DATE, '%d-%b-%Y') END_DATE, 	EMAIL, 	TELEPHONE_NUMBER, "
				+ "	(SELECT COUNT(*) 	   FROM ADM_USER_WAREHOUSE_ASSIGNMENTS WHA 	 "
				+ " WHERE WHA.USER_ID = USR.USER_ID 	    AND WHA.STATUS = 'A') FACILITY_FLAG "
				+ "FROM ADM_USERS_V USR WHERE USER_TYPE_ID=IFNULL("+userTypeId+",USER_TYPE_ID)"
				+ " AND ROLE_ID=IFNULL("+roleId+",ROLE_ID) AND STATUS='A' ";
	
		if(userBean.getX_ROLE_NAME().equals("SCCO")
				|| userBean.getX_ROLE_NAME().equals("SIO")
				|| userBean.getX_ROLE_NAME().equals("SIFP")){
			//if user type is admin and role id and warehosue id  is null 
			if(userTypeId.equals("148433") && roleId.equals("null") && warehouseId.equals("null")){
				whereCondition="AND WAREHOUSE_ID IN (SELECT WAREHOUSE_ID  FROM INVENTORY_WAREHOUSES "
				 +" WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()+") OR WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()+"   ORDER BY FIRST_NAME";
			}//if user type is admin and lio moh role and warehouse id  is null 
			else if(userTypeId.equals("148433") && (roleId.equals("5004") || roleId.equals("5005")) && warehouseId.equals("null")){
				whereCondition="AND WAREHOUSE_ID IN (SELECT WAREHOUSE_ID  FROM INVENTORY_WAREHOUSES "
						 +" WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()+")  ORDER BY FIRST_NAME";
			}//if user type is admin and lio moh role and warehouse id  is selected
			else if(userTypeId.equals("148433") && (roleId.equals("5004") || roleId.equals("5005"))){
				whereCondition=" AND WAREHOUSE_ID  = "+warehouseId;
			}//if user type is admin and lio moh role and warehouse id  is null 
			else if(userTypeId.equals("148433") && (roleId.equals("5003") || roleId.equals("5006") || roleId.equals("5007"))){
				whereCondition=" AND WAREHOUSE_ID  =IFNULL("+warehouseId+","+userBean.getX_WAREHOUSE_ID()+")";
			}//if user type is employee and role cco and warehouse id  is null 
			else if(userTypeId.equals("148434") && warehouseId.equals("null")){
				whereCondition=" AND WAREHOUSE_ID IN (SELECT WAREHOUSE_ID  FROM INVENTORY_WAREHOUSES "
						 +" WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()+")  ORDER BY FIRST_NAME";
			}//if user type is employee and role cco and warehouse id  is selected
			else if(userTypeId.equals("148434") && !warehouseId.equals("null")){
				whereCondition=" AND WAREHOUSE_ID =IFNULL( "+warehouseId+",WAREHOUSE_ID)";
			}
		}else if(userBean.getX_ROLE_NAME().equals("NTO")){
			whereCondition=" AND WAREHOUSE_ID =IFNULL( "+warehouseId+",WAREHOUSE_ID)";
		}else if(userBean.getX_ROLE_NAME().equals("LIO")
				|| userBean.getX_ROLE_NAME().equals("MOH")){
			String roleNameForConditon=userBean.getX_ROLE_NAME().equals("LIO")?"MOH":"LIO";
			whereCondition="AND  WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID() 
					+" AND ROLE_ID <> (SELECT ROLE_ID FROM ADM_ROLES WHERE ROLE_NAME = '"+roleNameForConditon+"')" ;
		}
		 x_query+=whereCondition;
		JSONArray array = null;
		try {
			SQLQuery query = session.createSQLQuery(x_query);
			query.setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP);
			List resultlist = query.list();
			array = GetJsonResultSet.getjson(resultlist);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return array;
		}
	
	
//	public JSONArray getCCEHistory(String user_id) {
//		System.out.println("-- CCEService.getCCEHistory() mehtod called: -- ");
//		Session session = sf1.openSession();
//		String x_query="";
//		x_query="SELECT (SELECT CONCAT(IFNULL(CUSR.FIRST_NAME,'not available'),' ',IFNULL(CUSR.LAST_NAME,'')) "
//				+"FROM ADM_USERS CUSR WHERE CUSR.USER_ID = (SELECT C.CREATED_BY  "
//				+"  FROM ADM_USERS C WHERE C.USER_ID = "+user_id+")) CREATED_BY,  "
//				+"  (SELECT CONCAT(IFNULL(UUSR.FIRST_NAME,'not available'),' ', "
//				+"   IFNULL(UUSR.LAST_NAME,''))  "
//				+"     FROM ADM_USERS UUSR WHERE UUSR.USER_ID = (SELECT U.UPDATED_BY "
//				+"       FROM ADM_USERS U WHERE U.USER_ID = "+user_id+")) UPDATED_BY,"
//				+"        DATE_FORMAT(MNTB.CREATED_ON,'%b %d %Y %h:%i %p') CREATED_ON, "
//				+"         DATE_FORMAT(MNTB.LAST_UPDATED_ON,'%b %d %Y %h:%i %p') LAST_UPDATED_ON  "
//				+"FROM ADM_USERS MNTB  WHERE MNTB.USER_ID =" +user_id;
//		JSONArray array = null;
//		try {
//			SQLQuery query = session.createSQLQuery(x_query);
//			query.setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP);
//			List resultlist = query.list();
//			array = GetJsonResultSet.getjson(resultlist);
//		} catch (Exception e) {
//			e.printStackTrace();
//		} finally {
//			session.close();
//		}
//		return array;
//		}
//	public int passwordChange(String user_id, String newPassword,String oldPassword) {
//		Session session = sf1.openSession();
//		session.beginTransaction();
//		String x_query="";
//		int result=0;
//		try {
//			x_query="UPDATE ADM_USERS "
//					+ "SET PASSWORD='"+newPassword+"', SYNC_FLAG='N' "
//					+ "WHERE USER_ID="+user_id+" AND PASSWORD='"+oldPassword+"'";
//			SQLQuery query = session.createSQLQuery(x_query);
//			 result=query.executeUpdate();
//			 session.getTransaction().commit();
//		} catch (Exception e) {
//			e.printStackTrace();
//		} finally {
//			session.close();
//		}
//		return result;
//	}
	public int saveCCEAddEdit(CCEBeanForCCEForm bean, String action,AdmUserV userBean) {
		int insertupdateadmCCEFlag = 0;
//		int insertupdateRolemapingFlag = 0;
//		int insertupdateWarehouseAssimgmentFlag = 0;
		int insetUpdateCCEFlag = 0;
		String x_QUERY="";
		Session session = sf1.openSession();
                String facilityId="";
		session.beginTransaction();
		try {
			if (action.equals("add")) {
				x_QUERY="INSERT INTO E003"
                                                                + " (FACILITY_ID, " //1
                                                                + "DEVICE_SERIAL_NO, " //2
                                                                + "CCE_ID, " //3
                                                                + "DATE_NF, " //4
                                                                + "STATUS, " //5
                                                                + "DECISION, " //6
                                                                + "YEAR_OF_ACQUISITION, " //7
                                                                + "SOURCE_OF_CCE, " //8
                                                                + "LOCATION, " //9
                                                                + "UPDATED_BY, " //10
                                                                + "LAST_UPDATED_ON, "
                                                                + "CREATED_BY, " //11
                                                                + "CREATED_ON ) "
								+ " VALUES(?,?,(SELECT CCE_ID FROM CCE_LIST WHERE MODEL =?),STR_TO_DATE(?,'%d-%m-%Y'),?,?,?,?,?,?,NOW(),?,NOW())";
			}else{
				x_QUERY="UPDATE E003 SET "
                                                                + "FACILITY_ID=?, " //1
                                                                + "DEVICE_SERIAL_NO=?, " //2
                                                                + "CCE_ID=(SELECT CCE_ID FROM CCE_LIST WHERE MODEL =?), " //3
                                                                + "DATE_NF=STR_TO_DATE(?,'%d-%m-%Y'), " //4
                                                                + "STATUS=?, " //5
                                                                + "DECISION=?, " //6
                                                                + "YEAR_OF_ACQUISITION=?, " //7
                                                                + "SOURCE_OF_CCE=?, " //8
                                                                + "LOCATION=?, " //9
                                                                + "UPDATED_BY=?, " //10
                                                                + "LAST_UPDATED_ON=NOW()" 
								+ " WHERE CCE_DATA_ID=?";//11
			}
			SQLQuery query = session.createSQLQuery(x_QUERY);
//                        query.setParameter(0, facilityId);
                        query.setParameter(0, bean.getX_CCE_FACILITY_ID());
			query.setParameter(1, bean.getX_CCE_SERIAL_NO());
			query.setParameter(2, bean.getX_CCE_MODEL());
			query.setParameter(3, bean.getX_CCE_DATE_NF());
			query.setParameter(4, bean.getX_CCE_STATUS());
			query.setParameter(5, bean.getX_CCE_DECISION());
			query.setParameter(6, bean.getX_CCE_MONTH_OF_ACQUISITION()+"/"+bean.getX_CCE_YEAR_OF_ACQUISITION());
			query.setParameter(7, bean.getX_CCE_SOURCE());
			query.setParameter(8, bean.getX_CCE_LOCATION());
                        query.setParameter(9,userBean.getX_USER_ID());
			if (action.equals("add")) {		
				query.setParameter(10, userBean.getX_USER_ID());	
				
			}else{
				query.setParameter(10, bean.getX_CCE_DATA_ID());	
			}
			insertupdateadmCCEFlag = query.executeUpdate();
//			insertupdateRolemapingFlag = saveSetRoleIDMapping(bean, action, userBean, session);
//			insertupdateWarehouseAssimgmentFlag = setWarehouseIdAssingment(bean, action, userBean, session);
			if (insertupdateadmCCEFlag == 1) {
				session.getTransaction().commit();
				insetUpdateCCEFlag = 1;
			} else {
				session.getTransaction().rollback();
			}

		} catch (Exception e) {
			e.printStackTrace();
			session.getTransaction().rollback();
		} finally {
			session.close();
		}
		return insetUpdateCCEFlag;
	}
	
//	public int saveSetRoleIDMapping(CCEBeanForCCEForm bean, String action, AdmUserV userBean, Session session) {
//		int result=0;
//		String x_QUERY="";
//		try {
//			if (action.equals("add")) {
//				x_QUERY="INSERT INTO ADM_USER_ROLE_MAPPINGS "
//						+ "	(  	  STATUS, "
//						+ "		 START_DATE, " //0
//						+ "		 END_DATE," //1
//						+ "		 SYNC_FLAG,"  
//						+ "        WAREHOUSE_ID,"//2
//						+ "        USER_ID,"//3
//						+ " ROLE_ID,"//4
//						+ "		COMPANY_ID) "
//						+ "		VALUES ('A',?,?,'N',?,?,?,21000)";
//			}else{
//				x_QUERY="UPDATE ADM_USER_ROLE_MAPPINGS SET "
//						+ "	STATUS='A', "
//						+ "	START_DATE=?, "//0
//						+ "	END_DATE=?,"//1
//						+ "	SYNC_FLAG='N' "
//						+ " WHERE USER_ID=?";//2
//			}
//			SQLQuery query = session.createSQLQuery(x_QUERY);
//			query.setParameter(0, CalendarUtil.getDateStringInMySqlInsertFormat(bean.getX_START_DATE())+ " " + CalendarUtil.getCurrentTime());
//			if (bean.getX_END_DATE() == null || bean.getX_END_DATE().equals("")) {
//				query.setParameter(1, null);
//			} else {
//				query.setParameter(1, CalendarUtil.getDateStringInMySqlInsertFormat(bean.getX_END_DATE())+ " " + CalendarUtil.getCurrentTime());
//			}
//			if(action.equals("add")){
//				query.setParameter(2, bean.getX_ASSIGN_LGA_ID());
//				lastInsertCCEId=getLastInsertCCEID(bean.getX_LOGIN_NAME(),bean.getX_ASSIGN_LGA_ID());
//				query.setParameter(3,lastInsertCCEId );
//				query.setParameter(4, bean.getX_USER_ROLE_ID());
//				
//			}else{
//				query.setParameter(2, bean.getX_USER_ID());
//			}
//			 result=query.executeUpdate();
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//		return result;
//	}
//	
//	public int setWarehouseIdAssingment(CCEBeanForCCEForm bean, String action, AdmUserV userBean, Session session) {
//		int result=0;
//		String x_QUERY="";
//		try {
//			if (action.equals("add")) {
//				x_QUERY="INSERT INTO ADM_USER_WAREHOUSE_ASSIGNMENTS "
//						+ "		 (COMPANY_ID, "
//						+ "		 START_DATE, "// 0
//						+ "		 END_DATE,"// 1
//						+ "        STATUS,"// 
//						+ "       CREATED_ON,"
//						+ "       UPDATED_BY,"// 2
//						+ "       LAST_UPDATED_ON,"
//						+ "		SYNC_FLAG,"
//						+ "		  WAREHOUSE_ID, "// 3
//						+ "		  USER_ID,	"// 4
//						+ "		 CREATED_BY)"// 5) "
//						+ "		VALUES (21000,?,?,'A',now(),?,now(),'N',?,?,?) ";
//			}else{
//				x_QUERY="UPDATE ADM_USER_WAREHOUSE_ASSIGNMENTS SET "
//						+ "		 COMPANY_ID=21000, "
//						+ "		 START_DATE=?, "// 0
//						+ "		 END_DATE=?,"// 1
//						+ "        STATUS='A',"// 
//						+ "       UPDATED_BY=?,"// 2
//						+ "       LAST_UPDATED_ON=now(),"
//						+ "		SYNC_FLAG='N' " + " WHERE USER_ID=?";// 3
//			}
//			SQLQuery query = session.createSQLQuery(x_QUERY);
//			if (action.equals("add")) {
//				query.setParameter(3, bean.getX_ASSIGN_LGA_ID());
//				query.setParameter(4, lastInsertCCEId);
//				query.setParameter(5, userBean.getX_USER_ID());
//			}else{
//				query.setParameter(3, bean.getX_USER_ID());
//			}
//			query.setParameter(0, CalendarUtil.getDateStringInMySqlInsertFormat(bean.getX_START_DATE()) + " "
//					+ CalendarUtil.getCurrentTime());
//			if (bean.getX_END_DATE() == null || bean.getX_END_DATE().equals("")) {
//				query.setParameter(1, null);
//			} else {
//				query.setParameter(1, CalendarUtil.getDateStringInMySqlInsertFormat(bean.getX_END_DATE()) + " "
//						+ CalendarUtil.getCurrentTime());
//				
//			}
//			query.setParameter(2, userBean.getX_USER_ID());
//			 result=query.executeUpdate();
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//		return result;
//	}
//	
	public String getLastInsertCCEID(String user_name,String warehouse_id) {
		Session session = sf1.openSession();
		try {
			SQLQuery query = session.createSQLQuery("Select USER_ID from adm_users"
					+ " Where LOGIN_NAME='"+user_name+"'  AND WAREHOUSE_ID="+warehouse_id+ " AND STATUS='A'");
			query.setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP);
			List resultlist = query.list();
			if (resultlist.size()==1) {
				HashMap<String, String> row=(HashMap) resultlist.get(0);
				System.out.println("last insert CCE Id is"+String.valueOf(row.get("USER_ID")));
				return String.valueOf(row.get("USER_ID"));
			} else
				return null;
		} catch (HibernateException e) {
			return null;
		} finally {
			session.close();
		}
	}
}
