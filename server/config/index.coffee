module.exports = {}
module.exports[conf] = require "./#{conf}" for conf in ['db','http']