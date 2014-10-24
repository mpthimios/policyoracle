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
//= require bootstrap
//= require jquery
//= require jquery_ujs
//= require_tree
jQuery(document).ready(function(){
    jQuery('ul.sf-menu').superfish();
    $('#publish_date').datetimepicker();
    $('#end_date').datetimepicker();
    $('.pagination').hide();
    $('#load_more_questions').show().click(function() {
        var $this, loading_posts, more_posts_url;
        if (!loading_posts) {
            loading_posts = true;
            more_posts_url = $('.pagination a.next_page').attr('href');
            $this = $(this);
            $this.html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />').addClass('disabled');
            $.getScript(more_posts_url, function() {
                if ($this) {
                    $this.text('More posts').removeClass('disabled');
                }
                return loading_posts = false;
            });
        }
    });
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

