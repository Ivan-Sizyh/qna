import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
    let questionsList = $(".questions-list")

    consumer.subscriptions.create('QuestionsChannel', {
        connected: function() {
            this.perform(`follow`);
        }
        ,
        received: function(data) {
            questionsList.append(data)
        }
    })
});
