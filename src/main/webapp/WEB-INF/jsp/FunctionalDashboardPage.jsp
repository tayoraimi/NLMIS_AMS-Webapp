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
	.table_div2{
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
			<div id="lga_combobox_div2" style="display: inline;">
				<label>Select Level:</label> 
				<select id="lga_combobox2" class="easyui-combobox" name="lga_combobox2" style="width:200px;">
<!--                                    <option value="LGA">LGA</option>
                                    <option value="WARD">WARD</option>-->
                                </select> 	
			</div>
                    
			<span>Select Store:</span> 
			<select id="agg_combobox2" class="easyui-combobox" name="agg_combobox2" style="width: 100px;">
			</select> 
<!--			<span>Week</span> 
			<select id="week_combobox4" class="easyui-combobox" name="week_combobox4" style="width: 100px;">
			</select> -->
			<a id="viewDashboardLinkBtn2" href="#" class="easyui-linkbutton" onclick="filterGridData2(true)" >View Dashboard </a>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<a id="exportLinkBtn2" class="easyui-linkbutton" href="functional_dashboard_export_data.xls">Export</a>

				
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

		<div id="table_div2" class="table_div2">
			<div class="wrap">
				<table class="head" id="heading_table2">
					<!-- DYNAMICALLY ROWS WILL GENERATE HERE... -->			
				</table>
				<div class="inner_table">
					<table id="table_body2">
						<!-- DYNAMICALLY ROWS WILL GENERATE HERE... -->
					</table>
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
function showTableData2(url) {
        
	document.getElementById("loader_div").style.display = "block";
	var xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
            
		if (xhttp.readyState == 4 && xhttp.status == 200) {
			document.getElementById("loader_div").style.display = "none";
                        
			var ss = JSON.parse(xhttp.responseText);
//                        alertBox(ss);
			loaddata(ss);
		}
	};
	xhttp.open("POST", url, true);
	xhttp.send();
}

function filterGridData2(isloadHeader) {
	var filterLevel="";
        var aggLevel="";
	var validate=true;
	var message="";
 if($('#lga_combobox2').combobox('getValue')===''){
			message=("Filter is Empty");
			validate=false;
		 }
                 else if($('#agg_combobox2').combobox('getValue')===''){
			message=("Level is Empty");
			validate=false;
		 }
                 else{
//                        message=($('#lga_combobox2').combobox('getValue'));
			validate=true;
		}
	if(message!=''){
		alertBox(message);
	}
	if(validate){
		filterLevel = $('#lga_combobox2').combobox('getValue');
		aggLevel = $('#agg_combobox2').combobox('getValue');
		
		var url2 = "get_functional_dashboard_data?filterLevel="+filterLevel+"&aggLevel="+aggLevel;;
		if(isloadHeader){
			loadHeadingTable(filterLevel);				
		}
		showTableData2(url2);
	}
}

$('#lga_combobox2').combobox({
    url : 'get_sclevel_list?userType='+'${userBean.x_ROLE_NAME}',
    valueField : 'value',
    textField : 'label',
    onSelect : function(rec) {
            $('#agg_combobox2').combobox({
                    url : 'get_aggby_list?levelSelected='+rec.value,
                    valueField : 'value',
                    textField : 'label'
            });
    }
});
/* Do not delete below code - IMPORTANT */
$('#lga_combobox2').combobox({});
$('#agg_combobox2').combobox({});
//$('#week_combobox').combobox({});
$('#viewDashboardLinkBtn2').linkbutton({});
$('#exportLinkBtn2').linkbutton({});
</script>
