/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
function showhide(column, elem){
    if (elem.checked)
        dp = "table-cell";
    else
        dp = "none";
    tds = document.getElementsByTagName('tr');
    for (i=0; i<tds.length; i++)
        tds[i].childNodes[column].style.display = dp;
}

