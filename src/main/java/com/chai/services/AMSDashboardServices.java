package com.chai.services;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.json.JSONArray;
import org.json.JSONObject;

import com.chai.hibernartesessionfactory.HibernateSessionFactoryClass;
import com.chai.model.views.AdmUserV;
import com.chai.util.GetJsonResultSet;

public class AMSDashboardServices {
	SessionFactory sf = HibernateSessionFactoryClass.getSessionAnnotationFactory();

        public JSONArray getMergedDashboardData(AdmUserV userBean, String filterLevel, String aggLevel) {
		System.out.println("-- AMSDashboardServices.getMergedDashboardData() mehtod called: facID=-- "+userBean.getX_WAREHOUSE_ID());
		JSONArray array = new JSONArray();
		Session session = sf.openSession();
		try {
//			String x_query = "SELECT STATE_ID, STATE, LGA_ID, LGA, WARD,"
//                        + " FACILITY_ID, WAREHOUSE_TYPE_ID, LOCATION,"
//                        + " DEFAULT_ORDERING_WAREHOUSE_ID,"
                    System.out.println("Filter for Merged Dashboard "+filterLevel);
                    String x_query = "SELECT cv.STATE, cv.LGA, cv.WARD,"
                        + " CAST(CONCAT(SUM(cv.RI_A),'/',SUM(cv.RI_R)) AS CHAR)AS RI,"
                        + " CAST(CONCAT(SUM(cv.MEN_A_A),'/',SUM(cv.MEN_A_R)) AS CHAR) AS MEN_A,"
                        + " CAST(CONCAT(SUM(cv.ROTA_A),'/',SUM(cv.ROTA_R)) AS CHAR) AS ROTA,"
                        + " CAST(CONCAT(SUM(cv.MR_A),'/',SUM(cv.MR_R)) AS CHAR) AS MR,"
                        + " CAST(CONCAT(SUM(cv.HPV_A),'/',SUM(cv.HPV_R)) AS CHAR) AS HPV,"
                        + " SUM(fv.F) AS tF, SUM(fv.NF) AS tNF, SUM(fv.NI) AS tNI, SUM(fv.O_F) AS tO_F, SUM(fv.O_NF) AS tO_NF, SUM(fv.F)+SUM(fv.NI) AS TOTAL"
                        + " FROM view_cce_status_dashboard fv JOIN view_cce_capacity_dashboard cv"
                        + " ON fv.FACILITY_ID = cv.FACILITY_ID";
                        String x_where_condition = " WHERE cv.SUPPLY_CHAIN_LEVEL= '"+((aggLevel.equals("WARD"))?"HF":aggLevel)+"'"+ ((filterLevel.equals(""))?"":" AND cv."+((filterLevel.equalsIgnoreCase("National"))?"STATE":filterLevel)+" IS NOT NULL")+" AND (cv.DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()
                        + " OR cv.FACILITY_ID = "+userBean.getX_WAREHOUSE_ID()
                        +" OR cv.DEFAULT_ORDERING_WAREHOUSE_ID IN ( SELECT FACILITY_ID FROM view_all_facilities WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()+"))";
                        x_query = x_query+x_where_condition+" GROUP BY"+((filterLevel.equalsIgnoreCase("National"))?" DEFAULT_ORDERING_WAREHOUSE_ID":" "+filterLevel);
		
			Transaction tx = null;
			tx = session.beginTransaction();
			SQLQuery query = session.createSQLQuery(x_query);
			query.setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP);
                        List resultlist = query.list();

			array = GetJsonResultSet.getjson(resultlist);
		} catch (HibernateException e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return array;
	}
	
	public JSONArray getCapacityDashboardData(AdmUserV userBean, String filterLevel, String aggLevel) {
		System.out.println("-- AMSDashboardServices.getCapacityDashboardData() mehtod called: facID=-- "+userBean.getX_WAREHOUSE_ID());
		JSONArray array = new JSONArray();
		Session session = sf.openSession();
		try {
//			String x_query = "SELECT STATE_ID, STATE, LGA_ID, LGA, WARD,"
//                        + " FACILITY_ID, WAREHOUSE_TYPE_ID, LOCATION,"
//                        + " DEFAULT_ORDERING_WAREHOUSE_ID,"
                    System.out.println("Filter for Capacity "+filterLevel);
                    String x_query = "SELECT STATE, LGA, WARD,"
//                        + " SUM(RI_A) AS RI,"
                        + " CAST(CONCAT(SUM(RI_A),'/',SUM(RI_R)) AS CHAR)AS RI,"
                        + " CAST(CONCAT(SUM(MEN_A_A),'/',SUM(MEN_A_R)) AS CHAR) AS MEN_A,"
                        + " CAST(CONCAT(SUM(ROTA_A),'/',SUM(ROTA_R)) AS CHAR) AS ROTA,"
                        + " CAST(CONCAT(SUM(MR_A),'/',SUM(MR_R)) AS CHAR) AS MR,"
                        + " CAST(CONCAT(SUM(HPV_A),'/',SUM(HPV_R)) AS CHAR) AS HPV"
                        + " FROM view_cce_capacity_dashboard";
                        String x_where_condition = " WHERE SUPPLY_CHAIN_LEVEL= '"+((aggLevel.equals("WARD"))?"HF":aggLevel)+"'"+ ((filterLevel.equals(""))?"":" AND "+((filterLevel.equalsIgnoreCase("National"))?"STATE":filterLevel)+" IS NOT NULL")+" AND (DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()
                        + " OR FACILITY_ID = "+userBean.getX_WAREHOUSE_ID()
                        +" OR DEFAULT_ORDERING_WAREHOUSE_ID IN ( SELECT FACILITY_ID FROM view_all_facilities WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()+"))";
                        x_query = x_query+x_where_condition+((filterLevel.equalsIgnoreCase("National"))?" GROUP BY STATE":" GROUP BY "+filterLevel);
		
//			if (userBean.getX_ROLE_NAME().toUpperCase().equals("NTO")) {
//                            
//                            
//                            x_query = x_query+x_where_condition+" GROUP BY "+(filterLevel.equals("")?"State":filterLevel);
//			} else if (userBean.getX_ROLE_NAME().toUpperCase().equals("NTO")) {
//                            x_query = x_query+x_where_condition+" GROUP BY "+(filterLevel.equals("")?"Ward":filterLevel);
//			} else if (userBean.getX_ROLE_NAME().toUpperCase().equals("SCCO")) {
//                            x_query = x_query+x_where_condition+" GROUP BY "+(filterLevel.equals("")?"LGA":filterLevel);
//			} else if (userBean.getX_ROLE_NAME().toUpperCase().equals("CCO")) {
//                            x_query = x_query+x_where_condition+" GROUP BY "+(filterLevel.equals("")?"Ward":filterLevel);
//			} else if (userBean.getX_ROLE_NAME().toUpperCase().equals("LIO")) {
//                            x_query = x_query+x_where_condition+" GROUP BY "+(filterLevel.equals("")?"Ward":filterLevel);
                            
                            
//			}

			Transaction tx = null;
			tx = session.beginTransaction();
			SQLQuery query = session.createSQLQuery(x_query);
			query.setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP);
                        List resultlist = query.list();
                        //                        Iterator iterator = resultlist.iterator();
//                        while (iterator.hasNext()) {
//                                Map map = (Map) iterator.next();
//                                System.out.println("HERE "+map.get("RI"));
//                                System.out.println(map.get("MEN_A"));
//                                System.out.println(map.get("ROTA"));
//                        }
//                        Map<String,Object> map= new HashMap<String,Object>();
//                        while (iterator.hasNext())
//                        {
//                        map= (Map<String,Object>)iterator.next();
//
//                                System.out.println("HERE "+map.get("RI"));
//
//                        }
			array = GetJsonResultSet.getjson(resultlist);
		} catch (HibernateException e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return array;
	}
	
	public JSONArray getFunctionalDashboardData(AdmUserV userBean, String filterLevel, String aggLevel) {
		System.out.println("-- AMSDashboardServices.getFunctionalDashboardData() mehtod called: facID=-- "+userBean.getX_WAREHOUSE_ID());
		JSONArray array = new JSONArray();
		Session session = sf.openSession();
		try {
//			String x_query = "SELECT STATE_ID, STATE, LGA_ID, LGA, WARD,"
//                        + " FACILITY_ID, WAREHOUSE_TYPE_ID, LOCATION,"
//                        + " DEFAULT_ORDERING_WAREHOUSE_ID,"
//                        String x_query = "SELECT STATE_ID, STATE, LGA_ID, LGA, WARD, WAREHOUSE_TYPE_ID, LOCATION,"
                        String x_query = "SELECT STATE, LGA, WARD,"
                                        + " SUM(F) AS tF, SUM(NF) AS tNF, SUM(NI) AS tNI, SUM(O_F) AS tO_F, SUM(O_NF) AS tO_NF, SUM(F)+SUM(NI) AS TOTAL"
                                        + " FROM view_cce_status_dashboard ";
                        String x_where_condition = " WHERE LOCATION= '"+((aggLevel.equals("WARD"))?"HF":aggLevel)+"'"+ ((filterLevel.equals(""))?"":" AND "+((filterLevel.equalsIgnoreCase("National"))?"STATE":filterLevel)+" IS NOT NULL")+" AND (DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()
                        + " OR FACILITY_ID = "+userBean.getX_WAREHOUSE_ID()
                        +" OR DEFAULT_ORDERING_WAREHOUSE_ID IN ( SELECT FACILITY_ID FROM view_all_facilities WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()+"))";
                        x_query = x_query+x_where_condition+" GROUP BY"+((filterLevel.equalsIgnoreCase("National"))?" DEFAULT_ORDERING_WAREHOUSE_ID":" "+filterLevel);
                        System.out.println("QUERY: "+x_query);
		
//			if (userBean.getX_ROLE_NAME().toUpperCase().equals("NTO")) {
//                            
//                            
//                            x_query = x_query+x_where_condition+" GROUP BY "+(filterLevel.equals("")?"State":filterLevel);
//			} else if (userBean.getX_ROLE_NAME().toUpperCase().equals("NTO")) {
//                            x_query = x_query+x_where_condition+" GROUP BY "+(filterLevel.equals("")?"WARD":filterLevel);
//			} else if (userBean.getX_ROLE_NAME().toUpperCase().equals("SCCO")) {
//                            x_query = x_query+x_where_condition+" GROUP BY "+(filterLevel.equals("")?"LGA":filterLevel);
//			} else if (userBean.getX_ROLE_NAME().toUpperCase().equals("CCO")) {
//                            x_query = x_query+x_where_condition+" GROUP BY "+(filterLevel.equals("")?"WARD":filterLevel);
//			} else if (userBean.getX_ROLE_NAME().toUpperCase().equals("LIO")) {
//                            x_query = x_query+x_where_condition+" GROUP BY "+(filterLevel.equals("")?"WARD":filterLevel);
//                            
//                            
//			}

			Transaction tx = null;
			tx = session.beginTransaction();
			SQLQuery query = session.createSQLQuery(x_query);
			query.setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP);
                        List resultlist = query.list();
//			List resultlist = query.list();
//                        Iterator iterator = resultlist.iterator();
//                        while (iterator.hasNext()) {
//                                Map map = (Map) iterator.next();
//                                System.out.println("HERE "+map.get("RI"));
//                                System.out.println(map.get("MEN_A"));
//                                System.out.println(map.get("ROTA"));
//                        }
//                        Map<String,Object> map= new HashMap<String,Object>();
//                        while (iterator.hasNext())
//                        {
//                        map= (Map<String,Object>)iterator.next();
//
//                                System.out.println("HERE "+map.get("RI"));
//
//                        }
			array = GetJsonResultSet.getjson(resultlist);
		} catch (HibernateException e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return array;
	}
	
}
			
