moment       = require('moment')
mongoose     = require('mongoose')
Schema       = mongoose.Schema
database_url = process.env.MONGOLAB_URI || "mongodb://localhost/dora"

mongoose.connect database_url

Repository = new Schema(
  name: {type: String, index: true},
  user: {type: String, index: true},
  description: String,
  indexed_at: { type: Date, default: Date.now },
  url: String
)

Repository.methods.human_indexed_date = ->
  moment(this.indexed_at).format('dddd, MMMM Do YYYY')

module.exports = exports = mongoose.model("Respository", Repository)

