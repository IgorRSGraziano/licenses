// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require tom-select
import "@hotwired/turbo-rails"
import "controllers"

const addTomSelect = () => {
    document.querySelectorAll("[data-tom-select]").forEach(e => {
        new TomSelect(e, {
            create: false,
            allowEmptyOption: true,
            sortField: {
                field: "text",
                direction: "asc"
            }
        });
    })
}

document.addEventListener('DOMContentLoaded', addTomSelect)
document.addEventListener('turbo:render', addTomSelect)