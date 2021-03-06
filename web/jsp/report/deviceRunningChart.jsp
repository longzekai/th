<%@page import="th.util.DateUtil"%>
<%@page import="th.dao.OrgDealDAO"%>
<%@ page contentType="text/html; charset=utf-8" language="java" pageEncoding="UTF-8"
	import="java.sql.*" errorPage=""%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="copyright" content="Copyright(c) 天和. All Rights Reserved." />
	<link rel="stylesheet" type="text/css"
		href="<%=request.getContextPath()%>/css/channel.css" />
		<link rel="stylesheet" type="text/css"
		href="<%=request.getContextPath()%>/css/jquery.jqplot.css" />
	<link rel="stylesheet" href="../../zTree/css/demo.css" type="text/css" />
		<link rel="stylesheet"
			href="../../zTree/css/zTreeStyle/zTreeStyle.css" type="text/css" />
			<script type="text/javascript"
				src="../../zTree/js/jquery-1.4.4.min.js"></script>
			<script type="text/javascript"
				src="../../zTree/js/jquery.ztree.core-3.5.js"></script>
			<script type="text/javascript"
				src="../../zTree/js/jquery.ztree.excheck-3.5.js"></script>
			<script type="text/javascript"
				src="<%=request.getContextPath()%>/js/Calendar.js"></script>
			<script type="text/javascript"
				src="<%=request.getContextPath()%>/js/jquery.jqplot.js">
				</script><script type="text/javascript" src="<%=request.getContextPath()%>/js/jqplot.barRenderer.js"></script>
				<script type="text/javascript" src="<%=request.getContextPath()%>/js/jqplot.categoryAxisRenderer.js"></script>
				<script type="text/javascript" src="<%=request.getContextPath()%>/js/jqplot.pointLabels.js"></script>
				<script type="text/javascript" src="<%=request.getContextPath()%>/js/excanvas.js"></script>
				<script type="text/javascript" src="<%=request.getContextPath()%>/js/jqplot.highlighter.js"></script>
				<script type="text/javascript" src="<%=request.getContextPath()%>/js/jqplot.cursor.js"></script>
				<script type="text/javascript" src="<%=request.getContextPath()%>/js/jqplot.dateAxisRenderer.js"></script>
			<%@ page import="th.entity.OrganizationBean"%>
			<%@ page import="th.com.util.Define"%>
			<%@ page import="java.util.*"%>
			<%@ page import="th.user.*"%>
			<%@ page import="org.apache.commons.logging.Log"%>
			<%@ page import="org.apache.commons.logging.LogFactory"%>
			<%
				Log logger = LogFactory.getLog(this.getClass());
				User user = (User) session.getAttribute("user_info");
				String realname =null;
				if (user == null) {
				     response.setContentType("text/html; charset=utf-8");
				     response.sendRedirect("/th/index.jsp");
				} else {
				    realname = user.getReal_name();
				    logger.info("获得当前用户的用户名，用户名是： " + realname);
				}
			%>
<style type="text/css">
</style>
<script type="text/javascript">
   var oCalendarChs=new PopupCalendar("oCalendarChs"); //初始化控件时,请给出实例名称:oCalendarChs
        oCalendarChs.weekDaySting=new Array("星期日","星期一","星期二","星期三","星期四","星期五","星期六");
        oCalendarChs.monthSting=new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");
        oCalendarChs.oBtnTodayTitle="今天";
        oCalendarChs.oBtnCancelTitle="取消";
        oCalendarChs.Init();
  function onFold(id){
    var vDiv = document.getElementById(id);
	vDiv.style.display = (vDiv.style.display == 'none')?'block':'none';
	var fold = document.getElementById('clientStyleId'); 
	if(vDiv.style.display === 'none'){ 
		fold.className = 'x-fold-plus';
	}else{
		fold.className = 'x-fold-minus';
	}
  }
  
	//组织结构下拉菜单
	var setting = {
	            view: {  
	                dblClickExpand: false  
	            },  
	            data: {  
	                simpleData: {  
	                    enable: true  
	                }  
	            },  
	            callback: {  
	                //beforeClick: beforeClick,//(点击之前)用于捕获 勾选 或 取消勾选 之前的事件回调函数，并且根据返回值确定是否允许 勾选 或 取消勾选   
	                onClick: onClick  
	            }  
	};  
	var zNodes = <%=(String) request.getAttribute( "MONITOR_ORG_LIST" )%> ;

  $(document).ready(function() {
	  <%
	  	String chartType = (String)request.getAttribute("chartType");
	  	String dataType = (String)request.getAttribute("dataType");
	  	String selectedOrgId = (String)request.getAttribute("selectedOrg");
   		String timeType = (String)request.getAttribute("timeType");
   		String time = (String)request.getAttribute("selectTime");
   		String orgname = "";
   		String showStr = "";
	  %>
	  <%if(selectedOrgId != null) {
	  	OrgDealDAO oDao = new OrgDealDAO();
	  	HashMap[] a = oDao.getCurOrgNodeByOrgId(Long.parseLong(selectedOrgId));
	  	orgname = (String)a[0].get("ORG_NAME");
	  	if(dataType !=null&&dataType.equals("1")){
	  		showStr = "开机率－"+orgname;
	  	}else if(dataType !=null&&dataType.equals("2")){
	  		showStr = "频道使用率－"+orgname;
	  	}
	  %>
	  	$('#SelectOrg').val(<%=selectedOrgId%>);
	  <%}%>
	  <%if(time == null) {
	  	String defaultTime = DateUtil.getYesterdayDate("yyyyMMdd");
	  %>
	  	$('#selectedDateId').val(formatDate2(<%=defaultTime%>));
	  <%}%>
	  <%if(time != null) {%>
	  	$('#selectedDateId').val(formatDate2(<%=time%>));
	  <%}%>
	  <%if(timeType == null) {%>
	  	$('#withMonth').attr('checked',true);
	   <%}else{%>
		<%if(timeType != null&&timeType.equals("1"))	{    %>
			$('#chart1').css('width','2500px');
		  	$('#withMonth').attr('checked',true);
		<%}%>
  		<%if(timeType != null&&timeType.equals("2"))	{    %>
	  		$('#withYear').attr('checked',true);
		<%}%>
	  <%}%>
	  
	  <%if(selectedOrgId != null) {%>
	  	$('#SelectOrg').val(<%=selectedOrgId%>);
	  <%}%>
	  <%if(dataType ==null) {%>
	  	$('#workingRate').attr('checked',true);
	 	$('#chartTypeLabelId').html('柱形图');
	  <%}else{%>
		<%if(dataType !=null&&dataType.equals("1"))	{    %>
		  	$('#workingRate').attr('checked',true);
			 	$('#chartTypeLabelId').html('柱形图');
		<%}%>
  		<%if(dataType !=null&&dataType.equals("2"))	{    %>
	  		$('#channelUsing').attr('checked',true);
			$('#chartTypeLabelId').html('线形图');
		<%}%>
	  <%}%>
	  var showString ="<%=showStr%>";
	  //柱状图
	  <%if(null !=chartType&& chartType.equals("1")) {%>
	  
	  	<%
		  	List totalRate = (List)request.getAttribute("total_running_rate");
	   		List normalRate = (List)request.getAttribute("normal_runing_rate");
	   		List listTimes = (List)request.getAttribute("list_time");
	  	%>
	  	var s1 = new Array();
	    var s2 = new Array();
	    var s3 = new Array();
		<%if(totalRate !=null&&normalRate!=null&&listTimes!=null) {%>
		    <% for(int i=0;i<totalRate.size();i++){%>
		    	s1[<%=i%>]= formatLabel(<%=totalRate.get(i)%>);
		    <%}%>
		    <% for(int i=0;i<normalRate.size();i++){%>
	    		s2[<%=i%>]= formatLabel(<%=normalRate.get(i)%>);
		    <%}%>
		    <% for(int i=0;i<listTimes.size();i++){%>
			s3[<%=i%>]= formatDate(<%=listTimes.get(i)%>);
	    	<%}%>
	    <%}%>
	    // Can specify a custom tick Array.
	    // Ticks should match up one for each y value (category) in the series.
	    var ticks = ['0','0.5','1','1.3'];
	     
	    var plot1 = $.jqplot('chart1', [s1, s2], {
	        // The "seriesDefaults" option is an options object that will
	        // be applied to all series in the chart.
	        seriesDefaults:{
	            renderer:$.jqplot.BarRenderer,
	            rendererOptions: {fillToZero: true
	            },
	            pointLabels: { show:true } 
	        },

            axesDefaults: {
                tickRenderer: $.jqplot.CanvasAxisTickRenderer ,
                tickOptions: {
                  fontSize: '10pt',
                  angle: '-100'
                }
            },
	        // Custom labels for the series are specified with the "label"
	        // option on the series option.  Here a series option object
	        // is specified for each series.
	        series:[
	            {label:'开机率'},
	            {label:'正常使用率'},
	            
	        ],
	        // Show the legend and put it outside the grid, but inside the
	        // plot container, shrinking the grid to accomodate the legend.
	        // A value of "outside" would not shrink the grid and allow
	        // the legend to overflow the container.
	        legend: {
	            show: true,
	            placement: 'outsideGrid'
	        },
	        axes: {
	            // Use a category axis on the x axis and use our custom ticks.
	            xaxis: {
	                renderer: $.jqplot.CategoryAxisRenderer,
	                ticks: s3,
	                tickOptions:{formatString:'%Y/%#m/%#d'} ,
	                label: showString,
	            	labelOptions: {
	                    fontFamily: 'Helvetica',
	                    fontSize: '14pt'
	                  }
	            },
	            // Pad the y axis just a little so bars can get close to, but
	            // not touch, the grid boundaries.  1.2 is the default padding.
	            yaxis: {
	                ticks:ticks,
	                tickOptions: {formatString: '%d'},
	            	label: "开机率",
	            	labelOptions: {
	                    fontFamily: 'Georgia, Serif',
	                    fontSize: '12pt'
	                  }
	            }
	        }
	    });
	  <%}%>

	  //线状图
	  <%if(null !=chartType&&chartType.equals("2")) {%>
	  
	  	<%
	  		List requestTimes = (List)request.getAttribute("channel_request_times");
		%>
	 <%if(null !=requestTimes&&requestTimes.size()>0) {%>
	  	var line = new Array();
	  	<% for(int i=0;i<requestTimes.size();i++){%>
	  		var subList = new Array();
	  		<% List subC = (List)requestTimes.get(i);%>
		  		subList[0] =formatDate( <%=(String)subC.get(0)%>);
		  		subList[1] =<%=subC.get(1)%>
		  		line[<%=i%>] = subList;
    	
   	 	<%}%>
   	 	
	  var line1=[['2008-01-30', 578.55]];
	         var plot1 = $.jqplot('chart1', [line], {
	             //title:'Data Point Highlighting',
	             axes:{
	               xaxis:{
		                renderer: $.jqplot.CategoryAxisRenderer,
		                tickOptions:{formatString:'%Y/%#m/%#d'} ,
		                 label: showString,
		            	labelOptions: {
		                    fontFamily: 'Helvetica',
		                    fontSize: '14pt'
		                  }
	               },
	               yaxis:{
		                 tickOptions:{
		                   formatString:'%d'
		                   },
		            	label: "频道使用率 (次)",
		            	labelOptions: {
		                    fontFamily: 'Georgia, Serif',
		                    fontSize: '12pt'
		                  }
	               }
	             },
	             axesDefaults: {
	                 tickRenderer: $.jqplot.CanvasAxisTickRenderer ,
	                 tickOptions: {
	                   fontSize: '10pt',
	                   angle: '-100'
	                 }
	             },
	             seriesDefaults: { 
	                 showMarker:false,
	                 pointLabels: { show:true, edgeTolerance: -25} 
	               },
	             highlighter: {
	               show: true,
	               sizeAdjust: 7.5
	             },
	             cursor: {
	               show: false
	             }
	         });
	  <%}%>
	  <%}%>
	  function formatDate(str){
		  var s = str.toString();
		  var year = s.substring(0,4);
		  if(year==''){
			  return year;
		  }
		  var month = s.substring(4,6);
		  if(month ==''){
			  return year;
		  }
		  var day = s.substring(6,8);
		  if(day ==''){
			  return year+"/"+month;
		  }
		  return year+"/"+month+"/"+day;
	  }
	  function formatDate2(str){
		  var s = str.toString();
		  var year = s.substring(0,4);
		  if(year==''){
			  return year;
		  }
		  var month = s.substring(4,6);
		  if(month ==''){
			  return year;
		  }
		  var day = s.substring(6,8);
		  if(day ==''){
			  return year+"-"+month;
		  }
		  return year+"-"+month+"-"+day;
	  }
	  function formatLabel(str){
		  var formatStr = str.toString();
		  var pointIndex = formatStr.indexOf('.');
		  var endIndex =pointIndex+3; 
		  return formatStr.substring(0,endIndex);
	  }
	  $('#workingRate').change(function(){
		  var dataType = $('input[@name="dataTypeRadio"][checked]').val();
		  //开机率统计
		  if(dataType=='1'){
			  $('#chartTypeLabelId').html('柱形图');
		  }
		  //频道使用率统计
		  if(dataType=='2'){
			  $('#chartTypeLabelId').html('线形图');
		  }
	  });
	  $('#channelUsing').change(function(){
		  var dataType = $('input[@name="dataTypeRadio"][checked]').val();
		  //开机率统计
		  if(dataType=='1'){
			  $('#chartTypeLabelId').html('柱形图');
		  }
		  //频道使用率统计
		  if(dataType=='2'){
			  $('#chartTypeLabelId').html('线形图');
		  }
	  });
	  
	  $('#searchdata').click(function(){
		  //图表类型
		  var chartType = $('#chartTypeLabelId').html();
		  if(chartType == '柱形图'){
			  $('#chartTypeId').val('1');
		  }else if(chartType =='线形图'){
			  $('#chartTypeId').val('2');
		  }
		  //组织选择
		  var selectOrg = $('#SelectOrg').val();
		  //时间类型
		  var selectedTimeType1 = $('#withMonth').attr('checked');
		  var selectedTimeType2 = $('#withYear').attr('checked');
		  if(selectedTimeType1 ==true){
			  $('#timeTypeId').val('1');
		  }else{
			  $('#timeTypeId').val('2');
		  }
		  //考核指标
		  var dataType = $('input[@name="dataTypeRadio"][checked]').val();
		  //时间
		  var time = $('#selectedDateId').val();
		  if(time ==''){
			  alert('请选择时间');
			  return;
		  }
		  $('#dataTypeId').val(dataType);
		  $('#selectedOrgId').val(selectOrg);
		  $('#timeId').val(time);
		  $('#typeId').val('runningChart');
		  $('form').attr('action','clientUseInfo.html');
		  $('form').submit();
		  
	  });
		zTreeObj = $.fn.zTree.init($("#treeDemo"), setting, zNodes);
		
		var nodes = zTreeObj.transformToArray(zTreeObj.getNodes());
		var v = "", w = "";
		// 设置组织名称下拉列表值 
		var orgList = document.getElementById("SelectOrg");
		for (var i=0; i<nodes.length; i++) {
			w = "";
			if(i<nodes.length-1){
				for(var j=0; j<(nodes[i].level-nodes[0].level); j++){
					w += "├─";					
				}
			}else{
				for(var j=0; j<(nodes[i].level-nodes[0].level); j++){
					w += "└─";
				}
			}
			// 为select下拉菜单动态赋予option值 
			orgList.options.add(new Option(w+nodes[i].name,nodes[i].id));
			// 组织List信息拼接  
			v += w + nodes[i].name + "_" + nodes[i].id;
			if(i<nodes.length-1){
				v += ",";
			}
		}
	});
  function onClick(e, treeId, treeNode) {  
      var zTree = $.fn.zTree.getZTreeObj("treeDemo"),  
      nodes = zTree.getSelectedNodes(),//获取 zTree 当前被选中的节点数据集合（按Ctrl多选择）  
      v = "";
      var nid = "";
      nodes.sort(function compare(a,b){return a.id-b.id;});//按照id从小到大进行排序  
      for (var i=0, l=nodes.length; i<l; i++) {  
          v += nodes[i].name + ",";  
          nid = nodes[i].id;
      }  
      if (v.length > 0 ) v = v.substring(0, v.length-1);  
      var cityObj = $("#citySel");  
      cityObj.attr("value", v);//设置文本框的值  
      
      //选中一个节点后关闭div
      hideMenu();
      //alert(nid);
      window.document.form_data.orderType.value ="2";
  	window.document.form_data.pageID.value ="<%=Define.JSP_MONITOR_CLIENT_RUNNING_ID%>";
  	window.document.form_data.orgID.value = nid;
      window.document.form_data.action = "<%=Define.MONITOR_SERVLET%>";
      window.document.form_data.target = "_self";
      window.document.form_data.submit();
  } 
</script>
			<title>设备考核趋势图</title>
</head>
<body>
	<div style="margin-left: 4px;">
		<div class="x-title">
			<span>&nbsp;&nbsp;报表管理-设备考核趋势图</span>
		</div>
		<table><tr style ="heigt:30px"></tr></table>
		<form class="x-client-form" id="clientUseForm">
			<input type="hidden" name="selectedOrg" id="selectedOrgId" /> 
			<input type="hidden" name="dataType" id="dataTypeId" /> 
			<input type="hidden" name="chartType" id="chartTypeId" /> 
			<input type="hidden" name="timeType" id="timeTypeId" /> 
			<input type="hidden" name="selectTime" id="timeId" /> 
			<input type="hidden" name="type" id="typeId" />
			<div class="x-title">
				<div id="clientStyleId" class="x-fold-minus"
					onclick="onFold('clientId');" />
			</div>
			<div style="height: 26px; text-align: left; line-height: 26px">检索</div>
			</div>
			<div id="clientId" style="background-color: #B2DFEE">
				<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td width="68" style="border: 0;padding-left: 5px;">组&nbsp;&nbsp;&nbsp;织：</td>
						<td width="278" style="border-right:0px solid #B2DFEE;text-align: left">
							<div>
								<select id="SelectOrg" name="selectOrgName"
									style="border: 1px solid #737C73;" id="selectOrgId"></select>&nbsp;&nbsp;&nbsp;&nbsp;
							</div>
					 	</td>
					  	<td width="88" style="border: 0;padding-left: 5px;"> 考核指标：</td>
						<td width="278" style="border-right:0px solid #B2DFEE;">
							<label> <input type="radio" name="dataTypeRadio" id="workingRate"  value="1" />开机率&nbsp;&nbsp;</label>
							 <label> <input type="radio"  name="dataTypeRadio" id="channelUsing"  value="2" />频道使用&nbsp;&nbsp;</label>
						</td>
						<td width="88" style="border: 0; text-align: left;padding-left: 5px;">图表类型：</td>
						<td width="278" style="border: 0; text-align: left">
							<label id="chartTypeLabelId"></label>
						</td>
					</tr>
					<tr>
						<td style="border: 0;padding-left: 5px;"> 时&nbsp;&nbsp;&nbsp;间：</td>
						<td style="border-right:0px solid white;text-align: left">
							<label> <input type="radio" name="timeRadio" id="withMonth" value="1"/>月度&nbsp;&nbsp;</label>
							<label> <input type="radio" id="withYear" name="timeRadio" value="2" />年度&nbsp;&nbsp;</label>
						</td>
							
						<td style="border: 0;padding-left: 5px;">时间选择：</td>
						<td style="border-right:0px solid white;text-align: left">
						<input type="text" size="10" name="selectedDate"
							id="selectedDateId"
							onclick="getDateString(this,oCalendarChs)" />
						</td>
						
						<td colspan="2" style="padding-left: 5px;"><input id="searchdata" type="button" value="检索" class="x-button"/></td>
					</tr>
				</table>
				
			</div>
			<div style="padding-left: 20px;padding-right: 40px;padding-top: 50px;padding-bottom:50; overflow:auto;scrollBar-hightLight-color: green;height: 400px;">
				<div id="chart1" style="z-index:-1;position: relative;" >
			</div>
				
			</div>
		</form>
	</div>
</body>
</html>
