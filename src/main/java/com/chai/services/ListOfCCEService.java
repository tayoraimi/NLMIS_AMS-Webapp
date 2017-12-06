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
import com.chai.model.ListOfCCEBeanForListOfCCEForm;
import com.chai.model.views.AdmUserV;
import com.chai.util.CalendarUtil;
import com.chai.util.GetJsonResultSet;

public class ListOfCCEService {
	private static Logger logger = Logger.getLogger(ListOfCCEService.class);
	String lastInsertListOfCCEId="";
	SessionFactory sf1 = HibernateSessionFactoryClass.getSessionAnnotationFactory();
	public  JSONArray getListOfCCEListPageData(AdmUserV userBean) {
		System.out.println("-- ListOfCCEService.getListOfCCEListPageData mehtod called: -- ");
		Session session = sf1.openSession();
		String warehoseRole=userBean.getX_ROLE_NAME();
		String x_query="";
//		if(warehoseRole.equals("NTO")){
		 x_query="SELECT `CCE_ID`,"
                         + " `MODEL`,"
                         + " `DESIGNATION`,"
                         + " `CATEGORY`,"
                         + " `COMPANY`,"
                         + " `REFRIGERANT`,"
                         + " `VOL_NEG`,"
                         + " `VOL_POS`,"
                         + " `EXPECTED_WORKING_LIFE`,"
                         + " `PRICE`,"
                         + " `TYPE`,"
                         + " `ENERGY_SOURCE`,"
                         + " `CREATED_BY`,"
                         + " DATE_FORMAT(CREATED_ON, '%d-%b-%Y') CREATED_ON,"
                         + " `UPDATED_BY`,"
                         + " DATE_FORMAT(UPDATED_ON, '%d-%b-%Y') UPDATED_ON"
                         + " FROM `cce_list` WHERE 1"
                         + " ORDER BY CCE_ID DESC";
                                
//		}
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
	
	public int saveListOfCCEAddEdit(ListOfCCEBeanForListOfCCEForm bean, String action,AdmUserV userBean) {
		int insertupdateadmListOfCCEFlag = 0;
//		int insertupdateRolemapingFlag = 0;
//		int insertupdateWarehouseAssimgmentFlag = 0;
		int insetUpdateListOfCCEFlag = 0;
		String x_QUERY="";
		Session session = sf1.openSession();
		session.beginTransaction();
		try {
			if (action.equals("add")) {
				x_QUERY="INSERT INTO `cce_list`"
                                                                + "(`MODEL`, "
                                                                + "`DESIGNATION`, "
                                                                + "`CATEGORY`, "
                                                                + "`COMPANY`, "
                                                                + "`REFRIGERANT`, "
                                                                + "`VOL_NEG`, "
                                                                + "`VOL_POS`, "
                                                                + "`EXPECTED_WORKING_LIFE`, "
                                                                + "`PRICE`, "
                                                                + "`TYPE`, "
                                                                + "`ENERGY_SOURCE`, "
                                                                + "`UPDATED_BY`, "
                                                                + "`UPDATED_ON`, "
                                                                + "`CREATED_BY`, "
                                                                + "`CREATED_ON` ) "
                                                                + " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,NOW(),?,NOW())";
			}else{
				x_QUERY="UPDATE `cce_list` SET "
                                                                + "`MODEL`=?,"
                                                                + "`DESIGNATION`=?,"
                                                                + "`CATEGORY`=?,"
                                                                + "`COMPANY`=?,"
                                                                + "`REFRIGERANT`=?,"
                                                                + "`VOL_NEG`=?,"
                                                                + "`VOL_POS`=?,"
                                                                + "`EXPECTED_WORKING_LIFE`=?,"
                                                                + "`PRICE`=?,"
                                                                + "`TYPE`=?,"
                                                                + "`ENERGY_SOURCE`=?,"
                                                                + "`UPDATED_BY`=?,"
                                                                + "`UPDATED_ON`= NOW()"
                                                                + " WHERE `CCE_ID`=?";
			}
			SQLQuery query = session.createSQLQuery(x_QUERY);
                        query.setParameter(0, bean.getX_ListOfCCE_MODEL());
			query.setParameter(1, bean.getX_ListOfCCE_DESIGNATION());
			query.setParameter(2, bean.getX_ListOfCCE_CATEGORY());
			query.setParameter(3, bean.getX_ListOfCCE_COMPANY());
			query.setParameter(4, bean.getX_ListOfCCE_REFRIGERANT());
			query.setParameter(5, bean.getX_ListOfCCE_VOL_NEG());
			query.setParameter(6, bean.getX_ListOfCCE_VOL_POS());
			query.setParameter(7, bean.getX_ListOfCCE_EXPECTED_WORKING_LIFE());
			query.setParameter(8, bean.getX_ListOfCCE_PRICE());
                        query.setParameter(9, bean.getX_ListOfCCE_TYPE());
                        query.setParameter(10, bean.getX_ListOfCCE_ENERGY_SOURCE());
                        query.setParameter(11, userBean.getX_USER_ID());
			if (action.equals("add")) {
                                query.setParameter(12, userBean.getX_USER_ID());
			}else{
                                query.setParameter(12, bean.getX_ListOfCCE_CCE_ID());	
			}
                        System.out.println("This is the query "+x_QUERY);
			insertupdateadmListOfCCEFlag = query.executeUpdate();
//			insertupdateRolemapingFlag = saveSetRoleIDMapping(bean, action, userBean, session);
//			insertupdateWarehouseAssimgmentFlag = setWarehouseIdAssingment(bean, action, userBean, session);
			if (insertupdateadmListOfCCEFlag == 1) {
				session.getTransaction().commit();
				insetUpdateListOfCCEFlag = 1;
			} else {
				session.getTransaction().rollback();
			}

		} catch (Exception e) {
			e.printStackTrace();
			session.getTransaction().rollback();
		} finally {
			session.close();
		}
		return insetUpdateListOfCCEFlag;
	}
	
	public String getLastInsertListOfCCEID(String user_name,String warehouse_id) {
		Session session = sf1.openSession();
		try {
			SQLQuery query = session.createSQLQuery("Select USER_ID from adm_users"
					+ " Where LOGIN_NAME='"+user_name+"'  AND WAREHOUSE_ID="+warehouse_id+ " AND STATUS='A'");
			query.setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP);
			List resultlist = query.list();
			if (resultlist.size()==1) {
				HashMap<String, String> row=(HashMap) resultlist.get(0);
				System.out.println("last insert ListOfCCE Id is"+String.valueOf(row.get("USER_ID")));
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
