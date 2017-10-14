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
import com.chai.model.REBeanForREForm;
import com.chai.model.views.AdmUserV;
import com.chai.util.CalendarUtil;
import com.chai.util.GetJsonResultSet;

/**
 *
 * @author S3-Developer
 */
public class REService {

    private static Logger logger = Logger.getLogger(CCEService.class);
    String lastInsertCCEId = "";
    SessionFactory sf1 = HibernateSessionFactoryClass.getSessionAnnotationFactory();

    public static ArrayList<Object> validateRELogin(String x_LOGIN_NAME, String x_PASSWORD) {
        System.out.println("-- REService.validateRELogin() mehtod called: -- ");
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

    public JSONArray getREListPageData(AdmUserV userBean) {
        System.out.println("-- REService.getREListPageData mehtod called: -- ");
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
                    + "e001.FACILITY_ID, "
                    + "WARD, "
                    + "WAREHOUSE_TYPE_ID,"
                    + "DEFAULT_ORDERING_WAREHOUSE_ID,"
                    + "GEN_DATA_ID,"
                    + "FACILITY_HAS_ELECTRICITY,"
                    + "ELECTRICITY_HRS, MANUFACTURER, MODEL, POWER, FUNCTIONAL, FUEL_TYPE, FUEL_AVAILABLE, PPM, PLANNED_REPAIRS,"
                    + "DURATION_NF "
                    + "FROM E001 "
                    + "INNER JOIN view_all_facilities "
                    + "ON e001.FACILITY_ID=view_all_facilities.FACILITY_ID "
                    + " WHERE e001.FACILITY_ID = "
                    + userBean.getX_WAREHOUSE_ID()
                    + " OR DEFAULT_ORDERING_WAREHOUSE_ID = "
                    + userBean.getX_WAREHOUSE_ID()
                    + "  OR DEFAULT_ORDERING_WAREHOUSE_ID "
                    + " IN (SELECT FACILITY_ID FROM view_all_facilities WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "
                    + userBean.getX_WAREHOUSE_ID()
                    + ") ORDER BY GEN_DATA_ID DESC";

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
        } catch (org.hibernate.exception.JDBCConnectionException e) {
            e.printStackTrace();
        } finally {
            session.close();
        }
//		System.out.println("result list size"+resultlist.size());

        return array;
    }

    public int saveREAddEdit(REBeanForREForm bean, String action, AdmUserV userBean) {
        int insertupdateadmCCEFlag = 0;
//		int insertupdateRolemapingFlag = 0;
//		int insertupdateWarehouseAssimgmentFlag = 0;
        int insetUpdateCCEFlag = 0;
        String x_QUERY = "";
        Session session = sf1.openSession();
        session.beginTransaction();
        try {
            if (action.equals("add")) {
                x_QUERY = "INSERT INTO E001"
                        + " (FACILITY_ID, " //0
                        + "FACILITY_HAS_ELECTRICITY, " //1
                        + "ELECTRICITY_HRS, " //2                                      
                        + "MANUFACTURER, " //3
                        + "MODEL, " //4
                        + "POWER, " //5                      
                        + "FUNCTIONAL, " //6
                        + "FUEL_TYPE, " //7
                        + "FUEL_AVAILABLE, " //8
                        + "PPM, " //9
                        + "PLANNED_REPAIRS, " //10
                        + "LOCATION, " //11      
                        + "DURATION_NF, " //12
                        + "CREATED_BY, " //13
                        + "CREATED_ON, "
                        + "UPDATED_BY, " //14
                        + "LAST_UPDATED_ON ) "
                        + " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,NOW(),?,NOW())";
            } else {
                x_QUERY = "UPDATE E001 SET "
                        + "FACILITY_ID=?, " //0
                        + "FACILITY_HAS_ELECTRICITY=?, " //1
                        + "ELECTRICITY_HRS=?, " //2
                        + "MANUFACTURER=?, " //3
                        + "MODEL=?, " //4
                        + "POWER=?, " //5
                        + "FUNCTIONAL=?, " //6
                        + "FUEL_TYPE=?, " //7
                        + "FUEL_AVAILABLE=?, " //8
                        + "PPM=?, " //9
                        + "PLANNED_REPAIRS=?, " //10
                        + "LOCATION=?, " //11 
                        + "DURATION_NF=?, " //12

                        + "UPDATED_BY=?, " //13
                        + "LAST_UPDATED_ON=NOW()  "
                        + " WHERE GEN_DATA_ID=?"; //14
            }
            SQLQuery query = session.createSQLQuery(x_QUERY);
            query.setParameter(0, bean.getX_GENERATOR_FACILITY_ID());
            query.setParameter(1, bean.getX_GENERATOR_LOCATION_HAS_ELECTRICITY());
            query.setParameter(2, bean.getX_GENERATOR_ELECTRICITY_HRS());
            query.setParameter(3, bean.getX_GENERATOR_MANUFACTURER());
            query.setParameter(4, bean.getX_GENERATOR_MODEL());
            query.setParameter(5, bean.getX_GENERATOR_POWER());
            query.setParameter(6, bean.getX_GENERATOR_FUNCTIONAL());
            query.setParameter(7, bean.getX_GENERATOR_FUEL_TYPE());
            query.setParameter(8, bean.getX_GENERATOR_FUEL_AVAILABLE());
            query.setParameter(9, bean.getX_GENERATOR_PPM());
            query.setParameter(10, bean.getX_GENERATOR_PLANNED_REPAIRS());
            query.setParameter(11, bean.getX_GENERATOR_LOCATION());
            query.setParameter(12, bean.getX_GENERATOR_DURATION_NF());
            query.setParameter(13, userBean.getX_USER_ID());
            if (action.equals("add")) {
                query.setParameter(14, userBean.getX_USER_ID());
            } else {
                query.setParameter(14, bean.getX_GEN_DATA_ID());
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

}
