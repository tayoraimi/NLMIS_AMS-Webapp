<%@ page isELIgnored="false"%>
<head>
<link type="text/css" href="resources/easyui/themes/default/easyui.css" rel="stylesheet">
<script type="text/javascript" src="resources/easyui/jquery.easyui.min.js"></script>
<style>
	.status-list {
		display: inline-block;
	}
	.status-list li {
		display: inline;
	}
	.red-status {
		width: 10px;
		height: 10px;
		background: red;
		display: inline-block;
	}
	.green-status {
		width: 10px;
		height: 10px;
		background: green;
		display: inline-block;
	}
	.yellow-status {
		width: 10px;
		height: 10px;
		background: yellow;
		display: inline-block;
	}
	.orange-status {
		width: 10px;
		height: 10px;
		background: orange;
		display: inline-block;
	}
	.table_div{
		overflow-x:scroll;
		overflow-y:scroll;
	}
	.wrap {
		width: 100%;
	}
	.wrap table {
		width: 100%;
		table-layout: fixed;
		border-collapse: collapse;
	}
	.wrap table tr th {
		border: 1px solid black;
		background-color: #e7f0ff;
		padding: 5px 0px 5px 0px;
	}
	table tr td {
		padding: 5px;
		border: 1px solid black;
		width: 100px;
		word-wrap: break-word;
	}
	table tr td {
		padding: 5px;
		border: 1px solid black;
		width: 100px;
		text-align:center;
		word-wrap: break-word;
	}
	table tr td:FIRST-CHILD {
		padding: 5px;
		border: 1px solid black;
		width: 200px;
		word-wrap: break-word;
	}
	table.head tr td {
		background: #eee;
	}
	.inner_table {
		height:323px;
		overflow-y: overlay;
		overflow-x:auto;
	}
</style>
</head>
<body>
	<div>
		<!-- filters -->
		<div id="filters" style="padding: 3px;box-shadow: 1px 1px 1px 0px;">
			<div id="lga_combobox_div4" style="display: inline;">
				<label>Filter By:</label> 
				<select id="lga_combobox4" class="easyui-combobox" name="lga_combobox4" style="width:200px;">
<!--                                    <option value="LGA">LGA</option>
                                    <option value="WARD">WARD</option>-->
                                </select> 	
			</div>
                    
			<span>Select Level:</span> 
			<select id="agg_combobox4" class="easyui-combobox" name="agg_combobox4" style="width: 100px;">
			</select> <!--
			<span>Week</span> 
			<select id="week_combobox4" class="easyui-combobox" name="week_combobox4" style="width: 100px;">
			</select> -->
			<a id="viewDashboardLinkBtn4" href="#" class="easyui-linkbutton" onclick="filterGridData4(true)">View Dashboard </a>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<a id="exportLinkBtn4" class="easyui-linkbutton" href="capacity_dashboard_export_data.xls">Export</a>

					<div style="display: inline;"><div class="red-status"></div><div style="display: inline;">Below 70% of required capacity</div></div>
					<div style="display: inline;"><div class="green-status"></div><div style="display: inline;">100% Capacity Available</div></div>
					<div style="display: inline;"><div class="orange-status"></div> <div style="display: inline;">&lt; 100% of capacity required available</div></div>
				
		</div>
		<!-- filters end here -->

		<div id="table_div4" class="table_div">
			<div class="wrap">
				<table class="head" id="heading_table4">
					<!-- DYNAMICALLY ROWS WILL GENERATE HERE... -->			
				</table>
				<div class="inner_table">
					<table id="table_body4">
						<!-- DYNAMICALLY ROWS WILL GENERATE HERE... -->
					</table>
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
function filterGridData4(isloadHeader) {
	var filterLevel="";
        var aggLevel="";
	var validate=true;
	var message="";
 if($('#lga_combobox4').combobox('getValue')===''){
			message=("Filter is Empty");
			validate=false;
		 }
                 else if($('#agg_combobox4').combobox('getValue')===''){
			message=("Level is Empty");
			validate=false;
		 }
                 else{
			validate=true;
		}
	if(message!=''){
		alertBox(message);
	}
	if(validate){
		filterLevel = $('#lga_combobox4').combobox('getValue');
		aggLevel = $('#agg_combobox4').combobox('getValue');
		
		var agg_combobox = $('#agg_combobox4').combobox('getValue');
		var url = "get_capacity_dashboard_data?filterLevel="+filterLevel+"&aggLevel="+aggLevel;//?year=" + year + "&week="+ week+"&lgaId="+lgaId+"&lgaName="+lgaName;
		if(isloadHeader){
			loadHeadingTable4(filterLevel);				
		}
		showTableData4(url);
	}
}
//$('#lga_combobox4').combobox({
//	url : 'getlgalist?option=notAll',
//	valueField : 'value',
//	textField : 'label'
//});
//$('#year_combobox4').combobox({
//	url : 'get_year_list',
//	valueField : 'value',
//	textField : 'label',
//	onSelect : function(rec) {
//		$('#week_combobox4').combobox({
//			url : 'get_week_list/week?yearParam=' + rec.value,
//			valueField : 'value',
//			textField : 'label'
//		});
//
//	}
//});
/* Do not delete below code - IMPORTANT */
//$('#lga_combobox4').combobox({});
//$('#year_combobox4').combobox({});
//$('#week_combobox4').combobox({});
$('#viewDashboardLinkBtn4').linkbutton({});
//$('#exportLinkBtn4').linkbutton({});
</script>
