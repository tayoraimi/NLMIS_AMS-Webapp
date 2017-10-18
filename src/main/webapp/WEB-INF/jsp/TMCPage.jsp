<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="f"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>TMC</title>
        <link rel="stylesheet" href="resources/css/buttontoolbar.css"
              type="text/css">
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
                        break;
                    case "SIO":
                        $('#addBtn').hide();
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
                document.getElementById("common_lable").innerHTML = "TMC";
                if (user == "NTO") {
                    document.getElementById("user").innerHTML = "User: National Admin";
                    document.getElementById("warehouse_name").innerHTML = "National: " + '${userBean.getX_WAREHOUSE_NAME()}';
                } else if (user == "SIO" || user == "SCCO" || user == "SIFP") {
                    document.getElementById("user").innerHTML = "User: " + user + '${userBean.getX_WAREHOUSE_NAME()}';
                    document.getElementById("warehouse_name").innerHTML = "State :" + '${userBean.getX_WAREHOUSE_NAME()}';
                } else if (user == "LIO" || user == "MOH") {
                    document.getElementById("user").innerHTML = "User: " + user + '${userBean.getX_WAREHOUSE_NAME()}';
                    document.getElementById("warehouse_name").innerHTML = "LGA :" + '${userBean.getX_WAREHOUSE_NAME()}';
                }

            }
        </script>
        <style type="text/css">
            #first_name_label,#last_name_label,#cce_name_label,#cce_types_label,#password_label,
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

        </style>
    </head>
    <body style="margin: 0px;" onload="setRole()">
        <!-- to check seesoin is null or not -->

        <!-- headr of page -->
        <jsp:include page="headerforamspages.jsp"></jsp:include>

            <!-- button bar -->

            <div class="button_bar" id="button_bar">
                <ul>
                    <li><a id="addBtn" class="w3-btn w3-ripple" onclick="AddTMC()" > <img alt="add"
                                                                                          src="resources/images/file_add.png">Add
                        </a>
                    </li>
                    <li><a id="editBtn" class="w3-btn w3-ripple" onclick="editTMC(this.id)"> <img alt="edit"
                                                                                                  src="resources/images/file_edit.png">Edit
                        </a></li>
                    <!--			<li><a id="overViewBtn" class="w3-btn w3-ripple" onclick="editCCE(this.id)"> <img alt="overViewBtn"
                                                    src="resources/images/file_edit.png">OverView
                                            </a></li>-->
                    <!--			<li><a class="w3-btn w3-ripple" onclick="handleHistory()"> <img alt="history"
                                                            src="resources/images/file_history.png">History
                                            </a></li>
                                            <li><a class="w3-btn w3-ripple" href="user_list_export"> <img alt="export"
                                                            src="resources/images/Export_load_upload.png">Export
                                            </a></li>
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
                    CCE Type:   <select id="usertype_combobox" class="easyui-combobox"  style="width:100px">
                    </select>
                    Role Name:   <select id="rolename_combobox" class="easyui-combobox"  style="width:100px">
                    </select>
                    Store Name: 
                    <select id="assign_lga_combobox" class="easyui-combobox"  style="width:180px">
                        
                    </select>
                    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="doSearch()">Search</a>
                </div>-->

            <!-- cce table -->

            <div id="cce_table_div" style="margin-left: 5px;">
                <table id="tmcListTable" class="easyui-datagrid"
                       style="width: 100%; height: 430px;padding-left: 5px;" title="TMC"
                       data-options="toolbar:'#table_toolbar', rownumbers:'true',  singleSelect:'true',
                       striped:'true', remoteSort:'false',pagination:'true',pageSize:20">	
                </table>
            </div>

            <!-- add edit form -->

            <div id="form_dialog" class="easyui-dialog" style="width:430px;height:520px; padding:10px 20px"
                 closed="true" buttons="#form_buttons">
            <f:form id="add_edit_form" method="post" commandName="beanForTMC">
                <table cellspacing="10px;">
                    <tr>
                        <td>
                            <div id="tmc_state_div">
                                <label id="tmc_state_label">*State:</label>
                                <f:select  id="tmc_state_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_TMC_STATE_ID"/>
                            </div>
                        </td>
                        <td>
                            <div class="tmc_lga_div">
                                <label id="tmc_lga_label"> *LGA:</label>
                                <f:select id="tmc_lga_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_TMC_LGA_ID"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="tmc_ward_div">
                                <label id="tmc_ward_label">*Ward:</label>
                                <f:select id="tmc_ward_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_TMC_WARD"/>
                            </div>
                        </td>
                        <td>

                            <div class="tmc_facility_name_div">
                                <label id="tmc_facility_name_label">*Facility Name:</label>
                                <f:select  id="tmc_facility_name_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_TMC_FACILITY_ID" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="tmc_location_div">
                                <label id="tmc_location_label">*Equipment Location:</label>
                                <f:select id="tmc_location_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_TMC_DEVICE_LOCATION">
                                    <option value="State">State</option>
                                    <option value="LGA">LGA</option>
                                    <option value="Facility">Facility</option>
                                </f:select>
                            </div>
                        </td>

                        <td>
                            <div class="tmc_has_electricity_div">
                                <label id="tmc_has_electricity_label">*Facility Has Electricity:</label>
                                <f:select id="tmc_has_electricity_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_TMC_LOCATION_HAS_ELECTRICITY">
                                    <option value="Yes">Yes</option>
                                    <option value="No">No</option>

                                </f:select>
                            </div>
                        </td>

                    </tr>
                    <tr>
                        <td>
                            <div class="tmc_hrs_div">
                                <label id="tmc_hrs_label">*Hours of Electricity:</label>
                                <f:input id="tmc_hrs_textbox"  class="easyui-textbox" path="x_TMC_HOURS_OF_ELECTRICITY"/>
                            </div>
                        </td>
                        <td>

                            <div class="tmc_status_div">
                                <label id="tmc_status_label">*Device Available:</label>
                                <f:select id="tmc_device_available_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_TMC_TEMPERATURE_MONITORING_DEVICE_AVAILABLE">
                                    <option value="Yes">Yes</option>
                                    <option value="No">No</option>

                                </f:select>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="tmc_type_of_device_div">
                                <label id="tmc_type_of_device_label">*Type of Device:</label>
                                <f:select id="tmc_type_of_device_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_TMC_TYPE_OF_DEVICE">
                                    <option value="A">A</option>
                                    <option value="B">B</option>
                                    <option value="C">C</option>
                                </f:select>
                            </div>
                        </td>

                    </tr>
                </table>
            </f:form>
        </div>
        <div id="form_buttons">
            <a href="javascript:void(0)" id="saveBtn" class="easyui-linkbutton c6" iconCls="icon-ok" onclick="saveTMC()" style="width:90px">Save</a>
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

        <jsp:include page="footer-for-page.jsp"></jsp:include>
            <!-- loder div -->
            <div style="display: none;" id="loader_div" class="loader_div">
                <div class="loader" id="loader_show">
                </div>
            </div>
        </body>
        <script type="text/javascript" src="resources/js/jquery-2.2.3.min.js"></script>
        <script type="text/javascript"
        src="resources/easyui/jquery.easyui.min.js"></script>
        <script src="resources/js/common.js"></script>
        <script type="text/javascript">
                var submitType;
                //function doSearch(){
                //	if($('#ccetype_combobox').combobox('getValue')==''){
                //		alertBox("Please Select CCE Type:");
                //	}else{
                //		var cceTypeId=$('#ccetype_combobox').combobox('getValue')==''?null:$('#ccetype_combobox').combobox('getValue');
                //		var roleId=$('#rolename_combobox').combobox('getValue')==''?null:$('#rolename_combobox').combobox('getValue');
                //		var warehouseId=$('#assign_lga_combobox').combobox('getValue')==''?null:$('#assign_lga_combobox').combobox('getValue');
                //		var searchUrl="search_cce_list?cceTypeId="+cceTypeId+"&roleId="+roleId+"&warehouseId="+warehouseId;
                //		$('#cceListTable').datagrid('reload',searchUrl);
                //	} 
                //}
                function alertBox(message) {
                    $.messager.alert('Warning!', message, 'warning');
                }
                function AddTMC() {
                    submitType = "add";
                    $('#form_dialog').dialog('open').dialog('center').dialog('setTitle', 'Add TMC');
                    $('#add_edit_form').form('clear');
                    $('#add_edit_form').attr('action', 'save_addedit_tmc?action=add');

                    $('#tmc_state_combobox_form').combobox('disable', true);




                    //    $('#rolename_combobox_form').combobox('enable',true);
                    //    $('#assign_lga_combobox_form').combobox('enable',true);    
                    //    $('#password_textbox').combobox('enable',true);
                    //    $('#confirm_password_textbox').combobox('enable',true);
                    //    $("#status_checkbox").prop("checked", true);
                    //    $("#status_checkbox").attr("disabled", true);
                    //    $("#activeted_checkbox").attr("disabled", true);
                    //    $("#activeted_checkbox").prop("checked", false);
                    //    $('#start_date').datebox('setValue',formateDate(new Date()));
                    loadFormComboboxList();
                    //    $('#ccetype_combobox_form').combobox('enable',true);
                }
                function loadFormComboboxList() {
                    $('#tmc_state_combobox_form').combobox('disable', true);
                    $('#tmc_state_combobox_form').combobox('setValue', '${userBean.getX_WAREHOUSE_ID()}');
                    $('#tmc_state_combobox_form').combobox('setText', '${userBean.getX_WAREHOUSE_NAME()}');
                    $('#tmc_lga_combobox_form').combobox({
                        url: 'getlgalistBasedOnStateId',
                        valueField: 'value',
                        textField: 'label',
                        queryParams: {stateId: '${userBean.getX_WAREHOUSE_ID()}', option: 'notAll'},
                        onSelect: function (tmcLGA) {
                            $('#tmc_facility_name_combobox_form').combobox('clear');
                            $('#tmc_ward_combobox_form').combobox({
                                url: 'getWardList',
                                valueField: 'value',
                                textField: 'label',
                                queryParams: {lgaid: tmcLGA.value, option: 'notAll'},
                                onSelect: function () {
                                    $('#tmc_location_combobox_form').combobox('clear');
                                    $('#tmc_facility_name_combobox_form').combobox({
                                        url: 'getHflist',
                                        valueField: 'value',
                                        textField: 'label',
                                        queryParams: {lgaid: tmcLGA.value, option: 'notAll'}
                                        //                                                        onSelect : function() {

                                    });
                                    $('#cce_make_combobox_form').combobox({
                                        url: 'get_cce_specification_list',
                                        valueField: 'value',
                                        textField: 'label',
                                        queryParams: {arg0: 'MakeList', arg1: '', arg2: '', arg3: ''},
                                        onSelect: function (make) {
                                            $('#cce_type_combobox_form').combobox('clear');
                                            $('#cce_model_combobox_form').combobox({
                                                url: 'get_cce_specification_list',
                                                valueField: 'label',
                                                textField: 'label',
                                                queryParams: {arg0: 'ModelList', arg1: make.label, arg2: '', arg3: ''},
                                                onSelect: function (model) {
                                                    $('#cce_category_combobox_form').combobox('clear');
                                                    $('#cce_type_combobox_form').combobox({
                                                        url: 'get_cce_specification_list',
                                                        valueField: 'value',
                                                        textField: 'label',
                                                        queryParams: {arg0: 'TypeList', arg1: make.label, arg2: model.label, arg3: ''},
                                                        onSelect: function (type) {
                                                            $('#cce_category_combobox_form').combobox({
                                                                url: 'get_cce_specification_list',
                                                                valueField: 'value',
                                                                textField: 'label',
                                                                queryParams: {arg0: 'CategoryList', arg1: make.label, arg2: model.label, arg3: type.label},
                                                                onSelect: function () {
                                                                    $('#cce_status_combobox_form').combobox({
                                                                        url: 'get_cce_specification_list',
                                                                        valueField: 'label',
                                                                        textField: 'label',
                                                                        queryParams: {arg0: 'StatusList', arg1: '', arg2: '', arg3: ''},
                                                                        onSelect: function (status) {
                                                                            $('#cce_decision_combobox_form').combobox({
                                                                                url: 'get_cce_specification_list',
                                                                                valueField: 'label',
                                                                                textField: 'label',
                                                                                queryParams: {arg0: 'DecisionList', arg1: status.label, arg2: '', arg3: ''}
                                                                            });
                                                                            $('#cce_src_combobox_form').combobox({
                                                                                url: 'get_cce_specification_list',
                                                                                valueField: 'label',
                                                                                textField: 'label',
                                                                                queryParams: {arg0: 'SourceList', arg1: '', arg2: '', arg3: ''}
                                                                            });
                                                                            $('#cce_acquisition1_combobox_form').combobox({
                                                                                url: 'get_last_20_years_list',
                                                                                valueField: 'value',
                                                                                textField: 'label'
                                                                            });
                                                                            $('#cce_acquisition2_combobox_form').combobox({
                                                                                url: 'get_month_number_list',
                                                                                valueField: 'value',
                                                                                textField: 'label'
                                                                            });
                                                                        }
                                                                    })
                                                                }
                                                            });

                                                        }
                                                    });

                                                }
                                            });
                                        }
                                    });

                                }
                            });
                        }
                    });



                }
                function saveTMC() {
                    $('#add_edit_form').form('submit', {
                        url: $('#add_edit_form').attr('action'),
                        onSubmit: function () {
                            var errormessage = "";
                            var validate = true;

                            if ($('#tmc_lga_combobox_form').combobox('getValue') == '') {
                                errormessage = "LGA is Empty!";
                                validate = false;
                            } else if ($('#tmc_ward_combobox_form').combobox('getValue') == '') {
                                errormessage = "Name of Ward is Empty!";
                                validate = false;
                            } else if ($('#tmc_facility_name_combobox_form').combobox('getValue') == '') {
                                errormessage = "Name of Facility is Empty!";
                                validate = false;
                            } else if ($('#tmc_location_combobox_form').combobox('getValue') == '') {
                                errormessage = "Equipment Location is Empty!";
                                validate = false;
                            } else if ($('#tmc_has_electricity_combobox_form').combobox('getValue') == '') {
                                errormessage = "Facility Has Electricity is Empty!";
                                validate = false;
                            } else if ($('#tmc_hrs_textbox').textbox('getValue') == '') {
                                errormessage = "Hours of Electricity is Empty!";
                                validate = false;
                            } else if ($('#tmc_device_available_combobox_form').combobox('getValue') == '') {
                                errormessage = "Device Available is Empty!";
                                validate = false;
                            } else if ($('#tmc_type_of_device_combobox_form').combobox('getValue') == '') {
                                errormessage = "Type of device is Empty!";
                                validate = false;
                            }
                            if (errormessage != '') {
                                alertBox(errormessage);
                            }
                            return validate;
                        },
                        success: function (result) {
                            if (result.toString() == 'success') {
                                // close the dialog
                                alertBox("Operation Successful");
                                refreshData();
                            } else {
                                alertBox("Operation Failed");
                            }
                            $('#form_dialog').dialog('close');
                        }
                    });
                }
                function editTMC(buttonId) {
                    if (buttonId == 'editBtn') {
                        $('#saveBtn').linkbutton('enable', true);
                    } else {
                        $('#saveBtn').linkbutton('disable', true);
                    }
                    submitType = "edit";
                    var row = $('#tmcListTable').datagrid('getSelected');

                    if (row) {
                        if (buttonId == 'editBtn') {
                            $('#form_dialog').dialog('open').dialog('center').dialog('setTitle', 'Edit TMC');
                        } else {
                            $('#form_dialog').dialog('open').dialog('center').dialog('setTitle', 'Overview Of TMC');
                        }
                        loadFormComboboxList();
                        $('#tmc_state_combobox_form').combobox('setValue', row.STATE_ID);
                        $('#tmc_state_combobox_form').combobox('setText', row.STATE);
                        $('#tmc_lga_combobox_form').combobox('setValue', row.LGA_ID);
                        $('#tmc_lga_combobox_form').combobox('setText', row.LGA);
                        $('#tmc_ward_combobox_form').combobox('setValue', row.WARD);
                        $('#tmc_ward_combobox_form').combobox('setText', row.WARD);
                        $('#tmc_facility_name_combobox_form').combobox('setValue', row.FACILITY_ID);
                        $('#tmc_facility_name_combobox_form').combobox('setText', row.FACILITY_NAME);
                        $('#tmc_location_combobox_form').combobox('setValue', row.LOCATION);
                        $('#tmc_has_electricity_combobox_form').combobox('setValue', row.FACILITY_HAS_ELECTRICITY);
                        $('#tmc_hrs_textbox').textbox('setValue', row.ELECTRICITY_HRS);
                        $('#tmc_device_available_combobox_form').combobox('setValue', row.DEVICE_AVAILABLE);
                        $('#tmc_type_of_device_combobox_form').combobox('setValue', row.TYPE_OF_DEVICE);

                        //Disable lga,ward,health facility
                        // $('#tmc_lga_combobox_form').combobox('disable', true);
                        // $('#tmc_ward_combobox_form').combobox('disable', true);
                        //  $('#tmc_facility_name_combobox_form').combobox('disable', true);

                        $('#add_edit_form').attr('action', 'save_addedit_tmc?action=edit&tmcId=' + row.TMC_DATA_ID);

                    } else {
                        alertBox("Please Select Record!");
                    }

                }

                function refreshData() {
                    //	$('#ccetype_combobox').combobox('clear');
                    //	$('#rolename_combobox').combobox('clear');
                    //	$('#assign_lga_combobox').combobox('clear');
                    $('#tmcListTable').datagrid('reload', 'gettmclist');
                }
                //function handleHistory(){
                //	 var row = $('#cceListTable').datagrid('getSelected');
                //	 document.getElementById("loader_div").style.display = "block";
                //	 if(row==null){
                //		 alertBox("Please Select Record From Table")
                //	 }else{
                //		 $.ajax({
                //			  url: "get_history_cce",
                //			  type: "post", //send it through post method
                //			  data:{cce_id: row.USER_ID},
                //			  dataType:'json',
                //			  async:false,
                //			  success: function(response) {
                //				  if(response[0].CREATED_BY=='' || response[0].CREATED_BY==null){
                //					  $('#createdBylabel').text("<Not Available>");
                //				  }else{
                //					  $('#createdBylabel').text(response[0].CREATED_BY); 
                //				  }
                //				  $('#createdOnlabel').text(response[0].CREATED_ON);
                //				  $('#updatedBylabel').text(response[0].UPDATED_BY);
                //				  $('#updatedOnlabel').text(response[0].LAST_UPDATED_ON);
                //				  $('#history_dialog').dialog('open').dialog('center').dialog('setTitle','CCE Record History');  
                //				 // document.getElementById("loader_div").style.display = "none";
                //			  },
                //			  error: function(xhr) {
                //			   alert("error in get history data");
                //			  }
                //			});
                //		
                //	 }
                //	 document.getElementById("loader_div").style.display = "none";
                //}
                //function handleChangePassword(){
                //	 var row = $('#cceListTable').datagrid('getSelected');
                //	 if(row==null){
                //		 alertBox("Please Select Record From Table")
                //	 }else{
                //		 $('#old_password').textbox('clear');
                //		 $('#new_password').textbox('clear');
                //		 $('#confirm_password').textbox('clear');
                //		 $('#change_password_dialog').dialog('open').dialog('center').dialog('setTitle','Change Password'); 
                //	 }
                //}
                //function changePasswordActionOk(){
                //	var row = $('#cceListTable').datagrid('getSelected');
                //	if($('#old_password').val()==''){
                //		alertBox("Old Password Is Empty!");
                //		$('#old_password').focus();
                //	}else if($('#new_password').val()==''){
                //		alertBox("New Password Is Empty!");
                //	}else if($('#confirm_password').val()==''){
                //		alertBox("Confirm Password Is Empty!");
                //	}else if($('#confirm_password').val()!=$('#new_password').val()){
                //		alertBox("New Password And Confirm Password Does Note Match!");
                //	}else{
                //		document.getElementById("loader_div").style.display = "block";
                //		$('#change_password_dialog').dialog('close');
                //		var newPassword=$('#new_password').val();
                //		var oldPassword=$('#old_password').val();
                //		$.ajax({
                //			  url: "change_user_password?user_id="+row.USER_ID+"&oldPassword="+oldPassword+"&newPassword="+newPassword,
                //			  type: "post", //send it through post method
                //			  dataType:'text',
                //			  success: function(response) {
                //				 document.getElementById("loader_div").style.display = "none";
                // 					if(response=='succsess'){
                // 						 alertBox(" Password Updated Succesufully");
                // 							refreshData();
                //				  	}else{
                //				  		alertBox(" Old Password Is Not Correct");
                //				  	}
                //				},
                //			  error: function(xhr) {
                //			   alert("Error in change password");
                //			  }
                //			});
                //	}
                //}
    </script>
    <script type="text/javascript">
        $('#tmcListTable').datagrid({
            url: 'gettmclist',
            remoteSort: false,
            columns: [[
                    {field: 'STATE_ID', title: 'STATE ID', sortable: true, hidden: true},
                    {field: 'STATE', title: 'STATE', sortable: true, hidden: true},
                    {field: 'LGA', title: 'NAME OF LGA', sortable: true},
                    {field: 'WARD', title: 'NAME OF WARD', sortable: true},
                    {field: 'LOCATION', title: 'DEVICE LOCATION', sortable: true
                    },
                    {field: 'LGA_ID', title: 'LGA ID', sortable: true, hidden: true},
                    {field: 'FACILITY_NAME', title: 'NAME OF FACILITY', sortable: true},
                    {field: 'WAREHOUSE_TYPE_ID', title: 'WAREHOUSE TYPE ID', sortable: true, hidden: true},
                    {field: 'DEFAULT_ORDERING_WAREHOUSE_ID', title: 'DEFAULT ORDERING WAREHOUSE ID', sortable: true, hidden: true},
                    {field: 'TMC_DATA_ID', title: 'TMC DATA ID', sortable: true, hidden: true},

                    {field: 'FACILITY_HAS_ELECTRICITY', title: 'LOCATION HAS ELECTRICITY?', sortable: true},
                    {field: 'ELECTRICITY_HRS', title: 'HOURS OF ELECTRICITY PER DAY', sortable: true},
                    {field: 'DEVICE_AVAILABLE', title: 'DEVICE AVAILABLE', sortable: true},
                    {field: 'TYPE_OF_DEVICE', title: 'TYPE OF DEVICE', sortable: true}
                ]],
            onClickRow: function (index, row) {
                if ('${userBean.getX_ROLE_NAME()}' == 'NTO') {
                    if (row.ROLE_NAME != 'NTO') {
                        $('#editBtn').attr('class', 'w3-btn w3-disabled w3-ripple');
                        $('#editBtn').attr('onclick', '');
                    } else {
                        $('#editBtn').attr('class', 'w3-btn w3-ripple');
                        $('#editBtn').attr('onclick', 'editCCE(this.id)');
                    }
                } else if ('${userBean.getX_ROLE_NAME()}' == 'SIO') {
                    if (row.ROLE_NAME != 'SIO') {
                        $('#editBtn').attr('class', 'w3-btn w3-disabled w3-ripple');
                        $('#editBtn').attr('onclick', '');
                    } else {
                        $('#editBtn').attr('class', 'w3-btn w3-ripple');
                        $('#editBtn').attr('onclick', 'editCCE(this.id)');
                    }
                } else if ('${userBean.getX_ROLE_NAME()}' == 'SIFP') {
                    if (row.ROLE_NAME != 'SIFP') {
                        $('#editBtn').attr('class', 'w3-btn w3-disabled w3-ripple');
                        $('#editBtn').attr('onclick', '');
                    } else {
                        $('#editBtn').attr('class', 'w3-btn w3-ripple');
                        $('#editBtn').attr('onclick', 'editCCE(this.id)');
                    }
                }
            }
        });
    </script>
    <!--  <script type="text/javascript">
          hideAfterCurrentDate('#cce_nf_date');//for disable after current date 
          //hideBeforCurrentDate('#end_date');//for disable before current date 
          $('#cce_nf_date').datebox({
              formatter: myformatter,
              parser: myparser
          });
  
      </script>-->
    <script type="text/javascript">
        loadPaginationForTable(tmcListTable);
    </script>

</html>