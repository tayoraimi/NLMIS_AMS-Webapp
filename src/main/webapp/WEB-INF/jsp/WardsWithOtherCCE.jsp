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
        <link rel=" stylesheet" href="resources/css/w3css.css" type="text/css">
        <link rel="stylesheet" href="resources/css/table.css" type="text/css">
        <link rel="stylesheet" type="text/css" href="resources/easyui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="resources/easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="resources/easyui/demo/demo.css">

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
                if ((user === 'SIO') || (user==='SIFP')|| (user==='SCCO')){
                    user = 'SCCO';	
                    $('#cceListNavigationMenu').hide();
                } else if(user === 'MOH'|| (user==='LIO')|| (user==='CCO')) {
                    user = 'LIO';
                    $('#cceListNavigationMenu').hide();
                }else if(user === 'NTO'){
			user = 'NTO';
		}
                
                
                        
                switch (user) {
                    case "SCCO":
                            $('#warehouse_name').text('State: ${userdata.getX_WAREHOUSE_NAME()}');	
                            $('#cceListNavigationMenu').hide();
                            break;

                    case "NTO":
                            $('#warehouse_name').text('National: ${userdata.getX_WAREHOUSE_NAME()}');	

                            break;
                    case "LIO":
                            $('#warehouse_name').text('LGA: ${userdata.getX_WAREHOUSE_NAME()}');	
                            $('#cceListNavigationMenu').hide();	

                            break;
		}

            });

            function showLicense() {
                $('#license_modal').openModal();
            }
	function showDashBoardDivAndHideIframe() {
		$('#mainHomePageDiv').show();
		$('#iframe').hide();
	}
	function showIframeAndHideDashBoardDiv(action) {
		$('#loader_for_iframe').show();
		$('#mainHomePageDiv').hide();
		$('#iframe').show();
		$('#iframe').attr('src', "");
		$('#iframe').attr('src', action);

		document.getElementById("iframe").onload = function() {
			$('#loader_for_iframe').hide();
		};

	}
        function goToNLMIS(){
		var user = '${userdata.getX_ROLE_NAME()}';
		$('#user').text('User: '+user+' ${userdata.getX_WAREHOUSE_NAME()}');
		$('#login_time').text('${login_time}');
		if((user === 'SIO') || (user==='SIFP')|| (user==='SCCO')){
			user = 'SCCO';
		}else if(user === 'MOH'|| (user==='LIO')|| (user==='CCO')){
			user = 'LIO';
		}else if(user === 'NTO'){
			user = 'NTO';
		}
	     if(user==='LIO'){
	    	 window.location.href="homepage";
	     }else{
                 window.location.href="homepage";
             }
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
            var ss = JSON.parse(xhttp.responseText);
            loadchartdata(ss);
            document.getElementById("loader_div").style.display = "none";
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
                        y: data[i]["FUNCTIONAL_SR"],
                        label: data[i]["LG_NAME"]
                    });
                    
                    dps2.push({
                        y: data[i]["REPAIRABLE_SR"],
                        label: data[i]["LG_NAME"]
                    });
                    
                    dps3.push({
                        y: data[i]["WITHOUT_SR"],
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
            text: "# of Wards With Other CCE In Each LGA",
                    fontFamily: "arial black"
            },
                    axisY: {
                    title: "Number of Wards",
                    minimum: 0,
                    maximum: 100
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
<script type="text/javascript" src="resources/easyui/jquery.easyui.min.js"></script>
<script src="resources/js/common.js" type="text/javascript"></script>
<script src="resources/js/datagrid_agination.js" type="text/javascript"></script>
<script src="resources/js/amsdashboards.js"></script>
</html>