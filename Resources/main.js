/**
 * Created by Madhav on 14 August 2014.
 */

$(document).ready(function () {
	/*** Using jQuery Layout, set the layout column/rows of the page ***/
	$('body').layout({ applyDefaultStyles: true, minSize:140 });
    
	/*** Define URL page Mappings - Will be invoked each time the URL changes ***/
	Path.map("#/page/:page_id").to(function(){
		/*** Get the Page ID from the URL ***/
        var page_id = this.params['page_id'];
		
		/*** Hide all pages initially ***/
        $('.page').hide();
		
		/*** Make the currently selected page visible ***/
        $('#'+page_id).show();
		
		/*** Clear the pageNotes container ***/
		$('#pageNotes').empty();
		
		/*** Does the page have any notes ? ***/
		if($('#'+page_id+ ' .notes').length!==0)
		{
			/*** Yes, it does, so just copy the notes to the pageNotes container ***/
			$('#pageNotes').html($('#'+page_id+ ' .notes').html());
		}
    });
	
	/*** Find the first page defined in the document ***/
	var firstPage = $('.page').filter(':first').attr('id');
	
	/*** Redirect to that first Page initially ***/
    Path.root("#/page/"+firstPage);

	/*** Listen to URL Changes ***/
    Path.listen();
});