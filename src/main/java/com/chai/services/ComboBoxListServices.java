package com.chai.services;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.json.JSONArray;
import org.springframework.stereotype.Service;

import com.chai.hibernartesessionfactory.HibernateSessionFactoryClass;
import com.chai.model.LabelValueBean;
import com.chai.util.GetJsonResultSet;

@Service
public class ComboBoxListServices {
	
	Transaction tx = null;
	SessionFactory sf = HibernateSessionFactoryClass.getSessionAnnotationFactory();
	SQLQuery query=null;
	
	public  JSONArray getComboboxList(String... args) {
		System.out.println("-- ComboboxlistService.getComboboxList() mehtod called: -- ");
		String x_QUERY="";
		JSONArray array=new JSONArray();
		Session session = sf.openSession();
		if(args[0]!=null){
			if(args[0].equals("lgalistBasedonstate")){
			x_QUERY="SELECT WAREHOUSE_ID, WAREHOUSE_NAME "
					+ " FROM VIEW_INVENTORY_WAREHOUSES "
					+ " WHERE DEFAULT_ORDERING_WAREHOUSE_ID ='"+args[1]+"' ORDER BY WAREHOUSE_NAME";
			}else if(args[0].equals("STATE_STORE")){
				x_QUERY = " SELECT WAREHOUSE_ID, WAREHOUSE_NAME "
						+ " FROM VIEW_INVENTORY_WAREHOUSES "
						+ " WHERE DEFAULT_ORDERING_WAREHOUSE_ID = "
						+ args[1]
						+ " ORDER BY WAREHOUSE_NAME";
			}else if(args[0].equals("hfListLgaBased")){
				x_QUERY = " SELECT IFNULL(CUSTOMER_ID,DB_ID) CUSTOMER_ID,         CUSTOMER_NAME   "
						+" FROM VIEW_CUSTOMERS  "
						+" WHERE DEFAULT_STORE_ID =" +args[1]
						+" ORDER BY CUSTOMER_NAME ";
			}else if(args[0].equals("TRANSACTION_TYPE")){
				x_QUERY = "SELECT TYPE_ID, TYPE_NAME  FROM TYPES " 
						+" WHERE SOURCE_TYPE='TRANSACTION_TYPE' "
						+" AND TYPE_ID NOT IN(F_GET_TYPE('TRANSACTION_TYPE', 'MISC_ISSUE'), "
						+" F_GET_TYPE('TRANSACTION_TYPE', 'MISC_RECEIPT'),F_GET_TYPE('TRANSACTION_TYPE', 'INTER_FACILITY'))";
			}else if(args[0].equals("REASON_TYPE")){
				x_QUERY = "SELECT TYPE_ID, TYPE_NAME  FROM TYPES  WHERE SOURCE_TYPE='STOCK ADJUSTMENTS'";
			}else if(args[0].equals("USER_TYPE")){
				x_QUERY = "SELECT TYPE_ID, TYPE_NAME 	"	 
						+" FROM VIEW_TYPES "
						+" WHERE SOURCE_TYPE = 'USER TYPES' ORDER BY TYPE_NAME ";
			}else if(args[0].equals("wardListLgaBased")){
				x_QUERY = " SELECT TYPE_ID, "
					+ "        TYPE_CODE  "
					+ "   FROM TYPES  "
					+ "  WHERE SOURCE_TYPE='CUSTOMER TYPE' AND STATUS='A' AND WAREHOUSE_ID = "
					+ args[1] + "  ORDER BY TYPE_CODE ";
			}else if(args[0].equals("hfListWardBased")){
				x_QUERY = " SELECT IFNULL(CUSTOMER_ID,DB_ID) CUSTOMER_ID,         CUSTOMER_NAME   "
						+" FROM VIEW_CUSTOMERS  "
						+" WHERE CUSTOMER_TYPE_ID = " +args[1]
						+" ORDER BY CUSTOMER_NAME ";
			}else if(args[0].equals("EquipmentLocationList")){
				x_QUERY = " SELECT WAREHOUSE_TYPE_ID, LOCATION"
					+ "   FROM VIEW_STORE_TYPES "
                                + "WHERE FACILITY_ID = "+args[1]
                                + " OR WAREHOUSE_TYPE_ID = "+args[1];
			}else if(args[0].equals("DesignationList")){
				x_QUERY = " SELECT CCE_ID, DESIGNATION "
					+ "   FROM CCE_LIST GROUP BY DESIGNATION ASC ";
			}else if(args[0].equals("MakeList")){
				x_QUERY = " SELECT CCE_ID, COMPANY "
					+ "   FROM CCE_LIST GROUP BY COMPANY ASC ";
			}else if(args[0].equals("ModelList")){
				x_QUERY = " SELECT CCE_ID, MODEL "
					+ "    FROM CCE_LIST ORDER BY CCE_ID ASC ";
			}else if(args[0].equals("TypeList")){
				x_QUERY = " SELECT CCE_ID, TYPE "
					+ "   FROM CCE_LIST WHERE COMPANY = '"
                                        + args[1]+"' AND MODEL = '"
                                        + args[2]+"' GROUP BY TYPE ASC ";
			}else if(args[0].equals("CategoryList")){
				x_QUERY = " SELECT CCE_ID, CATEGORY "
					+ "   FROM CCE_LIST WHERE COMPANY = '"
                                        + args[1]+"' AND MODEL = '"
                                        + args[2]+"' AND TYPE = '"
                                        + args[3]+"' GROUP BY CATEGORY ASC ";
			}else if(args[0].equals("DecisionList")){
				x_QUERY = " SELECT DECISION_ID, DECISION "
					+ "   FROM CCE_DECISION WHERE STATUS = '"
                                        + args[1]+"' GROUP BY DECISION ASC ";
			}else if(args[0].equals("StatusList")){
				x_QUERY = " SELECT DECISION_ID, STATUS "
					+ "   FROM CCE_DECISION GROUP BY STATUS ASC ";
			}else if(args[0].equals("SourceList")){
				x_QUERY = " SELECT CCE_DATA_ID, SOURCE_OF_CCE "
					+ "   FROM E003 GROUP BY SOURCE_OF_CCE ASC ";
			}else if(args[0].equals("USER_ROLE_NAME")){
				if(args[2].equalsIgnoreCase("SCCO")
						|| args[2].equalsIgnoreCase("SIO")
						|| args[2].equalsIgnoreCase("SIFP")){
					if(args[1].equalsIgnoreCase("Admin")){
						x_QUERY = "SELECT ROLE_ID,   ROLE_NAME FROM ADM_ROLES "
								+"  WHERE STATUS = 'A'  AND ROLE_NAME <> 'NTO'  AND ROLE_NAME <> 'CCO'  ORDER BY ROLE_NAME  ";
					}else{
						x_QUERY = "SELECT ROLE_ID,   ROLE_NAME FROM ADM_ROLES "
								+" WHERE STATUS = 'A'  AND ROLE_NAME = 'CCO'  ORDER BY ROLE_NAME ";
					}
					
				}else if(args[2].equalsIgnoreCase("LIO")
						|| args[2].equalsIgnoreCase("MOH")){
					if(args[1].equalsIgnoreCase("Admin")){
						x_QUERY = "SELECT ROLE_ID,   ROLE_NAME FROM ADM_ROLES "
								+"  WHERE STATUS = 'A'    AND ROLE_NAME = '"+args[2]+"' ";
					}else{
						x_QUERY = "SELECT ROLE_ID,   ROLE_NAME FROM ADM_ROLES "
								+" WHERE STATUS = 'A'  AND ROLE_NAME = 'CCO'   ";
					}
				}else if(args[2].equalsIgnoreCase("NTO")){
					if(args[1].equalsIgnoreCase("Admin")){
						x_QUERY = "SELECT ROLE_ID,   ROLE_NAME FROM ADM_ROLES "
								+"  WHERE STATUS = 'A'    AND ROLE_NAME <> 'CCO'  ORDER BY ROLE_NAME  ";
					}else{
						x_QUERY = "SELECT ROLE_ID,   ROLE_NAME FROM ADM_ROLES "
								+" WHERE STATUS = 'A'  AND ROLE_NAME = 'CCO'  ORDER BY ROLE_NAME ";
					}
				}
				
			} else if (args[0].equals("COUNTRY_LIST")) {
				x_QUERY = "SELECT COUNTRY_ID, 		  COUNTRY_NAME "
						+ "   FROM VIEW_COUNTRIES  WHERE COUNTRY_NAME IS NOT NULL   "
						+ " AND COUNTRY_NAME <> '' AND STATUS='A'  ORDER BY COUNTRY_NAME  ";
			}else if(args[0].equals("ModelInfoList")){
				x_QUERY = " SELECT MODEL, MODEL "
					+ "   FROM CCE_LIST GROUP BY MODEL ASC ";
			}else if(args[0].equals("DesignationInfoList")){
				x_QUERY = " SELECT DESIGNATION, DESIGNATION "
					+ "   FROM CCE_LIST GROUP BY DESIGNATION ASC ";
			}else if(args[0].equals("CategoryInfoList")){
				x_QUERY = " SELECT CATEGORY, CATEGORY "
					+ "   FROM CCE_LIST GROUP BY CATEGORY ASC ";
			}else if(args[0].equals("CompanyInfoList")){
				x_QUERY = " SELECT COMPANY, COMPANY "
					+ "   FROM CCE_LIST GROUP BY COMPANY ASC ";
			}else if(args[0].equals("RefrigerantInfoList")){
				x_QUERY = " SELECT REFRIGERANT, REFRIGERANT "
					+ "   FROM CCE_LIST GROUP BY REFRIGERANT ASC ";
			}else if(args[0].equals("PriceInfoList")){
				x_QUERY = " SELECT PRICE, PRICE "
					+ "   FROM CCE_LIST GROUP BY PRICE ASC ";
			}else if(args[0].equals("TypeInfoList")){
				x_QUERY = " SELECT TYPE, TYPE "
					+ "   FROM CCE_LIST GROUP BY TYPE ASC ";
			}else if(args[0].equals("EnergySourceInfoList")){
				x_QUERY = " SELECT ENERGY_SOURCE, ENERGY_SOURCE "
					+ "   FROM CCE_LIST GROUP BY ENERGY_SOURCE ASC ";
			}
			
		}
		try {
			query = session.createSQLQuery(x_QUERY);
			System.out.println("HF DROP DOWN LIST QUERY: "+x_QUERY);
			query.setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP);
			List resultlist = query.list();
			if (args.length == 3) {
				if (args[2] != null && args[2].equals("All")) {
					System.out.println("list with alloption");
					array = GetJsonResultSet.getjsonCombolist(resultlist, true);
				} else {
					array = GetJsonResultSet.getjsonCombolist(resultlist, false);
				}
			}else{
				System.out.println("list with Without Alloption");
				array=GetJsonResultSet.getjsonCombolist(resultlist,false);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return array;
	}
		
	public  JSONArray getProductList(String... args) {
		System.out.println("-- Comboboxlistserivces.getProductList() mehtod called: -- ");
		String x_QUERY="";
		JSONArray array=new JSONArray();
		Session session = sf.openSession();
		if(args[0]!=null){
			 if(args[0].equals("productlistbassedonlga")){
				x_QUERY="SELECT ITEM_ID, "
						+ "	  ITEM_NUMBER FROM ITEM_MASTERS "
						+ " WHERE STATUS = 'A' AND WAREHOUSE_ID=IFNULL('"+args[1]+"',WAREHOUSE_ID) "
						+ "ORDER BY ITEM_NUMBER";
			}
		}
		try {
			query = session.createSQLQuery(x_QUERY);
			query.setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP);
			List resultlist = query.list();
			array=GetJsonResultSet.getjsonCombolist(resultlist,Boolean.parseBoolean(args[2]));
		} catch (HibernateException e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return array;
	}
	public  List<LabelValueBean> getProductListInBean(String... args) {
		System.out.println("-- Comboboxlistserivces.getProductListInBean() mehtod called: -- ");
		String x_QUERY="";
		Session session = sf.openSession();
		List<LabelValueBean> array=null;;
		if(args[0]!=null){
			 if(args[0].equals("productlistbassedonlga")){
				x_QUERY="SELECT ITEM_ID, ITEM_NUMBER"
						+" FROM VIEW_ITEM_MASTERS "
						+" WHERE STATUS = 'A' "
						+" AND ITEM_TYPE_ID IN (F_GET_TYPE('PRODUCT','VACCINE')) "
						+" AND  warehouse_id="+args[1]+"  ORDER BY ITEM_NUMBER ";
			}
		}
		try {
			query = sf.openSession().createSQLQuery(x_QUERY);
			query.setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP);
			List resultlist = query.list();
			array = GetJsonResultSet.getCombolistInBean(resultlist, Boolean.parseBoolean(args[2]));
		} catch (HibernateException e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return array;
	}
}
