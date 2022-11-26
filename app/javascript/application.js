// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require tom-select
import "@hotwired/turbo-rails"
import "controllers"

document.querySelectorAll("[data-tom-select]").forEach(e => {
    new TomSelect(e,{
        create: false,
        allowEmptyOption: true,
        sortField: {
            field: "text",
            direction: "asc"
        }
    });
})

console.log("Hello")
