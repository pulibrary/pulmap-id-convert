/*jslint browser: true*/
/*global ZeroClipboard */
$(document).ready(function(){
  'use strict';

  var APIBase = '/api/';

  function getRelatedIds(idType, id){
  	var url = APIBase + idType + '/' + id;

    $.getJSON( url, function(data) {
      populateDataFields(data);
    });
   }
	function populateDataFields(ids) {
    $('#lookupVal').val('');
    setId(ids.ark, '#ark-val');
    setId(ids.guid, '#guid-val');
    setId(ids.image, '#image-val');

    //set input focus
    $('#lookupVal').focus();
	}
  function setId(id, selector) {
    if (id) {
      $(selector).val(id);

      // setup clipboard copy data
      $(selector +'-clip').attr('data-clipboard-text',id);
    } else {
      $(selector).val('None');
      $(selector +'-clip').attr('data-clipboard-text','');
    }
  }
  function setupCopyToClipboardButton(buttonId) {
    new ZeroClipboard( document.getElementById(buttonId) );
  }
  function setup(){
    $('#getArk').click(function(e) {
	    e.preventDefault();
  		getRelatedIds('arks', $('#lookupVal').val());
  	});

    $('#getGuid').click(function(e) {
      e.preventDefault();
      getRelatedIds('guids', $('#lookupVal').val());
    });

    $('#getImage').click(function(e) {
      e.preventDefault();
      getRelatedIds('images', $('#lookupVal').val());
    });

    setupCopyToClipboardButton('ark-val-clip');
    setupCopyToClipboardButton('guid-val-clip'); 
    setupCopyToClipboardButton('image-val-clip');

    // setup tootip
    $('[data-toggle="tooltip"]').tooltip();

    //set input focus
    $('#lookupVal').focus();
  }

  setup();
});
