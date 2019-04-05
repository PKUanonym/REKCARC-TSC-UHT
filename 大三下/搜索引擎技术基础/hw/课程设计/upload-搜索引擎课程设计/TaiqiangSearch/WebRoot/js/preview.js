
//显示悬浮
function showInform(url){
    if(url.indexOf(".docx") == -1) {
        document.getElementById("frame").src = "http://" + url;
        document.getElementById("inform").style.display = 'block';
    }
    // document.getElementById("inform").css("display","block");
}
//隐藏悬浮层
function hiddenInform(event){

    document.getElementById('inform').style.display='none';
}