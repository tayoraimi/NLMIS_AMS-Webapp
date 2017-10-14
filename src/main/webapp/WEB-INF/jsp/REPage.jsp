<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="f"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>Related Equipments</title>
        <link rel="stylesheet" href="resources/css/buttontoolbar.css"
              type="text/css">
        <link rel="stylesheet" href="resources/css/table.css" type="text/css">
        <link rel="stylesheet" type="text/css" href="resources/easyui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="resources/easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="resources/easyui/demo/demo.css">
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

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
                document.getElementById("common_lable").innerHTML = "Related Equipment - Standby Generators \n\n & \n Voltage Stabilizers for larger vaccine stores";
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

                document.getElementById("decision").innerHTML = "No Decision Yet";

                $('#gen_year_of_installation_combobox_form').combobox({
                    onChange: function (newValue) {
                        // Return today's date and time
                        var currentTime = new Date();
                        // returns the year (four digits)
                        var currentYear = currentTime.getFullYear();

                        var status = $('#hiddenStatus').val();
                        
                        $('#hiddenYear').val(newValue);

                        if (status == 'F') {
                            if (currentYear - newValue > 10) {
                                document.getElementById("decision").innerHTML = "Obsolete";
                            } else {
                                document.getElementById("decision").innerHTML = "Good";
                            }
                        } 

                        if (status == 'NF') {
                            if (currentYear - newValue > 10) {
                                document.getElementById("decision").innerHTML = "Obsolete";
                            } else {
                                document.getElementById("decision").innerHTML = "Repair";
                            }
                        } 
                    }
                });

                $('#gen_status_combobox_form').combobox({
                    onChange: function (newValue) {
                        
                        // Return today's date and time
                        var currentTime = new Date();
                        // returns the year (four digits)
                        var currentYear = currentTime.getFullYear();

                        var selectedYear = $('#hiddenYear').val();                       
                        
                        if (newValue == 'NF') {
                            $('#gen_nf_date').datebox({
                                disabled: false
                            });

                            //Decision
                            document.getElementById("decision").innerHTML = "Repair";
                            $('#hiddenStatus').val("NF");
                            
                            if (currentYear - selectedYear > 10) {
                                document.getElementById("decision").innerHTML = "Obsolete";
                            } else {
                                document.getElementById("decision").innerHTML = "Repair";
                            }

                        } else if (newValue == 'F') {
                            $('#gen_nf_date').datebox({
                                disabled: true
                            });

                            //Decision
                            document.getElementById("decision").innerHTML = "Good";
                            $('#hiddenStatus').val("F");
                            
                            if (currentYear - selectedYear > 10) {
                                document.getElementById("decision").innerHTML = "Obsolete";
                            } else {
                                document.getElementById("decision").innerHTML = "Good";
                            }

                        } else if (newValue == 'NI') {
                            $('#gen_nf_date').datebox({
                                disabled: true
                            });

                            //Decision
                            document.getElementById("decision").innerHTML = "Install";
                            $('#hiddenStatus').val("NI");
                        }
                    }
                });


                $('#x1').change(function () {
                    if ($(this).prop('checked')) {
                        //duration_of_nf_textbox
                        $("#gen_hrs_combobox_form").prop('disabled', false);
                        $("#x11").val("YES");
                    } else {
                        $("#gen_hrs_combobox_form").prop('disabled', true);
                        $("#x11").val("NO");
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

                $('#gen_hrs_combobox_form').change(function () {

                    var hrs_of_electricity = $(this).val();
                    $("#x111").val(hrs_of_electricity);
                });

            });

        </script>
        <style type="text/css">
            #first_name_label,#last_name_label,#cce_name_label,#cce_types_label,#password_label,
            #confirm_password_label,#role_label,#assign_lga_label,#start_date_label{
                font-weight: bold;
            }
            #gen_hrs_combobox_form{
                width:160px;   
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
                    <li><a id="addBtn" class="w3-btn w3-ripple" onclick="AddRE()" > <img alt="add"
                                                                                         src="resources/images/file_add.png">Add
                        </a>
                    </li>
                    <li><a id="editBtn" class="w3-btn w3-ripple" onclick="editRE(this.id)"> <img alt="edit"
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

            <div id="re_table_div" style="margin-left: 5px;">
                <table id="reListTable" class="easyui-datagrid"
                       style="width: 100%; height: 430px;padding-left: 5px;" title="Related Equipments"
                       data-options="toolbar:'#table_toolbar', rownumbers:'true',  singleSelect:'true',
                       striped:'true', remoteSort:'false',pagination:'true',pageSize:20">	
                </table>
            </div>

            <!-- add edit form -->

            <div id="form_dialog" class="easyui-dialog" style="width:430px;height:520px;padding:10px 20px"
                 closed="true" buttons="#form_buttons">
            <f:form id="add_edit_form" method="post" commandName="beanForRE">
                <table cellspacing="10px;">
                    <tr>
                        <td>
                            <div id="gen_state_div">
                                <label id="gen_state_label">*State:</label>
                                <f:select  id="gen_state_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_GENERATOR_STATE_ID"/>
                            </div>
                        </td>
                        <td>
                            <div class="gen_lga_div">
                                <label id="gen_lga_label"> *LGA:</label>
                                <f:select id="gen_lga_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_GENERATOR_LGA_ID"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="gen_ward_div">
                                <label id="gen_ward_label">*Ward:</label>
                                <f:select id="gen_ward_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_GENERATOR_WARD"/>
                            </div>
                        </td>
                        <td>

                            <div class="gen_facility_name_div">
                                <label id="gen_facility_name_label">*Site Name:</label>
                                <f:select  id="gen_facility_name_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_GENERATOR_FACILITY_ID" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="gen_location_div">
                                <label id="gen_location_label">*Equipment Location:</label>
                                <f:select id="gen_location_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_GENERATOR_LOCATION">
                                    <option value="State">State</option>
                                    <option value="LGA">LGA</option>
                                    <option value="HF">Facility</option>
                                </f:select>
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <div id="gen_manufacturer_div">
                                <label id="gen_manufacturer_label">*Manufacturer:</label>
                                <f:select id="gen_manufacturer_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_GENERATOR_MANUFACTURER">
                                    <option value="AVR R75OOWR">AVR R75OOWR</option>
                                    <option value="Behonda">Behonda</option>
                                    <option value="Signax">Signax</option>
                                    <option value="Coelmo Gruppo Electrogeno">Coelmo Gruppo Electrogeno</option>
                                    <option value="Constant">Constant</option>
                                    <option value="Deutz">Deutz</option>
                                    <option value="Elemax">Elemax</option>
                                    <option value="Elepaq">Elepaq</option>
                                    <option value="Elepaq Constant">Elepaq Constant</option>
                                    <option value="FG Willison">FG Willison</option>
                                    <option value="FG Wilson">FG Wilson</option>
                                    <option value="Figer">Figer</option>
                                    <option value="Fireman">Fireman</option>
                                    <option value="Firman">Firman</option>
                                    <option value="Honda">Honda</option>
                                    <option value="John Dere">John Dere</option>
                                    <option value="Jubaili Bros">Jubaili Bros</option>
                                    <option value="Kato Japan">Kato Japan</option>
                                    <option value="Leroy Somer">Leroy Somer</option>
                                    <option value="Lister">Lister</option>
                                    <option value="Lister & Petter">Lister & Petter</option>
                                    <option value="Lombardini">Lombardini</option>
                                    <option value="Lpark">Lpark</option>
                                    <option value="Luminous UPS">Luminous UPS</option>
                                    <option value="Lystar">Lystar</option>
                                    <option value="Miakno">Miakno</option>
                                    <option value="Mikano">Mikano</option>
                                    <option value="Mikano Luminous">Mikano Luminous</option>
                                    <option value="O-Tex">O-Tex</option>
                                    <option value="Otec">Otec</option>
                                    <option value="Yes">Perkin</option>
                                    <option value="Perkin">Perkins</option>
                                    <option value="Perkins Powerpoint">Perkins Powerpoint</option>
                                    <option value="Sifang">Sifang</option>
                                    <option value="Sumec Fireman">Sumec Fireman</option>
                                    <option value="Sumec Firman">Sumec Firman</option>
                                    <option value="Sumeo Firman">Sumeo Firman</option>
                                    <option value="Suzuki">Suzuki</option>
                                    <option value="Thermocool">Thermocool</option>
                                    <option value="Tiger">Tiger</option>
                                    <option value="Uptune">Uptune</option>
                                </f:select>
                            </div>
                        </td>
                        <td>
                            <div class="gen_has_electricity_div">
                                <input type="hidden" id="x11" name="x11" value="NO" />
                                <input id="x1" name="location_has_electricity2" type="checkbox"  />
                                <label id="gen_has_electricity_label">*Location Has Electricity:?</label>

                            </div>
                        </td>

                    </tr>
                    <tr>
                        <td>
                            <div id="gen_power_div">
                                <label id="gen_power_label">*Power:</label>
                                <f:select id="gen_power_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_GENERATOR_POWER">
                                    <option value="100KVA">100KVA</option>
                                    <option value="10KVA">10KVA</option>
                                    <option value="11.5KVA">11.5KVA</option>
                                    <option value="13.0HP">13.0HP</option>
                                    <option value="13.0KVA">13.0KVA</option>
                                    <option value="13KVA">13KVA</option>
                                    <option value="15KVA">15KVA</option>
                                    <option value="2.3KVA">2.3KVA</option>
                                    <option value="2.5KVA">2.5KVA</option>
                                    <option value="20KVA">20KVA</option>
                                    <option value="220V">220V</option>
                                    <option value="230KVA">230KVA</option>
                                    <option value="230V">230V</option>
                                    <option value="250KVA">250KVA</option>
                                    <option value="25KVA">25KVA</option>
                                    <option value="27KVA">27KVA</option>
                                    <option value="2KVA">2KVA</option>
                                    <option value="30KVA">30KVA</option>
                                    <option value="4.0KVA">4.0KVA</option>
                                    <option value="40KVA">40KVA</option>
                                    <option value="4KVA">4KVA</option>
                                    <option value="5KVA">5KVA</option>
                                    <option value="6.5KVA">6.5KVA</option>
                                    <option value="6KVA">6KVA</option>
                                    <option value="75KVA">75KVA</option>
                                    <option value="7KVA">7KVA</option>
                                    <option value="KVA-12">KVA-12</option>
                                    <option value="KVA-20">KVA-20</option>
                                    <option value="OHV 2.7KVA">OHV 2.7KVA</option>
                                    <option value="v1000">v1000</option>
                                </f:select>
                            </div>
                        </td>
                        <td>
                            <div class="gen_hrs_div">
                                <label id="gen_hrs_label">*Hours of Electricity:</label>
                                <input type="hidden" id="x111" name="x111" value="0"/>
                                <select id="gen_hrs_combobox_form"  path="x_GENERATOR_ELECTRICITY_HRS" style=" max-width: 90%;">

                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="6">6</option>
                                    <option value="7">7</option>
                                    <option value="8">8</option>
                                    <option value="9">9</option>
                                    <option value="10">10</option>
                                    <option value="11">11</option>
                                    <option value="12">12</option>
                                    <option value="13">13</option>
                                    <option value="14">14</option>
                                    <option value="15">15</option>
                                    <option value="16">16</option>
                                    <option value="17">17</option>
                                    <option value="18">18</option>
                                    <option value="19">19</option>
                                    <option value="20">20</option>
                                    <option value="21">21</option>
                                    <option value="22">22</option>
                                    <option value="23">23</option>
                                    <option value="24">24</option>

                                </select>
                            </div>
                        </td>

                    </tr>
                    <tr>
                        <td>
                            <div id="gen_year_of_installation_div">
                                <label id="gen_year_of_installation_label">*Year of Installation:</label>
                                <f:select id="gen_year_of_installation_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_GENERATOR_AGE">
                                    <option value="2017">2017</option>
                                    <option value="2016">2016</option>
                                    <option value="2015">2015</option>
                                    <option value="2014">2014</option>
                                    <option value="2013">2013</option>
                                    <option value="2012">2012</option>
                                    <option value="2011">2011</option>
                                    <option value="2010">2010</option>
                                    <option value="2009">2009</option>
                                    <option value="2008">2008</option>
                                    <option value="2007">2007</option>
                                    <option value="2006">2006</option>
                                    <option value="2005">2005</option>
                                    <option value="2004">2004</option>
                                    <option value="2003">2003</option>
                                    <option value="2002">2002</option>
                                    <option value="2001">2001</option>
                                    <option value="2000">2000</option>
                                    <option value="1999">1999</option>
                                    <option value="1998">1998</option>
                                    <option value="1997">1997</option>
                                </f:select>
                                    <input type="text" hidden id="hiddenYear" value="N/A" />
                            </div>
                        </td>
                        <td>

                            <div id="gen_model_div">
                                <label id="gen_model_label">*Model:</label>
                                <f:select id="gen_model_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_GENERATOR_MODEL">
                                    <option value="166631">166631</option>
                                    <option value="07-P31-08-945">07-P31-08-945</option>
                                    <option value="18755P">18755P</option>
                                    <option value="2000">2000</option>
                                    <option value="212625">212625</option>
                                    <option value="22010/12">22010/12</option>
                                    <option value="270">270</option>
                                    <option value="3300">3300</option>
                                    <option value="3500">3500</option>
                                    <option value="4000">4000</option>
                                    <option value="4005146">4005146</option>
                                    <option value="400532">400532</option>
                                    <option value="4761184">4761184</option>
                                    <option value="5PA2500">5PA2500</option>
                                    <option value="7238">7238</option>
                                    <option value="94592V">94592V</option>
                                    <option value="DA40">DA40</option>
                                    <option value="DH12">DH12</option>
                                    <option value="EB-3000">EB-3000</option>
                                    <option value="EC12000">EC12000</option>
                                    <option value="EC700">EC700</option>
                                </f:select>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div id="gen_nf_date_div">
                                <label id="gen_nf_date_label">*Date Not Functional:</label>
                                <f:input id="gen_nf_date"  class="easyui-datebox" width="120px" path="x_GENERATOR_NF_DATE" />
                            </div>
                        </td>
                        <td>

                            <div class="gen_status_div">
                                <label id="gen_status_label">*Status:</label>
                                <f:select id="gen_status_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_GENERATOR_FUNCTIONAL">
                                    <option value="F">Functional</option>
                                    <option value="NF">Not Functional</option>
                                    <option value="NI">Not Installed</option>
                                </f:select>
                                <input type="text" hidden id="hiddenStatus" value="N/A" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="gen_repairs_planned_div">
                                <input type="hidden" id="x22" name="x22" value="NO" />
                                <input id="x2" name="gen_repairs_planned2" type="checkbox"  />
                                <label id="gen_repairs_planned_label">*Repairs Planned?:</label>

                            </div>
                        </td>
                        <td>
                            <div class="gen_fuel_type_div">
                                <label id="gen_fuel_type_label">*Fuel Type:</label>
                                <f:select id="gen_fuel_type_combobox_form"  class="easyui-combobox" cssStyle="width:150px;" path="x_GENERATOR_FUEL_TYPE">

                                    <option value="D">D</option>
                                    <option value="P">P</option>

                                </f:select>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="gen_fuel_available_planned_div">
                                <input type="hidden" id="x33" name="x33" value="NO" />
                                <input id="x3" name="gen_fuel_available_planned2" type="checkbox"  />
                                <label id="gen_fuel_available_label">*Fuel Available?:</label>
                            </div>
                        </td>
                        <td>
                            <div class="gen_ppm_conducted_div">
                                <input type="hidden" id="x44" name="x44" value="NO" />
                                <input id="x4" name="gen_ppm_conducted2" type="checkbox"  />
                                <label id="gen_ppm_conducted_label">*PPM Conducted?:</label>

                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <div class="gen_decison_div">

                                <label id="gen_decision_label">Decision:</label>
                                <label id="decision" style=" color: green;"></label>
                            </div>
                        </td>

                    </tr>

                </table>
            </f:form>
        </div>
        <div id="form_buttons">
            <a href="javascript:void(0)" id="saveBtn" class="easyui-linkbutton c6" iconCls="icon-ok" onclick="saveRE()" style="width:90px">Save</a>
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
                function AddRE() {
                    submitType = "add";
                    $('#form_dialog').dialog('open').dialog('center').dialog('setTitle', 'Add Generator Form');
                    $('#add_edit_form').form('clear');
                    $('#add_edit_form').attr('action', 'save_addedit_re?action=add');

                    $('#gen_state_combobox_form').combobox('disable', true);

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

                    //
                    $("#x11").val("NO"); //Location Has Electricity
                    $("#x22").val("NO"); //Repairs Planned
                    $("#x33").val("NO"); //Fuel Available
                    $("#x44").val("NO"); //PPM CONDUCTED
                    //
                    $("#gen_hrs_combobox_form").prop('disabled', true);
                    $("x111").val(0);
                    //gen_hrs_combobox_form
                }
                function loadFormComboboxList() {
                    $('#gen_state_combobox_form').combobox('disable', true);
                    $('#gen_state_combobox_form').combobox('setValue', '${userBean.getX_WAREHOUSE_ID()}');
                    $('#gen_state_combobox_form').combobox('setText', '${userBean.getX_WAREHOUSE_NAME()}');
                    $('#gen_lga_combobox_form').combobox({
                        url: 'getlgalistBasedOnStateId',
                        valueField: 'value',
                        textField: 'label',
                        queryParams: {stateId: '${userBean.getX_WAREHOUSE_ID()}', option: 'notAll'},
                        onSelect: function (genLGA) {
                            $('#gen_facility_name_combobox_form').combobox('clear');
                            $('#gen_ward_combobox_form').combobox({
                                url: 'getWardList',
                                valueField: 'value',
                                textField: 'label',
                                queryParams: {lgaid: genLGA.value, option: 'notAll'},
                                onSelect: function () {
                                    $('#gen_location_combobox_form').combobox('clear');
                                    $('#gen_facility_name_combobox_form').combobox({
                                        url: 'getHflist',
                                        valueField: 'value',
                                        textField: 'label',
                                        queryParams: {lgaid: genLGA.value, option: 'notAll'}
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
                                                                                url: 'get_year_list',
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
                function saveRE() {
                    $('#add_edit_form').form('submit', {
                        url: $('#add_edit_form').attr('action'),
                        onSubmit: function () {
                            var errormessage = "";
                            var validate = true;

                            if ($('#gen_state_combobox_form').combobox('getValue') == '') {
                                errormessage = "State is Empty!";
                                validate = false;
                            } else if ($('#gen_lga_combobox_form').combobox('getValue') == '') {
                                errormessage = "LGA is Empty!";
                                validate = false;
                            } else if ($('#gen_ward_combobox_form').combobox('getValue') == '') {
                                errormessage = "Ward is Empty!";
                                validate = false;
                            } else if ($('#gen_facility_name_combobox_form').combobox('getValue') == '') {
                                errormessage = "Site Name is Empty!";
                                validate = false;
                            } else if ($('#gen_location_combobox_form').combobox('getValue') == '') {
                                errormessage = "Equipment Location is Empty!";
                                validate = false;
                            } else if ($('#gen_manufacturer_combobox_form').combobox('getValue') == '') {
                                errormessage = "Generator Manufacturer is Empty!";
                                validate = false;
                            } /*else if ($('#gen_has_electricity_combobox_form').combobox('getValue') == '') {
                             errormessage = "Facility Has Electricity is Empty!";
                             validate = false;
                             }*/ else if ($('#gen_power_combobox_form').combobox('getValue') == '') {
                                errormessage = "Generator Power Rating is Empty!";
                                validate = false;
                            } /*else if ($('#gen_hrs_textbox').textbox('getValue') == '') {
                             errormessage = "Hours of Electricity is Empty!";
                             validate = false;
                             }*/ else if ($('#gen_year_of_installation_combobox_form').combobox('getValue') == '') {
                                errormessage = "Generator Year of Installation is Empty!";
                                validate = false;
                            } else if ($('#gen_model_combobox_form').combobox('getValue') == '') {
                                errormessage = "Generator Model is Empty!";
                                validate = false;
                            } else if ($('#gen_nf_date').datebox('getValue') == '') {
                                errormessage = "Date Not Functional is Empty!";
                                validate = false;
                            } else if ($('#gen_status_combobox_form').combobox('getValue') == '') {
                                errormessage = "Generator Status is Empty!";
                                validate = false;
                            } /*else if ($('#gen_repairs_planned_combobox_form').combobox('getValue') == '') {
                             errormessage = "Generator Repairs Planned is Empty!";
                             validate = false;
                             }*/ else if ($('#gen_fuel_type_combobox_form').combobox('getValue') == '') {
                                errormessage = "Generator Fuel Type is Empty!";
                                validate = false;
                            } /*else if ($('#gen_fuel_available_combobox_form').combobox('getValue') == '') {
                             errormessage = "Generator Fuel Available is Empty!";
                             validate = false;
                             } else if ($('#gen_ppm_conducted_combobox_form').combobox('getValue') == '') {
                             errormessage = "Generator PPM Conducted is Empty!";
                             validate = false;
                             } else if ($('#gen_duration_nf_textbox').textbox('getValue') == '') {
                             errormessage = "Duration NF is Empty!";
                             validate = false;
                             }*/
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
                function editRE(buttonId) {
                    if (buttonId == 'editBtn') {
                        $('#saveBtn').linkbutton('enable', true);
                    } else {
                        $('#saveBtn').linkbutton('disable', true);
                    }
                    submitType = "edit";
                    var row = $('#reListTable').datagrid('getSelected');

                    if (row) {
                        if (buttonId == 'editBtn') {
                            $('#form_dialog').dialog('open').dialog('center').dialog('setTitle', 'Edit RE');
                        } else {
                            $('#form_dialog').dialog('open').dialog('center').dialog('setTitle', 'OverView Of RE');
                        }
                        loadFormComboboxList();
                        $('#gen_state_combobox_form').combobox('setValue', row.STATE_ID);
                        $('#gen_state_combobox_form').combobox('setText', row.STATE);
                        $('#gen_lga_combobox_form').combobox('setValue', row.LGA_ID);
                        $('#gen_lga_combobox_form').combobox('setText', row.LGA);
                        $('#gen_ward_combobox_form').combobox('setValue', row.WARD);
                        $('#gen_ward_combobox_form').combobox('setText', row.WARD);
                        $('#gen_facility_name_combobox_form').combobox('setValue', row.FACILITY_ID);
                        $('#gen_facility_name_combobox_form').combobox('setText', row.FACILITY_NAME);
                        //  $('#gen_location_combobox_form').combobox('setValue', row.LOCATION);
                        //  $('#gen_location_combobox_form').combobox('setText', row.LOCATION);
                        $('#gen_manufacturer_combobox_form').combobox('setValue', row.MANUFACTURER);
                        $('#gen_manufacturer_combobox_form').combobox('setText', row.MANUFACTURER);
                        $('#gen_has_electricity_combobox_form').combobox('setValue', row.FACILITY_HAS_ELECTRICITY);
                        $('#gen_has_electricity_combobox_form').combobox('setText', row.FACILITY_HAS_ELECTRICITY);
                        $('#gen_year_of_installation_combobox_form').combobox('setValue', row.TYPE);
                        $('#gen_year_of_installation_combobox_form').combobox('setText', row.TYPE);
                        $('#gen_model_combobox_form').combobox('setValue', row.MODEL);
                        $('#gen_model_combobox_form').combobox('setText', row.MODEL);
                        $('#gen_power_combobox_form').combobox('setValue', row.POWER);
                        $('#gen_power_combobox_form').combobox('setText', row.POWER);
                        $('#gen_duration_nf_textbox').textbox('setValue', row.DURATION_NF);
                        $('#gen_duration_nf_textbox').textbox('setText', row.DURATION_NF);
                        $('#gen_hrs_textbox').textbox('setText', row.ELECTRICITY_HRS);
                        $('#gen_hrs_textbox').textbox('setValue', row.ELECTRICITY_HRS);
                        $('#gen_status_combobox_form').combobox('setValue', row.FUNCTIONAL);
                        $('#gen_status_combobox_form').combobox('setText', row.FUNCTIONAL);
                        $('#gen_repairs_planned_combobox_form').combobox('setValue', row.PLANNED_REPAIRS);
                        $('#gen_repairs_planned_combobox_form').combobox('setText', row.PLANNED_REPAIRS);
                        $('#gen_fuel_type_combobox_form').combobox('setValue', row.FUEL_TYPE);
                        $('#gen_fuel_type_combobox_form').combobox('setText', row.FUEL_TYPE);
                        $('#gen_fuel_available_combobox_form').combobox('setValue', row.FUEL_AVAILABLE);
                        $('#gen_fuel_available_combobox_form').combobox('setText', row.FUEL_AVAILABLE);
                        $('#gen_ppm_conducted_combobox_form').combobox('setValue', row.PPM);
                        $('#gen_ppm_conducted_combobox_form').combobox('setText', row.PPM);

                        // alert(row.FACILITY_HAS_ELECTRICITY + row.PLANNED_REPAIRS + row.FUEL_AVAILABLE + row.PPM);

                        var FACILITY_HAS_ELECTRICITY = row.FACILITY_HAS_ELECTRICITY;
                        $('#x11').val(FACILITY_HAS_ELECTRICITY);
                        var FACILITY_HAS_ELECTRICITY2 = $('#x11').val();
                        alert($('#x11').val());
                        //
                        /* $('#x11').textbox('setValue', row.FACILITY_HAS_ELECTRICITY);
                         $('#x11').textbox('setValue', row.FACILITY_HAS_ELECTRICITY);
                         //
                         $('#x22').textbox('setValue', row.PLANNED_REPAIRS);
                         $('#x22').textbox('setValue', row.PLANNED_REPAIRS);
                         //
                         $('#x33').textbox('setValue', row.FUEL_AVAILABLE);
                         $('#x33').textbox('setValue', row.FUEL_AVAILABLE);
                         //
                         $('#x44').textbox('setValue', row.PPM);
                         $('#x44').textbox('setValue', row.PPM);*/

                        //

                        $("x111").val(row.ELECTRICITY_HRS);

                        $('#add_edit_form').attr('action', 'save_addedit_re?action=edit&reId=' + row.GEN_DATA_ID);

                    } else {
                        alertBox("Please Select Record!");
                    }

                }

                function refreshData() {
                    //	$('#ccetype_combobox').combobox('clear');
                    //	$('#rolename_combobox').combobox('clear');
                    //	$('#assign_lga_combobox').combobox('clear');
                    $('#reListTable').datagrid('reload', 'getrelist');
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
        $('#reListTable').datagrid({
            url: 'getrelist',
            remoteSort: false,
            columns: [[
                    {field: 'GEN_DATA_ID', title: 'GEN DATA ID', sortable: true, hidden: true},
                    {field: 'STATE_ID', title: 'STATE ID', sortable: true, hidden: true},
                    {field: 'STATE', title: 'STATE', sortable: true, hidden: true},
                    {field: 'LGA_ID', title: 'LGA ID', sortable: true, hidden: true},
                    {field: 'LGA', title: 'LGA', sortable: true},
                    {field: 'FACILITY_ID', title: 'FACILITY ID', sortable: true, hidden: true},
                    {field: 'WARD_ID', title: 'WARD ID', sortable: true, hidden: true},
                    {field: 'WARD', title: 'WARD', sortable: true},
                    {field: 'WAREHOUSE_TYPE_ID', title: 'WAREHOUSE TYPE ID', sortable: true, hidden: true},
                    {field: 'LOCATION', title: 'EQUIPMENT LOCATION', sortable: true,
                    formatter: function (val) {
                        if(val == "LGA"){
                            var opts = $('#reListTable').datagrid('getColumnOption','FACILITY_NAME');
                            opts.val('LGA CS');
                        }
                    }
                },
                    {field: 'FACILITY_NAME', title: 'NAME OF FACILITY', sortable: true},
                    {field: 'DEFAULT_ORDERING_WAREHOUSE_ID', title: 'DEFAULT ORDERING WAREHOUSE ID', sortable: true, hidden: true},
                    {field: 'FACILITY_HAS_ELECTRICITY', title: 'LOCATION HAS ELECTRICITY', sortable: true},
                    {field: 'ELECTRICITY_HRS', title: 'HOURS OF ELECTRICITY PER DAY', sortable: true},
                    {field: 'MANUFACTURER', title: 'MANUFACUTURER', sortable: true},
                    {field: 'MODEL', title: 'MODEL', sortable: true},
                    {field: 'POWER', title: 'POWER', sortable: true},
                    {field: 'FUNCTIONAL', title: 'FUNCTIONAL STATUS', sortable: true},
                    {field: 'FUEL_TYPE', title: 'FUEL TYPE', sortable: true},
                    {field: 'FUEL_AVAILABLE', title: 'FUEL PURCHASED THIS WEEK?', sortable: true},
                    {field: 'PPM', title: 'PPM CONDUCTED', sortable: true},
                    {field: 'PLANNED_REPAIRS', title: 'REPAIRS PLANNED?', sortable: true},
                    {field: 'DURATION_NF', title: 'DURATION NF (MONTHS)', sortable: true}]],
            onClickRow: function (index, row) {
                if ('${userBean.getX_ROLE_NAME()}' == 'NTO') {
                    if (row.ROLE_NAME != 'NTO') {
                        $('#editBtn').attr('class', 'w3-btn w3-disabled w3-ripple');
                        $('#editBtn').attr('onclick', '');
                    } else {
                        $('#editBtn').attr('class', 'w3-btn w3-ripple');
                        $('#editBtn').attr('onclick', 'editRE(this.id)');
                    }
                } else if ('${userBean.getX_ROLE_NAME()}' == 'SIO') {
                    if (row.ROLE_NAME != 'SIO') {
                        $('#editBtn').attr('class', 'w3-btn w3-disabled w3-ripple');
                        $('#editBtn').attr('onclick', '');
                    } else {
                        $('#editBtn').attr('class', 'w3-btn w3-ripple');
                        $('#editBtn').attr('onclick', 'editRE(this.id)');
                    }
                } else if ('${userBean.getX_ROLE_NAME()}' == 'SIFP') {
                    if (row.ROLE_NAME != 'SIFP') {
                        $('#editBtn').attr('class', 'w3-btn w3-disabled w3-ripple');
                        $('#editBtn').attr('onclick', '');
                    } else {
                        $('#editBtn').attr('class', 'w3-btn w3-ripple');
                        $('#editBtn').attr('onclick', 'editRE(this.id)');
                    }
                }
            }
        });
    </script>
    <script type="text/javascript">
        hideAfterCurrentDate('#gen_nf_date');//for disable after current date 
        //hideBeforCurrentDate('#end_date');//for disable before current date 
        $('#gen_nf_date').datebox({
            formatter: myformatter,
            parser: myparser
        });

    </script>
    <script type="text/javascript">
        loadPaginationForTable(reListTable);
    </script>

</html>