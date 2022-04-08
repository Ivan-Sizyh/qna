import consumer from "./consumer"

$(document).on('turbolinks:load', () => {
    consumer.subscriptions.create("CommentsChannel", {
        connected() {
            this.perform('follow')
        },

        received(data) {
            let comment = document.createElement("div")
            let author = document.createElement("div")
            author.textContent = `Author: ${data.author_email}`
            let text = document.createElement("div")
            text.innerText = `Text: ${data.comment}`
            comment.appendChild(author)
            comment.appendChild(text)

            $(`#${data.commentable_type}-${data.commentable_id} .comments`).append(comment);
        }
    });
})
