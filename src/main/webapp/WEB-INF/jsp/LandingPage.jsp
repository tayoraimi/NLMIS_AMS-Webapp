<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" isELIgnored="false"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="f"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html id="homepageHtmlElement" style="font-size:13px">
<head>
<link rel="shortcut icon" type="image/x-icon" href="resources/images/favicon.ico" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />

<link rel="stylesheet" href="resources/css/materialize.min.css"	type="text/css">

<script src="resources/js/jquery-2.2.3.min.js"></script>
<script src="resources/js/materialize.min.js"></script>
<script src="resources/js/common.js"></script>

<title>N-LMIS/AMS</title>
<style>
    
#container{
  width:715px;
  height:230px;
  margin:180px auto;
}
.container {
  display: -webkit-box;
  display: -ms-flexbox;
  display: flex;
  -webkit-box-pack: center;
      -ms-flex-pack: center;
          justify-content: center;
  -webkit-box-align: center;
      -ms-flex-align: center;
          align-items: center;
  -ms-flex-line-pack: center;
      align-content: center;
  -ms-flex-wrap: wrap;
      flex-wrap: wrap;
  width: 60vw;
  max-width: 1200px;
  margin: 0 auto;
  min-height: 100vh;
}

.button {
  -webkit-box-flex: 1;
      -ms-flex: 1 1 auto;
          flex: 1 1 auto;
  margin: 10px;
  padding: 20px;
  border: 2px solid green;
  color: green;
  text-align: center;
  text-transform: uppercase;
  position: relative;
  overflow: hidden;
  -webkit-transition: .3s;
  transition: .3s;
}
.button:after {
  position: absolute;
  -webkit-transition: .3s;
  transition: .3s;
  content: '';
  width: 0;
  left: 50%;
  bottom: 0;
  height: 3px;
  background: green;
}
.button:hover {
  cursor: pointer;
}
.button:hover:after {
  width: 100%;
  left: 0;
}

nav, nav .nav-wrapper i, nav a.button-collapse, nav a.button-collapse i {
    height: 33px;
    line-height: 33px;
}
.dropdown-content li {
	min-height: 25px;
}
.dropdown-content li > a, .dropdown-content li > span {
    color: green;
    display: block;
    font-size: 16px;
    line-height: 22px;
    padding: 7px 16px;
}
.preloader-wrapper.big {
    height: 100px;
    left: 42%;
    top: 50%;
    width: 100px;
}
.loader_div {
	height: 100%;
	width: 100%;
	position: absolute;
	overflow: overlay;
	opacity: 0.5;
	z-index: 1000;
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

.loader_div_for_iframe {
	height: 84%;
	width: 100%;
	position: absolute;
	overflow: overlay;
	opacity: 0.5;
	z-index: 1000;
	top: 16%;
}
.loader_circle{
	border: 8px solid #f3f3f3;
	border-radius: 50%;
	border-top: 8px solid blue;
	border-bottom: 8px solid blue;
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
history.pushState(null, null, "landingpage");
window.addEventListener('popstate', function () {
history.pushState(null, null, "landingpage");
});	
</script>
<script type="text/javascript">
$(document).ready(function(){
	$('.tabs .tab').css('text-transform', 'none');
});
	$(document).ready(function(){
		$(".dropdown-button").dropdown({ hover: true });
		$("#cceDashboardTabsUL .indicator").css('height','5px');
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
		
		/* Below handler will run when Menu-Items(Navigation Menu-Dropdowns) clicked */	
		$('#iframe').hide();	
	});
      
</script>
</head>

<body>

	<jsp:include page="Header.jsp"></jsp:include>
	<%! int loadCount=0; %>
	<% loadCount =(int)request.getSession().getAttribute("loadCount");
		loadCount++;
		request.getSession().setAttribute("loadCount",loadCount);
	%>

	<!-- Below div, By default display's Stock Dashboard as home-page-default-view -->
	<div id="container" class="row">
					
<!--			<a id="ams_btn" href="assetManagementPage" title="Asset Management">
				<img src="resources/images/AMS.png" alt="">
			</a>&nbsp;&nbsp;			
			<a id="nlmis_btn" href="homepage" title="N-LMIS">
				<img src="resources/images/NLMIS.png" alt="">
			</a>&nbsp;&nbsp;-->
                        <a id="nlmis_btn" href="homepage" title="N-LMIS">
                            <div class="button">N-Logistics Management Information System</div>
                        </a>
                        <a id="ams_btn" href="assetManagementPage" title="Asset Management">
                            <div class="button">Asset Management System</div>
                        </a>


                        
                        
        </div>
     <iframe id="iframe" src=""  height="75%" width="100%"></iframe> 
	<!-- loader div -->
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
.tabs .tab {
line-height: 35px;
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
<script src="resources/js/stockdashboards.js"></script>
</html>