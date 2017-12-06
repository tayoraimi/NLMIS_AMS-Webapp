<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="f"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>List of CCE Details</title>
            <link rel="stylesheet" href="resources/css/buttontoolbar.css"
                    type="text/css">
            <link rel=" stylesheet" href="resources/css/w3css.css" type="text/css">
            <link rel="stylesheet" href="resources/css/table.css" type="text/css">
            <link rel="stylesheet" type="text/css" href="resources/easyui/themes/default/easyui.css">
            <link rel="stylesheet" type="text/css" href="resources/easyui/themes/icon.css">
            <link rel="stylesheet" type="text/css" href="resources/easyui/demo/demo.css">
        <script type="text/javascript">
    function setRole() {
        var user = '${userBean.getX_ROLE_NAME()}';
        switch (user) {
            case "SCCO":
                $('#overViewBtn').hide();
                $('#addBtn').hide();
                $('#editBtn').hide();
                break;
            case "SIO":
                $('#addBtn').hide();
                $('#editBtn').hide();
                break;
            case "SIFP":
                $('#addBtn').hide();
                break;
            case "NTO":
                $('#overViewBtn').hide();
                break;
            case "LIO":
                $('#addBtn').hide();
                $('#editBtn').hide();
                break;
            case "MOH":
                $('#editBtn').hide();
                $('#addBtn').hide();
                break;
        }
//        document.getElementById("common_lable").innerHTML = "Details of all CCE";
//        if (user == "NTO") {
//            document.getElementById("user").innerHTML = "User: National Admin";
//            document.getElementById("warehouse_name").innerHTML = "National: " + '${userBean.getX_WAREHOUSE_NAME()}';
//        } else if (user == "SIO" || user == "SCCO" || user == "SIFP") {
//            document.getElementById("user").innerHTML = "User: " + user + '${userBean.getX_WAREHOUSE_NAME()}';
//            document.getElementById("warehouse_name").innerHTML = "State :" + '${userBean.getX_WAREHOUSE_NAME()}';
//        } else if (user == "LIO" || user == "MOH") {
//            document.getElementById("user").innerHTML = "User: " + user + '${userBean.getX_WAREHOUSE_NAME()}';
//            document.getElementById("warehouse_name").innerHTML = "LGA :" + '${userBean.getX_WAREHOUSE_NAME()}';
//        }

    }
        </script>
        <style type="text/css">
            #first_name_label,#last_name_label,#list_of_cce_name_label,#list_of_cce_types_label,#password_label,
            #confirm_password_label,#role_label,#assign_lga_label,#start_date_label{
                font-weight: bold;
            }
        </style>
        <style>
            .loader_div {
                height: 100%;
                width: 100%;
                position: absolute;
                background: #0c1520;
                overflow: overlay;
                opacity: 0.5;
                z-index: 2;
                top: 0%;
            }

            .loader {
                border: 16px solid #f3f3f3;
                border-radius: 50%;
                border-top: 16px solid blue;
                border-bottom: 16px solid blue;
                top: 42%;
                left: 43%;
                z-index: 1;
                width: 120px;
                height: 120px;
                position: absolute;
                -webkit-animation: spin 2s linear infinite;
                animation: spin 1s linear infinite;
            }

            @-webkit-keyframes spin {
                0% { -webkit-transform: rotate(0deg); }
                100% { -webkit-transform: rotate(360deg); }
            }

            @keyframes spin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }
            
            #hf_number_label,#hf_name_label,#state_store_label,#default_ord_store_label,#country_name_label,
#ward_label,#start_date_label{
font-weight: bold;
}
        </style>
    </head>
    <body style="margin: 0px;" onload="setRole()">
        <!-- to check seesoin is null or not -->

        <!-- headr of page -->
        <%-- <jsp:include page="headerforamspages.jsp"></jsp:include> --%>

            <!-- button bar -->

            <div class="button_bar" id="button_bar">
                <ul>
                    <li><a id="addBtn" class="w3-btn w3-ripple" onclick="AddListOfCCE()" > <img alt="add"
                                                                                          src="resources/images/file_add.png">Add
                        </a>
                    </li>
                    <li><a id="editBtn" class="w3-btn w3-ripple" onclick="editListOfCCE(this.id)"> <img alt="edit"
                                                                                                  src="resources/images/file_edit.png">Edit
                        </a></li>
                    <!--			<li><a id="overViewBtn" class="w3-btn w3-ripple" onclick="editListOfCCE(this.id)"> <img alt="overViewBtn"
                                                    src="resources/images/file_edit.png">OverView
                                            </a></li>-->
                    <!--			<li><a class="w3-btn w3-ripple" onclick="handleHistory()"> <img alt="history"
                                                            src="resources/images/file_history.png">History
                                            </a></li>
-->                                            <li><a class="w3-btn w3-ripple" href="country_cce_details_export.xls"> <img alt="export"
                                                            src="resources/images/Export_load_upload.png">Export
                                            </a></li><!--
                                            <li><a class="w3-btn w3-ripple" onclick="handleChangePassword()"> <img alt="change password"
                                                            src="resources/images/change_password.png">Change Password
                                            </a></li>-->
                    <li><a class="w3-btn w3-ripple" onclick="refreshData()"> <img alt="refresh"
                                                                                  src="resources/images/refreshIcon.png" >Refresh
                        </a></li>
                </ul>
            </div>

            <!-- toolbar for table -->
            <!--    <div id="table_toolbar" style="padding:2px 5px;">
                    ListOfCCE Type:   <select id="usertype_combobox" class="easyui-combobox"  style="width:100px">
                    </select>
                    Role Name:   <select id="rolename_combobox" class="easyui-combobox"  style="width:100px">
                    </select>
                    Store Name: 
                    <select id="assign_lga_combobox" class="easyui-combobox"  style="width:180px">
                        
                    </select>
                    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="doSearch()">Search</a>
                </div>-->

            <!-- list_of_cce table -->

            <div id="list_of_cce_table_div" style="margin-left: 5px;">
                <table id="list_of_cceListTable" class="easyui-datagrid"
                       style="width: 100%; height: 430px;padding-left: 5px;" title="ListOfCCE"
                       data-options="toolbar:'#table_toolbar', rownumbers:'true',  singleSelect:'true',
                       striped:'true', remoteSort:'false',pagination:'true',pageSize:20">	
                </table>
            </div>

            <!-- add edit form -->

            <div id="form_dialog" class="easyui-dialog" style="width:430px;height:520px;padding:10px 20px"
                 closed="true" buttons="#form_buttons">
            <f:form id="add_edit_form" method="post" commandName="beanForListOfCCE">
                <table cellspacing="10px;">
                    <tr>
                        <td>
                            <div id="list_of_cce_model_div">
                                <label id="list_of_cce_model_label">*Model:</label>
                                <f:select  id="list_of_cce_model_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_ListOfCCE_MODEL"/>
                            </div>
                        </td>
                        <td>
                            <div class="list_of_cce_designation_div">
                                <label id="list_of_cce_designation_label"> *Designation:</label>
                                <f:select id="list_of_cce_designation_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_ListOfCCE_DESIGNATION"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="list_of_cce_category_div">
                                <label id="list_of_cce_category_label">*Category:</label>
                                <f:select id="list_of_cce_category_combobox_form"  class="easyui-textbox" cssStyle="width:150px;" path="x_ListOfCCE_CATEGORY"/>
                            </div>
                        </td>
                        <td>

                            <div class="list_of_cce_company_div">
                                <label id="list_of_cce_company_label">*Company:</label>
                                <f:select  id="list_of_cce_company_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_ListOfCCE_COMPANY" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="list_of_cce_refrigerant_div">
                                <label id="list_of_cce_refrigerant_label">Refrigerant:</label>
                                <f:select id="list_of_cce_refrigerant_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_ListOfCCE_REFRIGERANT" />
<!--                                    <option value="STATE">STATE</option>
                                    <option value="LGA">LGA</option>
                                    <option value="Ward">Ward</option>
                                    <option value="HF">Facility</option>-->
                            </div>
                        </td>
                        <td>

                            <!--                <div class="confirm_password_div">
                                                <label id="confirm_password_label">*Confirm Password:</label>
                                                <input type="password" id="confirm_password_textbox"  class="easyui-textbox" width="120px" />
                                            </div>-->
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div id="list_of_cce_vol_neg_div">
                                <label id="list_of_cce_vol_neg_label">*Vol - :</label>
                                <f:select id="list_of_cce_vol_neg_textbox_form"  
                                          class="easyui-textbox" cssStyle="width:150px;" path="x_ListOfCCE_VOL_NEG"/>
                            </div>
                        </td>
                        <td>

                            <div id="list_of_cce_vol_pos_div">
                                <label id="list_of_cce_vol_pos_label">*Vol + :</label>
                                <f:select id="list_of_cce_vol_pos_textbox_form"  
                                          class="easyui-textbox " cssStyle="width:150px;" path="x_ListOfCCE_VOL_POS"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div id="list_of_cce_expected_working_life_div">
                                <label id="list_of_cce_expected_working_life_label">*Expected Working Life</label>
                                <f:input id="list_of_cce_expected_working_life_textbox_form"  class="easyui-textbox" path="x_ListOfCCE_EXPECTED_WORKING_LIFE"/>
                            </div>
                        </td>
                        <td>

                            <div id="list_of_cce_price_div">
                                <label id="list_of_cce_price_label">*Price:</label>
                                <f:select id="list_of_cce_price_textbox_form"  
                                          class="easyui-textbox " cssStyle="width:150px;" path="x_ListOfCCE_PRICE"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="list_of_cce_type_div">
                                <label id="list_of_cce_type_label">*Type:</label>
                                <f:select  id="list_of_cce_type_combobox_form"
                                           class="easyui-combobox" cssStyle="width:150px;" path="x_ListOfCCE_TYPE"/>
                            </div>
                        </td>
                        <td>

                            <div class="list_of_cce_energy_source_div">
                                <label id="list_of_cce_energy_source_label">*Energy Source:</label>
                                <f:select  id="list_of_cce_energy_source_combobox_form"
                                           class="easyui-combobox" cssStyle="width:150px;" path="x_ListOfCCE_ENERGY_SOURCE"/>
                            </div>
                        </td>
                    </tr>
                </table>
            </f:form>
        </div>
        <div id="form_buttons">
            <a href="javascript:void(0)" id="saveBtn" class="easyui-linkbutton c6" iconCls="icon-ok" onclick="saveListOfCCE()" style="width:90px">Save</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#form_dialog').dialog('close')" style="width:90px">Cancel</a>
        </div>

        <!-- history div -->
        <!--        <div id="history_dialog" class="easyui-dialog" style="width:420px;height:250px;padding:10px" closed="true">
                <table align="center">
                <tr>
                        <td>Created By:</td>
                        <td><label  id="createdBylabel"></label></td>
                        </tr>
                        <tr>
                        <td>Created On:</td>
                        <td><label  id="createdOnlabel"></label></td>
                        </tr>
                      <tr>
                        <td>Updated By:</td>
                        <td><label  id="updatedBylabel"></label></td>
                      </tr>
                      <tr>
                        <td>Last updated On</td>
                        <td><label  id="updatedOnlabel"></label></td>
                      </tr>
                      <tr>
                        <td colspan="2" align="center" style="">
                                <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="javascript:$('#history_dialog').dialog('close')" style="width:90px">Ok</a>
                        </td>
                        <td>
                        </td>
                      </tr>
                </table>
                </div>
        -->
        <!-- change password diologe div -->
        <!--     
                <div id="change_password_dialog" class="easyui-dialog" style="width:420px;height:250px;padding:10px" closed="true">
                <table align="center">
                <tr>
                        <td><b>*Old Password:</b></td>
                        <td><input type="password"  id="old_password" class="easyui-textbox"></td>
                        </tr>
                        <tr>
                        <td><b>*New Password:</b></td>
                        <td><input type="password" id="new_password" class="easyui-textbox"></td>
                        </tr>
                      <tr>
                        <td><b>*Confirm Password:</b></td>
                        <td><input type="password" id="confirm_password" class="easyui-textbox"></td>
                      </tr>
                      
                      <tr>
                        <td >
                                <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="changePasswordActionOk()" style="width:90px">Ok</a>
                        </td>
                        <td>
                         <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#change_password_dialog').dialog('close')" style="width:90px">Cancel</a>
                        </td>
                      </tr>
                </table>
                </div>
        -->

       <%-- <jsp:include page="footer-for-page.jsp"></jsp:include> --%>
            <!-- loder div -->
            <div style="display: none;" id="loader_div" class="loader_div">
                <div class="loader" id="loader_show">
                </div>
            </div>
        </body>
        <script type="text/javascript" src="resources/js/jquery-2.2.3.min.js"></script>
        <script type="text/javascript" src="resources/easyui/jquery.easyui.min.js"></script>
        <script src="resources/js/common.js" type="text/javascript"></script>
        <script src="resources/js/datagrid_agination.js" type="text/javascript"></script>
        <script type="text/javascript">
                        var submitType;
       
                        function alertBox(message) {
                            $.messager.alert('Warning!', message, 'warning');
                        }
                        function AddListOfCCE() {
                            submitType = "add";
                            $('#form_dialog').dialog('open').dialog('center').dialog('setTitle', 'Add New CCE Info');
                            $('#add_edit_form').form('clear');

//                            $('#list_of_cce_vol_pos_textbox_form').combobox('disable', true);

                            loadFormComboboxList();
                            $('#add_edit_form').attr('action', 'save_addedit_listOfCCE?action=add');
        //    $('#list_of_ccetype_combobox_form').combobox('enable',true);
                        }
                        function loadFormComboboxList() {
//                            $('#list_of_cce_vol_pos_textbox_form').combobox('disable', true);
//                            $('#list_of_cce_vol_pos_textbox_form').combobox('setValue', '${userBean.getX_WAREHOUSE_ID()}');
//                            $('#list_of_cce_vol_pos_textbox_form').combobox('setText', '${userBean.getX_WAREHOUSE_NAME()}');
                            
                            $('#list_of_cce_model_combobox_form').combobox({
                                url: 'getCCEInfoDetails',
                                valueField: 'value',
                                textField: 'label',
                                queryParams: {option: 'ModelInfoList'}

                            });
                            $('#list_of_cce_designation_combobox_form').combobox({
                                url: 'getCCEInfoDetails',
                                valueField: 'value',
                                textField: 'label',
                                queryParams: {option: 'DesignationInfoList'}
                                
                            });
                            $('#list_of_cce_category_combobox_form').combobox({
                                url: 'getCCEInfoDetails',
                                valueField: 'value',
                                textField: 'label',
                                queryParams: {option: 'CategoryInfoList'}

                            });
                           $('#list_of_cce_company_combobox_form').combobox({
                                url: 'getCCEInfoDetails',
                                valueField: 'value',
                                textField: 'label',
                                queryParams: {option: 'CompanyInfoList'}
//                                                        onSelect : function() {

                            });
                            $('#list_of_cce_refrigerant_combobox_form').combobox({
                                url: 'getCCEInfoDetails',
                                valueField: 'value',
                                textField: 'label',
                                queryParams: {option: 'RefrigerantInfoList'}

                            });
//                            $('#list_of_cce_vol_neg_textbox_form').combobox({
//                                url: 'getCCEInfoDetails',
//                                valueField: 'value',
//                                textField: 'label',
//                                queryParams: {option: 'VolNegInfoList'}
//
//                            });
//                            $('#list_of_cce_vol_pos_textbox_form').combobox({
//                                url: 'getCCEInfoDetails',
//                                valueField: 'value',
//                                textField: 'label',
//                                queryParams: {option: 'VolPosInfoList'}
//
//                            });
//                            $('#list_of_cce_expected_working_life_textbox_form').combobox({
//                                url: 'getCCEInfoDetails',
//                                valueField: 'value',
//                                textField: 'label',
//                                queryParams: {option: 'ExpectedWorkingLifeInfoList'}
//
//                            });
                            $('#list_of_cce_type_combobox_form').combobox({
                                url: 'getCCEInfoDetails',
                                valueField: 'value',
                                textField: 'label',
                                queryParams: {option: 'TypeInfoList'}

                            });
                            $('#list_of_cce_energy_source_combobox_form').combobox({
                                url: 'getCCEInfoDetails',
                                valueField: 'value',
                                textField: 'label',
                                queryParams: {option: 'EnergySourceInfoList'}

                            });



                        }
                        function saveListOfCCE() {
                            $('#add_edit_form').form('submit', {
                                url: $('#add_edit_form').attr('action'),
                                onSubmit: function () {
                                    var errormessage = "";
                                    var validate = true;

                                    if ($('#list_of_cce_designation_combobox_form').combobox('getValue') == '') {
                                        errormessage = "Designation is Empty!";
                                        validate = false;
                                    } else if ($('#list_of_cce_price_textbox_form').textbox('getValue') == '' || isNaN($('#list_of_cce_price_textbox_form').textbox('getValue'))) {
                                        errormessage = "Price is Empty or not a number!";
                                        validate = false;
                                    } else if ($('#list_of_cce_company_combobox_form').combobox('getValue') == '') {
                                        errormessage = "Company is Empty!";
                                        validate = false;
                                    }else if ($('#list_of_cce_vol_neg_textbox_form').textbox('getValue') == '' || isNaN($('#list_of_cce_vol_neg_textbox_form').textbox('getValue'))) {
                                        errormessage = "Vol neg is Empty or not a number!";
                                        validate = false;
                                    } else if ($('#list_of_cce_vol_pos_textbox_form').textbox('getValue') == '' || isNaN($('#list_of_cce_vol_pos_textbox_form').textbox('getValue'))) {
                                        errormessage = "Vol pos is Empty or not a number!";
                                        validate = false;
                                    } else if ($('#list_of_cce_expected_working_life_textbox_form').textbox('getValue') == '' || isNaN($('#list_of_cce_expected_working_life_textbox_form').textbox('getValue'))) {
                                        errormessage = "Expected working life is Empty!";
                                        validate = false;
                                    } else if ($('#list_of_cce_category_combobox_form').combobox('getValue') == '') {
                                        errormessage = "Category is Empty!";
                                        validate = false;
                                    } else if ($('#list_of_cce_energy_source_combobox_form').combobox('getValue') == '') {
                                        errormessage = "Energy source is Empty!";
                                        validate = false;
                                    } else if ($('#list_of_cce_model_combobox_form').combobox('getValue') == '') {
                                        errormessage = "Model is Empty!";
                                        validate = false;
                                    } else if ($('#list_of_cce_type_combobox_form').combobox('getValue') == '') {
                                        errormessage = "Type is Empty!";
                                        validate = false;
                                    }
                                    if (errormessage != '') {
                                        alertBox(errormessage);
                                    }
                                    return validate;
                                },
                                success: function (result) {
                                    if (result.toString() == 'succsess') {
                                        // close the dialog
                                        alertBox("Operation Successful");
                                        $('#form_dialog').dialog('close');
                                        refreshData();
                                    } else {
                                        alertBox("Operation Failed");
                                    }
                                }
                            });
                        }
                        function editListOfCCE(buttonId) {
                            if (buttonId == 'editBtn') {
                                $('#saveBtn').linkbutton('enable', true);
                            } else {
                                $('#saveBtn').linkbutton('disable', true);
                            }
                            submitType = "edit";
                            var row = $('#list_of_cceListTable').datagrid('getSelected');

                            if (row) {
                                if (buttonId == 'editBtn') {
                                    $('#form_dialog').dialog('open').dialog('center').dialog('setTitle', 'Edit CCE Info');
                                } else {
                                    $('#form_dialog').dialog('open').dialog('center').dialog('setTitle', 'OverView Of CCE Info');
                                }
                                loadFormComboboxList();
                                $('#list_of_cce_designation_combobox_form').combobox('setValue', row.DESIGNATION);
                                $('#list_of_cce_designation_combobox_form').combobox('setText', row.DESIGNATION);
                                $('#list_of_cce_company_combobox_form').combobox('setValue', row.COMPANY);
                                $('#list_of_cce_company_combobox_form').combobox('setText', row.COMPANY);
                                $('#list_of_cce_refrigerant_combobox_form').combobox('setValue', row.REFRIGERANT);
                                $('#list_of_cce_refrigerant_combobox_form').combobox('setText', row.REFRIGERANT);
                                $('#list_of_cce_vol_neg_textbox_form').textbox('setValue', row.VOL_NEG);
                                $('#list_of_cce_vol_pos_textbox_form').textbox('setValue', row.VOL_POS);
                                $('#list_of_cce_model_combobox_form').combobox('setValue', row.MODEL);
                                $('#list_of_cce_model_combobox_form').combobox('setText', row.MODEL);
                                $('#list_of_cce_type_combobox_form').combobox('setValue', row.TYPE);
                                $('#list_of_cce_type_combobox_form').combobox('setText', row.TYPE);
                                $('#list_of_cce_category_combobox_form').combobox('setValue', row.CATEGORY);
                                $('#list_of_cce_category_combobox_form').combobox('setText', row.CATEGORY);
                                $('#list_of_cce_price_textbox_form').textbox('setValue', row.PRICE);
                                $('#list_of_cce_expected_working_life_textbox_form').textbox('setValue', row.EXPECTED_WORKING_LIFE);
                                $('#list_of_cce_energy_source_combobox_form').combobox('setValue', row.ENERGY_SOURCE);
                                $('#list_of_cce_energy_source_combobox_form').combobox('setText', row.ENERGY_SOURCE);

                                $('#add_edit_form').attr('action', 'save_addedit_listOfCCE?action=edit&listOfCCEId=' + row.CCE_ID);

                            } else {
                                alertBox("Please Select Record!");
                            }

                        }

                        function refreshData() {
                            $('#list_of_cceListTable').datagrid('reload', 'getlistOfCCElist');
                        }
    
    </script>
    <script type="text/javascript">
        $('#list_of_cceListTable').datagrid({
            url: 'getlistOfCCElist',
            remoteSort: false,
            columns: [[
                    {field: 'CCE_ID', title: 'CCE ID', sortable: true, hidden: true},
                    {field: 'MODEL', title: 'MODEL', sortable: true},
                    {field: 'DESIGNATION', title: 'DESIGNATION', sortable: true},
                    {field: 'CATEGORY', title: 'CATEGORY', sortable: true},
                    {field: 'COMPANY', title: 'COMPANY', sortable: true},
    //            {field:'WARD_ID',title:'WARD ID',sortable:true,hidden:true},
                    {field: 'REFRIGERANT', title: 'REFRIGERANT', sortable: true},
                    {field: 'VOL_NEG', title: 'VOL -', sortable: true},
                    {field: 'VOL_POS', title: 'VOL +', sortable: true},
                    {field: 'EXPECTED_WORKING_LIFE', title: 'EXPECTED WORKING LIFE', sortable: true},
                    {field: 'PRICE', title: 'PRICE', sortable: true},
                    {field: 'TYPE', title: 'TYPE', sortable: true},
                    {field: 'ENERGY_SOURCE', title: 'ENERGY SOURCE', sortable: true}
                ]],
        onClickRow: function (index, row)     {
                if ('${userBean.getX_ROLE_NAME()}' == 'NTO') {
                        $('#editBtn').attr('class', 'w3-btn w3-ripple');
                        $('#editBtn').attr('onclick', 'editListOfCCE(this.id)');
                }
            }
        });
    </script>
    
    <script type="text/javascript">
        loadPaginationForTable(list_of_cceListTable);
    </script>

</html>