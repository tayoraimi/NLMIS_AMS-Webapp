<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="f"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>Cold Rooms & Freezer Rooms, Refrigerators & Freezers</title>
            <link rel="stylesheet" href="resources/css/buttontoolbar.css"
                    type="text/css">
            <link rel=" stylesheet" href="resources/css/w3css.css" type="text/css">
            <link rel="stylesheet" href="resources/css/table.css" type="text/css">
            <link rel="stylesheet" type="text/css" href="resources/easyui/themes/default/easyui.css">
            <link rel="stylesheet" type="text/css" href="resources/easyui/themes/icon.css">
            <link rel="stylesheet" type="text/css" href="resources/easyui/demo/demo.css">
        <script type="text/javascript">
    function streamlineUser(){
        var user = '${userBean.getX_ROLE_NAME()}';
        if((user === 'SIO') || (user==='SIFP')|| (user==='SCCO')){
			user = 'SCCO';
		}else if(user === 'MOH'|| (user==='LIO')|| (user==='CCO')){
			user = 'LIO';
		}else if(user === 'NTO'){
			user = 'NTO';
		}
                return user;
    }
    function setRole() {
        var user = streamlineUser();
        switch (user) {
            case "SCCO":
                $('#overViewBtn').hide();
                $('#cce_state_div').hide();
                $('#info_label').text('If LGA or HF is not selected, equipment will be located at the STATE Store');
                loadlgaList({value:'${userBean.getX_WAREHOUSE_ID()}'});
                break;
            case "NTO":
                $('#overViewBtn').hide();
                $('#info_label').text('If State or LGA or HF is not selected, equipment will be located at the National Store');
                loadStateList();
                break;
            case "LIO":
                $('#cce_state_div').hide();
                $('#cce_lga_div').hide();
                $('#info_label').text('If HF is not selected, equipment will be located at the LGA Store');
                loadWardBadesdOnLga({value:'${userBean.getX_WAREHOUSE_ID()}'});
                break;
        }

    }
        </script>
        
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
                    <li><a id="addBtn" class="w3-btn w3-ripple" onclick="AddCCE()" > <img alt="add"
                                                                                          src="resources/images/file_add.png">Add
                        </a>
                    </li>
                    <li><a id="editBtn" class="w3-btn w3-ripple" onclick="editCCE(this.id)"> <img alt="edit"
                                                                                                  src="resources/images/file_edit.png">Edit
                        </a></li>
                    <!--			<li><a id="overViewBtn" class="w3-btn w3-ripple" onclick="editCCE(this.id)"> <img alt="overViewBtn"
                                                    src="resources/images/file_edit.png">OverView
                                            </a></li>-->
                    <!--			<li><a class="w3-btn w3-ripple" onclick="handleHistory()"> <img alt="history"
                                                            src="resources/images/file_history.png">History
                                            </a></li>
-->                                            <li><a class="w3-btn w3-ripple" href="cce_list_export.xls"> <img alt="export"
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
                <table id="cceListTable" class="easyui-datagrid"
                       style="width: 100%; height: 630px;padding-left: 5px;" title="CCE"
                       data-options="toolbar:'#table_toolbar', rownumbers:'true',  singleSelect:'true',
                       striped:'true', remoteSort:'false',pagination:'true',pageSize:20">	
                </table>
            </div>

            <!-- add edit form -->

            <div id="form_dialog" class="easyui-dialog" style="width:430px;height:580px;padding:10px 20px"
                 closed="true" buttons="#form_buttons">
            <f:form id="add_edit_form" method="post" commandName="beanForCCE">
                <table cellspacing="10px;">
                    <div class="row" style="color: red;">
				<span id="info_label"></span>
			</div>
                    <tr>
                        <td>
                            <f:hidden id="cce_facility_id_form" path="x_CCE_FACILITY_ID"/>
                            <f:hidden id="cce_data_id_form" path="x_CCE_DATA_ID"/>
                            <div id="cce_state_div">
                                <label id="cce_state_label">*State:</label>
                                <f:select id="cce_state_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_CCE_STATE_ID"/>
                            </div>
                        </td>
                        <td>
                            <div id="cce_lga_div">
                                <label id="cce_lga_label"> *LGA:</label>
                                <f:select id="cce_lga_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_CCE_LGA_ID"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div id="cce_ward_div">
                                <label id="cce_ward_label">*Ward:</label>
                                <f:select id="cce_ward_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_CCE_WARD"/>
                            </div>
                        </td>
                        <td>

                            <div id="cce_facility_name_div">
                                <label id="cce_facility_name_label">*Site Name:</label>
                                <f:select  id="cce_facility_name_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_CCE_PHC_ID" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div id="cce_location_div">
                                <label id="cce_location_label">*Equipment Location/Store will be:</label>
                                <f:input id="cce_location_textbox" readonly="true"  class="easyui-textbox" path="x_CCE_LOCATION"/>
                            </div>
                        </td>
                        <td>

                        </td>
                    </tr>
                    <tr>
                        <td>

                            <div id="cce_model_div">
                                <label id="cce_model_label">*Model:</label>
                                <f:select id="cce_model_combobox_form"  
                                          class="easyui-combobox " cssStyle="width:150px;" path="x_CCE_MODEL"/>
                            </div>
                        </td>
                        <td>
                            <div id="cce_make_div">
                                <label id="cce_make_label">*Company/Make:</label>
                                <f:select id="cce_make_combobox_form"  
                                          class="easyui-combobox" cssStyle="width:150px;" path="x_CCE_MAKE"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div id="cce_type_div">
                                <label id="cce_type_label">*Type:</label>
                                <f:select id="cce_type_combobox_form"  
                                          class="easyui-combobox "  cssStyle="width:150px;" path="x_CCE_TYPE"/>
                            </div>
                        </td>
                        <td>

                            <div id="cce_category_div">
                                <label id="cce_category_label">*Category:</label>
                                <f:select id="cce_category_combobox_form"  
                                          class="easyui-combobox " cssStyle="width:150px;" path="x_CCE_CATEGORY"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div id="cce_serial_div">
                                <label id="cce_serial_label">*Serial:</label>
                                <f:input id="cce_serial_textbox"  class="easyui-textbox" path="x_CCE_SERIAL_NO"/>
                            </div>
                        </td>
                        <td>

                            <div class="cce_status_div">
                                <label id="cce_status_label">*Status:</label>
                                <f:select  id="cce_status_combobox_form"
                                           class="easyui-combobox" cssStyle="width:150px;" path="x_CCE_STATUS">
                                    <option value=""></option>
                                    <option value="Functional">Functional</option>
                                    <option value="Not Functional">Not Functional</option>
                                    <option value="Not Installed">Not Installed</option>
                                </f:select>
                                <input type="text" hidden id="hiddenStatus" value="N/A" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div id="cce_decision_div">
                                <label id="cce_decision_label">*Decision:</label>
                                <f:select id="cce_decision_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_CCE_DECISION"/>
                            </div>
                        </td>
                        <td>
                            <div id="cce_nf_date_div">
                                <label id="cce_nf_date_label">Date Not Functional:</label>
                                <f:input id="cce_nf_date"  class="easyui-datebox" width="120px" path="x_CCE_DATE_NF" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div id="cce_acquisition_div">
                                <label id="cce_acquisition_label">*Year/Month of Installation:</label>
                                <f:select  id="cce_acquisition1_combobox_form"  class="easyui-combobox" cssStyle="width:60px;" path="x_CCE_YEAR_OF_ACQUISITION" />
                                /
                                <f:select  id="cce_acquisition2_combobox_form"  class="easyui-combobox" cssStyle="width:60px;" path="x_CCE_MONTH_OF_ACQUISITION" />
                            </div>
                        </td>
                        <td>

                            <div id="cce_src_div">
                                <label id="cce_src_label">*Source of CCE:</label>
                                <f:input id="cce_src_combobox_form"  
                                         class="easyui-combobox" cssStyle="width:150px;" path="x_CCE_SOURCE"/>
                            </div>
                        </td>
                    </tr>
                </table>
            </f:form>
        </div>
        <div id="form_buttons">
            <a href="javascript:void(0)" id="saveBtn" class="easyui-linkbutton c6" iconCls="icon-ok" onclick="saveCCE()" style="width:90px">Save</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#form_dialog').dialog('close')" style="width:90px">Cancel</a>
        </div>

        <!-- history div -->

        

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
                        var expectedWorkingLife;
                        var yearsInstalled;
        
                        function alertBox(message) {
                            $.messager.alert('Warning!', message, 'warning');
                        }
                        function makeNonEditableCombos(){
                            $('#cce_state_combobox_form').combobox({editable:false});
                            $('#cce_lga_combobox_form').combobox({editable:false});
                            $('#cce_ward_combobox_form').combobox({editable:false});
                            $('#cce_facility_name_combobox_form').combobox({editable:false});
//                            $('#cce_location_textbox').textbox({editable:false});
//                            $('#cce_location_textbox').textbox('disable',true);
                            $('#cce_make_combobox_form').combobox({ disabled: true });
                            $('#cce_model_combobox_form').combobox({editable:false});
                            $('#cce_type_combobox_form').combobox({ disabled: true });
                            $('#cce_category_combobox_form').combobox({ disabled: true });
                            $('#cce_status_combobox_form').combobox({editable:false});
                            $('#cce_decision_combobox_form').combobox({editable:false});
                            $('#cce_acquisition1_combobox_form').combobox({editable:false});
                            $('#cce_acquisition2_combobox_form').combobox({editable:false});
                            
                        }
                        function showLocations(){
                            var user = streamlineUser();
                                $('#cce_ward_div').show();
                                $('#cce_facility_name_div').show();
                                $('#cce_location_div').show();
                            if(user == 'NTO'){
                                $('#cce_location_textbox').textbox('setValue','National');
                                $('#cce_state_div').show();
                                $('#cce_lga_div').show();
                            }
                            if(user == 'SCCO'){
                                $('#cce_location_textbox').textbox('setValue','STATE');
                                $('#cce_lga_div').show();
                            }
                            if(user == 'LIO'){
                                $('#cce_location_textbox').textbox('setValue','LGA');
                            }
//                            $('#cce_location_div').show();
                        }
//                        function setFacilityId(value){
                            
//                            $('#cce_facility_id_field').textbox('setValue',value);
//                            if($('#cce_state_combobox_form').combobox('getValue')==''){
//                                $('#cce_facility_id_field').textbox('setValue','101');
//                            }
//                            else if($('#cce_lga_combobox_form').combobox('getValue')==''){
//                                 
//                                $('#cce_facility_id_field').textbox('setValue',$('#cce_state_combobox_form').combobox('getText'));
//                            }
//                            else if($('#cce_ward_combobox_form').combobox('getValue')=='' || $('#cce_facility_name_combobox_form').combobox('getValue')==''){
//                                 
//                                $('#cce_facility_id_field').textbox('setValue',$('#cce_state_combobox_form').combobox('getText'));
//                            }
//                        }
                        function AddCCE() {
                            submitType = "add";
                            $('#form_dialog').dialog('open').dialog('center').dialog('setTitle', 'Add CCE');
                            
                            makeNonEditableCombos();
                            
                            $('#add_edit_form').form('clear');
                            showLocations();
                            $('#cce_facility_id_form').val(${userBean.getX_WAREHOUSE_ID()});
                            loadCCEDetailsDropdown();
                            $('#add_edit_form').attr('action', 'save_addedit_cce?action=add');
                        }
                        function loadCCEDetailsDropdown() {
//                            $('#cce_state_combobox_form').combobox('setValue', '${userBean.getX_WAREHOUSE_ID()}');
//                            $('#cce_state_combobox_form').combobox('setText', '${userBean.getX_WAREHOUSE_NAME()}');
                             var user = streamlineUser();
                             $('#cce_model_combobox_form').combobox({
                                url: 'get_cce_specification_list',
                                valueField: 'label',
                                textField: 'label',
                                queryParams: {arg0: 'ModelList', arg1: '', arg2: '', arg3: ''},
                                onSelect: function (model) {
                                    loadCCEDetailFields(model.label);
                                
                                }
                            });
                $('#cce_status_combobox_form').combobox({
                    onSelect: function (status) {
                        $('#cce_decision_combobox_form').combobox({
                            url: 'get_cce_specification_list',
                            valueField: 'label',
                            textField: 'label',
                            queryParams: {arg0: 'DecisionList', arg1: $('#cce_status_combobox_form').combobox('getValue'), arg2: '', arg3: ''}
                        });
                        $('#cce_src_combobox_form').combobox({
                            url: 'get_cce_specification_list',
                            valueField: 'label',
                            textField: 'label',
                            queryParams: {arg0: 'SourceList', arg1: '', arg2: '', arg3: ''}
                        });
                        $('#cce_acquisition1_combobox_form').combobox({
                            url: 'get_last_20_years_list',
                            valueField: 'label',
                            textField: 'label'
                        });
                        $('#cce_acquisition2_combobox_form').combobox({
                            url: 'get_month_number_list',
                            valueField: 'value',
                            textField: 'label'
                        });
                    }
                })                            
                $('#cce_status_combobox_form').combobox({
                    onChange: function (newValue) {
                        
                        if (newValue == "Not Functional") {
                            $('#cce_nf_date').datebox({
                                disabled: false
                            });

                            $('#hiddenStatus').val("Not Functional");
                        } else if (newValue == "Functional") {
                            $('#cce_nf_date').datebox({
                                disabled: true
                            });
                            $('#cce_acquisition1_combobox_form').combobox({
                                disabled: false
                            });
                            $('#cce_acquisition2_combobox_form').combobox({
                                disabled: false
                            });

                            $('#hiddenStatus').val("Functional");

                        } else if (newValue == "Not Installed") {
                            $('#cce_acquisition1_combobox_form').combobox({
                                disabled: true
                            });
                            $('#cce_acquisition2_combobox_form').combobox({
                                disabled: true
                            });
                            
                            $('#hiddenStatus').val("Not Installed");
                        }
                        
                        $('#cce_decision_combobox_form').combobox({
                            url: 'get_cce_specification_list',
                            valueField: 'label',
                            textField: 'label',
                            queryParams: {arg0: 'DecisionList', arg1: $('#cce_status_combobox_form').combobox('getValue'), arg2: '', arg3: ''}
                        });
                    }
                    
                });



                        }

                        function saveCCE() {
                            $('#add_edit_form').form('submit', {
                                url: $('#add_edit_form').attr('action'),
                                onSubmit: function () {
                                    $('#saveBtn').linkbutton('disable', true);
                                    var errormessage = "";
                                    var validate = true;
                                    var user = streamlineUser();
                                    yearsInstalled = (new Date()).getFullYear() - $('#cce_acquisition1_combobox_form').combobox('getValue')
//                                    alertBox('yearsInstalled '+yearsInstalled);

                                    if ($('#cce_state_combobox_form').combobox('getValue') == '' && user=='NTO' && $('#cce_location_textbox').textbox('getValue') != 'National') {
                                        errormessage = "State is Empty!";
                                        validate = false;
                                    } else if ($('#cce_lga_combobox_form').combobox('getValue') == '' && user=='SCCO' && $('#cce_location_textbox').textbox('getValue') != 'STATE') {
                                        errormessage = "LGA is Empty!";
                                        validate = false;
                                    } 
//                                    else if ($('#cce_ward_combobox_form').combobox('getValue') == ''&&$('#cce_facility_name_combobox_form').combobox('getValue') == 'HF') {
//                                        errormessage = "Ward is Empty!";
//                                        validate = false;
//                                    }
                                    else if ($('#cce_facility_name_combobox_form').combobox('getValue') == '' && user=='LIO' && $('#cce_location_textbox').textbox('getText') != 'LGA') {
                                        errormessage = "Site Location is Empty!";
                                        validate = false;
                                    } else if ($('#cce_location_textbox').textbox('getValue') == '') {
                                        errormessage = "Equipment Location is Empty!";
                                        validate = false;
                                    } else if ($('#cce_make_combobox_form').combobox('getValue') == '') {
                                        errormessage = "Company/Make is Empty!";
                                        validate = false;
                                    } else if ($('#cce_model_combobox_form').combobox('getValue') == '') {
                                        errormessage = "Model is Empty!";
                                        validate = false;
                                    } else if ($('#cce_type_combobox_form').combobox('getValue') == '') {
                                        errormessage = "Type is Empty!";
                                        validate = false;
                                    } else if ($('#cce_category_combobox_form').combobox('getValue') == '') {
                                        errormessage = "Category is Empty!";
                                        validate = false;
                                    } else if ($('#cce_serial_textbox').textbox('getValue') == '') {
                                        errormessage = "Serial Number is Empty!";
                                        validate = false;
                                    } else if ($('#cce_status_combobox_form').combobox('getValue') == '') {
                                        errormessage = "Status is Empty!";
                                        validate = false;
                                    } else if ($('#cce_decision_combobox_form').combobox('getValue') == '') {
                                        errormessage = "Decision is Empty!";
                                        validate = false;
                                    } else if ($('#cce_nf_date').datebox('getValue') == '' && $('#cce_status_combobox_form').combobox('getValue') == 'Not Functional') {
                                        errormessage = "Date Not Functional is Empty!";
                                        validate = false;
                                    } else if ($('#cce_acquisition1_combobox_form').combobox('getValue') == '') {
                                        errormessage = "Year of Installation is Empty!";
                                        validate = false;
                                    } else if ((yearsInstalled>expectedWorkingLife && !($('#cce_decision_combobox_form').combobox('getValue')=="Obsolete"))
                                            ||(yearsInstalled<expectedWorkingLife && $('#cce_decision_combobox_form').combobox('getValue')=="Obsolete")) {
                                        errormessage = "Decision and Year of Installation does not agree!!";
                                        validate = false;
                                    } else if ($('#cce_acquisition2_combobox_form').combobox('getValue') == '') {
                                        errormessage = "Month of Installation is Empty!";
                                        validate = false;
                                    } else if ($('#cce_src_combobox_form').combobox('getValue') == '') {
                                        errormessage = "Source of CCE is Empty!";
                                        validate = false;
                                    }
                                    if (errormessage != '') {
                                        alertBox(errormessage);
                                    $('#saveBtn').linkbutton('enable', true);
                                    }
                                    return validate;
                                },
                                success: function (result) {
                                    if (result.toString() == 'succsess') {
                                        // close the dialog
                                        alertBox("Operation Successfull");
                                        refreshData();
                                    } else {
                                        alertBox("Operation Failed ");
                                    }
                                    $('#saveBtn').linkbutton('enable', true);
                                    $('#form_dialog').dialog('close');
                                }
                            });
                        }


                        function editCCE(buttonId) {
                            
                            if (buttonId == 'editBtn') {
                                $('#saveBtn').linkbutton('enable', true);
                            } else {
                                $('#saveBtn').linkbutton('disable', true);
                            }
                            submitType = "edit";
                            var row = $('#cceListTable').datagrid('getSelected');

                            if (row) {
                                if (buttonId == 'editBtn') {
                                    $('#form_dialog').dialog('open').dialog('center').dialog('setTitle', 'Edit CCE');
                                } else {
                                    $('#form_dialog').dialog('open').dialog('center').dialog('setTitle', 'OverView Of CCE');
                                }
                                
                                $('#cce_state_div').hide();
                                $('#cce_lga_div').hide();
                                $('#cce_ward_div').hide();
                                $('#cce_facility_name_div').hide();
                                $('#cce_location_div').hide();
                                
                                makeNonEditableCombos();
                                
                                loadCCEDetailsDropdown();
                                
                                
                                
                                $('#cce_state_combobox_form').combobox('setText', row.FACILITY_ID);
                                $('#cce_state_combobox_form').combobox('setValue', row.STATE);
                                
                                $('#cce_lga_combobox_form').combobox('setText', row.FACILITY_ID);
                                $('#cce_lga_combobox_form').combobox('setValue', row.LGA);
                                
                                $('#cce_ward_combobox_form').combobox('setValue', row.WARD);
                                $('#cce_ward_combobox_form').combobox('setText', row.WARD);
                                
                                $('#cce_facility_name_combobox_form').combobox('setText', row.FACILITY_ID);
                                $('#cce_facility_name_combobox_form').combobox('setValue', row.FACILITY_NAME);
                                
                                $('#cce_facility_id_form').val(row.FACILITY_ID);
                                $('#cce_data_id_form').val(row.CCE_DATA_ID);
//                                $('#cce_location_textbox').textbox('setValue', row.LOCATION);
                                $('#cce_location_textbox').textbox('setValue', row.LOCATION);
                                
                                $('#cce_make_combobox_form').combobox('setValue', row.MAKE);
                                $('#cce_make_combobox_form').combobox('setText', row.MAKE);
                                
                                $('#cce_model_combobox_form').combobox('setValue', row.MODEL);
                                $('#cce_model_combobox_form').combobox('setText', row.MODEL);
                                
                                $('#cce_type_combobox_form').combobox('setValue', row.TYPE);
                                $('#cce_type_combobox_form').combobox('setText', row.TYPE);
                                
                                $('#cce_category_combobox_form').combobox('setValue', row.CATEGORY);
                                $('#cce_category_combobox_form').combobox('setText', row.CATEGORY);
                                
                                $('#cce_serial_textbox').textbox('setValue', row.DEVICE_SERIAL_NO);
//                                $('#cce_serial_textbox').textbox('setValue', row.DEVICE_SERIAL_NO);
                                
                                $('#cce_status_combobox_form').combobox('setValue', row.STATUS);
                                $('#cce_status_combobox_form').combobox('setText', row.STATUS);
                                
                                $('#cce_decision_combobox_form').combobox('setValue', row.DECISION);
                                $('#cce_decision_combobox_form').combobox('setText', row.DECISION);
                                
                                $('#cce_acquisition1_combobox_form').combobox('setValue', row.YR_OF_ACQUISITION);
                                $('#cce_acquisition1_combobox_form').combobox('setText', row.YR_OF_ACQUISITION);
                                
                                $('#cce_acquisition2_combobox_form').combobox('setValue', row.MONTH_OF_ACQUISITION);
                                $('#cce_acquisition2_combobox_form').combobox('setText', row.MONTH_OF_ACQUISITION_STR);
                                
//                                alertBox(row.FACILITY_ID);
                                
                                $('#cce_src_combobox_form').combobox('setValue', row.SOURCE_OF_CCE);
                                $('#cce_src_combobox_form').combobox('setText', row.SOURCE_OF_CCE);
                                var dates = formateDate(row.DATE_NF);
//                                $('#cce_nf_date').datebox('setValue', dates);
                                $('#cce_nf_date').datebox('setText', dates);
                                

                                $('#add_edit_form').attr('action', 'save_addedit_cce?action=edit');
//                                loadCCEDetailsDropdown();
                                

                            } else {
                                alertBox("Please Select Record!");
                            }

                        }
                        
                        function refreshData() {
                            $('#cceListTable').datagrid('reload', 'getccelist');
                        }
   
    </script>
    <script type="text/javascript">
        $('#cceListTable').datagrid({
            url: 'getccelist',
            remoteSort: false,
            columns: [[
//                    {field: 'STATE_ID', title: 'STATE ID', sortable: true, hidden: true},
                    {field: 'STATE_ID', title: 'STATE ID', sortable: true, hidden: true},
                    {field: 'STATE', title: 'STATE', sortable: true, hidden: true},
//                    {field: 'LGA_ID', title: 'LGA ID', sortable: true, hidden: true},
                    {field: 'LGA_ID', title: 'LGA ID', sortable: true, hidden: true},
                    {field: 'LGA', title: 'LGA', sortable: true, hidden: true},
                    {field: 'FACILITY_ID', title: 'FACILITY ID', sortable: true, hidden: true},
    //            {field:'WARD_ID',title:'WARD ID',sortable:true,hidden:true},
                    {field: 'WARD', title: '<span style="color:white;"> WARD </span>', sortable: true},
                    {field: 'WAREHOUSE_TYPE_ID', title: 'WAREHOUSE TYPE ID', sortable: true, hidden: true},
                    {field: 'LOCATION', title: '<span style="color:white;"> EQUIPMENT LOCATION</span>', sortable: true},
                    {field: 'FACILITY_NAME', title: '<span style="color:white;"> NAME OF FACILITY </span>', sortable: true},
                    {field: 'DEFAULT_ORDERING_WAREHOUSE_ID', title: 'DEFAULT ORDERING WAREHOUSE ID', sortable: true, hidden: true},
                    {field: 'CCE_ID', title: 'CCE ID', sortable: true, hidden: true},
                    {field: 'CCE_DATA_ID', title: 'CCE DATA ID', sortable: true, hidden: true},
                    {field: 'DESIGNATION', title: '<span style="color:white;"> DESIGNATION </span>', sortable: true},
                    {field: 'MAKE', title: '<span style="color:white;"> MAKE </span>', sortable: true},
                    {field: 'MODEL', title: '<span style="color:white;"> MODEL </span>', sortable: true},
                    {field: 'DEVICE_SERIAL_NO', title: '<span style="color:white;"> DEVICE SERIAL NO </span>', sortable: true},
                    {field: 'REFRIGERANT', title: 'REFRIGERANT', sortable: true, hidden: true},
                    {field: 'VOL_NEG', title: '<span style="color:white;"> VOL - </span>', sortable: true},
                    {field: 'VOL_POS', title: '<span style="color:white;"> VOL + </span>', sortable: true},
                    {field: 'SUMMARY', title: '<span style="color:white;"> SUMMARY </span>', sortable: true,
                        formatter: function (val) {

                            if (val.endsWith("Functional-Obsolete") || val.endsWith("Not Functional-Obsolete")) {
                                return "<span style='background-color:red;height:100%; width:100%;display:block; overflow:auto;'>(" + val + ")</span>";
                            } else if (val.endsWith("Not Installed") || val.endsWith("Functional-Good")) {
                                return "<span style='background-color:green; color:white; height:100%; width:100%;display:block; overflow:auto;'>(" + val + ")</span>";
                            } else {
                                return "<span style='background-color:yellow;height:100%; width:100%;display:block; overflow:auto;'>(" + val + ")</span>"
                            }

                        }
                    },
                    {field: 'DATE_NF', title: '<span style="color:white;"> DATE NOT FUNCTIONAL </span>', sortable: true},
                    {field: 'CATEGORY', title: 'CATEGORY', sortable: true, hidden: true},
                    {field: 'TYPE', title: 'TYPE', sortable: true, hidden: true},
                    {field: 'STATUS', title: 'STATUS', sortable: true, hidden: true},
                    {field: 'DECISION', title: 'DECISION', sortable: true, hidden: true},
                    {field: 'ENERGY', title: 'ENERGY', sortable: true, hidden: true},
                    {field: 'MONTH_OF_ACQUISITION', title: 'MONTH OF ACQUISITION', sortable: true, hidden: true},
                    {field: 'MONTH_OF_ACQUISITION_STR', title: 'MONTH OF ACQUISITION STR', sortable: true, hidden: true},
                    {field: 'YR_OF_ACQUISITION', title: 'YR  OF ACQUISITION', sortable: true, hidden: true},
                    {field: 'YEAR_OF_ACQUISITION', title: '<span style="color:white;"> YEAR  OF ACQUISITION </span>', sortable: true},
                    {field: 'SOURCE_OF_CCE', title: '<span style="color:white;"> SOURCE OF CCE </span>', sortable: true
                    }]],
        onClickRow: function (index, row)     {
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
        hideAfterCurrentDate('#cce_nf_date');//for disable after current date 
    //hideBeforCurrentDate('#end_date');//for disable before current date 
        $('#cce_nf_date').datebox({
            formatter: myformatter,
            parser: myparser
        });

function loadStateList(){
	$('#cce_state_combobox_form').combobox('clear');
        $('#cce_state_combobox_form').combobox({
               url: 'get_state_store_list',
               valueField: 'value',
               textField: 'label',
               queryParams: {option: 'notAll'},
               onSelect: function(state) {
                $('#info_label').text('');
                $('#cce_location_textbox').textbox('setValue', 'STATE');
                $('#cce_facility_id_form').val(state.value);
                    loadlgaList(state);
                }
           });
}
function loadlgaList(stateId){
	$('#cce_lga_combobox_form').combobox('clear');
        $('#cce_lga_combobox_form').combobox({
                url: 'getlgalistBasedOnStateId',
                valueField: 'value',
                textField: 'label',
                queryParams: {stateId: stateId.value, option: 'notAll'},
                onSelect: function(lga) {
                $('#info_label').text('');
                $('#cce_location_textbox').textbox('setValue', 'LGA');
                $('#cce_facility_id_form').val(lga.value);
                    loadWardBadesdOnLga(lga);
                }
        });
}
//$('#country_name_combobox_form').combobox({
//	url : 'getCountrylist',
//	valueField : 'value',
//	textField : 'label'
//});
function loadWardBadesdOnLga(lgaId){
	$('#cce_ward_combobox_form').combobox('clear');
        $('#cce_ward_combobox_form').combobox({
                url: 'getWardList',
                valueField: 'value',
                textField: 'label',
                queryParams: {lgaid: lgaId.value, option: 'notAll'},
		onLoadSuccess:function(){
			$('#cce_facility_name_combobox_form').combobox('select','');	
		},
                onSelect:  function(ward) {
			 $('#ward_combobox_form_field').val(ward.value);
                         $('#ward_combobox_form_field').text(ward.label);
                         $('#info_label').text('');
                     loadHfDrpdn(ward);
                 }
        });
}

function loadCCEDetailFields(model){
	var xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
		if (xhttp.readyState == 4 && xhttp.status == 200) {
			var ss = JSON.parse(xhttp.responseText);
//                        alertBox(ss[0].EXPECTED_WORKING_LIFE);
			expectedWorkingLife = ss[0].EXPECTED_WORKING_LIFE;
                        $('#cce_make_combobox_form').combobox('setValue', ss[0].COMPANY);
                        $('#cce_make_combobox_form').combobox('setText', ss[0].COMPANY);
                        $('#cce_type_combobox_form').combobox('setValue', ss[0].TYPE);
                        $('#cce_type_combobox_form').combobox('setText', ss[0].TYPE);
                        $('#cce_category_combobox_form').combobox('setValue', ss[0].CATEGORY);
                        $('#cce_category_combobox_form').combobox('setText', ss[0].CATEGORY);
		}
	};
	xhttp.open("GET", 'get_cce_detail?model='+model, true);
	xhttp.send();
}

function loadHfDrpdn(cceWard){
	$('#cce_facility_name_combobox_form').combobox('clear');
        $('#cce_facility_name_combobox_form').combobox({
                url: 'getHfListWardBased',
                valueField: 'value',
                textField: 'label',
                queryParams: {wardid: cceWard.value, option: 'notAll'},
		onLoadSuccess:function(){
			$('#cce_facility_name_combobox_form').combobox('select','');	
		},
                onSelect: function (cceHF) {
                $('#info_label').text('');
                $('#cce_location_textbox').textbox('setValue', 'HF');
                $('#cce_facility_id_form').val(cceHF.value);
                }
        });
}
        loadPaginationForTable(cceListTable);
    </script>

</html>