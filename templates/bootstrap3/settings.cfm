// Bootstrap 3 form settings 
set(functionName="submitTag", class="btn btn-primary", value="Save Changes");
set(functionName="checkBox,checkBoxTag", labelPlacement="aroundRight", prependToLabel="<div class=""checkbox"">", appendToLabel="</div>", uncheckedValue="0");
set(functionName="radioButton,radioButtonTag", labelPlacement="aroundRight", prependToLabel="<div class=""radio"">", appendToLabel="</div>");
set(functionName="textField,textFieldTag,select,selectTag,passwordField,passwordFieldTag,textArea,textAreaTag,fileFieldTag,fileField",
	class="form-control",
	labelClass="control-label",
	labelPlacement="before",
	prependToLabel="<div class=""form-group"">",
	prepend="<div class="""">",
	append="</div></div>"  );

set(functionName="dateTimeSelect,dateSelect", prepend="<div class=""form-group"">", append="</div>", timeSeparator="", minuteStep="5", secondStep="10", dateOrder="day,month,year", dateSeparator="", separator="");

set(functionName="errorMessagesFor", class="alert alert-dismissable alert-danger"" style=""margin-left:0;padding-left:26px;");
set(functionName="errorMessageOn", wrapperElement="div", class="alert alert-danger");
set(functionName="flash", prepend="<div class=""alert""><a class=""close"" data-dismiss=""alert"">&times;</a>", append="</div>");
set(functionName="flashMessages", prependToValue="<div class=""alert alert-dismissable alert-info""><a class=""close"" data-dismiss=""alert"">&times;</a>", appendToValue="</div>");
set(functionName="paginationLinks", prepend="<ul class=""pagination"">", append="</ul>", prependToPage="<li>", appendToPage="</li>", linkToCurrentPage=true, classForCurrent="active", anchorDivider="<li class=""disabled""><a href=""##"">...</a></li>");