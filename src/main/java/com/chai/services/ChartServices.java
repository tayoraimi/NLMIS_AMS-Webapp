package com.chai.services;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Iterator;

import org.apache.log4j.Logger;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Repository;

import com.chai.hibernartesessionfactory.HibernateSessionFactoryClass;
import com.chai.model.views.AdmUserV;
import com.chai.util.GetJsonResultSet;

@Repository
public class ChartServices {
	Logger logger=Logger.getLogger(ChartServices.class);
	SessionFactory sf = HibernateSessionFactoryClass.getSessionAnnotationFactory();

	public JSONArray getLGAStockPerfData(AdmUserV userBean,String lgaid){
		System.out.println("-- ChartServices.getLGAStockPerfData() method called: facID=-- "+userBean.getX_WAREHOUSE_ID());
                
		JSONArray array = new JSONArray();
		Session session = sf.openSession();
		try {
                        String x_query = "SELECT SUM(SUFFICIENT_STOCK_TOTAL_HF_PER) AS 'status_green',"
                                + " SUM(LESS_3_ANTIGENS_TOTAL_HF_PER) AS 'status_yellow',"
                                + " SUM(GREATER_2_ANTIGENS_TOTAL_HF_PER) AS 'status_red',"
                                + " SUM(IF(STATE_ID!=0,1,0)) AS 'denom',"
                                + " 0  AS 'status_blue'"
                                + " FROM lga_stock_performance_dashboard_v";
                        String x_where_condition = " WHERE STATE_ID = "+userBean.getX_WAREHOUSE_ID()
                                + " AND STOCK_RECEIVED_WEEK = WEEK(NOW())"
                                + " AND STOCK_RECEIVED_YEAR = YEAR(NOW())";
                        x_query = x_query+x_where_condition;
                        System.out.println("x_query getLGAStockPerfData "+x_query);
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
        
	public JSONArray getHFStockPerfData(AdmUserV userBean,String lgaid){
		System.out.println("-- ChartServices.getHFStockPerfData() method called: facID=-- "+userBean.getX_WAREHOUSE_ID());
                
		JSONArray array = new JSONArray();
		Session session = sf.openSession();
		try {
                        String x_query = "SELECT  LGA_NAME,"
                                + " SUM(IF(LEGEND_FLAG='G',1,0)) AS 'status_green',"
                                + " SUM(IF(LEGEND_FLAG='Y',1,0)) AS 'status_yellow',"
                                + " SUM(IF(LEGEND_FLAG='R',1,0)) AS 'status_red',"
                                + " SUM(IF(LEGEND_FLAG='B',1,0)) AS 'status_blue'"
                                + " FROM hf_stock_performance_dashbord_v";
                        String x_where_condition = " WHERE STATE_ID = "+userBean.getX_WAREHOUSE_ID()
                                + " AND VACCINE_FLAG = 'Y'"
                                + " AND STOCK_RECEIVED_WEEK = WEEK(NOW())"
                                + " AND STOCK_RECEIVED_YEAR = YEAR(NOW())"
                                + " GROUP BY LGA_NAME";
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
	
}