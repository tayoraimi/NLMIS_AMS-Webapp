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

public class AMSChartServices {
	SessionFactory sf = HibernateSessionFactoryClass.getSessionAnnotationFactory();

	public JSONArray getFunctionalChartData(AdmUserV userBean, String filterLevel) {
		System.out.println("-- AMSDashboardServices.getFunctionalChartData() mehtod called: facID=-- "+userBean.getX_WAREHOUSE_ID());
		JSONArray array = new JSONArray();
		Session session = sf.openSession();
		try {
//			String x_query = "SELECT STATE_ID, STATE, LGA_ID, LGA, WARD,"
//                        + " FACILITY_ID, WAREHOUSE_TYPE_ID, LOCATION,"
//                        + " DEFAULT_ORDERING_WAREHOUSE_ID,"
//                        String x_query = "SELECT STATE_ID, STATE, LGA_ID, LGA, WARD, WAREHOUSE_TYPE_ID, LOCATION,"
                        String x_query = "SELECT STATE, LGA, WARD,"
                                        + " SUM(F) AS tF, SUM(NF) AS tNF, SUM(NI) AS tNI, SUM(O_F) AS tO_F, SUM(O_NF) AS tO_NF, SUM(F)+SUM(NI) AS TOTAL"
                                        + " FROM view_cce_status_chart ";
                        String x_where_condition = " WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()
                        + " OR FACILITY_ID = "+userBean.getX_WAREHOUSE_ID()
                        +" OR DEFAULT_ORDERING_WAREHOUSE_ID IN ( SELECT FACILITY_ID FROM view_all_facilities WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()+")";
                        x_query = x_query+x_where_condition;
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
  
        public JSONArray getFunctionalPISData(AdmUserV userBean, String filterLevel) {
		System.out.println("-- AMSDashboardServices.getFunctionalPISData() method called: facID=-- "+userBean.getX_WAREHOUSE_ID());
                
		JSONArray array = new JSONArray();
		Session session = sf.openSession();
		try {
                        String x_query = "SELECT STATE, LGA, WARD,"
                                        + " SUM(F) AS `functional`, SUM(R) AS `repair`, SUM(NI) AS `not_installed`, SUM(O_F) AS `functional_obsolete`, SUM(O_NF) AS `not_functional_obsolete`, SUM(F)+SUM(NI) AS TOTAL, TYPE"
                                        + " FROM view_cce_status_chart ";
                        String x_where_condition = " WHERE (TYPE = 'PIS/PQS electrical' OR TYPE = 'PIS/PQS Solar' OR TYPE = 'Absorption')  AND (DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()
                        + " OR FACILITY_ID = "+userBean.getX_WAREHOUSE_ID()
                        +" OR DEFAULT_ORDERING_WAREHOUSE_ID IN ( SELECT FACILITY_ID FROM view_all_facilities WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()+"))";
                        x_query = x_query+x_where_condition;
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
        
        public JSONArray getFunctionalDomesticData(AdmUserV userBean, String filterLevel) {
		System.out.println("-- AMSDashboardServices.getFunctionalPISData() method called: facID=-- "+userBean.getX_WAREHOUSE_ID());
                
		JSONArray array = new JSONArray();
		Session session = sf.openSession();
		try {
                        String x_query = "SELECT STATE, LGA, WARD,"
                                        + " SUM(F) AS `functional`, SUM(R) AS `repair`, SUM(NI) AS `not_installed`, SUM(O_F) AS `functional_obsolete`, SUM(O_NF) AS `not_functional_obsolete`, SUM(F)+SUM(NI) AS TOTAL, TYPE"
                                        + " FROM view_cce_status_chart ";
                        String x_where_condition = " WHERE (TYPE = 'Domestic - Electrical' OR TYPE = 'Domestic - Solar')  AND (DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()
                        + " OR FACILITY_ID = "+userBean.getX_WAREHOUSE_ID()
                        +" OR DEFAULT_ORDERING_WAREHOUSE_ID IN ( SELECT FACILITY_ID FROM view_all_facilities WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()+"))";
                        x_query = x_query+x_where_condition;
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
        
        public JSONArray getTypeOfCCEData(AdmUserV userBean, String filterLevel) {
		System.out.println("-- AMSDashboardServices.getTypeOfCCEData() method called: facID=-- "+userBean.getX_WAREHOUSE_ID());
                
		JSONArray array = new JSONArray();
		Session session = sf.openSession();
		try {
                        String x_query = "SELECT STATE, LGA, WARD,"
                                        + " SUM(IF(TYPE = 'PIS/PQS electrical' OR TYPE = 'PIS/PQS Solar'"
                                        + " OR TYPE = 'Absorption' OR TYPE = 'PIS/PQS',SUM(F)+SUM(NI)+SUM(NF)+SUM(O_F)+SUM(O_NF),0)) AS `qualified`,"
                                        + " SUM(IF(TYPE = 'Domestic - Electrical' OR TYPE = 'Domestic - Solar'"
                                        + " OR TYPE = 'Absorption',SUM(F)+SUM(NI)+SUM(NF)+SUM(O_F)+SUM(O_NF),0)) AS `domestic`"
                                        + " FROM view_cce_status_chart ";
                        String x_where_condition = " WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()
                        + " OR FACILITY_ID = "+userBean.getX_WAREHOUSE_ID()
                        +" OR DEFAULT_ORDERING_WAREHOUSE_ID IN ( SELECT FACILITY_ID FROM view_all_facilities WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()+")";
                        x_query = x_query+x_where_condition;
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
        
        public JSONArray getTypeOfSolarData(AdmUserV userBean, String filterLevel) {
		System.out.println("-- AMSDashboardServices.getTypeOfSolarData() method called: facID=-- "+userBean.getX_WAREHOUSE_ID());
                
		JSONArray array = new JSONArray();
		Session session = sf.openSession();
		try {
                        String x_query = "SELECT STATE, LGA, WARD,"
                                        + " SUM(IF(TYPE = 'PIS/PQS Solar',SUM(F)+SUM(NI)+SUM(NF)+SUM(O_F)+SUM(O_NF),0)) AS `qualified`,"
                                        + " SUM(IF(TYPE = 'Domestic - Solar',SUM(F)+SUM(NI)+SUM(NF)+SUM(O_F)+SUM(O_NF),0)) AS `domestic`"
                                        + " FROM view_cce_status_chart ";
                        String x_where_condition = " WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()
                        + " OR FACILITY_ID = "+userBean.getX_WAREHOUSE_ID()
                        +" OR DEFAULT_ORDERING_WAREHOUSE_ID IN ( SELECT FACILITY_ID FROM view_all_facilities WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()+")";
                        x_query = x_query+x_where_condition;
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
        
        public JSONArray getWardWithSolarData(AdmUserV userBean, String filterLevel) {
		System.out.println("-- AMSDashboardServices.getWardWithSolarData() method called: facID=-- "+userBean.getX_WAREHOUSE_ID());
                
		JSONArray array = new JSONArray();
		Session session = sf.openSession();
		try {
                        String x_query = "SELECT LG_NAME"
                                + ", SUM(F_SOLAR) as FUNCTIONAL_SR"
                                + ", SUM(R_SOLAR) AS REPAIRABLE_SR"
                                + ", SUM(OTHER_CCE) AS WITHOUT_SR"
                                + " FROM `view_cce_ward_data` ";
                        String x_where_condition = " WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()
                        + " OR FACILITY_ID = "+userBean.getX_WAREHOUSE_ID()
                        +" OR DEFAULT_ORDERING_WAREHOUSE_ID IN ( SELECT FACILITY_ID FROM view_all_facilities WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()+")";
                        x_query = x_query+x_where_condition;
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
        
        public JSONArray getWardWithOtherCCEData(AdmUserV userBean, String filterLevel) {
		System.out.println("-- AMSDashboardServices.getWardWithOtherCCEData() method called: facID=-- "+userBean.getX_WAREHOUSE_ID());
                
		JSONArray array = new JSONArray();
		Session session = sf.openSession();
		try {
                        String x_query = "SELECT LG_NAME"
                                + ", SUM(F_SOLAR) as FUNCTIONAL_SR"
                                + ", SUM(NF_SOLAR) AS REPAIRABLE_SR"
                                + ", SUM(OTHER_CCE) AS WITHOUT_SR"
                                + ", SUM(NO_CCE) AS WITHOUT_SR"
                                + " FROM `view_cce_ward_data` ";
                        String x_where_condition = " WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()
                        + " OR FACILITY_ID = "+userBean.getX_WAREHOUSE_ID()
                        +" OR DEFAULT_ORDERING_WAREHOUSE_ID IN ( SELECT FACILITY_ID FROM view_all_facilities WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID()+")";
                        x_query = x_query+x_where_condition;
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
        
        public JSONArray getLGACapacityData(AdmUserV userBean, String filterLevel) {
		System.out.println("-- AMSDashboardServices.getLGACapacityData() method called: facID=-- "+userBean.getX_WAREHOUSE_ID());
                
		JSONArray array = new JSONArray();
		Session session = sf.openSession();
		try {
                        String x_query = "SELECT `LGA_ID` AS `id`, `LGA` AS `lga`, year(NOW())-1 AS `year`, `ICAR`, `AC`, `CRIC`, `WMEN_A`, `WROTA`, `WMR`, `WHPV`"
                                + " FROM `view_cce_state_lga_capacity_chart` ";
                        String x_where_condition = " WHERE SUPPLY_CHAIN_LEVEL = 'LGA'"
                                + " AND DEFAULT_ORDERING_WAREHOUSE_ID = "+userBean.getX_WAREHOUSE_ID();
                        x_query = x_query+x_where_condition;
                     //   x_query = "SELECT `id`, `lga`, `year`, `ICAR`, `AC`, `CRIC`, `WMEN_A`, `WROTA`, `WMR`, `WHPV` FROM `lga_capacity` WHERE 1";
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
        
        public JSONArray getStateCapacityData(AdmUserV userBean, String filterLevel) {
		System.out.println("-- AMSDashboardServices.getStateCapacityData() method called: facID=-- "+userBean.getX_WAREHOUSE_ID());
                
		JSONArray array = new JSONArray();
		Session session = sf.openSession();
		try {
                        String x_query = "SELECT `LGA_ID` AS `id`, year(NOW())-1 AS `year`,"
                                + " `ICAR`, `AC`, `CRIC` AS `CRI`, `WMEN_A` AS `MEN_A`,"
                                + " `WROTA` AS `ROTA`, `WMR` AS `MR`,"
                                + " `WHPV` AS `HPV` FROM `view_cce_state_lga_capacity_chart`";
                        String x_where_condition = " WHERE SUPPLY_CHAIN_LEVEL = 'STATE'"
                                + " AND FACILITY_ID = "+userBean.getX_WAREHOUSE_ID();
                        x_query = x_query+x_where_condition;
                       // x_query = "SELECT `id`, `year`, `ICAR`, `AC`, `CRI`, `MEN_A`, `ROTA`, `MR`, `HPV` FROM `state_capacity_` WHERE 1";
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
	
}
			
