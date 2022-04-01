$(document).on('turbolinks:load', function() {
    vote('question')
    unvote('question')

    vote('answer')
    unvote('answer')
})

function vote(resource) {
    $(`.${resource} .vote-link`).on('ajax:success', function(e) {
        const score = e.detail[0].score;
        const id = e.detail[0].id;
        const votableName = e.detail[0].votable_type;
        $(`#${votableName}-${id} .${votableName}-voting .vote-link`).each(function() { $(this).addClass('hidden') })
        $(`#${votableName}-${id} .${votableName}-voting p`).html(`Score: ${score}`)
        $(`#${votableName}-${id} .${votableName}-voting .cancel-link`).removeClass(`hidden`)
    })
}

function unvote(resource) {
    $(`.${resource} .cancel-link`).on('ajax:success', function(e) {
        const score = e.detail[0].score;
        const id = e.detail[0].id;
        const votable = e.detail[0].votable_type;
        $(`#${votable}-${id} .${votable}-voting .vote-link`).each(function() { $(this).removeClass('hidden') })
        $(`#${votable}-${id} .${votable}-voting p`).html(`Score: ${score}`)
        $(`#${votable}-${id} .${votable}-voting .cancel-link`).addClass(`hidden`)
    })
}
