<%@ page isELIgnored="false"%>
<head>
<link type="text/css" href="resources/easyui/themes/default/easyui.css" rel="stylesheet" />
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
		overflow-x:overlay;
	}
</style>
</head>
<body>
	<div>
		<!-- filters -->
		<div id="filters" style="padding: 3px;box-shadow: 1px 1px 1px 0px;">
			<div id="lga_combobox_div" style="display: inline;">
				<label>Filter By:</label> 
				<select id="lga_combobox" class="easyui-combobox" name="lga_combobox" style="width:200px;">
<!--                                    <option value="LGA">LGA</option>
                                    <option value="WARD">WARD</option>
-->                                </select> 	
			</div>
                    
			<span>Select Level:</span> 
			<select id="agg_combobox" class="easyui-combobox" name="agg_combobox" style="width: 100px;">
<!--                            <option value="LGA">LGA</option>
                            <option value="WARD">WARD</option>-->
			</select> 
<!--			<span>Week</span> 
			<select id="week_combobox4" class="easyui-combobox" name="week_combobox4" style="width: 100px;">
			</select> -->
			<a id="viewDashboardLinkBtn" href="#" class="easyui-linkbutton" onclick="filterGridData(true)" >View Dashboard </a>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<a id="exportLinkBtn" class="easyui-linkbutton" href="merged_dashboard_export_data.xls">Export</a>
			<!--<a id="exportLinkBtn4" href="export_data_grid" class="easyui-linkbutton">Export</a>-->

				
                        <div style="display: inline;"><div class="green-status"></div><div style="display: inline;">&gt;90% of all PQS CCE functional</div></div>
				
					<div style="display: inline;"><div class="orange-status"></div> <div style="display: inline;">&gt;=50% to &lt;=90% of all PQS CCE functional
</div></div>
					<div style="display: inline;"><div class="red-status "></div><div style="display: inline;">&lt;50% of all PQS CCE</div></div>
				
<!--			<ul class="status-list" style="margin:0 0;">
				
					<li><div><div class="green-status"></div><div>&gt;90% of all PQS CCE functional</div></div></li>
				
					<li><div><div class="orange-status"></div> <div>&gt;=50% to &lt;=90% of all PQS CCE functional
</div></div></li>
					<li><div><div class="red-status "></div><div>&lt;50% of all PQS CCE</div></div></li>
				</ul>-->
		</div>
		<!-- filters end here -->

		<div id="merged_table_div" class="table_div">
			<div class="wrap">
				<table class="head" id="heading_merged_table">
					<!-- DYNAMICALLY ROWS WILL GENERATE HERE... -->			
				</table>
				<div class="inner_table">
					<table id="merged_table_body">
						<!-- DYNAMICALLY ROWS WILL GENERATE HERE... -->
					</table>
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
function showMergedTableData(url) {
        
	document.getElementById("loader_div").style.display = "block";
	var xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
            
		if (xhttp.readyState == 4 && xhttp.status == 200) {
			document.getElementById("loader_div").style.display = "none";
                        
			var ss = JSON.parse(xhttp.responseText);
			loadmergeddata(ss);
		}
	};
	xhttp.open("POST", url, true);
	xhttp.send();
}

function filterGridData(isloadHeader) {
	var filterLevel="";
        var aggLevel="";
	var validate=true;
	var message="";
 if($('#lga_combobox').combobox('getValue')===''){
			message=("Filter is Empty");
			validate=false;
		 }
                 else if($('#agg_combobox').combobox('getValue')===''){
			message=("Level is Empty");
			validate=false;
		 }
                 else{
//                        message=($('#lga_combobox').combobox('getValue'));
			validate=true;
		}
	if(message!=''){
		alertBox(message);
	}
	if(validate){
		filterLevel = $('#lga_combobox').combobox('getValue');
		
		aggLevel = $('#agg_combobox').combobox('getValue');
		var url2 = "get_merged_dashboard_data?filterLevel="+filterLevel+"&aggLevel="+aggLevel;
		if(isloadHeader){
//                    alertBox(url2);
			loadHeadingMergedTable(filterLevel);				
		}
		showMergedTableData(url2);
	}
}

//alertBox('${userdata.getX_ROLE_NAME()}');
$('#lga_combobox').combobox({
	url : 'get_sclevel_list?userType=${userdata.getX_ROLE_NAME()}',
	valueField : 'value',
	textField : 'label',
	onSelect : function(rec) {
		$('#agg_combobox').combobox({
			url : 'get_aggby_list?levelSelected='+rec.value,
			valueField : 'value',
			textField : 'label'
		});

	}
});
/* Do not delete below code - IMPORTANT */
$('#lga_combobox').combobox({});
$('#agg_combobox').combobox({});
//$('#week_combobox').combobox({});
$('#viewDashboardLinkBtn').linkbutton({});
//$('#exportLinkBtn4').linkbutton({});
</script>
