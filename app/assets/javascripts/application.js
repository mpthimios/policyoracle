// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require turbolinks
//= require jquery_ujs
//= require_tree

jQuery(document).ready(function(){
    jQuery('ul.sf-menu').superfish();
});


var number_of_answers = 0;
function add_new_answer(){

    answers_container = $('#answers_container');

    new_container = $('<div>').attr({
        id: 'container_answer_name_'+number_of_answers,
        class:"container",
        style:"border: 1px solid #ccc;"
    });

    title_row = $('<div>').attr({
        class:"row"
    });

    title_span = $('<div>').attr({
        class:"span6"
    });

    title_group = $('<div>').attr({
        class:"form-group"
    });

    title = $('<h3>').html('Answer ' + (number_of_answers + 1));

    title_label = $('<label>').attr({
        for: 'answer_text_'+number_of_answers
    }).html('Answer Title');

    title_text = $('<input>').attr({
        type: 'text',
        id: 'answer_text_'+number_of_answers,
        class:"form-control",
        name:"market[contracts_attributes][][name]",
        placeholder: "Enter a very short description of the answer"
    });

    title_group.append(title_label);
    title_group.append(title_text);
    title_span.append(title_group);
    title_row.append(title_span);

    description_row = $('<div>').attr({
        class:"row"
    });

    description_span = $('<div>').attr({
        class:"span10"
    });

    description_group = $('<div>').attr({
        class:"form-group"
    });

    description_label = $('<label>').attr({
        for: 'answer_description_'+number_of_answers
    }).html('Answer Description');

    description_text = $('<textarea>').attr({
        type: 'text',
        id: 'answer_description_'+number_of_answers,
        class:"form-control",
        name:"market[contracts_attributes][][description]",
        placeholder: "Enter a longer description of the answer"
    });

    description_group.append(description_label);
    description_group.append(description_text);
    description_span.append(description_group);
    description_row.append(description_span);

    new_container.append(title);
    new_container.append(title_row);
    new_container.append(description_row);
    answers_container.append(new_container);
    number_of_answers++;
};

// Make sure the DOM elements are loaded and accounted for
$(document).ready(function() {

    // Match to Bootstraps data-toggle for the modal
    // and attach an onclick event handler
    $('a[data-toggle="modal"]').on('click', function(e) {
        console.log("modal clicked!");
        // From the clicked element, get the data-target arrtibute
        // which BS3 uses to determine the target modal
        var target_modal = $(e.currentTarget).data('target');
        console.log(target_modal);
        // also get the remote content's URL
        var remote_content = e.currentTarget.href;

        // Find the target modal in the DOM
        var modal = $(target_modal);

        modal.removeData('bs.modal');
        modal.modal({remote: remote_content });
        modal.modal('show');
        // Find the modal's <div class="modal-body"> so we can populate it
        //var modalBody = $(target_modal + ' .modal-body');

        // Capture BS3's show.bs.modal which is fires
        // immediately when, you guessed it, the show instance method
        // for the modal is called
        //modal.on('show.bs.modal', function () {
            // use your remote content URL to load the modal body
        //    modalBody.load(remote_content);
        //}).modal();
        // and show the modal

        // Now return a false (negating the link action) to prevent Bootstrap's JS 3.1.1
        // from throwing a 'preventDefault' error due to us overriding the anchor usage.
        return false;
    });
});

