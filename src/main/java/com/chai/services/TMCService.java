/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
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
import com.chai.model.TMCBeanForTMCForm;
import com.chai.model.views.AdmUserV;
import com.chai.util.CalendarUtil;
import com.chai.util.GetJsonResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author Ayobami Akinyinka
 */
public class TMCService {

    private static Logger logger = Logger.getLogger(CCEService.class);
    String lastInsertCCEId = "";
    SessionFactory sf1 = HibernateSessionFactoryClass.getSessionAnnotationFactory();

    public static ArrayList<Object> validateTMCLogin(String x_LOGIN_NAME, String x_PASSWORD) {
        System.out.println("-- CCEService.validateTMCLogin() mehtod called: -- ");
        SessionFactory sf = HibernateSessionFactoryClass.getSessionAnnotationFactory();
        Session session = sf.openSession();

        String sql = "SELECT week(date_sub(now(),INTERVAL 1 WEEK)) AS PREVIOUS_WEEK_OF_YEAR, USER_ID, "
                + " COMPANY_ID, "
                + " FIRST_NAME, "
                + " LAST_NAME, "
                + " ROLE_ID, "
                + "	ROLE_NAME, "
                + "	USER_TYPE_ID, "
                + " USER_TYPE_CODE, "
                + " USER_TYPE_NAME,"
                + " WAREHOUSE_ID, "
                + "	WAREHOUSE_NAME "
                + " FROM ADM_USERS_V "
                + " WHERE LOGIN_NAME =:loginName "
                + "   AND PASSWORD =:password "
                + "   AND STATUS = 'A' "
                + " AND UPPER(ROLE_NAME) <> 'CCO' "
                + " AND USER_TYPE_ID = F_GET_TYPE('USER TYPES','ADMIN') ";
        AdmUserV userData = new AdmUserV();
        ArrayList<Object> loginListBeanAndTimebean = new ArrayList<>();
        try {
            SQLQuery query = session.createSQLQuery(sql);
            query.setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP);
            query.setParameter("loginName", x_LOGIN_NAME);
            query.setParameter("password", x_PASSWORD);
            List<AdmUserV> list = query.list();
            if (list.size() == 1) {
                for (Object object : list) {
                    Map row = (Map) object;
                    userData.setX_USER_ID((Integer) row.get("USER_ID"));
                    userData.setX_COMPANY_ID((Integer) row.get("COMPANY_ID"));
                    userData.setX_FIRST_NAME((String) row.get("FIRST_NAME"));
                    userData.setX_LAST_NAME((String) row.get("LAST_NAME"));
                    userData.setX_ROLE_ID((Integer) row.get("ROLE_ID"));
                    userData.setX_ROLE_NAME((String) row.get("ROLE_NAME"));
                    userData.setX_USER_TYPE_ID((Integer) row.get("USER_TYPE_ID"));
                    userData.setX_USER_TYPE_CODE((String) row.get("USER_TYPE_CODE"));
                    userData.setX_USER_TYPE_NAME((String) row.get("USER_TYPE_NAME"));
                    userData.setX_WAREHOUSE_ID((Integer) row.get("WAREHOUSE_ID"));
                    userData.setX_WAREHOUSE_NAME((String) row.get("WAREHOUSE_NAME"));
                    loginListBeanAndTimebean.add(userData);
                    loginListBeanAndTimebean.add(row.get("PREVIOUS_WEEK_OF_YEAR"));
                }
            }
            // System.out.println("list size "+list.size());
        } catch (Exception e) {
            loginListBeanAndTimebean = null;
            e.printStackTrace();
        } finally {
            session.close();
        }
        return loginListBeanAndTimebean;
    }

    public JSONArray getTMCListPageData(AdmUserV userBean) {
        System.out.println("-- TMCService.getTMCListPageData mehtod called: -- ");
        Session session = sf1.openSession();
        String warehoseRole = userBean.getX_ROLE_NAME();
        String x_query = "";
        if (warehoseRole.equals("SIO")
                || warehoseRole.equals("SIFP")
                || warehoseRole.equals("SCCO")) {
            x_query = "SELECT STATE_ID, "
                    + "STATE, "
                    + "LGA_ID, "
                    + "LGA, "
                    + "FACILITY_NAME, "
                    + "e004.FACILITY_ID, "
                    + "WARD, "
                    + "WAREHOUSE_TYPE_ID,"
                    + "DEFAULT_ORDERING_WAREHOUSE_ID, "
                    + "TMC_DATA_ID,"
                    + "LOCATION, "
                    + "FACILITY_HAS_ELECTRICITY, "
                    + "ELECTRICITY_HRS, "
                    + "DEVICE_AVAILABLE, "
                    + "TYPE_OF_DEVICE "
                    + "FROM e004 "
                    + "INNER JOIN view_all_facilities "
                    + "ON e004.FACILITY_ID=view_all_facilities.FACILITY_ID "
                    + " WHERE e004.FACILITY_ID = "
                    + userBean.getX_WAREHOUSE_ID()
                    + " OR DEFAULT_ORDERING_WAREHOUSE_ID = "
                    + userBean.getX_WAREHOUSE_ID()
                    + "  OR DEFAULT_ORDERING_WAREHOUSE_ID "
                    + " IN (SELECT FACILITY_ID FROM view_all_facilities WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "
                    + userBean.getX_WAREHOUSE_ID()
                    + ")  ORDER BY TMC_DATA_ID DESC";
        } else if (warehoseRole.equals("LIO")
                || warehoseRole.equals("MOH")) {
            String roleNameForConditon = warehoseRole.equals("LIO") ? "MOH" : "LIO";
            x_query = "";
        } else if (warehoseRole.equals("NTO")) {
            x_query = "";
        }
        JSONArray array = null;
        try {
            SQLQuery query = session.createSQLQuery(x_query);
            query.setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP);
            List resultlist = query.list();
            array = GetJsonResultSet.getjson(resultlist);
            System.out.println("result list size" + resultlist.size());
        } catch (org.hibernate.exception.JDBCConnectionException e) {
            e.printStackTrace();
        } finally {
            session.close();
        }
        //System.out.println("result list size"+resultlist.size());

        return array;
    }

    public int saveTMCAddEdit(TMCBeanForTMCForm bean, String action, AdmUserV userBean) {
        int insertupdateadmTMCFlag = 0;
//		int insertupdateRolemapingFlag = 0;
//		int insertupdateWarehouseAssimgmentFlag = 0;
        int insetUpdateTMCFlag = 0;
        String x_QUERY = "";
        Session session = sf1.openSession();
        session.beginTransaction();
        try {
            if (action.equals("add")) {
                x_QUERY = "INSERT INTO E004"
                        + "(FACILITY_ID, " //0
                        + "LOCATION, " //1
                        + "FACILITY_HAS_ELECTRICITY, " //2
                        + "ELECTRICITY_HRS, " //3
                        + "DEVICE_AVAILABLE, " //4
                        + "TYPE_OF_DEVICE)" //5
                        + " VALUES(?,?,?,?,?,?)";
            } else {
                x_QUERY = "UPDATE E004 SET "
                        + "FACILITY_ID=?, "//0
                        + "LOCATION=?, " //1
                        + "FACILITY_HAS_ELECTRICITY=?, " //2
                        + "ELECTRICITY_HRS=?, " //3
                        + "DEVICE_AVAILABLE=?, " //4
                        + "TYPE_OF_DEVICE=? " //5
                        + "WHERE TMC_DATA_ID =?"; //6
            }
            SQLQuery query = session.createSQLQuery(x_QUERY);

            query.setParameter(0, bean.getX_TMC_FACILITY_ID());
            query.setParameter(1, bean.getX_TMC_DEVICE_LOCATION());
            query.setParameter(2, bean.getX_TMC_LOCATION_HAS_ELECTRICITY());
            query.setParameter(3, bean.getX_TMC_HOURS_OF_ELECTRICITY());
            query.setParameter(4, bean.getX_TMC_TEMPERATURE_MONITORING_DEVICE_AVAILABLE());
            query.setParameter(5, bean.getX_TMC_TYPE_OF_DEVICE());
            if (action.equals("edit")) {
                query.setParameter(6, bean.getX_TMC_DATA_ID());
            }

            insertupdateadmTMCFlag = query.executeUpdate();

//			insertupdateRolemapingFlag = saveSetRoleIDMapping(bean, action, userBean, session);
//			insertupdateWarehouseAssimgmentFlag = setWarehouseIdAssingment(bean, action, userBean, session);
            if (insertupdateadmTMCFlag == 1) {
                session.getTransaction().commit();
                insetUpdateTMCFlag = 1;
            } else {

                session.getTransaction().rollback();
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.getTransaction().rollback();
        } finally {
            session.close();
        }
        return insetUpdateTMCFlag;
    }
}
