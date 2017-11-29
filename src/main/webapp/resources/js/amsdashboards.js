Date.prototype.getWeek = function() {
    var onejan = new Date(this.getFullYear(),0,1);
    /*var today = new Date(this.getFullYear(),this.getMonth(),this.getDate());*/
    /*var dayOfYear = ((today - onejan +1)/86400000);*/
    return Math.ceil((((this - onejan) / 86400000)) / 7);
    /*return (dayOfYear/7)*/
};
function getWeekNumber(date){
	if(date instanceof Date){
		return date.getWeek();
	}else{
		return 0;
	}	
}
function getLastWeek(){
    var today = new Date();
    var lastWeek = new Date(today.getFullYear(), today.getMonth(), today.getDate() - 7);
    return lastWeek ;
}

//function filterCCEDashboardData(url, lgaComboBoxId, yearComboBoxId, weekComboBoxId) {
function filterCCEDashboardData(url) {
//	if ($('#'+lgaComboBoxId).combobox('getValue') == "") {alert("LGA is Empty");}
//	else if ($('#'+yearComboBoxId).combobox('getValue') == "") {alert("Year is Empty");} 
//	else if ($('#'+weekComboBoxId).combobox('getValue') == "") {alert("Week is Empty");} 
//	else {
//		var lga_id = $('#'+lgaComboBoxId).combobox('getValue');
//		var year = $('#'+yearComboBoxId).combobox('getValue');
//		var week = $('#'+weekComboBoxId).combobox('getValue');
//		var url2 = url+"?year="+year+"&week="+week+"&lga_id="+lga_id;
                var url2 = url+"?filterLevel=LGA";
		showTableData(url2);
//	}
}

function loaddataHeadTable(data){
	var datacard="<tr>";
	for (var i = 0; i < 7; i++) {
		datacard+="<td>"+data[i].field_header+"</td>";
	}
	datacard+="</tr>";
//        $('#heading_table2').empty();
	document.getElementById("heading_table2").innerHTML=datacard;
}
function loadHeadingTable(filterLevel){
	var xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
		if (xhttp.readyState == 4 && xhttp.status == 200) {
			var ss = JSON.parse(xhttp.responseText);
			loaddataHeadTable(ss);
		}
	};
	xhttp.open("GET", 'getheadingTableForCCEFunctionalDashboard?filterLevel='+filterLevel, true);
	xhttp.send();
}

function loaddata(data) {
	var headingrow = document.getElementById("heading_table2").rows[0].cells;
        var agg = $('#agg_combobox2').combobox('getValue');
        var fac = $('#lga_combobox2').combobox('getValue');
        var singlerow = (fac!=agg)?'SUM OF ALL CCEs IN '+agg+'S':'no';
        fac = (fac==='National')?'STATE':fac;
	var datacard = "";
	for (var i = 0; i < data.length; i++) {
		datacard += "<tr>";
		datacard += "<td>" + ((singlerow==='no')?data[i][fac]:singlerow) + "</td>";
		for (var rowid = 1; rowid < 7; rowid++) {
			$.each(data[i],function(itemName, itemValue) {
				if(itemName==headingrow[rowid].innerHTML){
					var color;
					var stockBal;
					$.each(itemValue,function(label, value) {						
						if(label=='FACIITY_STATUS'){
							stockBal=value;
						}else{
							color=value;
						}
					})
					datacard += "<td style='background-color:"+color+";align:center;'>"
					+ stockBal + "</td>";
				}
			})
		}
		datacard += "</tr>";
	}
	document.getElementById("table_body2").innerHTML = datacard;
        
        
	
}

function loadHeadingMergedTable(filterLevel){
	var xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
		if (xhttp.readyState == 4 && xhttp.status == 200) {
			var ss = JSON.parse(xhttp.responseText);
			loaddataHeadMergedTable(ss);
		}
	};
	xhttp.open("GET", 'getheadingTableForCCEMergedDashboard?filterLevel='+filterLevel, true);
	xhttp.send();
}

function loaddataHeadMergedTable(data){
	var datacard="<tr>";
	for (var i = 0; i < 12; i++) {
		datacard+="<td>"+data[i].field_header+"</td>";
	}
	datacard+="</tr>";
//        $('#heading_table2').empty();
	document.getElementById("heading_merged_table").innerHTML=datacard;
}

function loadmergeddata(data) {
	var headingrow = document.getElementById("heading_merged_table").rows[0].cells;
        var agg = $('#agg_combobox').combobox('getValue');
        var fac = $('#lga_combobox').combobox('getValue');
        var singlerow = ((fac!=agg)&&(data.length==1))?'SUM OF ALL CCEs IN '+agg+'S':'no';
        fac = (fac==='National')?'STATE':fac;
	var datacard = "";
	for (var i = 0; i < data.length; i++) {
		datacard += "<tr>";
		datacard += "<td>" + ((singlerow==='no')?data[i][fac]:singlerow) + "</td>";
		for (var rowid = 1; rowid < 7; rowid++) {
			$.each(data[i],function(itemName, itemValue) {
				if(itemName==headingrow[rowid].innerHTML){
					var color;
					var stockBal;
					$.each(itemValue,function(label, value) {						
						if(label=='FACIITY_STATUS'){
							stockBal=value;
						}else{
							color=value;
						}
					})
					datacard += "<td style='background-color:"+color+";align:center;'>"
					+ stockBal + "</td>";
				}
			})
		}
                for (var rowid = 7; rowid < 12; rowid++) {
			$.each(data[i],function(itemName, itemValue) {
				if(itemName==headingrow[rowid].innerHTML){
					var color;
					var stockBal;
					$.each(itemValue,function(label, value) {						
						if(label=='FACIITY_STATUS'){
							stockBal=value;
						}else{
							color=value;
						}
					})
					datacard += "<td style='background-color:"+color+";align:center;'>"
					+ ((stockBal==="")?"":stockBal+"%")+"</td>";
				}
			})
		}
		datacard += "</tr>";
	}
	document.getElementById("merged_table_body").innerHTML = datacard;
        
        
	
}

function alertBox(message){
    $.messager.alert('Warning!',message,'warning');
}


function loaddataHeadTable4(data){
	var datacard="<tr>";
	for (var i = 0; i < 6; i++) {
		datacard+="<td>"+data[i].field_header+"</td>";
	}
	datacard+="</tr>";
//        $('#heading_table4').empty();
	document.getElementById("heading_table4").innerHTML=datacard;
}
function loadHeadingTable4(filterLevel){
	var xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
		if (xhttp.readyState == 4 && xhttp.status == 200) {
			var ss = JSON.parse(xhttp.responseText);
			loaddataHeadTable4(ss);
		}
	};
	xhttp.open("GET", 'getheadingTableForCCECapacityDashboard?filterLevel='+filterLevel, true);
	xhttp.send();
}
function loaddata4(data) {
	var headingrow = document.getElementById("heading_table4").rows[0].cells;
        var agg = $('#agg_combobox4').combobox('getValue');
        var fac = $('#lga_combobox4').combobox('getValue');
        var singlerow = ((fac!=agg)&&(data.length==1))?'SUM OF ALL CCEs IN '+agg+'S':'no';
        fac = (fac==='National')?'STATE':fac;
	var datacard = "";
	for (var i = 0; i < data.length; i++) {
		datacard += "<tr>";
		datacard += "<td>" + ((singlerow==='no')?data[i][fac]:singlerow) + "</td>";
		for (var rowid = 1; rowid < 6; rowid++) {
			$.each(data[i],function(itemName, itemValue) {
				if(itemName==headingrow[rowid].innerHTML){
					var color;
					var stockBal;
					$.each(itemValue,function(label, value) {						
						if(label=='FACIITY_CAPACITY'){
							stockBal=value;
						}else{
							color=value;
						}
					})
					datacard += "<td style='background-color:"+color+";align:center;'>"
					+ ((stockBal==="")?"":stockBal+"%")+"</td>";
				}
			})
		}
		datacard += "</tr>";
	}
        $('#table_body4').html("");
        console.log(datacard);
	document.getElementById("table_body4").innerHTML = datacard;
}
function showTableData4(url) {
	document.getElementById("loader_div").style.display = "block";
         
	var xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
		if (xhttp.readyState == 4 && xhttp.status == 200) {
			document.getElementById("loader_div").style.display = "none";
			var ss = JSON.parse(xhttp.responseText);
			loaddata4(ss);
		}
	};
	xhttp.open("GET", url, true);
	xhttp.send();
}
