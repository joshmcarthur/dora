moment       = require('moment')
mongoose     = require('mongoose')
Schema       = mongoose.Schema
database_url = "mongodb://localhost/dora"

mongoose.connect database_url

Repository = new Schema(
  name: {type: String, index: true},
  description: String,
  indexed_at: { type: Date, default: Date.now },
  url: String
)

Repository.methods.human_indexed_date = ->
  moment(this.indexed_at).format('dddd, MMMM Do YYYY')

module.exports = exports = mongoose.model("Respository", Repository)

