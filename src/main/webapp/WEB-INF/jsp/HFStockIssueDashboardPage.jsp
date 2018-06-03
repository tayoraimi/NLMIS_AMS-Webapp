<%@ page isELIgnored="false"%>
<head>
<link type="text/css" href="resources/easyui/themes/default/easyui.css" rel="stylesheet">
<script type="text/javascript" src="resources/easyui/jquery.easyui.min.js"></script>
<style>
	.status-list {
		display: inline-flex;
		margin: 0px; 
		padding: 0px;		
	}
	.status-list li{margin-right:10px}
	.status-list li div {
		display: inline-flex;
		padding-left:2px; 
	}
	.red-status {
		width: 10px;
		height: 10px;
		background: red;
		display: inline-block;
		margin-top: 6px;
	}
	.green-status {
		width: 10px;
		height: 10px;
		background: green;
		display: inline-block;
		margin-top: 6px;
	}
	.yellow-status {
		width: 10px;
		height: 10px;
		background: yellow;
		display: inline-block;
		margin-top: 6px;
	}
	.blue-status{
	width: 10px;
		height: 10px;
		background:  #8e84fb;
		display: inline-block;
		margin-top: 6px;
	}
	.table_div6{
	overflow:hidden;
	width: 100%;
	height: 60%;
}
.wrap6 {
	width: 100%;
}
.headingTable6 table{
	width: 98.8%;
	border-collapse: collapse;
	font-size:12px;
}

.headingTable6 table tr td {
	border: 1px solid black;
	background-color: #e7f0ff;
	padding: 6px;
	width: 7.8%;
	text-align: center;
}
.inner_table6 table tr td {
	padding: 5px;
	border: 1px solid black;
	width: 7.8%;
	word-wrap: break-word;
	text-align: center;
}

.inner_table6 table tr td:FIRST-CHILD ,.headingTable6 tr td:FIRST-CHILD  {
	padding: 5px;
	border: 1px solid black;
	width: 200px;
	word-wrap: break-word;
	text-align: left;
}

.inner_table6 table{
font-size: 12px;
}
.inner_table6 {
	height:86%;
	overflow-y: scroll;
}

</style>
</head>
<body>
	<div>
		<!-- filters -->
		<div id="filters" style="padding: 2px;box-shadow: 1px 1px 1px 0px;">
			<div id="lga_combobox_div6" style="display: inline;">
				<span>LGA:</span> 
				<select id="lga_combobox6" class="easyui-combobox" name="lga_combobox6" style="width:200px;">
				</select> 	
			</div>
			<span>Year:</span> 
			<select id="year_combobox6" class="easyui-combobox" name="year_combobox6" style="width: 100px;">
			</select> 
			<span>Week</span> 
			<select id="week_combobox6" class="easyui-combobox" name="week_combobox6" style="width: 100px;">
			</select> 
			<a id="viewDashboardLinkBtn6" href="#" class="easyui-linkbutton" onclick="filterGridData6(true)">View Dashboard </a>
			<a id="exportLinkBtn6" href="hf_stock_summary_export_data" class="easyui-linkbutton">Export</a>
			&nbsp;&nbsp;
			<span id="activeHFCount">Active Facilities with Functional CCE : </span>
<!-- 			<select id="otherActiveHfs" class="easyui-combobox" name="otherActiveHfs" style="width: 200px;" -->
<!-- 			        data-options="textField:'CUSTOMER_NAME',valueField:'CUSTOMER_NAME'"> -->
<!-- 			</select>			 -->
			<ul class="status-list" style="margin:0 0;">
				<li><div><div class="red-status"></div><div>Antigen Below Minimum Level</div></div></li>
				<li><div><div class="green-status"></div><div>Antigen Sufficient</div></div></li>
				<li><div><div class="yellow-status"></div> <div>Antigen need to be re-orderd</div></div></li>
				<li><div><div class="blue-status"></div> <div>Over Stock</div></div></li>
			</ul>
		</div>
		<!-- filters end here -->

		<div  class="table_div6">
			<div class="wrap6">
			<div class="headingTable6">
				<table  id="heading_table6">
					<!-- DYNAMICALLY ROWS WILL GENERATE HERE... -->			
				</table>
			</div>
				
				<div class="inner_table6">
					<table id="table_body6">
						<!-- DYNAMICALLY ROWS WILL GENERATE HERE... -->
					</table>
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
function filterGridData6(isloadHeader) {
	var lgaName="";
	var validate=true;
	var message="";
 if('${userBean.getX_ROLE_NAME()}'==="SCCO"
		 || '${userBean.getX_ROLE_NAME()}'==="SIO"
		 || '${userBean.getX_ROLE_NAME()}'==="SIFP"){
		 if($('#lga_combobox6').combobox('getValue')===''){
			message=("LGA is Empty");
			validate=false;
		 }else if ($('#year_combobox6').combobox('getValue') === "") {
			message=("Year is Empty");
			validate=false;
		} else if ($('#week_combobox6').combobox('getValue') === "") {
			validate=false;
			message=("Week is Empty");
		}else{
			validate=true;
		}
	}else if(('${userBean.x_ROLE_NAME}'==="LIO") || ('${userBean.x_ROLE_NAME}'==="MOH")){
		if ($('#year_combobox6').combobox('getValue') === "") {
			message=("Year is Empty");
			validate=false;
		} else if ($('#week_combobox6').combobox('getValue') === "") {
			validate=false;
			message=("Week is Empty");
		}else{
			validate=true;
		}
	}
	if(message!=''){
		alertBox(message);
	}
	if(validate){
		var lgaName=$('#lga_combobox6').combobox('getText');
		var lgaId = $('#lga_combobox6').combobox('getValue');
		if(('${userBean.x_ROLE_NAME}'==="LIO") || ('${userBean.x_ROLE_NAME}'==="MOH")){			
			lgaId = '${userBean.x_WAREHOUSE_ID}';
			lgaName = '${userBean.x_WAREHOUSE_NAME}';
		}
		var year = $('#year_combobox6').combobox('getValue');
		var week = $('#week_combobox6').combobox('getValue');
		var url = "get_hf_stock_issue_grid_data?year=" + year + "&week="+ week+"&lgaId="+lgaId+"&lgaName="+lgaName;
		if(isloadHeader){
			loadHeadingTable6(lgaId,lgaName);				
		}
		showTableData6(url);
	}
}
$('#lga_combobox6').combobox({
	url : 'getlgalist?option=notAll',
	valueField : 'value',
	textField : 'label'
});
$('#year_combobox6').combobox({
	url : 'get_year_list',
	valueField : 'value',
	textField : 'label',
	onSelect : function(rec) {
		$('#week_combobox6').combobox({
			url : 'get_week_list/week?yearParam=' + rec.value,
			valueField : 'value',
			textField : 'label'
		});

	}
});
/* Do not delete below code - IMPORTANT */
$('#lga_combobox6').combobox({});
$('#year_combobox6').combobox({});
$('#week_combobox6').combobox({});
$('#viewDashboardLinkBtn6').linkbutton({});
$('#exportLinkBtn6').linkbutton({});
</script>
