setInterval(function(){
    var a = new Array();
    $("#box > span").each(function(){
        a.push($(this).css('background-color'));
    });
    $.unique(a.sort());
    if($("#box > span[style='background-color: " + a[0] + ";']").length === 1) {
        $("#box > span[style='background-color: " + a[0] + ";']").click();
    } else {
        $("#box > span[style='background-color: " + a[1] + ";']").click();
    }
}, 10);
