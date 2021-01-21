function FixOverflowHidden(pItemId) {

	apex.jQuery("#" + pItemId).parents().css("overflow","visible");
}

function mi_option_init( pDisplayBlockId, pMenuId, pItemId, pSelectMenuOption, pActiveThemeClass, pDisplayFormat, pAjaxIdentifier, pParentItems, pItemstoSubmit ) {
	
	// select menu option
	apex.jQuery("#" + pMenuId + " .mi-menu-option").click( function(event) {

		lReturnId   = apex.jQuery(this).attr("returnid");
		lActionType = apex.jQuery(this).attr("actiontype");
		lActionValue = apex.jQuery(this).attr("actionvalue");

		if ( pSelectMenuOption == "YES" ) {
  
			$s( pItemId, lReturnId );
			var lValue = apex.jQuery(this).children(".mi-option-text").attr("c-value");
			lValue = pDisplayFormat.replace(/#DISPLAY_VALUE#/g,lValue)
			apex.jQuery("#" + pDisplayBlockId + " .mi-label").html( lValue ); 
		}

		apex.jQuery("#" + pMenuId ).hide();

		//apex.jQuery("#ResultSet").trigger("apexrefresh");
         
		event.stopPropagation();

		switch (lActionType) {

			case "NOACTION": break
			case "REDIRECT": location.href=lActionValue; break
			case "SUBMIT": apex.submit(lActionValue); break

			default:
		}
	});
	
	// hover menu option animation
	apex.jQuery("#" + pMenuId + " .mi-menu-option").hover( function() {

		apex.jQuery(this).children(".mi-option-icon").addClass(pActiveThemeClass);
		apex.jQuery(this).children(".mi-option-icon").removeClass("ui-icon-black");

		apex.jQuery(this).toggleClass("mi-option-hover",true);

		apex.jQuery(this).children(".mi-submenu").show();
		apex.jQuery(this).children(".mi-submenu").position({my:"left top", at:"right top", of:apex.jQuery(this), collision:"flip"});

	}, function() {

		apex.jQuery(this).children(".mi-option-icon").addClass("ui-icon-black");
		apex.jQuery(this).children(".mi-option-icon").removeClass(pActiveThemeClass);

		apex.jQuery(this).toggleClass("mi-option-hover",false);

		apex.jQuery(this).children(".mi-submenu").hide();
	});
}

function mi_init( pDisplayBlockId, pMenuId, pItemId, pSelectMenuOption, pActiveThemeClass, pDisplayFormat, pAjaxIdentifier, pParentItems, pItemstoSubmit ) {

    // show menu
	apex.jQuery("#" + pDisplayBlockId ).click(function(event) {

		apex.jQuery("#" + pMenuId ).show();
		apex.jQuery("#" + pMenuId ).position({my:"center top", at:"bottom", of:"#" + pDisplayBlockId, collision:"fit"});

		event.stopPropagation();
	});
	
	//refresh menu
	apex.jQuery("#" + pItemId ).bind("apexrefresh", function() {
	
		apex.jQuery("#" + pItemId ).trigger("apexbeforerefresh");
		apex.jQuery("#" + pDisplayBlockId ).append('<span class="apex-loading-indicator"></span>');
		
		var lItemstoSubmit;
		if (pItemstoSubmit) {
		 
			lItemstoSubmit = pParentItems + ',' + pItemstoSubmit;
		} else {
			lItemstoSubmit = pParentItems;
		}
		
		apex.server.plugin( pAjaxIdentifier, { x01: "APEXREFRESH", pageItems: lItemstoSubmit }, { dataType: "html" , success: function( pData ) { 

			var lData = apex.jQuery(pData).html();
			apex.jQuery("#" + pMenuId ).html(lData);
			
			if ( $v(pItemId) )
				apex.jQuery("#" + pMenuId + " .mi-menu-option").each( function() {
					
					if ( apex.jQuery(this).attr("returnid") == $v(pItemId) ) {
						
						var lValue = apex.jQuery(this).children(".mi-option-text").attr("c-value");
						lValue = pDisplayFormat.replace(/#DISPLAY_VALUE#/g,lValue);
						
						if ( lValue != apex.jQuery("#" + pDisplayBlockId + " .mi-label").html() ) 
							apex.jQuery("#" + pDisplayBlockId + " .mi-label").html( lValue ); 
					}
				});
			
			mi_option_init( pDisplayBlockId, pMenuId, pItemId, pSelectMenuOption, pActiveThemeClass, pDisplayFormat, pAjaxIdentifier, pParentItems, pItemstoSubmit );
			
			apex.jQuery("#" + pDisplayBlockId + " .apex-loading-indicator" ).remove();
			apex.jQuery("#" + pItemId ).trigger("apexafterrefresh");
		}});
	});
	
	//Cascading LOV Parent Item(s)
	if (pParentItems) {
		
		apex.jQuery(pParentItems).bind("change", function() {
		
			apex.jQuery("#" + pItemId ).trigger("apexrefresh");
		});
	}
	
	FixOverflowHidden(pItemId);

	// hide list on click outside
	apex.jQuery(document).click(function() {

		apex.jQuery("#" + pMenuId).hide();
	});
 
	// hover display element animation
	apex.jQuery("#" + pDisplayBlockId ).hover( function() {

		apex.jQuery(this).find(".mi-icon").addClass(pActiveThemeClass);
		apex.jQuery(this).find(".mi-icon").removeClass("ui-icon-black");

		apex.jQuery(this).find(".mi-label").toggleClass("mi-hover",true);
		apex.jQuery(this).toggleClass("mi-hover",true);

	}, function() {

		apex.jQuery(this).find(".mi-icon").addClass("ui-icon-black");
		apex.jQuery(this).find(".mi-icon").removeClass(pActiveThemeClass);

		apex.jQuery(this).find(".mi-label").toggleClass("mi-hover",false);
		apex.jQuery(this).toggleClass("mi-hover",false);
	});
	
	mi_option_init( pDisplayBlockId, pMenuId, pItemId, pSelectMenuOption, pActiveThemeClass, pDisplayFormat, pAjaxIdentifier, pParentItems, pItemstoSubmit );
}