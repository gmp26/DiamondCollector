/**
 * Controls operation of MathQuill elements on page.
 * Separated from Angular to avoid scope clashes.
 */

"use strict";

$(function(){
	$(".js_keyup_listener").keyup( function(e){
		var latex = $(".js_mq_editable").mathquill("latex");
		$(".js_mq_latex_visible").text(latex);

		// Borrowed from http://stackoverflow.com/questions/15657046/angularjs-data-binding-by-dom-manipulation
		// Gets angular scope for #angular_controller (MainCtrl), then forces an update to mqLatex.
		// This in turn triggers the watcher in the angular code.
		var scope = angular.element('#angular_controller').scope();
		scope.$apply(function(){
			scope.mqLatex = latex;
		});
	});
});

/**
 * IE-safe console.info()
 * @param msg
 */
function console_info(msg) {
	if(window.console){
		console.info(msg);
	}
}