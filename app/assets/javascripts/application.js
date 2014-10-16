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
//= require_tree
jQuery(document).ready(function(){
    jQuery('ul.sf-menu').superfish();
    $('#publish_date').datetimepicker();
    $('#end_date').datetimepicker();
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

jQuery(function ($) {
    var csrf_token = $('meta[name=csrf-token]').attr('content'),
        csrf_param = $('meta[name=csrf-param]').attr('content');

    $.fn.extend({
        /**
         * Triggers a custom event on an element and returns the event result
         * this is used to get around not being able to ensure callbacks are placed
         * at the end of the chain.
         *
         * TODO: deprecate with jQuery 1.4.2 release, in favor of subscribing to our
         *       own events and placing ourselves at the end of the chain.
         */
        triggerAndReturn: function (name, data) {
            var event = new jQuery.Event(name);
            this.trigger(event, data);

            return event.result !== false;
        },

        /**
         * Handles execution of remote calls firing overridable events along the way
         */
        callRemote: function () {
            var el      = this,
                data    = el.is('form') ? el.serializeArray() : [],
                method  = el.attr('method') || el.attr('data-method') || 'GET',
                url     = el.attr('action') || el.attr('href');

            // TODO: should let the developer know no url was found
            if (url !== undefined) {
                if (el.triggerAndReturn('ajax:before')) {
                    $.ajax({
                        url: url,
                        data: data,
                        type: method.toUpperCase(),
                        beforeSend: function (xhr) {
                            xhr.setRequestHeader("Accept", "text/javascript");
                            el.trigger('ajax:loading', xhr);
                        },
                        success: function (data, status, xhr) {
                            el.trigger('ajax:success', [data, status, xhr]);
                        },
                        complete: function (xhr) {
                            el.trigger('ajax:complete', xhr);
                        },
                        error: function (xhr, status, error) {
                            el.trigger('ajax:failure', [xhr, status, error]);
                        }
                    });
                }

                el.trigger('ajax:after');
            }
        }
    });

    /**
     *  confirmation handler
     */
    $('a[data-confirm],input[data-confirm]').live('click', function () {
        var el = $(this);
        if (el.triggerAndReturn('confirm')) {
            if (!confirm(el.attr('data-confirm'))) {
                return false;
            }
        }
    });


    /**
     * remote handlers
     */
    $('form[data-remote="true"]').live('submit', function (e) {
        $(this).callRemote();
        e.preventDefault();
    });

    $('a[data-remote="true"],input[data-remote="true"]').live('click', function (e) {
        $(this).callRemote();
        e.preventDefault();
    });

    $('a[data-method][data-remote!=true]').live('click',function(e){
        var link = $(this),
            href = link.attr('href'),
            method = link.attr('data-method'),
            form = $('<form method="post" action="'+href+'">'),
            input = $('<input name="_method" value="'+method+'" type="hidden" />'),
            csrf_input = $('<input name="'+csrf_param+'" value="'+csrf_token+'" type="hidden" />');

        form.hide()
            .append(input)
            .append(csrf_input)
            .appendTo('body'); // redundant?

        e.preventDefault();
        form.submit();
    });

    /**
     * disable_with handlers
     */
    $('form[data-remote="true"]').live('ajax:before', function () {
        $(this).children('input[data-disable-with]').each(function () {
            var input = $(this);
            input.data('enable_with', input.val())
                 .attr('value', input.attr('data-disable-with'))
                 .attr('disabled', 'disabled');
        });
    });

    $('form[data-remote="true"]').live('ajax:after', function () {
        $(this).children('input[data-disable-with]').each(function () {
            var input = $(this);
            input.removeAttr('disabled')
                 .val(input.data('enable_with'));
        });
    });
});

