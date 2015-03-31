// public/plugins/site/pages.js
// browser side functionality for Ado::Control::Pages - part of Ado::Plugin::Site
/**
  Dropdown for folder and root pages.
  Displays popup with items for adding children pages under a page.
 */
(function($) {
'use strict';
$('.page.item .button').popup({
  inline   : true,
  hoverable: true,
  position : 'bottom right',
  delay: {
    show: 300,
    hide: 800
  }
});

// Initialise dropdowns in forms
$('select.dropdown').dropdown();

//  Let us define links behavior for pages items

/**
  Opens the modal form for creating a page
*/

function create_page () {
  var $mod = $('#create_page'); 
  $mod.modal('show');
  //set the action of the form
  var $form = $('#create_page form');

  $form.attr('action',$(this).data('href'));
  //TODO: implement form validation using Semantic UI when documented properly
  $form.on('submit', function (e) {
    var form = e.target;

    if(!form.alias.value.match(/^[\w-]{3,50}$/)){
      $('.field',form).addClass('error');
      $(form.alias).attr('placeholder', 'PLease add a valid page alias!');
      return false;
    }
    //now we can send the form
    $.post(
      $form.attr('action'),
      $(form).serialize(),
      function success (data) {
        $mod.modal('hide');
        $('.menu a[href="/ado-pages"]').click();//dirty reload of pages tree
      }
    );
    $mod.modal('hide');
    return false;
  });

}
//show this modal when clicking on a "create" 
// link item in the popup menu for a page
$('#tab_body .page span.create').each(function(i){
  $(this).click(create_page);
});
// TODO: Set validation for create_page form

/**
  Opens the modal form for updating a page
*/
function update_page () {
  alert('not implemented!');
  //$('#update_page').modal('show');
}
//show this modal when clicking on a "update" 
// link item in the popup menu for a page
$('.page span.update.item').each(function(){$(this).click(update_page)});

/**
  Opens the modal form for deleting a page
*/
function delete_page () {
    alert('not implemented!');
  //$('#delete_page').modal('show');
}
//show this modal when clicking on a "delete" 
// link item in the popup menu for a page
$('.page span.delete.item').each(function(){$(this).click(delete_page)});

})(jQuery); //execute;
