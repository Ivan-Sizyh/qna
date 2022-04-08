import consumer from "./consumer"

$(document).on('turbolinks:load', () => {
    consumer.subscriptions.create("AnswersChannel", {
        connected() {
            this.perform('follow', { question_id: gon.question_id })
        },

        received(data) {
            $('.answers').append(data.answer)

            if (gon.user_id != data.answer_author_id){
                if (gon.user_id != undefined) {
                    $(`#answer-${data.answer_id} .answer-voting .vote-link`).each(function() { $(this).removeClass('hidden') })
                }
                $(`#answer-${data.answer_id} .optional-link`).each(function() { $(this).remove() })
            }
        }
    });
})
