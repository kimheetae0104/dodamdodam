<%@page import="org.springframework.context.annotation.Import"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="today" value="<%=new java.util.Date()%>" />
<!-- 현재날짜 -->
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="date"><fmt:formatDate value="${today}" pattern="yyyy-MM-dd" /></c:set> 
<c:set var="path" value="${pageContext.request.contextPath}"/>
<html>
<head>
    <meta charset="UTF-8" />
    <title>2021 MINI HOMEPAGE</title>
    <script src="${path}/resources/static/code/highcharts.js"></script>
	<script src="${path}/resources/static/code/modules/wordcloud.js"></script>
	<script src="${path}/resources/static/code/modules/exporting.js"></script>
	<script src="${path}/resources/static/code/modules/export-data.js"></script>
	<script src="${path}/resources/static/code/modules/accessibility.js"></script>
    <link rel="stylesheet" href="${path}/resources/static/font.css" />
    <link rel="stylesheet" href="${path}/resources/static/layout.css" />
    <link rel="stylesheet" href="${path}/resources/static/home.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com"/>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com"/>
    <link
      href="https://fonts.googleapis.com/css2?family=Dongle:wght@400;700&display=swap"
      rel="stylesheet"
    />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com"  />
    <link
      href="https://fonts.googleapis.com/css2?family=Dongle:wght@400;700&family=Poor+Story&family=Single+Day&display=swap"
      rel="stylesheet"
    />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com"  />
    <link
      href="https://fonts.googleapis.com/css2?family=Dongle:wght@400;700&family=Single+Day&display=swap"
      rel="stylesheet"
    />
    <title>Document</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
 	<link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.10.2/main.min.css' rel='stylesheet' />
	<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.10.2/main.min.js'></script>
	<script src="https://code.highcharts.com/highcharts.js"></script>
    <script src='${path}/resources/static/ko.js'></script> <!-- 캘린더 -->
    <script>
	    
      document.addEventListener('DOMContentLoaded', function() {
    	    var calendarEl = document.getElementById('calendar');
			
    	    $.ajax({
	            url: 'diarySelect.do',
	            type : 'post',
	            dataType: 'json',
	            success: loadDiary,
				error : function(e){
					console.log(e);
				}
	     }); //ajax end
    	    
    	    function loadDiary(diary){

				console.log('에이젝스 받아와짐')
           var events = [];
          
           if(diary!=null){
        	   
        	   var todayWord = "일기를 작성해주세요"
     	    	  $.each(diary, function(index, vo) {
     	    		  
     					 if('${date}' == vo.d_date){
     						todayWord = vo.d_content;
     					 }
     	          }); //.each()
               		
     	    	   var text = todayWord,
     	    	    lines = text.split(/[,\. ]+/g),
     	    	    data = lines.reduce((arr, word) => {
     	    	        let obj = Highcharts.find(arr, obj => obj.name === word);
     	    	        if (obj) {
     	    	            obj.weight += 1;
     	    	        } else {
     	    	            obj = {
     	    	                name: word,
     	    	                weight: 1
     	    	            };
     	    	            arr.push(obj);
     	    	        }
     	    	        return arr;
     	    	    }, []);
     		
     		    	Highcharts.chart('container', {
     		    	    accessibility: {
     		    	        screenReaderSection: {
     		    	            beforeChartFormat: '<h5>{chartTitle}</h5>' +
     		    	                '<div>{chartSubtitle}</div>' +
     		    	                '<div>{chartLongdesc}</div>' +
     		    	                '<div>{viewTableButton}</div>'
     		    	        }
     		    	    },
     		    	    series: [{
     		    	        type: 'wordcloud',
     		    	        data,
     		    	        name: 'Occurrences'
     		    	    }],
     		    	    title: {
     		    	        text: '이러한 단어를 많이 사용하셨어요.'
     		    	    }
     		    	});
        	   
               
                   $.each(diary, function(index, vo) {
                    
                        events.push({
                               id:index,
                               title: '작성 완료♥',
                               start: vo.d_date,
                               color: '#000000'
                            }); //.push()
               console.log(vo.d_date);
               }); //.each()
               
               console.log(events);
               
    	    var calendar = new FullCalendar.Calendar(calendarEl, {
    	      selectable: true,
    	      locale: 'ko',
    	      timeZone: 'UTC',
    	      events : events,
    	      dateClick: function(info) {
    	        console.log(info.dateStr);
    			$('#diaryDate').val(info.dateStr)
    			$("#popUp").show();
    			$("#calendar").css('opacity', '0');
    			$("#close").on("click", function () {
    				$("#popUp").hide();
    				$("#calendar").css('opacity', '1');
    				$('#diaryTitle').val('');
					$('#diaryContent').val('');
					$('#childMSG').val('');
					$('#counter').html("(0 / 최대 3000자)");  
					
				})
				
				
				$.each(diary, function(index, vo) {
					 if(info.dateStr == vo.d_date){
						$('#diaryTitle').val(vo.d_title);
						$('#diaryContent').val(vo.d_content);
						$('#childMSG').val(vo.d_msg);

			     	    	  $.each(diary, function(index, vo) {
			     	    		  
			     					 if(info.dateStr == vo.d_date){
			     						todayWord = vo.d_content;
			     					 }
			     	          }); //.each()
						
						 var text = todayWord,
		     	    	    lines = text.split(/[,\. ]+/g),
		     	    	    data = lines.reduce((arr, word) => {
		     	    	        let obj = Highcharts.find(arr, obj => obj.name === word);
		     	    	        if (obj) {
		     	    	            obj.weight += 1;
		     	    	        } else {
		     	    	            obj = {
		     	    	                name: word,
		     	    	                weight: 1
		     	    	            };
		     	    	            arr.push(obj);
		     	    	        }
		     	    	        return arr;
		     	    	    }, []);
		     		
		     		    	Highcharts.chart('container', {
		     		    	    accessibility: {
		     		    	        screenReaderSection: {
		     		    	            beforeChartFormat: '<h5>{chartTitle}</h5>' +
		     		    	                '<div>{chartSubtitle}</div>' +
		     		    	                '<div>{chartLongdesc}</div>' +
		     		    	                '<div>{viewTableButton}</div>'
		     		    	        }
		     		    	    },
		     		    	    series: [{
		     		    	        type: 'wordcloud',
		     		    	        data,
		     		    	        name: 'Occurrences'
		     		    	    }],
		     		    	    title: {
		     		    	        text: '이러한 단어를 많이 사용하셨어요.'
		     		    	    }
		     		    	});
						
					 }
               }); //.each()
				
				
				
    	      }
    	    });
    	    calendar.render();
    	    
    	    
           }//if end      
      }
      //막대 그래프 추가
      Highcharts.chart('container2', {
          chart: {
              type: 'column'
          },
          title: {
              text: '감정분석 결과'
          },
          xAxis: {
              categories: ['오늘', '1일전', '2일전', '3일전','4일전']
          },
          yAxis: {
              min: 0,
              title: {
                  text: ''
              }
          },
          tooltip: {
              pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b> ({point.percentage:.0f}%)<br/>',
              shared: true
          },
          plotOptions: {
              column: {
                  stacking: 'percent'
              }
          },
          series: [{
              name: '기쁨',
              data: [1, 3, 4, 7, 2]
          }, {
              name: '분노',
              data: [3, 2, 3, 2, 1]
          }, {
              name: '슬픔',
              data: [3, 4, 4, 2, 5]
          },{
              name: '불안',
              data: [3, 4, 4, 2, 5]
          }]
      });
    	  });
      
    </script>
    
    <style type="text/css">
    	#calendar{
	    	position : relative;
	    	float : left;
    		width : 60%;
    		height : 90%;
    	}
    	.fc-toolbar-title{
    		color : #000;
    		 font-family: 'Single Day', cursive;
          font-size: 35px;
    		
    	}
    	  .fc-scrollgrid-sync-inner{
       background-color: #FAFAD2;
       font-family: 'Single Day', cursive;
       font-size: 20px;
       }
    	  .fc-event-title-container{
       margin-left:20px;
       box-sizing: content-box;
        color: #FAFAD2;
       }
       .fc-daygrid-day-top{
       margin-bottom: 5px;
       }
    	.fc-daygrid-day-frame{
    	background-color:white;
    		cursor: pointer;
    	}
    	#diary{
    		display : none;
    		width : 60%;
    		height : 110%;
    		box-sizing: content-box;
    		overflow: hidden;
    		margin : 0;
    	}
    	.miniroom_contents{
    	overflow : hidden;
    	box-sizing: content-box;
    	}
    	.notes {
        background-attachment: local;
        background-image: linear-gradient(
            to right,
            white 10px,
            transparent 10px
          ),
          linear-gradient(to left, white 10px, transparent 10px),
          repeating-linear-gradient(
            rgb(255, 255, 233),
            white 30px,
            rgb(83, 83, 83) 30px,
            rgb(76, 76, 76) 31px,
            white 31px
          );
        line-height: 31px;
	    }
	    #popUp{
	    	position:absolute;
	        width: 764.59px;
	        height: 100%;
	        background-color: blanchedalmond;
	        display : none;
	        z-index: 99;
	    }
	    #popUpHead{
	        text-align: center;
	    }
	    #popUp strong{
	        font-size: larger; font-family: 'Single Day', cursive
	    }
	    #popUp button{
	        background-color: rgb(255, 255, 233);
	        font-family: 'Single Day', cursive;
	        font-size: 20px;
	        margin-top: 80px;
	        width: 100px;
	        height: 40px;
	        cursor: pointer;
	    }
	    #childMSG{
	        width: 758px;
	          height: 70px;
	          resize: none;
	          background-color: rgb(255, 255, 233);
	          font-size: 27px;
	          font-family: 'Dongle', sans-serif;
	    }
	    #diaryContent{
	        border-style: none;
	        width: 758px;
	        height: 250px;
	        resize: none;
	        background-color: rgb(255, 255, 233);
	        font-size: 24px;
	        font-family: 'Poor Story', cursive;
	        padding-left : 2px;
	    }
	    #diarySelect{
	        background-color: rgb(255, 255, 233);
	        font-family: 'Single Day', cursive;
	        font-size: 20px;
	        width: 90px;
	    }
	    #diaryDate{
	        background-color: rgb(255, 255, 233);
	        width: 200px;
	        height: 40px;
	        font-size: 20px;
	        font-family: 'Dongle', sans-serif;
	        font-size : 30px;
	    }
	    #diaryTitle{
	        background-color: rgb(255, 255, 233);
	        width: 500px;
	        height: 40px;
	        font-size: 35px;
	        font-family: 'Dongle', sans-serif;
	    }
	    .diaryFont{
	    	font-size: larger; font-family: 'Single Day', cursive; color : #000;
	    }
	    
	    .highcharts-figure,
		.highcharts-data-table table {
			position : relative;
			float : right;
			top : 45%;
		  	width : 40%;
		    margin: 1em auto;
		}
		
		.highcharts-data-table table {
		    font-family: Verdana, sans-serif;
		    border-collapse: collapse;
		    border: 1px solid #ebebeb;
		    margin: 10px auto;
		    text-align: center;
		    width: 100%;
		    max-width: 500px;
		}
		
		.highcharts-data-table caption {
		    padding: 1em 0;
		    font-size: 1.2em;
		    color: #555;
		}
		
		.highcharts-data-table th {
		    font-weight: 600;
		    padding: 0.5em;
		}
		
		.highcharts-data-table td,
		.highcharts-data-table th,
		.highcharts-data-table caption {
		    padding: 0.5em;
		}
		
		.highcharts-data-table thead tr,
		.highcharts-data-table tr:nth-child(even) {
		    background: #f8f8f8;
		}
		
		.highcharts-data-table tr:hover {
		    background: #f1f7ff;
		}
	    .sideform_main{
	    	border-radius : 5%;
	    	width : 300px;
	    	height: 459px;
	    }
	    .highcharts-figure2 {
		    position : absolute;
			top : -1%;
			left : 60%;
		  	width : 40%;
		    margin: 1em auto;
		}	
	    
    </style>
  </head>
  <body>
  <div class="logo_main">
    <img src="${path}/resources/static/images/도담도담 갈색버전.png" width="200px" />
   </div>
   <div class="name_main">
    <img src="${path}/resources/static/images/도담도담 로고.png" width="250px" />
  </div>

    
    <div class="bookcover">
      <div class="bookdot">
        <div class="page">
          <div class="home">
            <div class="upside">
              <br /><strong
                >&emsp;&emsp;&emsp; <span style="color: coral"></span> 
              </strong>
              &emsp;&emsp;&emsp; &emsp;
              <span class="title"></span>
              &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
            </div>
            <div class="home_main">
              <div class="home_contents">

                <div class="miniroom_contents">
                	  <div id = "popUp">
                	<form action="http://127.0.0.1:7000/post2" method="post">
                		<input type = "hidden" value = "admin" name="m_id">
					      <div id = "popUpHead">
					        <br>
					        <strong class="diaryFont">일기 제목 :
					        </strong>
					        <input
					          spellcheck="false"  
					          type="text"
					          name="d_title"
					          id="diaryTitle"
					        />
					        &emsp;&emsp;&emsp;
					        <br />
					        <br />
					        <strong class="diaryFont">날짜 :
					        </strong>
					        <input
					          type="date"
					          id="diaryDate"
					          name = "d_date"
					        />
					        &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
					        <strong class="diaryFont">
					          나의 아이들
					          <select
					            name="c_seq"
					            id = "diarySelect">
					            <c:forEach var = "vo" items = "${childList }">
						            <option value="${vo.c_seq }">${vo.c_name }</option>
					            </c:forEach>
					          </select>
					        </strong>
					      </div>
					      <br /><br />
					      <div style="text-align: center">
					        <strong class="diaryFont">
					          일기 내용 (3000자 이내)</strong>
					      </div>
					      <br />
					      <textarea spellcheck="false"
					        id="diaryContent"
					        class="notes"
					        rows="30"
					        cols="100"
					        name="d_content"
					      ></textarea>
					      
						  <span style="color:#aaa;" id="counter">(0 / 최대 3000자)</span>
						
					      <br><br>
					      <div style="text-align: center">
					        <strong class="diaryFont">
					          아이에게 해주고 싶은 말</strong>
					      </div>
					      <br />
					      <textarea id = "childMSG"
					        spellcheck="false"
					        rows="5"
					        cols="100"
					        name="d_msg"
					      ></textarea>
					      <br>
					      <div id = "diarySubmit"class="button" style="text-align: center">
					        <button type="submit">
					          작성
					        </button>
					        &emsp;
					        <button type="button" id = "close">
					          닫기
					        </button>
					      </div>
					      </form>
					    </div>
                	 <div id='calendar'></div>
	                	 <figure class="highcharts-figure2">
					        <div id="container2"></div>
					    </figure>
						<figure class="highcharts-figure">
						    <div id="container"></div>
						</figure>
                </div>
              </div>
            </div>
          </div>
          <div class="menu_bar">
            <a href="./home.do" class="menu_button1">&nbsp;&nbsp;홈</a>
            <a href="./diary.do" class="menu_button2">&nbsp;&nbsp;육아일기</a>
            <a href="./photo.do" class="menu_button3">&nbsp;&nbsp;사진첩</a>
            <a href="./board.do" class="menu_button4">&nbsp;&nbsp;게시판</a>
            <a href="./diary2.do" class="menu_button4">&nbsp;&nbsp;육아수첩</a>
            <a href="./info.do" class="menu_button4"
              >&nbsp;&nbsp;육아 정보</a
            >
            <a href="./video.html" class="menu_button4"
              >&nbsp;&nbsp;교육용 컨텐츠</a
            >
          </div>
        </div>
      </div>
    </div>
    <div class="sideform_main" style="background-color: #d5d5d5">
      <img src="${path}/resources/static/images/unnamed.jpg" width="225px" />
      <a
        style="
          font-style: inherit;
          font-size: 15px;
          color: black;
          font-weight: bold;
          margin: auto;
          text-align: center;
          font-family: 'Poor Story', cursive;
        "
        >-----오늘은 사랑스러운 aaa와-----</a
      >
      <a
        style="
          font-style: inherit;
          font-size: 15px;
          color: black;
          font-weight: bold;
          margin: auto;
          text-align: center;
          font-family: 'Poor Story', cursive;
        "
        >--------nnnn일 째입니다--------
        </a>
      <button type="button" class="btn_main1" style="background-color: #f8e4d9; font-family:'Poor Story', cursive; font-size:larger; color: rgb(15, 15, 13); margin-left: 30px; margin-top: 10px;">로그인</button
        >&emsp;<button type="button" class="btn_main2" style="background-color:  #f8e4d9;  font-family:'Poor Story', cursive; font-size:larger;color: rgb(15, 15, 13); margin-left: 30px; margin-top: 10px;">회원가입</button>
      <div class="lb-audio">
        <audio controls>
          <source src="${path}/resources/static/audios/order-99518.mp3" type="audio/mp3">  
        </audio>
    </div>
    <input type = "hidden" id = "DiaryContents">
    </div>
	<script type="text/javascript">
	
	
	
	$('#diaryContent').keyup(function (e){
	    var content = $(this).val();
	    $('#counter').html("("+content.length+" / 최대 3000자)");    //글자수 실시간 카운팅

	    if (content.length > 3000){
	        alert("최대 3000자까지 입력 가능합니다.");
	        $(this).val(content.substring(0, 3000));
	        $('#counter').html("(3000 / 최대 3000자)");
	    }
	})
			</script>
  </body>
</html>