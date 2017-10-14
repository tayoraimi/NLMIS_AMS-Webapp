<%-- 
    Document   : TypeofCCEChart
    Created on : May 29, 2017, 11:02:59 PM
    Author     : Raimi Temitayo
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

        <title>Functional Status Chart</title>

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


        <!--Script of Chart goes here-->
        <!--  <script src="https://code.jquery.com/jquery-1.11.3.js"></script>-->
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/canvasjs/1.7.0/canvasjs.js"></script>
        <script type="text/javascript">
            $(document).ready(function () {
                var url = "get_functional_chart_data?filterLevel=LGA";
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
                var tF = 0, tO_F = 0, tNI = 0, tNF = 0, tO_NF = 0;
                for (var i = 0; i < data.length; i++) {
                    tF = tF + data[i]["tF"];
                    tO_F = tO_F + data[i]["tO_F"];
                    tNI = tNI + data[i]["tNI"];
                    tNF = tNF + data[i]["tNF"];
                    tO_NF = tO_NF + data[i]["tO_NF"];
                }
                window.chart = new CanvasJS.Chart("chartContainer",
                        {
                            title: {
                                text: "Functional Status Chart",
                                fontFamily: "arial black"
                            },
                            animationEnabled: true,
                            legend: {
                                verticalAlign: "bottom",
                                horizontalAlign: "center"
                            },
                            exportFileName: "Functional Status Charts",
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
                                        {y: tF, exploded: true, name: "Functional", legendMarkerType: "square"},
                                        {y: tO_F, name: "Functional Obsolete", legendMarkerType: "square"},
                                        {y: tNI, name: "Not Installed", legendMarkerType: "square"},
                                        {y: tNF, name: "Repair", legendMarkerType: "square"},
                                        {y: tO_NF, name: "Not functional Obsolete", legendMarkerType: "square"}


                                    ]
                                }
                            ]
                        });
                chart.render();
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


        <!-- loader div -->
        <div style="display: none;" id="loader_div" class="loader_div">
            <div class="loader" id="loader_show"></div>
        </div>

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