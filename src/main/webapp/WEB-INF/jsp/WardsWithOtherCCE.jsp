<%-- 
    Document   : TypeofCCEChart
    Created on : Mar 27, 2017, 11:02:59 PM
    Author     : Ayobami Akinyinka
--%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="f"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="false"%>
<%@page import="java.util.function.ToDoubleFunction"%>
<%@ page import="java.util.*,java.sql.*"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="com.google.gson.JsonObject"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<html id="homepageHtmlElement">
    <head>
        <link rel="shortcut icon" type="image/x-icon" href="resources/images/favicon.ico" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />

        <link rel="stylesheet" href="resources/css/materialize.min.css"	type="text/css">

        <script src="resources/js/jquery-2.2.3.min.js"></script>
        <script src="resources/js/materialize.min.js"></script>

        <title>Wards With Other CCE Chart</title>

        <style>
            nav, nav .nav-wrapper i, nav a.button-collapse, nav a.button-collapse i {
                height: 44px;
                line-height: 44px;
            }
            .dropdown-content li {
                min-height: 25px;
            }
            .dropdown-content li > a, .dropdown-content li > span {
                color: #26a69a;
                display: block;
                font-size: 16px;
                line-height: 22px;
                padding: 7px 16px;
            }
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
            .decres_trend_image{
                -ms-transform: rotate(90deg); /* IE 9 */
                -webkit-transform: rotate(90deg); /* Safari */
                transform: rotate(90deg);
            }
            .incres_trend_image{
                -ms-transform: rotate(270deg); /* IE 9 */
                -webkit-transform: rotate(270deg); /* Safari */
                transform: rotate(270deg);
            }
            #license_modal p{
                line-height: 1;
                font-family: arial;
                font-stretch: expanded;
            }
        </style>

        <script type="text/javascript">

            $(document).ready(function () {
                $('.tabs .tab').css('text-transform', 'none');
            });

            var reloadDashboards = true;
            $(document).ready(function () {
                $(".dropdown-button").dropdown({hover: true});
                $("#cceDashboardTabsUL .indicator").css('height', '5px');
                var user = '${userdata.getX_ROLE_NAME()}';
                $('#user').text('User: ' + user + ' ${userdata.getX_WAREHOUSE_NAME()}');
                $('#login_time').text('${login_time}');
                if ((user === 'SIO') || (user === 'SIFP')) {
                    user = 'SCCO';
                } else if (user === 'MOH') {
                    user = 'LIO';
                }
                switch (user) {
                    case "SCCO":
                        $('#warehouse_name').text('State: ${userdata.getX_WAREHOUSE_NAME()}');
                        $('#cceDashboardDropdown li:gt(4)').hide();
                        if (reloadDashboards) {
                            /* Below ajax request will run when user log-in(By-Default screen!) */
                            var defaultDashboardPageUrl = $("#cceDashboardTabsUL a").filter(".active").attr('name');
                            var capacityDashboardPageUrl = $("#cceDashboardTabsUL li:eq(2) > a").attr('name'); // "capacity_dashboard_page"

                            var defaultDashboardTabdivID = $("#cceDashboardTabsUL a").filter(".active").attr('href');
                            // 					alert("defaultDashboardTabdivID: "+defaultDashboardTabdivID);
                            var capacityDashboardTabDivId = $("#cceDashboardTabsUL li:eq(2) > a").attr('href');
                            // 					alert("capacityDashboardTabDivId: "+capacityDashboardTabDivId);

                            var functionalDashboardDataUrl = "get_functional_dashboard_data";

                            var capacityDashboardDataUrl = "get_capacity_dashboard_data";
                            //document.getElementById("loader_div").style.display = "block";
                            $.ajax({
                                type: "GET",
                                //Url to the webpage
                                url: defaultDashboardPageUrl,
                                dataType: "html",
                                //						    success: function(data){
                                ////	 					    	alert("STATESTOCKPERFODASHBOARD SUCCESS : "+data);		    	
                                //						    	$(defaultDashboardTabdivID).html(data);
                                //						    	if('${loadCount}'==='1'){
                                //						    		showTableData(functionalDashboardDataUrl);
                                //						    	}else{
                                //						    		document.getElementById("loader_div").style.display = "none";
                                //						    	}
                                //						    	$('#lga_combobox').combobox('setValue','null');
                                //						    	$('#lga_combobox').combobox('setText','All');
                                //						    	$('#year_combobox').combobox('setValue',new Date().getFullYear());
                                //						    	$('#year_combobox').combobox('setText',new Date().getFullYear());
                                //						    	$('#week_combobox').combobox({
                                //									url : 'get_week_list/week?yearParam='+(new Date().getFullYear()),
                                //									valueField : 'value',
                                //									textField : 'label'
                                //								});
                                //						    	$('#week_combobox').combobox('setValue','${PREVIOUS_WEEK_OF_YEAR}');
                                //						    	$('#week_combobox').combobox('setText','${PREVIOUS_WEEK_OF_YEAR}');
                                //						    }
                            });

                            $.ajax({
                                type: "GET",
                                //Url to the webpage
                                url: capacityDashboardPageUrl,
                                dataType: "html",
                                success: function (data) {
                                    //	 					    	alert("HFSTOCKSUMMARYSHEETDASHBOARD SUCCESS : "+data);		    	
                                    $(capacityDashboardTabDivId).html(data);
                                    // 			    	loadHeadingTable4('${userdata.x_WAREHOUSE_ID}','${userdata.x_WAREHOUSE_NAME}');
                                    // 			    	showTableData4(capacityDashboardDataUrl);
                                    // 			    	$('#lga_combobox_div4').css('display','none');
                                    // 						    	$('#year_combobox4').combobox('setValue',new Date().getFullYear());
                                    // 						    	$('#year_combobox4').combobox('setText',new Date().getFullYear());
                                    // 						    	$('#week_combobox4').combobox('setValue',(getWeekNumber(new Date())-1));
                                    // 						    	$('#week_combobox4').combobox('setText',(getWeekNumber(new Date())-1));
                                }
                            });


                            /* Above ajax request ends) */
                            reloadDashboards = false;
                        }
                        $("#cceDashboardTabsUL .indicator").css('height', '5px');
                        break;
                    case "SIO":
                        break;
                    case "SIFP":
                        break;
                    case "NTO":
                        break;
                    case "LIO":
                        break;
                    case "MOH":
                        break;
                }

                /* Below handler will run when Menu-Items(Navigation Menu-Dropdowns) clicked */
                $("#cceDashboardDropdown a").on("click", function (e) {
                    elementId = ('#' + this.name);
                    cceDashboardTabsUL = '#cceDashboardTabsUL';

                    var clickableTab = $(cceDashboardTabsUL + " a[href='" + elementId + "']").attr('id');
                    e.preventDefault(); // cancel the link itself
                    if ($(this).attr('href') !== '#!' || $(this).attr('href') !== '#') {
                        if (reloadDashboards) {
                            // 					$.get(this.href,function(data) {
                            // //	 					alert(elementId+", response: "+data);						
                            // 						$(elementId).html(data);
                            // 					    $("#"+clickableTab).click();
                            // 					    if(('${userdata.getX_ROLE_NAME()}' === 'SCCO') && ($("#cceDashboardTabsUL .active").attr('id') === 'cceDashboardLiTab3Link')){
                            // 							/* When LGA STOCK SUMMARY DASHBOARD clicked */
                            // 							$('#state_combobox3_div').css('display','none');

                            // 						}else if(('${userdata.getX_ROLE_NAME()}' === 'NTO') && ($("#cceDashboardTabsUL .active").attr('id') === 'cceDashboardLiTab3Link')){
                            // 							/* When LGA STOCK SUMMARY DASHBOARD clicked */
                            // 							$('#state_combobox3_div').css('display','block');
                            // 						}else if(('${userdata.getX_ROLE_NAME()}' === 'NTO') && ($(cceDashboardTabsUL+" .active").attr('id') === 'ntoStockDashboardLiTab2Link')){
                            // 							/* When LGA STOCK SUMMARY DASHBOARD clicked */
                            // 							$('#state_combobox3_div').css('display','block');
                            // 						}							    
                            // 					});	
                        } else {
                            $("#" + clickableTab).click();
                            if (('${userdata.getX_ROLE_NAME()}' === 'SCCO') && ($("#cceDashboardTabsUL .active").attr('id') === 'cceDashboardLiTab3Link')) {
                                /* When LGA STOCK SUMMARY DASHBOARD clicked */
                                $('#state_combobox3_div').css('display', 'none');

                            } else if (('${userdata.getX_ROLE_NAME()}' === 'NTO') && ($(cceDashboardTabsUL + " .active").attr('id') === 'ntoStockDashboardLiTab2Link')) {
                                /* When LGA STOCK SUMMARY DASHBOARD clicked */
                                $('#state_combobox3_div').css('display', 'block');
                            }
                        }
                    }
                });
            });

            function showLicense() {
                $('#license_modal').openModal();
            }
        </script>
        <!--Script of Chart goes here-->
        <!--  <script src="https://code.jquery.com/jquery-1.11.3.js"></script>-->
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/canvasjs/1.7.0/canvasjs.js"></script>
        <script type="text/javascript">
            $(document).ready(function () {
            var url = "get_ward_with_other_cce_data?filterLevel=LGA";
            showChartData(url);
            });
            function showLicense() {
            $('#license_modal').openModal();
            }

            function showChartData(url) {

            document.getElementById("loader_div").style.display = "block";
            var xhttp = new XMLHttpRequest();
            xhttp.onreadystatechange = function () {

            if (xhttp.readyState == 4 && xhttp.status == 200) {
            document.getElementById("loader_div").style.display = "none";
            var ss = JSON.parse(xhttp.responseText);
            loadchartdata(ss);
            }
            };
            xhttp.open("POST", url, true);
            xhttp.send();
            }
            function loadchartdata(data) {
                
            //Construct Datapoints
            var dps1 = [], dps2=[], dps3=[]; // dataPoints
            
            for (var i = 0; i < data.length; i++) {
          
             //Construct Datapoints
                var dps1 = [], dps2 = [], dps3 = [], dps4=[]; // dataPoints

                for (var i = 0; i < data.length; i++) {
                    dps1.push({
                        y: data[i]["FUNCTIONAL_SOLAR"],
                        label: data[i]["LG_NAME"]
                    });
                    
                    dps2.push({
                        y: data[i]["REPAIRABLE_SOLAR"],
                        label: data[i]["LG_NAME"]
                    });
                    
                    dps3.push({
                        y: data[i]["OTHER_CCE"],
                        label: data[i]["LG_NAME"]
                    });
                    
                    dps4.push({
                        y: data[i]["NO_CCE"],
                        label: data[i]["LG_NAME"]
                    });
            }
            
            
            
            window.chart = new CanvasJS.Chart("chartContainer",
            {
            title: {
            text: "Wards With Other CCE",
                    fontFamily: "arial black"
            },
                    axisY: {
                    title: "Number of Wards"
                    },
                    animationEnabled: true,
                    legend: {
                    verticalAlign: "bottom",
                            horizontalAlign: "center"
                    },
                    exportFileName: "Wards with Other CCE",
                    exportEnabled: true,
                    theme: "theme1",
                    data: [
                    {
                    type: "stackedColumn",
                            toolTipContent: "{label}<br/><span style='\"'color: {color};'\"'><strong>{name}</strong></span>: {y}",
                            name: "Wards with Functional Solar",
                            showInLegend: "true",
                            indexLabelFontSize: 5,
                            dataPoints: dps1
                    }, {
                    type: "stackedColumn",
                            toolTipContent: "{label}<br/><span style='\"'color: {color};'\"'><strong>{name}</strong></span>: {y}",
                            name: "Wards with Repairable Solar",
                            showInLegend: "true",
                            indexLabelFontSize: 5,
                            dataPoints: dps2
                    },
                    {
                    type: "stackedColumn",
                            toolTipContent: "{label}<br/><span style='\"'color: {color};'\"'><strong>{name}</strong></span>: {y}",
                            name: "Ward with other CCE",
                            showInLegend: "true",
                            indexLabelFontSize: 5,
                            dataPoints: dps3
                    },
                    {
                    type: "stackedColumn",
                            toolTipContent: "{label}<br/><span style='\"'color: {color};'\"'><strong>{name}</strong></span>: {y}",
                            name: "Ward with no CCE",
                            showInLegend: "true",
                            indexLabelFontSize: 5,
                            dataPoints: dps4
                    }
                    ]
                    ,
                    legend: {
                    cursor: "pointer",
                            itemclick: function (e) {
                            if (typeof (e.dataSeries.visible) === "undefined" || e.dataSeries.visible) {
                            e.dataSeries.visible = false;
                            } else
                            {
                            e.dataSeries.visible = true;
                            }
                            chart.render();
                            }
                    }
            });
            chart.render();
            }
        }
        </script>           <!--Script of Chart ends here-->
    </head>

    <body>
        <jsp:include page="HeaderAms.jsp"></jsp:include>
        <%! int loadCount = 0;%>
        <% loadCount = (int) request.getSession().getAttribute("loadCount");
            loadCount++;
            request.getSession().setAttribute("loadCount", loadCount);
        %>
        <!--Assets - Dropdown Structure -->
        <ul id="administrationDropdown" class="dropdown-content" style="">
            <li><a href="repage">Related Equipments</a></li>
            <li class="divider"></li>
            <li><a href="ccepage">Cold Chain Equipment</a></li>
            <li class="divider"></li>
            <li><a href="transportpage">Transport</a></li>
            <li class="divider"></li>
            <li><a href="tmcpage">TMC</a></li>
        </ul>

        <!--Reports - Dropdown Structure -->
        <ul id="reportDropdown" class="dropdown-content" style="">
            <li><a href="functional_chart_page">Functional Status Chart</a></li>
            <li class="divider"></li>
            <li><a href="functionalpis">Func-stat-PQS-Domestic Graph</a></li>
            <li class="divider"></li>
            <li><a href="typeofcce">Type of CCE</a></li>
            <li class="divider"></li>
           <!-- <li><a href="typeofsolar">Type of Solar Graph</a></li>-->
            <li class="divider"></li>
            <li><a href="statecapacity">State Capacity</a></li>
            <li class="divider"></li>
            <li><a href="lgacapacity">LGA Capacity</a></li>
            <li class="divider"></li>
            <li><a href="wardswithsolar">Wards with Solar</a></li>
            <li class="divider"></li>
            <li><a href="wardswithothercce">Wards with Other CCE</a></li>               
        </ul>

        <!--Dashboards - Dropdown Structure -->
	<ul id="productsDropdown" class="dropdown-content" style="">
		<li><a href="assetManagementPage">Functional Dashboard</a></li>
		 <li class="divider"></li>
		<li id="4"><a href="assetManagementPage" name="cceDashboardTab4View">Capacity Dashboard</a></li>
		<li class="divider"></li>
		<li><a href="#!">Cap Antigens Dashboard</a></li> 
	</ul>

        <!--SCCO - About - Dropdown Structure -->
        <ul id="aboutDropdown" class="dropdown-content">
            <li id="0"><a href="#" name="cceDashboardTab1View" onclick="showLicense()">License</a></li>
        </ul>

        <nav class="#1b5e20 green darken-1">
            <div class="nav-wrapper">
                <!-- <a href="#!" class="brand-logo">Logo</a> -->
                <ul class="right hide-on-med-and-down">
                    <!--Administration - Dropdown Trigger -->
                    <li>
                        <a class="dropdown-button" href="#!" data-activates="administrationDropdown" data-beloworigin="true" data-constrainwidth="false">
                            Assets<i class="material-icons right">arrow_drop_down</i>
                        </a>
                    </li>
                    <!--Reports Dropdown -->
                    <li>
                        <a class="dropdown-button" href="#!" data-activates="reportDropdown" data-beloworigin="true" data-constrainwidth="false">
                            Data Analysis Charts<i class="material-icons right">arrow_drop_down</i>
                        </a>
                    </li>
                    <!--Dashboards - Dropdown Trigger -->
                    <li>
                        <a class="dropdown-button" href="#!" data-activates="productsDropdown" data-beloworigin="true" data-constrainwidth="false">
                            Dashboards<i class="material-icons right">arrow_drop_down</i>
                        </a>
                    </li>
                    <!--List of CCE - Dropdown Trigger -->
                    <li id="stockManagementNavigationUL">
                        <a href="listOfCCEPage">
                            List of CCE
                        </a>
                    </li>
                    <!--Stock Dashboard - Dropdown Trigger -->
                    <!--				<li>
                                                            <a class="dropdown-button" href="#!" data-activates="cceDashboardDropdown" data-beloworigin="true" data-constrainwidth="false">
                                                                    Stock Dashboard<i class="material-icons right">arrow_drop_down</i>
                                                            </a>
                                                    </li>-->

                </ul>
            </div>
        </nav>


        <!-- loader div -->
        <div style="display: none;" id="loader_div" class="loader_div">
            <div class="loader" id="loader_show"></div>
        </div>

        <br/>
    <center>
        
       <div id="chartContainer" style="height: 500px; width: 100%; f"></div>
    </center>
    <!-- Modal Structure For license -->
    <div id="license_modal" class="modal modal-fixed-footer" >
        <div class="modal-content" >
            <p><i>Copyright (c) <2016>, National Primary Health Care Development Agency, Nigeria
                    All rights reserved.</i></p>

            <p><i>Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following 
                    conditions are met:</i></p>

            <p><i>1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.</i></p>

            <p><i>2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in
                    the documentation and/or other materials provided with the distribution.</i></p>

            <p><i>
                    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
                    BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
                    EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
                    CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
                    PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
                    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
                    POSSIBILITY OF SUCH DAMAGE.</i></p>
        </div>

    </div>
</body>

<style>
    .tabs {
        /* In easy-ui.css */
        border-style: solid;
        border-width: 0 0 1px;
        height: 26px;
        list-style-type: none;
        margin: 0;
        padding: 0 0 0 0px;
        width: 50000px;
    }
    .tabs {
        /* In material-min.css */
        background-color: #fff;
        display: flex;
        height: 48px;
        margin: 0 auto;
        /* overflow-x: auto; */
        /* overflow-y: hidden; */
        position: relative;
        white-space: nowrap;
        width: 100%;
    }
</style>
<script src="resources/js/amsdashboards.js"></script>
</html>