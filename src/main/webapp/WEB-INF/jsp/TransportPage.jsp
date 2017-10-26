<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="f"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>Transport</title>
        <link rel="stylesheet" href="resources/css/buttontoolbar.css"
              type="text/css">
        <link rel="stylesheet" href="resources/css/table.css" type="text/css">
        <link rel="stylesheet" type="text/css" href="resources/easyui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="resources/easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="resources/easyui/demo/demo.css">
        <script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
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
                document.getElementById("common_lable").innerHTML = "Transport";
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

            $(document).ready(function () {

                $('#tr_functional').change(function () {
                    if ($(this).prop('checked')) {
                        //duration_of_nf_textbox
                        $("#duration_of_nf_textbox").prop('disabled', true);
                        $("#tr_functional2").val("F");
                    } else {
                        $("#duration_of_nf_textbox").prop('disabled', false);
                        $("#tr_functional2").val("NF");
                    }
                });

                $('#x6').change(function () {
                    if ($(this).prop('checked')) {
                        //duration_of_nf_textbox
                        $("#x66").val("YES");
                    } else {
                        $("#x66").val("NO");
                    }
                });

                $('#x2').change(function () {
                    if ($(this).prop('checked')) {
                        //duration_of_nf_textbox
                        $("#x22").val("YES");
                    } else {

                        $("#x22").val("NO");
                    }
                });

                $('#x3').change(function () {
                    if ($(this).prop('checked')) {
                        //duration_of_nf_textbox
                        $("#x33").val("YES");
                    } else {

                        $("#x33").val("NO");
                    }
                });

                $('#x4').change(function () {
                    if ($(this).prop('checked')) {
                        //duration_of_nf_textbox
                        $("#x44").val("YES");
                    } else {
                        $("#x44").val("NO");
                    }
                });

                $('#x5').change(function () {
                    if ($(this).prop('checked')) {
                        //duration_of_nf_textbox
                        $("#x55").val("YES");
                    } else {
                        $("#x55").val("NO");
                    }
                });

                $("#duration_of_nf_textbox").focusout(function () {
                    $("#duration_of_nf_textbox2").val(this.val());
                });

            });


        </script>
        <style type="text/css">
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
                    <li><a id="addBtn" class="w3-btn w3-ripple" onclick="AddTransport()" > <img alt="add"
                                                                                                src="resources/images/file_add.png">Add
                        </a>
                    </li>
                    <li><a id="editBtn" class="w3-btn w3-ripple" onclick="editTransport(this.id)"> <img alt="edit"
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

            <div id="transport_table_div" style="margin-left: 5px;">
                <table id="transportListTable" class="easyui-datagrid"
                       style="width: 100%; height: 430px;padding-left: 5px;" title="Transport"
                       data-options="toolbar:'#table_toolbar', rownumbers:'true',  singleSelect:'true',
                       striped:'true', remoteSort:'false',pagination:'true',pageSize:20">	
                </table>
            </div>

            <!-- add edit form -->

            <div id="form_dialog" class="easyui-dialog" style="width:430px;height:520px;padding:10px 20px"
                 closed="true" buttons="#form_buttons">
            <f:form id="add_edit_form" method="post" commandName="beanForTransport">
                <table cellspacing="10px;">
                    <tr>
                        <td>
                            <div id="transport_state_div">
                                <label id="transport_state_label">*State:</label>
                                <f:select  id="transport_state_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_TRANSPORT_STATE_ID"/>
                            </div>
                        </td>
                        <td>
                            <div class="transport_lga_div">
                                <label id="transport_lga_label"> *LGA:</label>
                                <f:select id="transport_lga_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_TRANSPORT_LGA_ID"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="transport_ward_div">
                                <label id="transport_ward_label">*Ward:</label>
                                <f:select id="transport_ward_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_TRANSPORT_WARD_ID"/>
                            </div>
                        </td>
                        <td>

                            <div class="transport_facility_name_div">
                                <label id="transport_facility_name_label">*Site Name:</label>
                                <f:select  id="transport_facility_name_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_TRANSPORT_FACILITY_ID" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>

                            <div class="equipment_location_div">
                                <label id="equipment_location_label">*Equipment Location:</label>
                                <f:select id="equipment_location_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_TRANSPORT_LOCATION">
                                    <option value="State">State</option>
                                    <option value="LGA">LGA</option>
                                    <option value="Facility">Facility</option>
                                </f:select>
                            </div>
                        </td>
                        <td>
                            <div class="transport_number_of_hf_served_div">
                                <label id="transport_number_of_hf_served_label">*Number of HF Served:</label>
                                <f:input id="transport_number_of_hf_served_textbox"  class="easyui-textbox" path="x_TRANSPORT_NUMBER_OF_HF"/>
                            </div>
                        </td>
                    </tr>
                    <tr>

                        <td>

                            <div class="type_of_transport_div">
                                <label id="type_of_transport_label">*Type of Transport:</label>
                                <f:select id="type_of_transport_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_TRANSPORT_TYPE">
                                    <option value="Tricycle">Tricycles</option>
                                    <option value="Motorbike">Motor Bikes</option>
                                    <option value="Ward">Vehicles</option>

                                </f:select>
                            </div>
                        </td>
                        <td>
                            <div id="transport_make_div">
                                <label id="transport_make_label">*Make:</label>
                                <f:select id="transport_make_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_TRANSPORT_MAKE">
                                    <option value="Toyota">Toyota</option>
                                    <option value="Jim Bei">Jim Bei</option>
                                    <option value="Yamaha">Yamaha</option>
                                    <option value="Jincheng">Jincheng</option>
                                </f:select>
                            </div>
                        </td>
                    </tr>
                    <tr>

                        <td>

                            <div id="transport_model_div">
                                <label id="transport_model_label">*Model:</label>
                                <f:select id="transport_model_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_TRANSPORT_MODEL">
                                    <option value="Hiace">Hiace</option>
                                    <option value="Corolla">Corolla</option>
                                    <option value="Camry">Camry</option>

                                </f:select>
                            </div>
                        </td>
                        <td>
                            <div id="transport_owner_div">
                                <label id="transport_owner_label">*Owner:</label>
                                <f:select id="transport_owner_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_TRANSPORT_OWNER">
                                    <option value="O">O</option>
                                    <option value="P">P</option>
                                    <option value="E">E</option>

                                </f:select>
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <div class="transport_status_div">
                                <input id="tr_functional" name="tr_functional2" type="checkbox"  />
                                <label id="transport_functional_label">*Functional?:</label>
                                <input type="hidden" id="tr_functional2" name="hidden2" value="NF" />
                            </div>
                        </td>
                        <td>

                            <div class="fuel_available_div">
                                <input id="x2" type="checkbox" path="x_TRANSPORT_FUEL_AVAILABLE" value="0"/>  
                                <label id="fuel_available_label">*Fuel Available?:</label>
                                <input type="hidden" id="x22" name="x22" value="NF" />

                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="duration_of_nf_div">
                                <label id="duration_of_nf_label">*Duration of NF(Months):</label>
                                <input id="duration_of_nf_textbox" path="x_TRANSPORT_DURATION_NF" autocomplete="off"/>
                                <input type="hidden" id="duration_of_nf_textbox2" name="duration_of_nf_textbox2" value="0" />
                            </div>
                        </td>
                        <td>

                            <div class="serviced_div">
                                <input id="x3" type="checkbox" path="x_TRANSPORT_SERVICED" value="0"/>
                                <label id="serviced_label">*Serviced?:</label>
                                <input type="hidden" id="x33" name="x33" value="NF" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="awaiting_funds_div">
                                <input type="hidden" id="x44" name="x44" value="NF" />
                                <input id="x4" type="checkbox" path="x_TRANSPORT_AWAITING_FUND" value="0"/>
                                <label id="awaiting_funds_label">*Awaiting Funds:</label>                               

                            </div>
                        </td>
                        <td>
                            <div class="funds_available_div">
                                <input type="hidden" id="x55" name="x55" value="NF" />
                                <input id="x5" type="checkbox" path="x_TRANSPORT_FUND_AVAILABLE" value="0"/> 
                                <label id="funds_available_label">*Funds Available?:</label>                             

                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="ppm_conducted_div">
                                <input id="x6" type="checkbox" path="x_TRANSPORT_PPM_CONDUCTED" value="0"/>
                                <label id="ppm_conducted_label">*PPM Conducted:</label>

                                <input type="hidden" id="x66" name="x66" value="NF" />
                            </div>
                        </td>
                        <td>
                            <div class="distance_from_vaccine_source_div">
                                <label id="distance_from_vaccine_source_label">*Distance from Vaccine Source:</label>
                                <f:input id="distance_from_vaccine_source_textbox"  class="easyui-textbox" path="x_TRANSPORT_DISTANCE"/>
                            </div>
                        </td>
                    </tr>

                </table>
            </f:form>
        </div>
        <div id="form_buttons">
            <a href="javascript:void(0)" id="saveBtn" class="easyui-linkbutton c6" iconCls="icon-ok" onclick="saveTransport()" style="width:90px">Save</a>
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
                function AddTransport() {
                    submitType = "add";
                    $('#form_dialog').dialog('open').dialog('center').dialog('setTitle', 'Add Transport');
                    $('#add_edit_form').form('clear');
                    $('#add_edit_form').attr('action', 'save_addedit_transport?action=add');
                    $('#transport_state_combobox_form').combobox('disable', true);
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
                    
                    //
                    $("#tr_functional2").val("NF");
                    $("#x22").val("NO");
                    $("#x33").val("NO");
                    $("#x44").val("NO");
                    $("#x55").val("NO");
                    $("#x66").val("NO");
                    
                    //
                    $("#duration_of_nf_textbox2").val(0);
                    $("#duration_of_nf_textbox").val(0);

                    //    $('#ccetype_combobox_form').combobox('enable',true);
                }
                function loadFormComboboxList() {
                    $('#transport_state_combobox_form').combobox('disable', true);
                    $('#transport_state_combobox_form').combobox('setValue', '${userBean.getX_WAREHOUSE_ID()}');
                    $('#transport_state_combobox_form').combobox('setText', '${userBean.getX_WAREHOUSE_NAME()}');
                    $('#transport_lga_combobox_form').combobox({
                        url: 'getlgalistBasedOnStateId',
                        valueField: 'value',
                        textField: 'label',
                        queryParams: {stateId: '${userBean.getX_WAREHOUSE_ID()}', option: 'notAll'},
                        onSelect: function (transportLGA) {
                            $('#transport_facility_name_combobox_form').combobox('clear');
                            $('#transport_ward_combobox_form').combobox({
                                url: 'getWardList',
                                valueField: 'value',
                                textField: 'label',
                                queryParams: {lgaid: transportLGA.value, option: 'notAll'},
                                onSelect: function () {
                                    $('#transport_location_combobox_form').combobox('clear');
                                    $('#transport_facility_name_combobox_form').combobox({
                                        url: 'getHflist',
                                        valueField: 'value',
                                        textField: 'label',
                                        queryParams: {lgaid: transportLGA.value, option: 'notAll'}
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
                function saveTransport() {
                    $('#add_edit_form').form('submit', {
                        url: $('#add_edit_form').attr('action'),
                        onSubmit: function () {
                            var errormessage = "";
                            var validate = true;
                            if ($('#transport_state_combobox_form').combobox('getValue') == '') {
                                errormessage = "State is Empty!";
                                validate = false;
                            } else if ($('#transport_lga_combobox_form').combobox('getValue') == '') {
                                errormessage = "LGA is Empty!";
                                validate = false;
                            } else if ($('#transport_ward_combobox_form').combobox('getValue') == '') {
                                errormessage = "Ward is Empty!";
                                validate = false;
                            } else if ($('#transport_facility_name_combobox_form').combobox('getValue') == '') {
                                errormessage = "Facility Name is Empty!";
                                validate = false;
                            } else if ($('#transport_number_of_hf_served_textbox').textbox('getValue') == '') {
                                errormessage = "Number of Health Facility Serviced is Empty!";
                                validate = false;
                            } else if ($('#type_of_transport_combobox_form').combobox('getValue') == '') {
                                errormessage = "Type of Transport is Empty!";
                                validate = false;
                            } else if ($('#transport_owner_combobox_form').combobox('getValue') == '') {
                                errormessage = "Owner is Empty!";
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
                function editTransport(buttonId) {
                    if (buttonId == 'editBtn') {
                        $('#saveBtn').linkbutton('enable', true);
                    } else {
                        $('#saveBtn').linkbutton('disable', true);
                    }
                    submitType = "edit";
                    var row = $('#transportListTable').datagrid('getSelected');
                    if (row) {
                        if (buttonId == 'editBtn') {
                            $('#form_dialog').dialog('open').dialog('center').dialog('setTitle', 'Edit Transport');
                        } else {
                            $('#form_dialog').dialog('open').dialog('center').dialog('setTitle', 'Overview Of Transport');
                        }
                        loadFormComboboxList();
                        $('#transport_state_combobox_form').combobox('setValue', row.STATE_ID);
                        $('#transport_state_combobox_form').combobox('setText', row.STATE);
                        $('#transport_lga_combobox_form').combobox('setValue', row.LGA_ID);
                        $('#transport_lga_combobox_form').combobox('setText', row.LGA);
                        $('#transport_ward_combobox_form').combobox('setValue', row.WARD);
                        $('#transport_ward_combobox_form').combobox('setText', row.WARD);
                        $('#transport_facility_name_combobox_form').combobox('setValue', row.FACILITY_ID);
                        $('#transport_facility_name_combobox_form').combobox('setText', row.FACILITY_NAME);
                        $('#transport_number_of_hf_served_textbox').textbox('setValue', row.NUMBER_OF_HF_SERVED);
                        $('#transport_number_of_hf_served_textbox').textbox('setText', row.NUMBER_OF_HF_SERVED);
                        $('#type_of_transport_combobox_form').combobox('setValue', row.TYPE_OF_TRANSPORT);
                        $('#type_of_transport_combobox_form').combobox('setText', row.TYPE_OF_TRANSPORT);
                        $('#transport_make_combobox_form').combobox('setValue', row.MAKE);
                        $('#transport_make_combobox_form').combobox('setText', row.MAKE);
                        $('#transport_model_combobox_form').combobox('setValue', row.MODEL);
                        $('#transport_model_combobox_form').combobox('setText', row.MODEL);
                        $('#transport_owner_combobox_form').combobox('setValue', row.OWNER);
                        $('#transport_owner_combobox_form').combobox('setText', row.OWNER);
                        //$('#duration_of_nf_textbox').textbox('setValue', row.DURATION_NF);
                       // $('#duration_of_nf_textbox').textbox('setText', row.DURATION_NF);
                        $('#distance_from_vaccine_source_textbox').textbox('setValue', row.DISTANCE_FROM_VACCINE_SOURCE);
                        $('#distance_from_vaccine_source_textbox').textbox('setText', row.DISTANCE_FROM_VACCINE_SOURCE);
                       
                      /*  if(row.STATUS === "F"){
                            //Check the box, disable nf
                            $("#tr_functional").prop("checked", true);
                            //Disable NF
                            $("#duration_of_nf_textbox").prop('disabled', true);
                        }else{
                            //Uncheck the box, disable nf
                            $("#tr_functional").prop("checked", false);
                            //Esable NF
                            $("#duration_of_nf_textbox").prop('disabled', false);
                        }*/
            //
                    $("#tr_functional2").val((row.STATUS));
                    $("#x22").val(row.FUEL_PURCHASED);
                    $("#x33").val(row.VEHICLE_SERVICED);
                    $("#x44").val(row.AWAITING_FUNDS);
                    $("#x55").val(row.FUND_AVAILABLE);
                    $("#x66").val(row.PPM_CONDUCTED);
                        
                        $('#add_edit_form').attr('action', 'save_addedit_transport?action=edit&transportId=' + row.TRANSPORT_DATA_ID);
                    } else {
                        alertBox("Please Select Record!");
                    }

                }

                function refreshData() {
                    //	$('#ccetype_combobox').combobox('clear');
                    //	$('#rolename_combobox').combobox('clear');
                    //	$('#assign_lga_combobox').combobox('clear');
                    $('#transportListTable').datagrid('reload', 'gettransportlist');
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
        $('#transportListTable').datagrid({
            url: 'gettransportlist',
            remoteSort: false,
            columns: [[
                    {field: 'STATE_ID', title: 'STATE ID', sortable: true, hidden: true},
                    {field: 'STATE', title: 'STATE', sortable: true, hidden: true},
                    {field: 'LGA_ID', title: 'LGA ID', sortable: true, hidden: true},
                    {field: 'LGA', title: 'LGA', sortable: true},
                    {field: 'FACILITY_ID', title: 'FACILITY ID', sortable: true, hidden: true},
                    //            {field:'WARD_ID',title:'WARD ID',sortable:true,hidden:true},
                    {field: 'WARD', title: 'WARD', sortable: true},
                    {field: 'WAREHOUSE_TYPE_ID', title: 'WAREHOUSE TYPE ID', sortable: true, hidden: true},
                    {field: 'LOCATION', title: 'EQUIPMENT LOCATION', sortable: true},
                    {field: 'FACILITY_NAME', title: 'NAME OF FACILITY', sortable: true},
                    {field: 'DEFAULT_ORDERING_WAREHOUSE_ID', title: 'DEFAULT ORDERING WAREHOUSE ID', sortable: true, hidden: true},
                    {field: 'MONTHLY_TARGET_POPULATION', title: 'TARGET POPULATION', sortable: true, hidden: true},
                    {field: 'TRANSPORT_DATA_ID', title: 'DESIGNATION', sortable: true, hidden: true},
                    {field: 'NUMBER_OF_HF_SERVED', title: 'NUMBER OF HF SERVED', sortable: true},
                    {field: 'TYPE_OF_TRANSPORT', title: 'TYPE OF TRANSPORT', sortable: true},
                    {field: 'MAKE', title: 'MAKE', sortable: true},
                    {field: 'MODEL', title: 'MODEL', sortable: true},
                    {field: 'OWNER', title: 'OWNER', sortable: true},
                    {field: 'VEHICLE_SERVICED', title: 'SERVICED?', sortable: true},
                    {field: 'STATUS', title: 'FUNCTIONAL STATUS', sortable: true},
                    {field: 'FUEL_PURCHASED', title: 'FUEL PURCHASED?', sortable: true},
                    {field: 'PPM_CONDUCTED', title: 'PPM CONDUCTED THIS MONTH?', sortable: true},
                    {field: 'AWAITING_FUNDS', title: 'AWAITING FUNDS FOR REPAIRS', sortable: true},
                    {field: 'DURATION_NF', title: 'DURATION NF (MONTHS)', sortable: true},
                    {field: 'FUND_AVAILABLE', title: 'FUND AVAILABLE?', sortable: true},
                    {field: 'DISTANCE_FROM_VACCINE_SOURCE', title: 'DISTANCE FROM VACCINE SOURCE', sortable: true}
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

    <script type="text/javascript">
        loadPaginationForTable(transportListTable);
    </script>

</html>