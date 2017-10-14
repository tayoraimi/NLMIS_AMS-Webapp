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

        <title>Functional Status PQS Chart</title>

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
                    case "SCC        O":
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
                                $('#state_combobox3_div').css('display', 'none        ');

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

        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/canvasjs/1.7.0/canvasjs.js"></script>
        <script type="text/javascript">
            $(document).ready(function () {
                var url = "get_functional_pis_data?filterLevel=LGA";    
                var url1 = "get_functional_domestic_equipment_data?filterLevel=LGA";
                var url2 = "get_functional_pis_refrigerator_data?filterLevel=LGA";   
                var url3 = "get_functional_domestic_refrigerator_data?filterLevel=LGA";
                var url4 = "get_functional_pis_freezer_data?filterLevel=LGA";    
                var url5 = "get_functional_domestic_freezer_data?filterLevel=LGA";
                var url6 = "get_functional_pis_solar_refrigerator_data?filterLevel=LGA";    
                var url7 = "get_functional_domestic_solar_refrigerator_data?filterLevel=LGA";

                showChartData(url);
                showChartData1(url1);
                showChartData2(url2);
                showChartData3(url3);
                showChartData4(url4);
                showChartData5(url5);
                showChartData6(url6);
                showChartData7(url7);
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
            
            function showChartData1(url1) {

                document.getElementById("loader_div").style.display = "block";
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {

                    if (xhttp.readyState == 4 && xhttp.status == 200) {
                        document.getElementById("loader_div").style.display = "none";

                        var ss = JSON.parse(xhttp.responseText);
                        loadchartdata1(ss);
                    }
                };
                xhttp.open("POST", url1, true);
                xhttp.send();
            }
            
            function showChartData2(url2) {

                document.getElementById("loader_div").style.display = "block";
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {

                    if (xhttp.readyState == 4 && xhttp.status == 200) {
                        document.getElementById("loader_div").style.display = "none";

                        var ss = JSON.parse(xhttp.responseText);
                        loadchartdata2(ss);
                    }
                };
                xhttp.open("POST", url2, true);
                xhttp.send();
            }
            
            function showChartData3(url3) {

                document.getElementById("loader_div").style.display = "block";
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {

                    if (xhttp.readyState == 4 && xhttp.status == 200) {
                        document.getElementById("loader_div").style.display = "none";

                        var ss = JSON.parse(xhttp.responseText);
                        loadchartdata3(ss);
                    }
                };
                xhttp.open("POST", url3, true);
                xhttp.send();
            }
            
            function showChartData4(url4) {

                document.getElementById("loader_div").style.display = "block";
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {

                    if (xhttp.readyState == 4 && xhttp.status == 200) {
                        document.getElementById("loader_div").style.display = "none";

                        var ss = JSON.parse(xhttp.responseText);
                        loadchartdata4(ss);
                    }
                };
                xhttp.open("POST", url4, true);
                xhttp.send();
            }
            
            function showChartData5(url5) {

                document.getElementById("loader_div").style.display = "block";
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {

                    if (xhttp.readyState == 4 && xhttp.status == 200) {
                        document.getElementById("loader_div").style.display = "none";

                        var ss = JSON.parse(xhttp.responseText);
                        loadchartdata5(ss);
                    }
                };
                xhttp.open("POST", url5, true);
                xhttp.send();
            }
            
            function showChartData6(url6) {

                document.getElementById("loader_div").style.display = "block";
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {

                    if (xhttp.readyState == 4 && xhttp.status == 200) {
                        document.getElementById("loader_div").style.display = "none";

                        var ss = JSON.parse(xhttp.responseText);
                        loadchartdata6(ss);
                    }
                };
                xhttp.open("POST", url6, true);
                xhttp.send();
            }
            
            function showChartData7(url7) {

                document.getElementById("loader_div").style.display = "block";
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {

                    if (xhttp.readyState == 4 && xhttp.status == 200) {
                        document.getElementById("loader_div").style.display = "none";

                        var ss = JSON.parse(xhttp.responseText);
                        loadchartdata7(ss);
                    }
                };
                xhttp.open("POST", url7, true);
                xhttp.send();
            }
            
            function loadchartdata(data) {
                var aVal = 0, bVal = 0, cVal = 0, dVal = 0, eVal = 0;
                for (var i = 0; i < data.length; i++) {
                    aVal = aVal + data[i]["functional"];
                    bVal = bVal + data[i]["functional_obsolete"];
                    cVal = cVal + data[i]["not_installed"];
                    dVal = dVal + data[i]["repair"];
                    eVal = eVal + data[i]["not_functional_obsolete"];
                }
                window.chart = new CanvasJS.Chart("chartContainer",
                        {
                            title: {
                                text: "Functional Status of PIS/PQS Equipment",
                                fontFamily: "arial black"
                            },
                            animationEnabled: true,
                            legend: {
                                verticalAlign: "bottom",
                                horizontalAlign: "center"
                            },
                            exportFileName: "Functional PIS Charts",
                            exportEnabled: true,
                            theme: "theme1",
                            data: [
                                {
                                    type: "pie",
                                    indexLabelFontFamily: "Garamond",
                                    indexLabelFontColor: "Green",
                                    indexLabelFontSize: 15,
                                    indexLabelFontWeight: "bold",
                                    startAngle: 0,

                                    indexLabelLineColor: "darkgrey",
                                    indexLabelPlacement: "outside",
                                    toolTipContent: "<strong>{y}</strong>",
                                    showInLegend: true,
                                    indexLabel: "{name} #percent%",
                                    dataPoints: [
                                        {y: aVal, exploded: true, name: "Functional", legendMarkerType: "triangle"},
                                        {y: bVal, name: "Functional Obsolete", legendMarkerType: "square"},
                                        {y: cVal, name: "Not Installed", legendMarkerType: "circle"},
                                        {y: dVal, name: "Repair", legendMarkerType: "triangle"},
                                        {y: eVal, name: "Not functional Obsolete", legendMarkerType: "square"}

                                    ]
                                }
                            ]
                        });
                     
                chart.render();         
            }
            
            function loadchartdata1(data1) {
                var aVal = 0, bVal = 0, cVal = 0, dVal = 0, eVal = 0;
                for (var i = 0; i < data1.length; i++) {
                    aVal = aVal + data1[i]["functional"];
                    bVal = bVal + data1[i]["functional_obsolete"];
                    cVal = cVal + data1[i]["not_installed"];
                    dVal = dVal + data1[i]["repair"];
                    eVal = eVal + data1[i]["not_functional_obsolete"];
                }
                window.chart1 = new CanvasJS.Chart("chartContainer1",
                        {
                            title: {
                                text: "Functional Status of Domestic Equipments",
                                fontFamily: "arial black"
                            },
                            animationEnabled: true,
                            legend: {
                                verticalAlign: "bottom",
                                horizontalAlign: "center"
                            },
                            exportFileName: "Functional PIS Charts",
                            exportEnabled: true,
                            theme: "theme1",
                            data: [
                                {
                                    type: "pie",
                                    indexLabelFontFamily: "Garamond",
                                    indexLabelFontColor: "Green",
                                    indexLabelFontSize: 15,
                                    indexLabelFontWeight: "bold",
                                    startAngle: 0,

                                    indexLabelLineColor: "darkgrey",
                                    indexLabelPlacement: "outside",
                                    toolTipContent: "<strong>{y}</strong>",
                                    showInLegend: true,
                                    indexLabel: "{name} #percent%",
                                    dataPoints: [
                                        {y: aVal, exploded: true, name: "Functional", legendMarkerType: "triangle"},
                                        {y: bVal, name: "Functional Obsolete", legendMarkerType: "square"},
                                        {y: cVal, name: "Not Installed", legendMarkerType: "circle"},
                                        {y: dVal, name: "Repair", legendMarkerType: "triangle"},
                                        {y: eVal, name: "Not functional Obsolete", legendMarkerType: "square"}

                                    ]
                                }
                            ]
                        });
                     
                chart1.render();         
            }
            
            function loadchartdata2(data2) {
                var aVal = 0, bVal = 0, cVal = 0, dVal = 0, eVal = 0;
                for (var i = 0; i < data2.length; i++) {
                    aVal = aVal + data2[i]["functional"];
                    bVal = bVal + data2[i]["functional_obsolete"];
                    cVal = cVal + data2[i]["not_installed"];
                    dVal = dVal + data2[i]["repair"];
                    eVal = eVal + data2[i]["not_functional_obsolete"];
                }
                window.chart2 = new CanvasJS.Chart("chartContainer2",
                        {
                            title: {
                                text: "Functional Status of PIS/PQS Refrigerators",
                                fontFamily: "arial black"
                            },
                            animationEnabled: true,
                            legend: {
                                verticalAlign: "bottom",
                                horizontalAlign: "center"
                            },
                            exportFileName: "Functional PIS Charts",
                            exportEnabled: true,
                            theme: "theme1",
                            data: [
                                {
                                    type: "pie",
                                    indexLabelFontFamily: "Garamond",
                                    indexLabelFontColor: "Green",
                                    indexLabelFontSize: 15,
                                    indexLabelFontWeight: "bold",
                                    startAngle: 0,

                                    indexLabelLineColor: "darkgrey",
                                    indexLabelPlacement: "outside",
                                    toolTipContent: "<strong>{y}</strong>",
                                    showInLegend: true,
                                    indexLabel: "{name} #percent%",
                                    dataPoints: [
                                        {y: aVal, exploded: true, name: "Functional", legendMarkerType: "triangle"},
                                        {y: bVal, name: "Functional Obsolete", legendMarkerType: "square"},
                                        {y: cVal, name: "Not Installed", legendMarkerType: "circle"},
                                        {y: dVal, name: "Repair", legendMarkerType: "triangle"},
                                        {y: eVal, name: "Not functional Obsolete", legendMarkerType: "square"}

                                    ]
                                }
                            ]
                        });
                     
                chart2.render();         
            }
            
            function loadchartdata3(data3) {
                var aVal = 0, bVal = 0, cVal = 0, dVal = 0, eVal = 0;
                for (var i = 0; i < data3.length; i++) {
                    aVal = aVal + data3[i]["functional"];
                    bVal = bVal + data3[i]["functional_obsolete"];
                    cVal = cVal + data3[i]["not_installed"];
                    dVal = dVal + data3[i]["repair"];
                    eVal = eVal + data3[i]["not_functional_obsolete"];
                }
                window.chart3 = new CanvasJS.Chart("chartContainer3",
                        {
                            title: {
                                text: "Functional Status of Domestic Refrigerators",
                                fontFamily: "arial black"
                            },
                            animationEnabled: true,
                            legend: {
                                verticalAlign: "bottom",
                                horizontalAlign: "center"
                            },
                            exportFileName: "Functional PIS Charts",
                            exportEnabled: true,
                            theme: "theme1",
                            data: [
                                {
                                    type: "pie",
                                    indexLabelFontFamily: "Garamond",
                                    indexLabelFontColor: "Green",
                                    indexLabelFontSize: 15,
                                    indexLabelFontWeight: "bold",
                                    startAngle: 0,

                                    indexLabelLineColor: "darkgrey",
                                    indexLabelPlacement: "outside",
                                    toolTipContent: "<strong>{y}</strong>",
                                    showInLegend: true,
                                    indexLabel: "{name} #percent%",
                                    dataPoints: [
                                        {y: aVal, exploded: true, name: "Functional", legendMarkerType: "triangle"},
                                        {y: bVal, name: "Functional Obsolete", legendMarkerType: "square"},
                                        {y: cVal, name: "Not Installed", legendMarkerType: "circle"},
                                        {y: dVal, name: "Repair", legendMarkerType: "triangle"},
                                        {y: eVal, name: "Not functional Obsolete", legendMarkerType: "square"}

                                    ]
                                }
                            ]
                        });
                     
                chart3.render();         
            }
            
            function loadchartdata4(data4) {
                var aVal = 0, bVal = 0, cVal = 0, dVal = 0, eVal = 0;
                for (var i = 0; i < data4.length; i++) {
                    aVal = aVal + data4[i]["functional"];
                    bVal = bVal + data4[i]["functional_obsolete"];
                    cVal = cVal + data4[i]["not_installed"];
                    dVal = dVal + data4[i]["repair"];
                    eVal = eVal + data4[i]["not_functional_obsolete"];
                }
                window.chart = new CanvasJS.Chart("chartContainer4",
                        {
                            title: {
                                text: "Functional Status of PIS/PQS Freezers",
                                fontFamily: "arial black"
                            },
                            animationEnabled: true,
                            legend: {
                                verticalAlign: "bottom",
                                horizontalAlign: "center"
                            },
                            exportFileName: "Functional PIS Charts",
                            exportEnabled: true,
                            theme: "theme1",
                            data: [
                                {
                                    type: "pie",
                                    indexLabelFontFamily: "Garamond",
                                    indexLabelFontColor: "Green",
                                    indexLabelFontSize: 15,
                                    indexLabelFontWeight: "bold",
                                    startAngle: 0,

                                    indexLabelLineColor: "darkgrey",
                                    indexLabelPlacement: "outside",
                                    toolTipContent: "<strong>{y}</strong>",
                                    showInLegend: true,
                                    indexLabel: "{name} #percent%",
                                    dataPoints: [
                                        {y: aVal, exploded: true, name: "Functional", legendMarkerType: "triangle"},
                                        {y: bVal, name: "Functional Obsolete", legendMarkerType: "square"},
                                        {y: cVal, name: "Not Installed", legendMarkerType: "circle"},
                                        {y: dVal, name: "Repair", legendMarkerType: "triangle"},
                                        {y: eVal, name: "Not functional Obsolete", legendMarkerType: "square"}

                                    ]
                                }
                            ]
                        });
                     
                chart4.render();         
            }
            
            function loadchartdata5(data5) {
                var aVal = 0, bVal = 0, cVal = 0, dVal = 0, eVal = 0;
                for (var i = 0; i < data5.length; i++) {
                    aVal = aVal + data5[i]["functional"];
                    bVal = bVal + data5[i]["functional_obsolete"];
                    cVal = cVal + data5[i]["not_installed"];
                    dVal = dVal + data5[i]["repair"];
                    eVal = eVal + data5[i]["not_functional_obsolete"];
                }
                window.chart5 = new CanvasJS.Chart("chartContainer5",
                        {
                            title: {
                                text: "Functional Status of Domestic Freezers",
                                fontFamily: "arial black"
                            },
                            animationEnabled: true,
                            legend: {
                                verticalAlign: "bottom",
                                horizontalAlign: "center"
                            },
                            exportFileName: "Functional PIS Charts",
                            exportEnabled: true,
                            theme: "theme1",
                            data: [
                                {
                                    type: "pie",
                                    indexLabelFontFamily: "Garamond",
                                    indexLabelFontColor: "Green",
                                    indexLabelFontSize: 15,
                                    indexLabelFontWeight: "bold",
                                    startAngle: 0,

                                    indexLabelLineColor: "darkgrey",
                                    indexLabelPlacement: "outside",
                                    toolTipContent: "<strong>{y}</strong>",
                                    showInLegend: true,
                                    indexLabel: "{name} #percent%",
                                    dataPoints: [
                                        {y: aVal, exploded: true, name: "Functional", legendMarkerType: "triangle"},
                                        {y: bVal, name: "Functional Obsolete", legendMarkerType: "square"},
                                        {y: cVal, name: "Not Installed", legendMarkerType: "circle"},
                                        {y: dVal, name: "Repair", legendMarkerType: "triangle"},
                                        {y: eVal, name: "Not functional Obsolete", legendMarkerType: "square"}

                                    ]
                                }
                            ]
                        });
                     
                chart5.render();         
            }
            
            function loadchartdata6(data6) {
                var aVal = 0, bVal = 0, cVal = 0, dVal = 0, eVal = 0;
                for (var i = 0; i < data6.length; i++) {
                    aVal = aVal + data6[i]["functional"];
                    bVal = bVal + data6[i]["functional_obsolete"];
                    cVal = cVal + data6[i]["not_installed"];
                    dVal = dVal + data6[i]["repair"];
                    eVal = eVal + data6[i]["not_functional_obsolete"];
                }
                window.chart6 = new CanvasJS.Chart("chartContainer6",
                        {
                            title: {
                                text: "Functional Status of PIS/PQS Solar Refirgerators",
                                fontFamily: "arial black"
                            },
                            animationEnabled: true,
                            legend: {
                                verticalAlign: "bottom",
                                horizontalAlign: "center"
                            },
                            exportFileName: "Functional PIS Charts",
                            exportEnabled: true,
                            theme: "theme1",
                            data: [
                                {
                                    type: "pie",
                                    indexLabelFontFamily: "Garamond",
                                    indexLabelFontColor: "Green",
                                    indexLabelFontSize: 15,
                                    indexLabelFontWeight: "bold",
                                    startAngle: 0,

                                    indexLabelLineColor: "darkgrey",
                                    indexLabelPlacement: "outside",
                                    toolTipContent: "<strong>{y}</strong>",
                                    showInLegend: true,
                                    indexLabel: "{name} #percent%",
                                    dataPoints: [
                                        {y: aVal, exploded: true, name: "Functional", legendMarkerType: "triangle"},
                                        {y: bVal, name: "Functional Obsolete", legendMarkerType: "square"},
                                        {y: cVal, name: "Not Installed", legendMarkerType: "circle"},
                                        {y: dVal, name: "Repair", legendMarkerType: "triangle"},
                                        {y: eVal, name: "Not functional Obsolete", legendMarkerType: "square"}

                                    ]
                                }
                            ]
                        });
                     
                chart6.render();         
            }
            
            function loadchartdata7(data7) {
                var aVal = 0, bVal = 0, cVal = 0, dVal = 0, eVal = 0;
                for (var i = 0; i < data7.length; i++) {
                    aVal = aVal + data7[i]["functional"];
                    bVal = bVal + data7[i]["functional_obsolete"];
                    cVal = cVal + data7[i]["not_installed"];
                    dVal = dVal + data7[i]["repair"];
                    eVal = eVal + data7[i]["not_functional_obsolete"];
                }
                window.chart7 = new CanvasJS.Chart("chartContainer7",
                        {
                            title: {
                                text: "Functional Status of Domestic Solar Refrigerators",
                                fontFamily: "arial black"
                            },
                            animationEnabled: true,
                            legend: {
                                verticalAlign: "bottom",
                                horizontalAlign: "center"
                            },
                            exportFileName: "Functional PIS Charts",
                            exportEnabled: true,
                            theme: "theme1",
                            data: [
                                {
                                    type: "pie",
                                    indexLabelFontFamily: "Garamond",
                                    indexLabelFontColor: "Green",
                                    indexLabelFontSize: 15,
                                    indexLabelFontWeight: "bold",
                                    startAngle: 0,

                                    indexLabelLineColor: "darkgrey",
                                    indexLabelPlacement: "outside",
                                    toolTipContent: "<strong>{y}</strong>",
                                    showInLegend: true,
                                    indexLabel: "{name} #percent%",
                                    dataPoints: [
                                        {y: aVal, exploded: true, name: "Functional", legendMarkerType: "triangle"},
                                        {y: bVal, name: "Functional Obsolete", legendMarkerType: "square"},
                                        {y: cVal, name: "Not Installed", legendMarkerType: "circle"},
                                        {y: dVal, name: "Repair", legendMarkerType: "triangle"},
                                        {y: eVal, name: "Not functional Obsolete", legendMarkerType: "square"}

                                    ]
                                }
                            ]
                        });
                     
                chart7.render();         
            }

        </script>
        <!--Script of Chart ends here-->
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
<!--<div style="display: none;" id="loader_div" class="loader_div">
                        <div class="loader" id="loader_show"></div>
                    </div>-->
<div style="display: none;" id="loader_div" class="loader_div">
                        <div class="loader" id="loader_show"></div>
                    </div>
        <table>
            <tr>
                <td> <div id="chartContainer" style="height: 300px; width: 100%; f"></div></td>
                <td><div id="chartContainer1" style="height: 300px; width: 100%; f"></div></td>
            </tr>

            <tr>
                <td> <div id="chartContainer2" style="height: 300px; width: 100%; f"></div></td>
                <td><div id="chartContainer3" style="height: 300px; width: 100%; f"></div></td>
            </tr>

            <tr>
                <td> <div id="chartContainer4" style="height: 300px; width: 100%; f"></div></td>
                <td><div id="chartContainer5" style="height: 300px; width: 100%; f"></div></td>
            </tr>

            <tr>
                <td> <div id="chartContainer6" style="height: 300px; width: 100%; f"></div></td>
                <td><div id="chartContainer7" style="height: 300px; width: 100%; f"></div></td>
            </tr>
        </table>



        <br/>
        <!--Div for our chart-->
        <div id="chartContainer" style="height: 300px; width: 100%; f"></div>

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